import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart'; // Record 패키지
import 'package:personal_test/localization/app_localizations.dart';
import 'package:personal_test/home_screens/shared_preferences_helper.dart';
import 'dart:io';
import 'dart:async';

class VoiceRecorderOverlay extends StatefulWidget {
  final bool isVisible;
  final String? userVoiceFilePath;
  final Function(String?) onVoiceFilePathChanged;
  final VoidCallback onClose;
  final Function(String message) showSnackBar;

  const VoiceRecorderOverlay({
    Key? key,
    required this.isVisible,
    required this.userVoiceFilePath,
    required this.onVoiceFilePathChanged,
    required this.onClose,
    required this.showSnackBar,
  }) : super(key: key);

  @override
  State<VoiceRecorderOverlay> createState() => _VoiceRecorderOverlayState();
}

class _VoiceRecorderOverlayState extends State<VoiceRecorderOverlay> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  final AudioPlayer _audioPlayer = AudioPlayer(); // 사용자의 녹음 파일 재생 전용
  bool _isPlayingUserVoice = false; // _audioPlayer 재생 상태
  String? _currentSavedUserVoiceFilePath; // SharedPreferences에 저장된 사용자 음성 파일 경로
  String? _currentRecordingFilePath; // 현재 녹음된 (아직 저장되지 않은) 임시 파일 경로

  Duration _recordDuration = Duration.zero;
  Timer? _recordTimer;

  final Map<String, String> _exampleText = {
    "en": "Hello. My name is kubi. I am a first-year student in the kubi department, and I'm particularly interested in how artificial intelligence technology is applied in real life. On weekends, I usually spend my time reading related books or coding projects. I look forward to growing together with all of you. It's a pleasure to meet you.",
    "ko": "안녕하세요. 쿠비라고 합니다. 저는 쿠비 학과 1학년 학생이며, 인공지능 기술이 실생활에 어떻게 적용되는지에 특히 관심이 많습니다. 주말에는 주로 관련 서적을 읽거나 코딩 프로젝트를 하면서 시간을 보냅니다. 여러분과 함께 성장할 수 있기를 기대합니다. 만나서 반갑습니다.",
    "zh": "你好。我的名字叫kubi。我是kubi系的一年级学生，我对人工智能技术如何应用于现实生活特别感兴趣。周末我通常会阅读相关书籍或者做一些编码项目。我期待着和大家一起成长。很高兴认识大家。",
  };

  @override
  void initState() {
    super.initState();
    _currentSavedUserVoiceFilePath = widget.userVoiceFilePath;

    // _audioPlayer의 재생 상태 변화 리스너
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      if (mounted) {
        setState(() {
          _isPlayingUserVoice = isPlaying;
        });
        if (processingState == ProcessingState.completed) {
          print("오디오 재생 완료.");
          // 재생 완료 후 추가적인 UI 업데이트가 필요하다면 여기에 추가
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant VoiceRecorderOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userVoiceFilePath != oldWidget.userVoiceFilePath) {
      setState(() {
        _currentSavedUserVoiceFilePath = widget.userVoiceFilePath;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // dispose 전에 재생 중인 오디오 중지
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _recordTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _recordDuration = Duration.zero;
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration = _recordDuration + const Duration(seconds: 1);
      });
    });
  }

  void _stopTimer() {
    _recordTimer?.cancel();
    _recordTimer = null;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<bool> _checkAndRequestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    if (status.isGranted) {
      print("마이크 권한이 허용되었습니다.");
      return true;
    } else if (status.isPermanentlyDenied) {
      print("마이크 권한이 영구적으로 거부되었습니다. 설정에서 허용해주세요.");
      if (mounted) {
        _showPermissionDeniedDialog(AppLocalizations.of(context)!);
      }
      return false;
    }
    return false;
  }

  void _showPermissionDeniedDialog(AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('microphonePermissionNeeded')),
        content: Text(localizations.translate('microphonePermissionContent')),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text(localizations.translate('openSettings')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.translate('cancel')),
          ),
        ],
      ),
    );
  }

  Future<void> _startRecording() async {
    if (_isPlayingUserVoice) {
      await _stopAudio(); // 녹음 시작 전에 재생 중인 오디오 중지
    }

    if (!await _checkAndRequestMicrophonePermission()) {
      widget.showSnackBar(
          AppLocalizations.of(context)!.translate('microphonePermissionDenied'));
      return;
    }

    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/user_voice_${DateTime.now().millisecondsSinceEpoch}.wav';
        _currentRecordingFilePath = filePath; // 현재 녹음 파일 경로 저장

        // WAV (PCM 16비트, 16kHz, 모노) 형식으로 명시적 설정
        await _audioRecorder.start(
          RecordConfig(
            encoder: AudioEncoder.wav,          // WAV 컨테이너 지정
            sampleRate: 16000,                  // 16kHz 샘플 레이트 (TTS 모델에서 흔히 요구)
            numChannels: 1,                     // 1채널 (모노) 설정 (대부분의 TTS 모델은 모노 선호)
            bitRate: 16000 * 16 * 1,            // 비트레이트 = 샘플레이트 * 비트심도 * 채널수 (PCM의 경우)
          ),
          path: filePath,
        );

        setState(() {
          _isRecording = true;
        });
        _startTimer(); // 녹음 시간 타이머 시작
        widget.showSnackBar(
            AppLocalizations.of(context)!.translate('recordingStarted'));
        print("녹음 시작: $filePath (WAV PCM 16kHz, 모노)");
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _stopTimer(); // 오류 발생 시 타이머 중지
      widget.showSnackBar(AppLocalizations.of(context)!
          .translate('recordingError', {'error': e.toString()}));
      print("녹음 시작 오류: $e");
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return; // 녹음 중이 아니면 실행하지 않음

    try {
      final recordedFilePath = await _audioRecorder.stop();
      _stopTimer(); // 녹음 시간 타이머 중지

      setState(() {
        _isRecording = false;
      });

      if (recordedFilePath != null && recordedFilePath.isNotEmpty) {
        final file = File(recordedFilePath);
        if (await file.exists()) {
          print("녹음된 파일 존재. 경로: $recordedFilePath, 크기: ${await file.length()} bytes");
          _currentRecordingFilePath = recordedFilePath; // 최종 녹음 파일 경로 업데이트

          _showReviewAndRetakeDialog(recordedFilePath);

        } else {
          widget.showSnackBar(AppLocalizations.of(context)!
              .translate('failedToRecordVoice'));
          print("오류: 녹음된 파일이 경로에 존재하지 않습니다: $recordedFilePath");
          _currentRecordingFilePath = null;
        }
      } else {
        widget.showSnackBar(
            AppLocalizations.of(context)!.translate('failedToRecordVoice'));
        print("경고: stopRecording에서 유효한 파일 경로를 반환하지 않았습니다.");
        _currentRecordingFilePath = null;
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _stopTimer();
      widget.showSnackBar(AppLocalizations.of(context)!
          .translate('errorStoppingRecording', {'error': e.toString()}));
      print("녹음 중지 및 파일 처리 중 오류 발생: $e");
      _currentRecordingFilePath = null;
    }
  }

  Future<void> _playAudio(String filePath) async {
    try {
      print("재생 시도 파일 경로: $filePath");
      final file = File(filePath);
      if (!await file.exists()) {
        print("오류: 재생할 파일이 존재하지 않습니다: $filePath");
        widget.showSnackBar(AppLocalizations.of(context)!
            .translate('audioPlaybackError', {'error': 'File not found'}));
        setState(() { // 재생 실패 시 상태 업데이트
          _isPlayingUserVoice = false;
        });
        return;
      } else if (await file.length() == 0) {
        print("경고: 파일 크기가 0입니다. (빈 파일일 수 있음) 경로: $filePath");
        widget.showSnackBar(AppLocalizations.of(context)!
            .translate('audioPlaybackError', {'error': 'Empty audio file'}));
        setState(() { // 재생 실패 시 상태 업데이트
          _isPlayingUserVoice = false;
        });
        return;
      }

      if (_audioPlayer.playing) {
        print("현재 재생 중인 오디오 중지");
        await _audioPlayer.stop();
      }
      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
      setState(() { // 재생 시작 시 상태 업데이트
        _isPlayingUserVoice = true;
      });
      print("재생 시작 성공");
    } catch (e) {
      print("Error playing audio: $e");
      widget.showSnackBar(AppLocalizations.of(context)!
          .translate('audioPlaybackError', {'error': e.toString()}));
      setState(() { // 재생 실패 시 상태 업데이트
        _isPlayingUserVoice = false;
      });
    }
  }

  Future<void> _stopAudio() async {
    try {
      if (_audioPlayer.playing) {
        print("오디오 재생 중지");
        await _audioPlayer.stop();
      }
    } catch (e) {
      print("Error stopping audio: $e");
      widget.showSnackBar(AppLocalizations.of(context)!
          .translate('audioStopError', {'error': e.toString()}));
    } finally {
      if (_isPlayingUserVoice) { // 중지 완료 후 상태 업데이트
        setState(() {
          _isPlayingUserVoice = false;
        });
      }
    }
  }

  void _showReviewAndRetakeDialog(String currentRecordedFilePath) {
    final localizations = AppLocalizations.of(context)!;

    _stopAudio(); // 다이얼로그 띄우기 전에 재생 중인 오디오 중지

    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 외부 터치로 닫히지 않도록 설정
      builder: (BuildContext dialogContext) {
        return StatefulBuilder( // 다이얼로그 내부에서 상태 변경을 위해 StatefulBuilder 사용
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              title: Text(localizations.translate('reviewVoiceRecording')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(localizations.translate('playRecordedVoice')),
                    const SizedBox(height: 16),
                    FloatingActionButton.extended(
                      onPressed: _isPlayingUserVoice // _isPlayingUserVoice는 이제 _audioPlayer의 실제 상태를 반영
                          ? () async {
                        await _stopAudio();
                        dialogSetState(() {}); // 다이얼로그 UI 업데이트
                      }
                          : () async {
                        await _playAudio(currentRecordedFilePath);
                        dialogSetState(() {}); // 다이얼로그 UI 업데이트
                      },
                      label: Text(
                        _isPlayingUserVoice
                            ? localizations.translate('stopPlaying')
                            : localizations.translate('listen'),
                      ),
                      icon: Icon(_isPlayingUserVoice ? Icons.stop : Icons.play_arrow),
                      backgroundColor:
                      _isPlayingUserVoice ? Colors.orange : Colors.lightBlue,
                      heroTag: 'playRecordedVoiceOverlay',
                    ),
                    const SizedBox(height: 20),
                    Text(localizations.translate('retakeQuestion')),
                  ],
                ),
              ),
              actions: <Widget>[
                // ✨ 수정된 부분: Expanded 위젯으로 버튼 감싸기
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      if (_isPlayingUserVoice) {
                        await _stopAudio();
                      }
                      Navigator.of(dialogContext).pop(); // 다이얼로그 닫기
                      // 임시 녹음 파일 삭제
                      final fileToDelete = File(currentRecordedFilePath);
                      if (await fileToDelete.exists()) {
                        await fileToDelete.delete();
                        print("임시 녹음 파일 삭제 (재녹음 선택): $currentRecordedFilePath");
                      }

                      // SharedPreferences에 저장된 기존 음성 파일 경로는 유지
                      final existingVoicePath = await SharedPreferencesHelper.getUserVoicePath();
                      widget.onVoiceFilePathChanged(existingVoicePath); // 부모 위젯에 알림

                      setState(() { // 현재 위젯의 상태 업데이트
                        _currentSavedUserVoiceFilePath = existingVoicePath;
                        _isRecording = false; // 녹음 상태 초기화
                        _recordDuration = Duration.zero; // 타이머 초기화
                      });

                      _startRecording(); // 다시 녹음 시작
                    },
                    child: Text(localizations.translate('retake'),
                        style: const TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 8), // 버튼 사이 간격 추가
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      if (_isPlayingUserVoice) {
                        await _stopAudio();
                      }
                      Navigator.of(dialogContext).pop(); // 다이얼로그 닫기
                      // 사용자가 "이 음성 사용"을 선택하면 파일 저장
                      await SharedPreferencesHelper.saveUserVoicePath(currentRecordedFilePath);
                      widget.onVoiceFilePathChanged(currentRecordedFilePath); // 부모 위젯에 새 경로 알림
                      setState(() { // 현재 위젯의 상태 업데이트
                        _currentSavedUserVoiceFilePath = currentRecordedFilePath;
                      });
                      // ✨ 이 스낵바는 '저장 성공'을 알리는 단일 스낵바
                      widget.showSnackBar(localizations.translate('voiceSavedSuccessfully'));
                      widget.onClose(); // 오버레이 닫기
                    },
                    child: Text(localizations.translate('useThisVoice'),
                        style: const TextStyle(color: Colors.green)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final String currentExampleText = _exampleText[localizations.locale.languageCode] ?? _exampleText["en"]!;

    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        ModalBarrier(
          color: Colors.black54,
          dismissible: true, // 오버레이 외부 터치로 닫히도록 허용
          onDismiss: () {

            // 'Use This Voice' 버튼을 통해 정상적으로 닫힐 때는 이 조건이 false이므로 스낵바가 나오지 않습니다.
            if (_isRecording) {
              widget.showSnackBar(localizations.translate('pleaseStopRecordingFirst'));
              return; // 녹음 중일 때는 닫지 않도록
            }
            if (_isPlayingUserVoice) {
              _stopAudio();
            }
            // ✨ 여기서는 스낵바를 호출하지 않고, 오버레이만 닫습니다.
            widget.onClose();
          },
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 8,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 음성 등록이 안 되어 있을 때 (첫 녹음 또는 삭제 후)
                          if (_currentSavedUserVoiceFilePath == null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localizations.translate('recordVoicePrompt'),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  localizations.translate('recordVoiceExplain'),
                                  style:
                                  const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  localizations.translate('exampleTextTitle') ?? "다음 예문을 읽어보세요:",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      currentExampleText,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.5,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: Column(
                                    children: [
                                      if (_isRecording)
                                        Text(
                                          _formatDuration(_recordDuration),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      FloatingActionButton.extended(
                                        onPressed:
                                        _isRecording ? _stopRecording : _startRecording,
                                        label: Text(
                                          _isRecording
                                              ? localizations.translate('stopRecording')
                                              : localizations.translate('startRecording'),
                                        ),
                                        icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                                        backgroundColor:
                                        _isRecording ? Colors.red : Colors.green,
                                        heroTag: 'recordVoiceFabOverlay',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          // 음성 등록이 되어 있을 때
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localizations.translate('voiceRegistered'),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  localizations.translate('readyForVoiceFeatures'),
                                  style:
                                  const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    FloatingActionButton.extended(
                                      onPressed: _isPlayingUserVoice
                                          ? _stopAudio
                                          : () => _playAudio(_currentSavedUserVoiceFilePath!),
                                      label: Text(
                                        _isPlayingUserVoice
                                            ? localizations.translate('stopPlaying')
                                            : localizations.translate('listenVoice'),
                                      ),
                                      icon: Icon(
                                          _isPlayingUserVoice ? Icons.stop : Icons.play_arrow),
                                      backgroundColor:
                                      _isPlayingUserVoice ? Colors.orange : Colors.lightBlue,
                                      heroTag: 'playUserVoiceOverlay',
                                    ),
                                    FloatingActionButton.extended(
                                      onPressed: () async {
                                        if (_isPlayingUserVoice) {
                                          await _stopAudio();
                                        }
                                        // 기존 음성 파일 삭제 (removeUserVoicePath 내부에서 파일 삭제도 처리됨)
                                        await SharedPreferencesHelper.removeUserVoicePath();
                                        // 팝업 표시 상태는 유지 (다시 첫 녹음으로 간주하지 않음)
                                        widget.onVoiceFilePathChanged(null); // 저장된 음성 없음을 알림

                                        setState(() {
                                          _currentSavedUserVoiceFilePath = null;
                                          _isRecording = false;
                                          _recordDuration = Duration.zero;
                                        });
                                        // 여기서 스낵바를 호출하는 대신, _startRecording() 내부에서 시작 스낵바가 나오도록 합니다.
                                        _startRecording();
                                      },
                                      label: Text(localizations.translate('reRecordVoice')),
                                      icon: const Icon(Icons.mic),
                                      backgroundColor: Colors.orange,
                                      heroTag: 'reRecordVoiceOverlay',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: TextButton(
                                    onPressed: () async {
                                      if (_isPlayingUserVoice) {
                                        await _stopAudio();
                                      }
                                      // 모든 사용자 음성 관련 데이터 초기화 (파일 삭제 및 팝업 상태 초기화)
                                      await SharedPreferencesHelper.clearAllUserVoiceData();
                                      widget.onVoiceFilePathChanged(null); // 저장된 음성 없음을 알림
                                      setState(() {
                                        _currentSavedUserVoiceFilePath = null;
                                      });
                                      widget.showSnackBar(
                                          localizations.translate('voiceFileDeleted'));
                                      widget.onClose();
                                    },
                                    child: Text(
                                      localizations.translate('deleteVoiceFile'),
                                      style: const TextStyle(
                                          color: Colors.red, decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          // 녹음 중이거나 재생 중일 때만 스낵바를 표시하고, 그렇지 않을 때는 단순히 닫습니다.
                          if (_isRecording) {
                            widget.showSnackBar(localizations.translate('pleaseStopRecordingFirst'));
                            return; // 녹음 중일 때는 닫지 않도록
                          }
                          if (_isPlayingUserVoice) {
                            _stopAudio();
                          }
                          // ✨ 여기서는 스낵바를 호출하지 않고, 오버레이만 닫습니다.
                          widget.onClose();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}