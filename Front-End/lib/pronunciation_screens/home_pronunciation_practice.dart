// lib/pronunciation_practice_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'stt_service.dart';
import 'tts_service.dart';
import 'similarity_service.dart';
import 'pronunciation_result_screen.dart';
import 'practice_result.dart';
import 'database_helper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../localization/app_localizations.dart';

class PronunciationPracticeScreen extends StatefulWidget {
  final String correctText;
  final String? translatedText;

  final String userName;
  final String userCollege;
  final String userDepartment;
  final String? userRecordedAudioPath;

  const PronunciationPracticeScreen({
    Key? key,
    required this.correctText,
    this.translatedText,
    required this.userName,
    required this.userCollege,
    required this.userDepartment,
    this.userRecordedAudioPath,
  }) : super(key: key);

  @override
  _PronunciationPracticeScreenState createState() =>
      _PronunciationPracticeScreenState();
}

class _PronunciationPracticeScreenState
    extends State<PronunciationPracticeScreen> {
  late TtsService _ttsService;
  late SttService _sttService;
  late SimilarityService _similarityService;

  final AudioPlayer _userRecordingPlayer = AudioPlayer();
  final AudioPlayer _ttsReferencePlayer = AudioPlayer();

  bool _isListening = false;
  late String _text;
  late String _guideText;

  bool _isLoadingApi = false;
  bool _showResultButton = false;
  bool _isPlayingUserRecording = false;
  bool _isPlayingTtsReference = false;
  bool _isPersonalizedTtsAudioReady = false;

  String get correctText => widget.correctText;

  String? _recognizedText;
  double? _cerValue;
  String? _lastRecordedAudioPath;
  String? _lastGeneratedTtsAudioPath;

  double? _mfccSimilarityScore;

  Duration _currentRecordDuration = Duration.zero;
  StreamSubscription<Duration>? _recordDurationSubscription;

  @override
  void initState() {
    super.initState();
    _ttsService = TtsService();
    _sttService = SttService();
    _similarityService = SimilarityService();

    _initAudioPlayersListeners();
    _subscribeToSttRecordingDuration();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        setState(() {
          _text = localizations.translate('pressMicToSpeak') ?? 'Press the microphone to speak.';
          _guideText = localizations.translate('guideListenAndSpeak') ?? 'Press the speaker icon to listen to the personalized pronunciation, then press the microphone to speak.';
        });
      }
    });
  }

  void _initAudioPlayersListeners() {
    _userRecordingPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlayingUserRecording = state == PlayerState.playing;
        });
      }
    });

    _ttsReferencePlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlayingTtsReference = state == PlayerState.playing;
          if (state == PlayerState.completed || state == PlayerState.stopped || state == PlayerState.paused) {
            if (!_isListening && !_isLoadingApi) {
              _guideText = AppLocalizations.of(context)!.translate('guideListenAndSpeak') ?? 'Press the speaker icon to listen to the personalized pronunciation, then press the microphone to speak.';
            }
          }
        });
      }
    });
  }

  void _subscribeToSttRecordingDuration() {
    _recordDurationSubscription = _sttService.recordDurationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _currentRecordDuration = duration;
        });
      }
    }, onError: (error) {
      print('STT Record Duration Stream Error: $error');
    });
  }

  Future<void> _sendVoiceAndTextForPersonalizedTts() async {
    final localizations = AppLocalizations.of(context)!;

    if (widget.userRecordedAudioPath == null || widget.userRecordedAudioPath!.isEmpty) {
      _showSnackBar(localizations.translate('noVoiceFileFoundForPersonalization') ?? 'User voice file not found for personalization.');
      setState(() {
        _isLoadingApi = false;
        _guideText = localizations.translate('cannotProceedWithoutVoice') ?? 'Cannot proceed without user voice file.';
      });
      return;
    }
    final voiceFile = File(widget.userRecordedAudioPath!);
    if (!await voiceFile.exists()) {
      _showSnackBar(localizations.translate('userVoiceFileDoesNotExist') ?? 'User voice file does not exist.');
      setState(() {
        _isLoadingApi = false;
        _guideText = localizations.translate('cannotProceedWithoutVoice') ?? 'Cannot proceed without user voice file.';
      });
      return;
    }

    setState(() {
      _isLoadingApi = true;
      _guideText = localizations.translate('preparingPersonalizedAudio') ?? 'Preparing your personalized pronunciation audio...';
    });

    try {
      final uri = Uri.parse('http://aidb.kangwon.ac.kr:8083/zonos/generate/');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath('speaker_audio', widget.userRecordedAudioPath!));
      request.fields['text'] = correctText;

      request.fields['user_name'] = widget.userName;
      request.fields['user_college'] = widget.userCollege;
      request.fields['user_department'] = widget.userDepartment;

      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final bytes = await streamedResponse.stream.toBytes();
        final tempDir = await getTemporaryDirectory();
        _lastGeneratedTtsAudioPath = '${tempDir.path}/personalized_tts_${DateTime.now().millisecondsSinceEpoch}.wav';
        final File ttsFile = File(_lastGeneratedTtsAudioPath!);
        await ttsFile.writeAsBytes(bytes);

        print("Personalized TTS audio received and saved: $_lastGeneratedTtsAudioPath");
        _showSnackBar(localizations.translate('personalizedAudioReady') ?? 'Personalized audio is ready!');
        setState(() {
          _isPersonalizedTtsAudioReady = true;
        });
      } else {
        final errorBody = await streamedResponse.stream.bytesToString();
        print("TTS Server Error (${streamedResponse.statusCode}): $errorBody");
        _showSnackBar(localizations.translate('ttsServerError', {'statusCode': streamedResponse.statusCode.toString(), 'error': errorBody}) ?? 'TTS server error.');
        _lastGeneratedTtsAudioPath = null;
        setState(() {
          _isPersonalizedTtsAudioReady = false;
        });
      }
    } catch (e) {
      print("TTS server communication error: $e");
      _showSnackBar(localizations.translate('networkError', {'error': e.toString()}) ?? 'Network error.');
      _lastGeneratedTtsAudioPath = null;
      setState(() {
        _isPersonalizedTtsAudioReady = false;
      });
    } finally {
      setState(() {
        _isLoadingApi = false;
        if (_isPersonalizedTtsAudioReady) {
          _guideText = localizations.translate('guideListenAndSpeak') ?? 'Press the speaker icon to listen to the personalized pronunciation, then press the microphone to speak.';
        } else {
          _guideText = localizations.translate('failedToPrepareAudio') ?? 'Failed to prepare personalized audio. Cannot proceed with practice.';
        }
      });
    }
  }

  Future<void> _playCorrectTextReference() async {
    final localizations = AppLocalizations.of(context)!;
    if (!_isPersonalizedTtsAudioReady || _lastGeneratedTtsAudioPath == null || _lastGeneratedTtsAudioPath!.isEmpty) {
      if (!_isLoadingApi) {
        await _sendVoiceAndTextForPersonalizedTts();
      } else {
        _showSnackBar(localizations.translate('personalizedAudioBeingPrepared') ?? 'Personalized pronunciation audio is being prepared. Please wait.');
      }
      return;
    }

    if (_isPlayingTtsReference) {
      await _ttsReferencePlayer.stop();
      return;
    }

    if (!(await File(_lastGeneratedTtsAudioPath!).exists())) {
      _showSnackBar(localizations.translate('personalizedAudioNotFoundRecreating') ?? 'Personalized audio file not found. Re-creating...');
      setState(() {
        _isPersonalizedTtsAudioReady = false;
      });
      if (!_isLoadingApi) {
        await _sendVoiceAndTextForPersonalizedTts();
      }
      return;
    }

    await _userRecordingPlayer.stop();

    try {
      setState(() {
        _isPlayingTtsReference = true;
        _guideText = localizations.translate('playingPersonalizedAudio') ?? 'Playing personalized pronunciation... Listen carefully!';
      });
      await _ttsReferencePlayer.setSourceDeviceFile(_lastGeneratedTtsAudioPath!);
      await _ttsReferencePlayer.resume();
      print('Playing personalized TTS reference audio: $_lastGeneratedTtsAudioPath');
    } catch (e) {
      print('Failed to play personalized TTS reference audio: $e');
      _showSnackBar(localizations.translate('playPersonalizedAudioError', {'error': e.toString()}) ?? 'Failed to play personalized pronunciation.');
      setState(() {
        _isPlayingTtsReference = false;
      });
    }
  }

  void _toggleListening() async {
    final localizations = AppLocalizations.of(context)!;
    await _userRecordingPlayer.stop();
    await _ttsReferencePlayer.stop();

    if (!_isPersonalizedTtsAudioReady || _lastGeneratedTtsAudioPath == null || _lastGeneratedTtsAudioPath!.isEmpty) {
      _showSnackBar(localizations.translate('personalizedAudioNotReadyToRecord') ?? 'Personalized audio is not ready. Please play it first to generate it.');
      return;
    }

    if (_sttService.isRecording) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() async {
    final localizations = AppLocalizations.of(context)!;
    setState(() {
      _isListening = true;
      _text = localizations.translate('listening') ?? 'Listening...';
      _guideText = localizations.translate('speakNow') ?? 'Speak the sentence now.';
      _showResultButton = false;
      _isLoadingApi = false;
      _recognizedText = null;
      _cerValue = null;
      _mfccSimilarityScore = null;
      _isPlayingUserRecording = false;
      _isPlayingTtsReference = false;
      _currentRecordDuration = Duration.zero;
    });
    try {
      await _sttService.startRecording();
    } catch (e) {
      setState(() {
        _isListening = false;
        _guideText = localizations.translate('recordingError', {'error': e.toString()}) ?? 'Recording error.';
      });
      _showSnackBar(localizations.translate('errorStartingRecording', {'error': e.toString()}) ?? 'Error starting recording.');
    }
  }

  void _stopListening() async {
    final localizations = AppLocalizations.of(context)!;
    setState(() {
      _isLoadingApi = true;
      _isListening = false;
      _guideText = localizations.translate('analyzingPronunciation') ?? 'Recording complete. Analyzing your pronunciation...';
    });
    try {
      final sttResult = await _sttService.stopRecordingAndGetText(correctText);
      _recognizedText = sttResult['recognizedText'] as String?;
      _lastRecordedAudioPath = sttResult['recordedFilePath'] as String?;
      _cerValue = sttResult['cer'] as double?;

      setState(() {
        _text = _recognizedText ?? (localizations.translate('speechRecognitionFailed') ?? 'Speech recognition failed.');
      });

      if (_recognizedText != null && _recognizedText != '인식 실패') {
        if (_lastGeneratedTtsAudioPath != null && _lastRecordedAudioPath != null &&
            await File(_lastGeneratedTtsAudioPath!).exists() &&
            await File(_lastRecordedAudioPath!).exists()
        ) {
          try {
            _mfccSimilarityScore = await _similarityService.compareAudioSimilarity(
              _lastGeneratedTtsAudioPath!,
              _lastRecordedAudioPath!,
            );
            // Removed direct display of recognized text, CER, and MFCC here
            _guideText = localizations.translate('analysisCompleteProceedToResult') ?? 'Analysis complete. Press "View Result" to see details.';
          } catch (e) {
            print('MFCC 유사도 계산 중 오류 발생: $e');
            _guideText = localizations.translate('mfccCalculationError') ?? 'Analysis complete, but an error occurred during similarity calculation. Please view the result for details.';
          }
        } else {
          _guideText = localizations.translate('analysisCompleteProceedToResult') ?? 'Analysis complete. Press "View Result" to see details.';
          print('DEBUG: MFCC 유사도 계산 실패: 개인화된 TTS 기준 파일 또는 사용자 녹음 파일 경로가 유효하지 않음.');
        }

        _savePracticeResult(
            correctText, _recognizedText!, _cerValue, _mfccSimilarityScore, _lastRecordedAudioPath);
      } else {
        _showSnackBar(localizations.translate('speechRecognitionFailedTryAgain') ?? 'Speech recognition failed. Please try again.');
        _guideText = localizations.translate('speechRecognitionFailedTryAgain') ?? 'Speech recognition failed. Please try again.';
      }
      _showResultButton = true;

    } catch (e) {
      setState(() {
        _guideText = localizations.translate('speechRecognitionError', {'error': e.toString()}) ?? 'Speech recognition error.';
        _showResultButton = true;
      });
      _showSnackBar(localizations.translate('errorDuringSpeechRecognition', {'error': e.toString()}) ?? 'An error occurred during speech recognition.');
    } finally {
      setState(() {
        _isLoadingApi = false;
      });
    }
  }

  Future<void> _togglePlayUserRecording() async {
    final localizations = AppLocalizations.of(context)!;
    await _ttsReferencePlayer.stop();

    if (_isPlayingUserRecording) {
      await _userRecordingPlayer.pause();
      setState(() {
        _isPlayingUserRecording = false;
      });
    } else {
      if (_lastRecordedAudioPath == null || _lastRecordedAudioPath!.isEmpty || !(await File(_lastRecordedAudioPath!).exists())) {
        _showSnackBar(localizations.translate('noValidRecordingToPlay') ?? 'No valid recording to play. Please record your voice first.');
        return;
      }

      try {
        await _userRecordingPlayer.setSourceDeviceFile(_lastRecordedAudioPath!);
        await _userRecordingPlayer.resume();
        setState(() {
          _isPlayingUserRecording = true;
        });
        print('Playing user recording: $_lastRecordedAudioPath');
      } catch (e) {
        print('Failed to play user recording: $e');
        _showSnackBar(localizations.translate('failedToPlayRecording', {'error': e.toString()}) ?? 'Failed to play recording.');
        setState(() {
          _isPlayingUserRecording = false;
        });
      }
    }
  }

  Future<void> _savePracticeResult(
      String correct, String recognized, double? cer, double? mfccScore, String? audioPath) async {
    final result = PracticeResult(
      correctText: correct,
      recognizedText: recognized,
      cer: cer,
      mfccSimilarity: mfccScore,
      timestamp: DateTime.now(),
      recognizedAudioPath: audioPath,
    );
    await DatabaseHelper.instance.insertPracticeResult(result);
    print('Practice result saved: $result');
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _navigateToResultScreen() {
    final localizations = AppLocalizations.of(context)!;
    if (_recognizedText != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PronunciationResultScreen(
            recognizedText: _recognizedText!,
            correctText: correctText,
            cerValue: _cerValue,
            mfccSimilarityScore: _mfccSimilarityScore,
          ),
        ),
      );
    } else {
      _showSnackBar(localizations.translate('noRecognizedText') ?? 'No recognized text to display result.');
    }
  }


  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _ttsService.dispose();
    _sttService.dispose();
    _userRecordingPlayer.dispose();
    _ttsReferencePlayer.dispose();
    _recordDurationSubscription?.cancel();
    if (_lastGeneratedTtsAudioPath != null) {
      final file = File(_lastGeneratedTtsAudioPath!);
      if (file.existsSync()) {
        file.deleteSync();
        print('Deleted temporary personalized TTS audio: $_lastGeneratedTtsAudioPath');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    print('BUILD: _isLoadingApi: $_isLoadingApi, _isListening: $_isListening, _lastGeneratedTtsAudioPath: $_lastGeneratedTtsAudioPath, _isPersonalizedTtsAudioReady: $_isPersonalizedTtsAudioReady');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('pronunciationPractice'),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        actions: const [

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.translate('correctSentence')!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        correctText,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.translatedText != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          '(${widget.translatedText!})',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(
                              Icons.volume_up,
                              color: Colors.lightBlue,
                              size: 30
                          ),
                          onPressed: _playCorrectTextReference,
                          tooltip: localizations.translate('listenToCorrectSentence'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _guideText,
                  style: TextStyle(
                    fontSize: 18,
                    color: _isListening ? Colors.redAccent : Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_isLoadingApi && !_isListening)
                        const SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            strokeWidth: 6,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                          ),
                        ),
                      FloatingActionButton(
                        onPressed: () {
                          if (!_isPersonalizedTtsAudioReady || _lastGeneratedTtsAudioPath == null || _lastGeneratedTtsAudioPath!.isEmpty) {
                            _showSnackBar(localizations.translate('personalizedAudioNotReady') ?? 'Personalized audio is not ready. Please press the speaker button first.');
                            return;
                          }
                          if (_isLoadingApi && !_isListening) {
                            _showSnackBar(localizations.translate('processingRequest') ?? 'Processing your request. Please wait.');
                            return;
                          }
                          _toggleListening();
                        },
                        backgroundColor:
                        _isListening ? Colors.redAccent : Colors.lightBlue,
                        heroTag: 'microphoneBtn',
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_isListening)
                    Text(
                      _formatDuration(_currentRecordDuration),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          _text,
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (_lastRecordedAudioPath != null && _lastRecordedAudioPath!.isNotEmpty && !_isLoadingApi)
                        IconButton(
                          icon: Icon(
                            _isPlayingUserRecording ? Icons.pause_circle_filled : Icons.play_circle_fill,
                            color: Colors.green,
                            size: 35,
                          ),
                          onPressed: _togglePlayUserRecording,
                          tooltip: _isPlayingUserRecording ? localizations.translate('pauseYourRecording') : localizations.translate('playYourRecording'),
                        ),
                    ],
                  ),
                ],
              ),

              if (_showResultButton)
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: ElevatedButton(
                    onPressed: _navigateToResultScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      localizations.translate('viewResult')!,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}