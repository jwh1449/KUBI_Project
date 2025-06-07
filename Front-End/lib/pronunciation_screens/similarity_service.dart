// lib/services/similarity_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart' as http_parser;

class SimilarityService {
  final String _mfccCompareApiUrl = 'http://aidb.kangwon.ac.kr:8083/mfcc/compare/';

  Future<double> compareAudioSimilarity(String ttsAudioPath, String recordedAudioPath) async {
    try {
      var uri = Uri.parse(_mfccCompareApiUrl);
      var request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath(
        'audio1', // API가 기대하는 첫 번째 오디오 파일 필드명
        ttsAudioPath,
        contentType: http_parser.MediaType('audio', 'wav'), // 'http_parser.' 접두사 추가
      ));

      request.files.add(await http.MultipartFile.fromPath(
        'audio2', // API가 기대하는 두 번째 오디오 파일 필드명
        recordedAudioPath,
        contentType: http_parser.MediaType('audio', 'wav'), // 'http_parser.' 접두사 추가
      ));

      print('MFCC 유사도 API로 파일 전송 시작.');
      print('  Audio1 (TTS): $ttsAudioPath');
      print('  Audio2 (녹음): $recordedAudioPath');

      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      print('MFCC 유사도 API 응답 상태 코드: ${response.statusCode}');
      print('MFCC 유사도 API 응답 본문: $respStr');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(respStr);
        final double? similarityScore = responseData['similarity_percent']?.toDouble();

        if (similarityScore != null) {
          print('MFCC 유사도 점수: $similarityScore');
          return similarityScore;
        } else {
          throw Exception('MFCC 유사도 API 응답에 "similarity_percent"가 없거나 유효하지 않습니다.');
        }
      } else {
        throw Exception('MFCC 유사도 API 오류: ${response.statusCode} - $respStr');
      }
    } catch (e) {
      print('MFCC 유사도 API 통신 실패 예외: $e');
      throw Exception('MFCC 유사도 API 통신 실패: $e');
    }
  }
}