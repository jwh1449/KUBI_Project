import 'package:flutter/material.dart';
import 'package:personal_test/localization/app_localizations.dart';

//로그아웃 화면
class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // 현지화 인스턴스 가져오기

    return Scaffold(
      appBar: AppBar(title: Text(localizations.translate('settings'))), // ✨ 현지화
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showLogoutDialog(context); // 로그아웃 다이얼로그 호출
          },
          child: Text(localizations.translate('logout')), // ✨ 현지화
        ),
      ),
    );
  }

  // 로그아웃 확인 다이얼로그
  void _showLogoutDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // 현지화 인스턴스 가져오기

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.translate('logoutConfirmationTitle')), // ✨ 현지화
          content: Text(localizations.translate('logoutConfirmationContent')), // ✨ 현지화
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text(localizations.translate('cancellation')), // ✨ 현지화
            ),
            TextButton(
              onPressed: () {
                // 로그아웃 처리 코드 작성
                _logout(context);
              },
              child: Text(localizations.translate('check')), // ✨ 현지화
            ),
          ],
        );
      },
    );
  }

  // 로그아웃 처리 함수
  void _logout(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // 현지화 인스턴스 가져오기

    // 실제로는 인증 토큰 삭제, 사용자 데이터 초기화 등 실제 로그아웃 작업을 여기에 추가해야 합니다.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localizations.translate('loggedOutMessage'))), // ✨ 현지화
    );

    // 로그아웃 후 홈 화면 또는 로그인 화면으로 돌아가도록 할 수 있습니다.
    Navigator.pushReplacementNamed(context, '/LoginScreen');
  }
}