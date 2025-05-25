import os
import torch
import torchaudio
import tempfile
import librosa
import numpy as np
from dtaidistance import dtw
from fastapi import FastAPI, File, UploadFile, HTTPException, Form
from fastapi.responses import FileResponse
from transformers import WhisperProcessor, WhisperForConditionalGeneration, GenerationConfig
from zonos.model import Zonos
from zonos.conditioning import make_cond_dict
from zonos.utils import DEFAULT_DEVICE as device
import nlptutti as metrics

app = FastAPI()

# Whisper 모델 로드
WHISPER_PROCESSOR = WhisperProcessor.from_pretrained("jwh1449/whisper_small_test")
WHISPER_MODEL = WhisperForConditionalGeneration.from_pretrained("jwh1449/whisper_small_test")
WHISPER_MODEL = WHISPER_MODEL.to(device).eval()

# generation_config 설정
WHISPER_MODEL.generation_config = GenerationConfig.from_pretrained(
    "jwh1449/whisper_small_test",
    task="transcribe",  # 전사 작업 명시
    forced_decoder_ids=None  # forced_decoder_ids를 None으로 설정
)

# Zonos 모델 설정
CURRENT_MODEL = None
CURRENT_MODEL_TYPE = None

def load_zonos_model(model_choice: str = "Zyphra/Zonos-v0.1-transformer"):
    global CURRENT_MODEL, CURRENT_MODEL_TYPE
    if CURRENT_MODEL_TYPE != model_choice:
        if CURRENT_MODEL is not None:
            del CURRENT_MODEL
            torch.cuda.empty_cache()
        print(f"Loading {model_choice} model...")
        CURRENT_MODEL = Zonos.from_pretrained(model_choice, device=device)
        CURRENT_MODEL.requires_grad_(False).eval()
        CURRENT_MODEL_TYPE = model_choice
        print(f"{model_choice} model loaded successfully!")
    return CURRENT_MODEL

# 오디오 파일 검증 함수 (magic 없이)
async def validate_wav_file(file: UploadFile):
    # 파일 확장자 확인
    if not file.filename.lower().endswith(".wav"):
        raise HTTPException(status_code=400, detail="WAV 파일만 지원됩니다.")
    
    # 파일 크기 확인
    file_content = await file.read()
    if not file_content:
        raise HTTPException(status_code=400, detail="빈 파일입니다.")
    
    # 임시 파일에 저장하여 torchaudio로 검증
    with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as temp_file:
        temp_file.write(file_content)
        temp_file_path = temp_file.name
    
    try:
        # torchaudio로 파일 로드 시도
        waveform, sample_rate = torchaudio.load(temp_file_path)
        if waveform.size(0) == 0:
            raise HTTPException(status_code=400, detail="유효하지 않은 오디오 파일입니다.")
    except Exception as e:
        os.unlink(temp_file_path)
        raise HTTPException(status_code=400, detail=f"오디오 파일 로드 실패: {str(e)}")
    
    await file.seek(0)  # 파일 포인터 초기화
    return file_content, temp_file_path

# MFCC 및 DTW 유사도 계산 함수
def compute_mfcc(file_path, n_mfcc=13):
    # 음성 파일을 읽고 MFCC를 추출합니다.
    y, sr = librosa.load(file_path, sr=None)
    mfcc = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=n_mfcc)
    return mfcc.T  # (frames, coefficients)

def compute_dtw_distance(mfcc1, mfcc2):
    # MFCC 시퀀스를 프레임별 평균 내어 시퀀스로 만듭니다.
    seq1 = np.mean(mfcc1, axis=1)  # (frames,)
    seq2 = np.mean(mfcc2, axis=1)

    # DTW 거리 계산
    distance = dtw.distance(seq1, seq2)

    # 거리 정규화 (평균 길이로 나눔)
    avg_length = (len(seq1) + len(seq2)) / 2
    norm_distance = distance / avg_length
    return distance, norm_distance

def dtw_to_similarity(norm_dtw, method='reciprocal', alpha=2):
    # 정규화된 DTW 거리를 유사도로 변환
    if method == 'reciprocal':
        return 1 / (1 + norm_dtw)
    elif method == 'linear':
        return max(0, 1 - norm_dtw)
    elif method == 'exp':
        return np.exp(-alpha * norm_dtw)
    else:
        raise ValueError("Unknown method")

def compute_mfcc_dtw_similarity(file_path1, file_path2):
    # 두 파일의 MFCC 추출
    mfcc1 = compute_mfcc(file_path1)
    mfcc2 = compute_mfcc(file_path2)

    # DTW 거리 계산
    dtw_dist, dtw_norm = compute_dtw_distance(mfcc1, mfcc2)

    # 유사도 계산
    similarity_percent = dtw_to_similarity(dtw_norm, method='reciprocal') * 100

    print(f"원본 DTW 거리: {dtw_dist:.4f}")
    print(f"정규화된 DTW 거리: {dtw_norm:.4f}")
    print(f"DTW 기반 유사도 점수: {similarity_percent:.2f}%")

    return {
        "dtw_distance": dtw_dist,
        "normalized_dtw_distance": dtw_norm,
        "similarity_percent": similarity_percent
    }

@app.post("/whisper/transcribe/")
async def transcribe_audio(
    audio: UploadFile = File(...),
    reference_text: str = Form(...),
    language: str = Form("ko")
):
    try:
        # 파일 검증
        file_content, temp_file_path = await validate_wav_file(audio)

        # 오디오 로드 및 전처리
        waveform, sample_rate = torchaudio.load(temp_file_path)
        if sample_rate != 16000:
            waveform = torchaudio.transforms.Resample(sample_rate, 16000)(waveform)
        waveform = waveform.mean(dim=0, keepdim=True)

        # Whisper 전사
        inputs = WHISPER_PROCESSOR(
            waveform.squeeze().numpy(),
            sampling_rate=16000,
            return_tensors="pt",
            return_attention_mask=True
        ).to(device)
        with torch.no_grad():
            generate_kwargs = {
                "attention_mask": inputs["attention_mask"],
                "language": language  # 한국어 전사를 위해 명시
            }
            generated_ids = WHISPER_MODEL.generate(inputs["input_features"], **generate_kwargs)
        transcription = WHISPER_PROCESSOR.batch_decode(generated_ids, skip_special_tokens=True)[0]

        # CER 계산
        cer_score = metrics.get_cer(reference_text, transcription)

        percentile_score = (1.0 - cer_score["cer"]) * 100
        
        # 임시 파일 삭제
        os.unlink(temp_file_path)

        return {
            "transcription": transcription,
            # "reference_text": reference_text,
            # "cer": cer_score
            "cer": percentile_score
        }
    
    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"오류: {str(e)}")

@app.post("/zonos/generate/")
async def generate_audio(
    text: str = Form(...),
    speaker_audio: UploadFile = File(...),
    language: str = Form("ko"),
    cfg_scale: float = Form(2.0),
    seed: int = Form(420),
    randomize_seed: bool = Form(True)
):
    try:
        # Zonos 모델 로드
        model = load_zonos_model()

        # 시드 설정
        if randomize_seed:
            seed = torch.randint(0, 2**32 - 1, (1,)).item()
        torch.manual_seed(seed)

        # 스피커 임베딩
        file_content, temp_file_path = await validate_wav_file(speaker_audio)
        
        wav, sr = torchaudio.load(temp_file_path)
        speaker_embedding = model.make_speaker_embedding(wav, sr)
        speaker_embedding = speaker_embedding.to(device, dtype=torch.bfloat16)
        os.unlink(temp_file_path)

        # 조건 설정
        cond_dict = make_cond_dict(
            text=text,
            language=language,
            speaker=speaker_embedding,
            emotion=torch.tensor([1.0, 0.05, 0.05, 0.05, 0.05, 0.05, 0.1, 0.2], device=device),
            vqscore_8=torch.tensor([0.78] * 8, device=device).unsqueeze(0),
            fmax=24000.0,
            pitch_std=45.0,
            speaking_rate=15.0,
            dnsmos_ovrl=4.0,
            speaker_noised=False,
            device=device,
            unconditional_keys=["emotion"]
        )
        conditioning = model.prepare_conditioning(cond_dict)

        # 오디오 생성
        max_new_tokens = 86 * 30
        codes = model.generate(
            prefix_conditioning=conditioning,
            audio_prefix_codes=None,
            max_new_tokens=max_new_tokens,
            cfg_scale=cfg_scale,
            batch_size=1,
            sampling_params=dict(top_p=0.0, top_k=0, min_p=0.0, linear=0.5, conf=0.4, quad=0.0)
        )

        # 오디오 디코딩
        wav_out = model.autoencoder.decode(codes).cpu().detach()
        sr_out = model.autoencoder.sampling_rate

        # 텐서 차원 디버깅
        print(f"wav_out shape before adjustment: {wav_out.shape}, dim: {wav_out.dim()}")

        # 텐서 차원 조정
        if wav_out.dim() == 1:
            wav_out = wav_out.unsqueeze(0)  # [N] -> [1, N]
        elif wav_out.dim() == 3:
            if wav_out.size(0) == 1:
                wav_out = wav_out.squeeze(0)  # [1, C, N] -> [C, N]
            if wav_out.size(0) > 1:
                wav_out = wav_out[0:1, :]  # [C, N] -> [1, N]
        elif wav_out.dim() == 2:
            if wav_out.size(0) > 1:
                wav_out = wav_out[0:1, :]  # [C, N] -> [1, N]
        else:
            raise ValueError(f"Unexpected wav_out dimension: {wav_out.dim()}")

        # 최종 차원 확인
        if wav_out.dim() != 2:
            raise ValueError(f"wav_out is not 2D after adjustment: shape {wav_out.shape}")

        print(f"wav_out shape after adjustment: {wav_out.shape}")

        # 임시 파일로 오디오 저장
        with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as temp_file:
            torchaudio.save(temp_file.name, wav_out, sr_out)
            temp_file_path = temp_file.name

        return FileResponse(temp_file_path, media_type="audio/wav", filename="generated_audio.wav")

    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"오류: {str(e)}")

@app.post("/mfcc/compare/")
async def compare_audio_similarity(
    audio1: UploadFile = File(...),
    audio2: UploadFile = File(...)
):
    try:
        # 두 오디오 파일 검증
        file_content1, temp_file_path1 = await validate_wav_file(audio1)
        file_content2, temp_file_path2 = await validate_wav_file(audio2)

        # MFCC 및 DTW 유사도 계산
        result = compute_mfcc_dtw_similarity(temp_file_path1, temp_file_path2)

        # 임시 파일 삭제
        os.unlink(temp_file_path1)
        os.unlink(temp_file_path2)

        return result

    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"오류: {str(e)}")

@app.get("/health") # 테스트 용도
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port="YOUR PORT")