import os
import wave
import numpy as np
from tqdm import tqdm

# 경로 설정
base_dir = r"D:\한국어 음성\한국어_음성_분야"
text_file = r"C:\Users\82102\OneDrive\바탕 화면\파이썬\LLM\Kospeech\kospeech\dataset\kspon\transcripts.txt"

# 저장 경로
output_wav_dir = r"D:\한국어 음성\output_wav"
output_txt_dir = r"D:\한국어 음성\output_txt"
os.makedirs(output_wav_dir, exist_ok=True)
os.makedirs(output_txt_dir, exist_ok=True)

# PCM 파일을 WAV로 변환 (wave + numpy)
def convert_pcm_to_wav(pcm_path, wav_path, sample_rate=16000, sample_width=2, channels=1):
    with open(pcm_path, 'rb') as pcmfile:
        pcm_data = pcmfile.read()
        audio_data = np.frombuffer(pcm_data, dtype=np.int16)

    with wave.open(wav_path, 'wb') as wavfile:
        wavfile.setnchannels(channels)
        wavfile.setsampwidth(sample_width)
        wavfile.setframerate(sample_rate)
        wavfile.writeframes(audio_data.tobytes())

# 메인 실행
with open(text_file, "r", encoding="cp949") as f:
    lines = f.readlines()

for line in tqdm(lines, desc="PCM → WAV 변환 중"):
    try:
        pcm_relative_path, text, _ = line.strip().split("\t")
        
        # KsponSpeech_01 하위에 다시 KsponSpeech_01이 있다는 점 반영
        first_folder = pcm_relative_path.split("\\")[0]  # 예: KsponSpeech_01
        pcm_path = os.path.join(base_dir, first_folder, pcm_relative_path)

        if not os.path.isfile(pcm_path):
            print(f"❌ 파일 없음: {pcm_path}")
            continue

        file_id = os.path.splitext(os.path.basename(pcm_path))[0]

        wav_output_path = os.path.join(output_wav_dir, f"{file_id}.wav")
        txt_output_path = os.path.join(output_txt_dir, f"{file_id}.txt")

        # 변환
        convert_pcm_to_wav(pcm_path, wav_output_path)

        # 텍스트 저장
        with open(txt_output_path, "w", encoding="utf-8") as txt_file:
            txt_file.write(text.strip())

    except Exception as e:
        print(f"⚠️ 에러 발생: {line.strip()} → {e}")
