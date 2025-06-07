// lib/transport/app_language_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define MenuLanguage enum here as it's used for content translation
enum MenuLanguage {
  korean,
  english,
  chinese,
}

class AppLanguageProvider with ChangeNotifier {
  Locale _appLocale = const Locale('en'); // 초기 기본 언어는 영어로 설정 (이 부분은 앱의 정책에 따라 변경 가능)

  Locale get appLocale => _appLocale;

  // 현재 언어 코드를 문자열로 반환합니다.
  String get appLanguage => _appLocale.languageCode;

  // **수정된 부분:** 현재 Locale에 해당하는 MenuLanguage를 올바르게 반환합니다.
  MenuLanguage get currentMenuLanguage {
    if (_appLocale.languageCode == 'ko') { // _appLocale이 한국어일 때
      return MenuLanguage.korean; // MenuLanguage.korean 반환
    } else if (_appLocale.languageCode == 'en') { // _appLocale이 영어일 때
      return MenuLanguage.english; // MenuLanguage.english 반환
    } else if (_appLocale.languageCode == 'zh') { // _appLocale이 중국어일 때
      return MenuLanguage.chinese; // MenuLanguage.chinese 반환
    }
    return MenuLanguage.english; // 기본값으로 영어 반환 (혹은 앱의 기본 언어)
  }

  // SharedPreferences에서 언어 설정을 불러오는 함수
  Future<void> fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language_code');
    if (langCode == null) {
      _appLocale = const Locale('en'); // 저장된 언어가 없으면 기본값으로 영어 설정
    } else {
      _appLocale = Locale(langCode);
    }
    notifyListeners(); // 변경 사항을 리스너에게 알림
  }

  // 언어 설정을 변경하는 함수
  Future<void> changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return; // 현재 언어와 같으면 변경하지 않음
    }

    // Locale에 따라 _appLocale을 설정하고 저장
    if (type.languageCode == 'ko') {
      _appLocale = const Locale('ko');
      await prefs.setString('language_code', 'ko');
    } else if (type.languageCode == 'zh') {
      _appLocale = const Locale('zh');
      await prefs.setString('language_code', 'zh');
    } else { // 기본값은 영어
      _appLocale = const Locale('en');
      await prefs.setString('language_code', 'en');
    }
    notifyListeners(); // 변경 사항을 리스너에게 알림
  }
}