import 'package:flutter/material.dart';
import 'package:personal_test/localization/app_localizations.dart';
import 'package:translator/translator.dart';
import 'package:personal_test/pronunciation_screens/tts_service.dart'; // tts_service.dart 경로 확인

// MenuLanguage enum은 AppLanguageProvider.dart 또는 별도 파일에 정의되어 있어야 합니다.
enum MenuLanguage { english, chinese, korean }

class CommunicationScreen extends StatefulWidget {
  final String userName;
  final String userCollege;
  final String userDepartment;
  final String? userRecordedAudioPath; // 사용자가 녹음한 음성 파일 경로

  const CommunicationScreen({
    Key? key,
    required this.userName,
    required this.userCollege,
    required this.userDepartment,
    this.userRecordedAudioPath, // 이 경로를 받아서 사용합니다.
  }) : super(key: key);

  @override
  _CommunicationScreenState createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  final GoogleTranslator _googleTranslator = GoogleTranslator();

  late final TtsService _ttsService; // TTS 서비스 인스턴스

  bool _isLoadingTranslate = false; // 번역 로딩 상태
  bool _isLoadingSpeak = false; // TTS 재생 로딩 상태

  String _inputText = ''; // 사용자 입력 텍스트
  String _translatedText = ''; // 번역된 텍스트

  final TextEditingController _textEditingController = TextEditingController();

  MenuLanguage _currentSourceMenuLanguage = MenuLanguage.english; // 현재 선택된 원본 언어

  @override
  void initState() {
    super.initState();
    _ttsService = TtsService(); // TTS 서비스 초기화
  }

  @override
  void dispose() {
    _ttsService.dispose(); // TTS 서비스 리소스 해제
    _textEditingController.dispose(); // TextEditingController 리소스 해제
    super.dispose();
  }

  /// 텍스트를 번역하는 함수
  Future<void> _performTranslation() async {
    final localizations = AppLocalizations.of(context)!;
    _inputText = _textEditingController.text.trim();

    if (_inputText.isEmpty) {
      _showSnackBar(localizations.translate('enterTextToTranslate'));
      return;
    }

    setState(() {
      _isLoadingTranslate = true;
      _translatedText = ''; // 번역 시작 전 번역된 텍스트 초기화
    });

    try {
      _showSnackBar(localizations.translate('translating'));

      final translation = await _googleTranslator.translate(
        _inputText,
        from: _getGoogleTranslatorSourceLanguageCode(_currentSourceMenuLanguage),
        to: 'ko', // 한국어로 번역
      );

      _translatedText = translation.text;

      if (_translatedText.isEmpty) {
        _showSnackBar(localizations.translate('translationFailed'));
      } else {
        _showSnackBar(localizations.translate('translationComplete'));
      }
    } catch (e) {
      _showSnackBar(localizations.translate('communicationError', {'errorMessage': e.toString()}));
    } finally {
      setState(() {
        _isLoadingTranslate = false; // 번역 로딩 상태 해제
      });
    }
  }

  /// 번역된 텍스트를 TTS로 재생하는 함수 (사용자 녹음 음성 사용)
  Future<void> _performSpeech() async {
    final localizations = AppLocalizations.of(context)!;

    if (_translatedText.isEmpty) {
      _showSnackBar(localizations.translate('noTranslatedTextToSpeak'));
      return;
    }

    // 사용자 녹음 음성 파일이 유효한지 확인
    if (widget.userRecordedAudioPath == null || widget.userRecordedAudioPath!.isEmpty) {
      _showSnackBar(localizations.translate('voiceRecordingRequiredForPersonalizedTTS')); // 새로운 메시지 추가 필요
      return;
    }

    setState(() {
      _isLoadingSpeak = true; // TTS 재생 로딩 상태 설정
    });

    try {
      _showSnackBar(localizations.translate('speaking'));
      // TtsService의 speakText 대신 speakPersonalizedText 호출
      await _ttsService.speakPersonalizedText(
        _translatedText,
        language: 'ko', // 번역된 텍스트가 한국어이므로 'ko'로 명시
        speakerAudioPath: widget.userRecordedAudioPath!, // null 체크 후 ! 연산자 사용
      );
      _showSnackBar(localizations.translate('speechComplete'));
    } catch (e) {
      _showSnackBar(localizations.translate('ttsError', {'errorMessage': e.toString()}));
    } finally {
      setState(() {
        _isLoadingSpeak = false; // TTS 재생 로딩 상태 해제
      });
    }
  }

  /// Google Translator에 사용될 언어 코드 반환
  String _getGoogleTranslatorSourceLanguageCode(MenuLanguage lang) {
    switch (lang) {
      case MenuLanguage.english:
        return 'en';
      case MenuLanguage.chinese:
        return 'zh-cn';
      case MenuLanguage.korean:
        return 'ko';
      default:
        return 'en';
    }
  }

  /// 스낵바 메시지를 표시하는 헬퍼 함수
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
      );
    }
  }

  /// 언어 드롭다운 메뉴에 표시될 언어 이름 반환
  String _getLanguageDisplayName(MenuLanguage menuLanguage, AppLocalizations localizations) {
    switch (menuLanguage) {
      case MenuLanguage.english:
        return localizations.translate('english');
      case MenuLanguage.chinese:
        return localizations.translate('chinese');
      case MenuLanguage.korean:
        return localizations.translate('korean');
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final List<MenuLanguage> supportedSourceLanguages = [
      MenuLanguage.english,
      MenuLanguage.chinese,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('communicationTitle'), style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 원본 언어 선택 드롭다운 메뉴
              DropdownButtonFormField<MenuLanguage>(
                value: _currentSourceMenuLanguage,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // focusedBorder, labelStyle, floatingLabelStyle은 main.dart의 InputDecorationTheme을 따름
                ),
                onChanged: (MenuLanguage? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currentSourceMenuLanguage = newValue;
                      _inputText = '';
                      _translatedText = '';
                      _textEditingController.clear();
                    });
                  }
                },
                items: supportedSourceLanguages.map<DropdownMenuItem<MenuLanguage>>((MenuLanguage lang) {
                  return DropdownMenuItem<MenuLanguage>(
                    value: lang,
                    child: Text(_getLanguageDisplayName(lang, localizations)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // 텍스트 입력 필드
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: localizations.translate('enterTextInYourLanguage'),
                  hintText: localizations.translate('typeHere'),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey[700],
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.lightBlue,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _textEditingController.clear(),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),

              // 번역 버튼
              ElevatedButton.icon(
                onPressed: !_isLoadingTranslate ? _performTranslation : null,
                icon: const Icon(Icons.g_translate),
                label: Text(localizations.translate('translateButton')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 10),

              // TTS 음성 듣기 버튼
              ElevatedButton.icon(
                // userRecordedAudioPath가 없으면 버튼 비활성화 (개인화 TTS를 사용하기 위함)
                onPressed: _translatedText.isNotEmpty && !_isLoadingSpeak &&
                    (widget.userRecordedAudioPath != null && widget.userRecordedAudioPath!.isNotEmpty)
                    ? _performSpeech
                    : null,
                icon: const Icon(Icons.volume_up),
                label: Text(localizations.translate('speakButton')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 20),

              const Divider(),
              const SizedBox(height: 20),
              // 입력된 텍스트 표시 카드
              if (_inputText.isNotEmpty)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('${localizations.translate('yourInputText')}: $_inputText'),
                  ),
                ),
              // 번역된 텍스트 표시 카드
              if (_translatedText.isNotEmpty)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('${localizations.translate('translatedText')}: $_translatedText'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}