// lib/services/tts_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart'; // MediaType을 위해 필요
import 'dart:typed_data';

class TtsService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final String _ttsApiUrl = 'http://aidb.kangwon.ac.kr:8083/zonos/generate/';

  String? _lastGeneratedTtsAudioPath;

  TtsService();

  Future<String?> speakText(String text, {String? language = 'ko'}) async {
    if (text.isEmpty) {
      print('TTS: speakText (Standard) - 변환할 텍스트가 비어 있습니다. 요청을 보내지 않습니다.');
      return null;
    }

    try {
      await _audioPlayer.stop(); // 이전에 재생 중이던 오디오 중지

      var uri = Uri.parse(_ttsApiUrl);
      var request = http.MultipartRequest('POST', uri);

      request.fields['text'] = text;

      print('TTS 서버로 MultipartRequest 전송 준비. 텍스트: "$text"');
      print('TTS 서버 URL: $_ttsApiUrl');

      var response = await request.send();

      print('TTS 서버 응답 상태 코드: ${response.statusCode}');
      final String? contentType = response.headers['content-type'];
      print('TTS 서버 응답 Content-Type: $contentType');

      if (response.statusCode == 200) {
        List<int> audioBytesList;
        if (contentType?.contains('audio/') ?? false) {
          audioBytesList = await response.stream.toBytes();
          print('TTS: 오디오 바이트 직접 수신 (Content-Type: $contentType)');
        } else if (contentType?.contains('application/json') ?? false) {
          final respStr = await response.stream.bytesToString();
          print('TTS 서버 응답 본문 (JSON): ${respStr.length > 200 ? respStr.substring(0, 200) + '...' : respStr}');

          final Map<String, dynamic> responseData = json.decode(respStr);
          String? base64Audio = responseData['audioContent'] ?? responseData['audio'] ?? responseData['data'] ?? responseData['base64Audio'];

          if (base64Audio != null && base64Audio.isNotEmpty) {
            if (base64Audio.startsWith('data:')) {
              base64Audio = base64Audio.split(',').last;
            }
            audioBytesList = base64Decode(base64Audio);
            print('TTS: Base64 디코딩 후 오디오 바이트 수신');
          } else {
            throw Exception('TTS 응답 JSON에 유효한 오디오 콘텐츠가 없습니다.');
          }
        } else {
          final respStr = await response.stream.bytesToString();
          throw Exception('TTS 서버가 예상치 못한 Content-Type을 반환했습니다: $contentType. 응답: $respStr');
        }

        final Uint8List audioBytes = Uint8List.fromList(audioBytesList);

        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String fileName = 'tts_output_${DateTime.now().millisecondsSinceEpoch}.wav';
        final File ttsFile = File('${appDocDir.path}/$fileName');
        await ttsFile.writeAsBytes(audioBytes);
        _lastGeneratedTtsAudioPath = ttsFile.path;
        print('TTS: 생성된 TTS 오디오 파일 저장됨: $_lastGeneratedTtsAudioPath');

        await _audioPlayer.setSourceBytes(audioBytes);
        await _audioPlayer.resume();
        print('TTS: 오디오 재생 시작 (TtsService 내부에서)');

        return _lastGeneratedTtsAudioPath;
      } else {
        final respStr = await response.stream.bytesToString();
        throw Exception('TTS 서버 오류: ${response.statusCode} - $respStr');
      }
    } catch (e) {
      print('TTS 서버 통신 또는 오디오 생성/재생 실패 예외: $e');
      throw Exception('TTS 서버 통신 또는 오디오 생성/재생 실패: $e');
    }
  }

  // 개인화된 음성 복제 TTS
  // 이 함수는 speaker_audio_path를 필수로 받으며, TTS 서버로 해당 파일을 함께 전송
  Future<String?> speakPersonalizedText(String text, {required String language, required String speakerAudioPath}) async {
    if (text.isEmpty) {
      print('TTS: speakPersonalizedText - 변환할 텍스트가 비어 있습니다. 요청을 보내지 않습니다.');
      return null;
    }
    // 이 함수는 speakerAudioPath가 필수로 제공되어야 합니다.
    if (speakerAudioPath.isEmpty || !await File(speakerAudioPath).exists()) {
      final errorMessage = 'TTS 서버는 speaker_audio 파일을 필수로 요구하지만, 지정된 스피커 오디오 파일이 유효하지 않습니다. 경로: $speakerAudioPath';
      print('ERROR: speakPersonalizedText - $errorMessage');
      throw Exception(errorMessage);
    }

    try {
      await _audioPlayer.stop(); // 이전에 재생 중이던 오디오 중지

      var uri = Uri.parse(_ttsApiUrl); // 동일한 TTS API URL 사용 가정
      var request = http.MultipartRequest('POST', uri);

      request.fields['text'] = text;

      File speakerAudioFile = File(speakerAudioPath);

      print('DEBUG: speakPersonalizedText - 스피커 오디오 파일: $speakerAudioPath 를 요청에 추가합니다.');
      request.files.add(await http.MultipartFile.fromPath(
        'speaker_audio',
        speakerAudioFile.path,
        contentType: MediaType('audio', 'wav'),
      ));

      print('TTS 서버로 MultipartRequest 전송 준비 (개인화). 텍스트: "$text", speaker_audio 파일: $speakerAudioPath');
      print('TTS 서버 URL: $_ttsApiUrl');

      var response = await request.send();

      print('TTS 서버 응답 상태 코드 (개인화): ${response.statusCode}');
      final String? contentType = response.headers['content-type'];
      print('TTS 서버 응답 Content-Type (개인화): $contentType');

      if (response.statusCode == 200) {
        List<int> audioBytesList;
        if (contentType?.contains('audio/') ?? false) {
          audioBytesList = await response.stream.toBytes();
          print('TTS (개인화): 오디오 바이트 직접 수신');
        } else if (contentType?.contains('application/json') ?? false) {
          final respStr = await response.stream.bytesToString();
          final Map<String, dynamic> responseData = json.decode(respStr);
          String? base64Audio = responseData['audioContent'] ?? responseData['audio'] ?? responseData['data'] ?? responseData['base64Audio'];
          if (base64Audio != null && base64Audio.isNotEmpty) {
            if (base64Audio.startsWith('data:')) {
              base64Audio = base64Audio.split(',').last;
            }
            audioBytesList = base64Decode(base64Audio);
            print('TTS (개인화): Base64 디코딩 후 오디오 바이트 수신');
          } else {
            throw Exception('TTS 응답 JSON에 유효한 오디오 콘텐츠가 없습니다.');
          }
        } else {
          final respStr = await response.stream.bytesToString();
          throw Exception('TTS 서버가 예상치 못한 Content-Type을 반환했습니다: $contentType. 응답: $respStr');
        }

        final Uint8List audioBytes = Uint8List.fromList(audioBytesList);

        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String fileName = 'tts_personalized_output_${DateTime.now().millisecondsSinceEpoch}.wav';
        final File ttsFile = File('${appDocDir.path}/$fileName');
        await ttsFile.writeAsBytes(audioBytes);
        final String personalizedAudioPath = ttsFile.path;
        print('TTS (개인화): 생성된 TTS 오디오 파일 저장됨: $personalizedAudioPath');

        await _audioPlayer.setSourceBytes(audioBytes);
        await _audioPlayer.resume();
        print('TTS (개인화): 오디오 재생 시작');

        return personalizedAudioPath;
      } else {
        final respStr = await response.stream.bytesToString();
        throw Exception('TTS 서버 오류 (개인화): ${response.statusCode} - $respStr');
      }
    } catch (e) {
      print('TTS 서버 통신 또는 오디오 생성/재생 실패 예외 (개인화): $e');
      throw Exception('TTS 서버 통신 또는 오디오 생성/재생 실패 (개인화): $e');
    }
  }

  // 마지막으로 생성된 TTS 오디오 파일 경로를 가져오는 getter
  String? get lastGeneratedTtsAudioPath => _lastGeneratedTtsAudioPath;

  // 오디오 재생 중지
  Future<void> stop() async {
    await _audioPlayer.stop();
    print('TTS: stop - 현재 TTS 오디오 재생 중지됨.');
  }

  // 리소스 해제
  void dispose() {
    _audioPlayer.dispose();

    if (_lastGeneratedTtsAudioPath != null) {
      final file = File(_lastGeneratedTtsAudioPath!);
      if (file.existsSync()) {
        try {
          file.deleteSync();
          print('TTS: dispose - 생성된 TTS 오디오 파일 삭제: $_lastGeneratedTtsAudioPath');
        } catch (e) {
          print('TTS: dispose - 생성된 TTS 오디오 파일 삭제 중 오류 발생: $e');
        }
      }
    }
  }
}