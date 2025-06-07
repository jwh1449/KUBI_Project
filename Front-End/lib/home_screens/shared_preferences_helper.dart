import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // 파일 삭제를 위해 추가

class SharedPreferencesHelper {
  static const String _userVoicePathKey = 'userVoicePath';
  static const String _hasShownRecordVoicePopupKey = 'hasShownRecordVoicePopup';

  static Future<String?> getUserVoicePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userVoicePathKey);
  }

  static Future<void> saveUserVoicePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userVoicePathKey, path);
  }

  static Future<void> removeUserVoicePath() async {
    final prefs = await SharedPreferences.getInstance();
    final filePath = prefs.getString(_userVoicePathKey);
    if (filePath != null && filePath.isNotEmpty) {
      try {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          print("음성 파일이 성공적으로 삭제되었습니다: $filePath");
        }
      } catch (e) {
        print("음성 파일 삭제 중 오류 발생: $e");
      }
    }
    await prefs.remove(_userVoicePathKey);
  }

  static Future<bool> getHasShownRecordVoicePopup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasShownRecordVoicePopupKey) ?? false;
  }

  static Future<void> saveHasShownRecordVoicePopup(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasShownRecordVoicePopupKey, status);
  }

  // --- 추가할 함수: 모든 사용자 데이터 초기화 (음성 파일 포함) ---
  static Future<void> clearAllUserVoiceData() async {
    await removeUserVoicePath(); // SharedPreferences에서 경로 삭제 및 실제 파일 삭제
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasShownRecordVoicePopupKey); // 팝업 상태도 초기화
    print("모든 사용자 음성 관련 데이터가 초기화되었습니다.");
  }
}