import torch
import torchaudio
from zonos.model import Zonos
from zonos.conditioning import make_cond_dict
from zonos.utils import DEFAULT_DEVICE as device

# model = Zonos.from_pretrained("Zyphra/Zonos-v0.1-hybrid", device=device)
model = Zonos.from_pretrained("Zyphra/Zonos-v0.1-transformer", device=device)

wav, sampling_rate = torchaudio.load("/home/aiuser/test_project/OpenVoice/test.wav")
speaker = model.make_speaker_embedding(wav, sampling_rate)

torch.manual_seed(421)

cond_dict = make_cond_dict(text="안녕하십니까 방송인의 목소리를 사용해서 만든 TTS 테스트 음성입니다. 종합 게임 스트리머를 표방하며, 2025년에 주로 하는 게임은 배틀그라운드와 리그 오브 레전드. 이 외에 스팀 게임도 자주 하는 편입니다.", speaker=speaker, language="ko")
conditioning = model.prepare_conditioning(cond_dict)

codes = model.generate(conditioning)

wavs = model.autoencoder.decode(codes).cpu()
torchaudio.save("sample.wav", wavs[0], model.autoencoder.sampling_rate)
