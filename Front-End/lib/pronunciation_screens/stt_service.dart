// lib/services/stt_service.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async'; // Timer 및 StreamController 사용

class SttService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _recordedFilePath;
  bool _isRecording = false;

  Duration _recordDuration = Duration.zero; // 현재 녹음 시간
  Timer? _recordTimer; // 녹음 시간을 업데이트하는 타이머

  final StreamController<Duration> _recordDurationController = StreamController<Duration>.broadcast();

  Stream<Duration> get recordDurationStream => _recordDurationController.stream;

  final String _sttApiUrl = 'http://aidb.kangwon.ac.kr:8083/whisper/transcribe/';

  bool get isRecording => _isRecording;
  String? get lastRecordedFilePath => _recordedFilePath;

  Future<void> startRecording() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      try {
        if (await _audioRecorder.hasPermission()) {
          Directory? appDocDir = await getApplicationDocumentsDirectory();
          _recordedFilePath = '${appDocDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';

          await _audioRecorder.start(
            RecordConfig(
              encoder: AudioEncoder.wav,
              numChannels: 1,
              sampleRate: 16000,
            ),
            path: _recordedFilePath!,
          );

          _isRecording = true;
          print('STT - 녹음 시작 (WAV): $_recordedFilePath');

          _recordDuration = Duration.zero; // 녹음 시간 초기화
          _recordDurationController.add(_recordDuration); // 스트림에 초기값 전송 (00:00)
          _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            _recordDuration = _recordDuration + const Duration(seconds: 1);
            _recordDurationController.add(_recordDuration); // 스트림에 업데이트된 시간 추가
          });

        } else {
          throw Exception('마이크 권한이 허용되지 않았습니다.');
        }
      } catch (e) {
        _isRecording = false;
        _recordTimer?.cancel(); // 에러 발생 시 타이머 중지
        _recordDurationController.addError(e); // 스트림에 에러 전송
        print('STT - 녹음 시작 실패 예외: $e');
        rethrow; // 예외를 다시 던져서 상위에서 처리할 수 있도록 함
      }
    } else {
      _isRecording = false;
      throw Exception('마이크 권한이 거부되었습니다.');
    }
  }

  Future<Map<String, dynamic>> stopRecordingAndGetText(String correctText) async {
    try {
      final String? path = await _audioRecorder.stop();
      _isRecording = false;
      _recordTimer?.cancel(); // 녹음 중지 시 타이머 중지
      print('STT - 녹음 중지. 파일 경로: $path');

      if (path != null) {
        _recordedFilePath = path;
        return await _sendAudioToServer(path, correctText);
      } else {
        throw Exception('녹음이 중지되었지만 파일 경로를 찾을 수 없습니다.');
      }
    } catch (e) {
      _isRecording = false;
      _recordTimer?.cancel(); // 에러 발생 시 타이머 중지
      print('STT - 녹음 중지 또는 오디오 전송 실패 예외: $e');
      rethrow; // 예외를 다시 던져서 상위에서 처리할 수 있도록 함
    }
  }

  Future<Map<String, dynamic>> processRecordedFile(String filePath, String referenceText) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('지정된 음성 파일이 존재하지 않습니다: $filePath');
    }
    print('STT - 기존 파일로 STT 요청 시작. 파일: $filePath, 참조 텍스트: $referenceText');
    return await _sendAudioToServer(filePath, referenceText);
  }

  Future<Map<String, dynamic>> _sendAudioToServer(String filePath, String referenceText) async {
    try {
      var uri = Uri.parse(_sttApiUrl);
      var request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        filePath,
        contentType: MediaType('audio', 'wav'),
      ));

      request.fields['reference_text'] = referenceText;

      print('STT - 서버로 파일 및 텍스트 전송 시작. 파일: $filePath, 참조 텍스트: $referenceText');
      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      print('STT - 서버 응답 상태 코드: ${response.statusCode}');
      print('STT - 서버 응답 본문: $respStr');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(respStr);

        final String recognizedText = responseData['transcription'] ?? '인식 실패';

        double? cerValue;
        if (responseData.containsKey('cer')) {
          final dynamic cerData = responseData['cer'];
          if (cerData is num) {
            cerValue = cerData.toDouble();
          } else {
            print('DEBUG: STT - "cer" 값의 타입이 예상과 다릅니다: ${cerData.runtimeType}. 값: $cerData');
            cerValue = null;
          }
        } else {
          print('DEBUG: STT - 서버 응답에 "cer" 키가 없습니다.');
          cerValue = null;
        }

        print('STT - 최종 인식된 텍스트: $recognizedText, 최종 CER: ${cerValue?.toStringAsFixed(2) ?? 'N/A'}');

        return {
          'recognizedText': recognizedText,
          'cer': cerValue,
          'recordedFilePath': filePath,
        };
      } else {
        throw Exception('STT 서버 오류: ${response.statusCode} - $respStr');
      }
    } on SocketException {
      print('STT - 네트워크 오류: 서버가 닫혀 요청을 보낼 수 없습니다.');
      throw Exception('서버가 닫혀 요청을 보낼 수 없습니다.');
    } on FormatException {
      print('STT - 서버 응답 파싱 오류: 유효한 JSON 형식이 아닙니다.');
      throw Exception('서버 응답 처리 중 오류가 발생했습니다.');
    } catch (e) {
      print('STT - 서버와 통신 실패 예외: $e');
      rethrow; // 예외를 다시 던져서 상위에서 처리할 수 있도록 함
    }
  }

  void dispose() {
    _audioRecorder.dispose();
    _recordTimer?.cancel(); // 타이머 해제
    _recordDurationController.close(); // StreamController 닫기
    print('SttService disposed.');
  }
}