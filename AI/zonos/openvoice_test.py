# python3

import os
import torch
from openvoice import se_extractor
from openvoice.api import ToneColorConverter

ckpt_converter = 'checkpoints_v2/converter' # <-- 이게 안되면
# ckpt_converter = '../checkpoints_v2/converter'

device = "cuda:0" if torch.cuda.is_available() else "cpu"

output_dir = 'outputs_v2'


# 프로그램 시작 위치는 /root/OpenVoice <-- 여기임

tone_color_converter = ToneColorConverter(f'{ckpt_converter}/config.json', device=device)

tone_color_converter.load_ckpt(f'{ckpt_converter}/checkpoint.pth')

os.makedirs(output_dir, exist_ok=True)

reference_speaker = "/home/aiuser/test_project/OpenVoice/가렌.mp3"

target_se, audio_name = se_extractor.get_se(reference_speaker, tone_color_converter, vad=True)



from melo.api import TTS


texts = {
    # 'EN_NEWEST': "Did you ever hear a folk tale about a giant turtle?",  # The newest English base speaker model
    # 'EN': "Did you ever hear a folk tale about a giant turtle?",
    # 'ES': "El resplandor del sol acaricia las olas, pintando el cielo con una paleta deslumbrante.",
    # 'FR': "La lueur dorée du soleil caresse les vagues, peignant le ciel d'une palette éblouissante.",
    # 'ZH': "在这次vacation中，我们计划去Paris欣赏埃菲尔铁塔和卢浮宫的美景。",
    # 'JP': "彼は毎朝ジョギングをして体を健康に保っています。",
    'KR': "안녕하십니까 리그오브레전드 게임의 가렌의 목소리를 복제한 음성입니다."
}

src_path = f'{output_dir}/tmp.wav'
speed = 1.0





for language, text in texts.items():
    model = TTS(language=language, device=device)
    speaker_ids = model.hps.data.spk2id

    for speaker_key in speaker_ids.keys():
        speaker_id = speaker_ids[speaker_key]
        speaker_key = speaker_key.lower().replace('_', '-')

        # source_se = torch.load(f'../checkpoints_v2/base_speakers/ses/{speaker_key}.pth', map_location=device)
        source_se = torch.load(f'checkpoints_v2/base_speakers/ses/{speaker_key}.pth', map_location=device)
        model.tts_to_file(text, speaker_id, src_path, speed=speed)
        save_path = f'{output_dir}/output_v2_{speaker_key}.wav'

        # Run the tone color converter
        encode_message = "@MyShell"
        tone_color_converter.convert(
            audio_src_path=src_path,
            src_se=source_se,
            tgt_se=target_se,
            output_path=save_path,
            message=encode_message)