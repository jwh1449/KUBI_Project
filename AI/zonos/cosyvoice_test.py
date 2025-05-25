import sys
sys.path.append('third_party/Matcha-TTS')
from cosyvoice.cli.cosyvoice import CosyVoice2
from cosyvoice.utils.file_utils import load_wav
import torchaudio

# 모델 초기화
cosyvoice = CosyVoice2("/home/aiuser/test_project/pretrained_models/CosyVoice2-0.5B", load_jit=False, load_trt=False, fp16=False, use_flow_cache=False)

# 참조 음성 파일 지정
prompt_speech_16k = load_wav("/home/aiuser/test_project/OpenVoice/test.wav", 16000)

for i, j in enumerate(cosyvoice.inference_zero_shot(
    '본 음성은 방송인의 목소리의 특성을 참조하여 복제된 TTS입니다. 종합 게임 스트리머를 표방하며, 2025년에 주로 하는 게임은 배틀그라운드와 리그 오브 레전드. 이 외에 스팀 게임도 자주 하는 편입니다',
    "내가 고민 있을 때 남봉이나 주변 애들이나 얘기할 때 하 나 요즘 고민있어 이런 느낌 보다는 하 씨발부터 시작해 흐하하 흐하하 애들마다 반응이 있어 탬탬버린은 강지야 무슨일 있어? 이런 느낌이고 남봉이는 방송이나 보는 거 똑같을 거야 아마 어~ 흐허 어~ 갱쥐야 약간 이렇게 하는 어 가 좆나 커 어!! 흐허허",  # 프롬프트 텍스트 (강지4.wav 내용과 매핑)
    prompt_speech_16k,
    stream=False)):
    torchaudio.save(f"zero_shot_test_{i}.wav", j["tts_speech"], cosyvoice.sample_rate)


# # 제로샷 합성 (한글)
# for i, j in enumerate(cosyvoice.inference_cross_lingual(
#     '안녕하세요, 테스트입니다. 성능이 좋은지 확인중 입니다.',
#     prompt_speech_16k, stream=False, text_frontend=False)):
#     torchaudio.save('zero_shot_{}.wav'.format(i), j['tts_speech'], cosyvoice.sample_rate)

# # 세밀한 제어 (한글)
# for i, j in enumerate(cosyvoice.inference_cross_lingual(
#     '그가 터무니없는 이야기를 하던 중에 갑자기 [laughter] 멈췄어요, 왜냐하면 그가 스스로 웃음이 터졌기 때문이에요 [laughter].',
#     prompt_speech_16k, stream=False, text_frontend=False)):
#     torchaudio.save('fine_grained_control_{}.wav'.format(i), j['tts_speech'], cosyvoice.sample_rate)

# # 지시 기반 합성 (한글)
# for i, j in enumerate(cosyvoice.inference_instruct2(
#     '친구에게서 멀리서 온 생일 선물을 받아서, 뜻밖의 기쁨과 깊은 축복으로 마음이 달콤한 행복으로 가득 차고, 미소가 꽃처럼 피어났어요.',
#     '친절한 톤으로 말해줘', prompt_speech_16k, stream=False, text_frontend=False)):
#     torchaudio.save('instruct_{}.wav'.format(i), j['tts_speech'], cosyvoice.sample_rate)
