import 'package:flutter/material.dart';
import 'package:personal_test/localization/app_localizations.dart';

bool _isDialogShowing = false;

/// 앱 종료 확인 대화상자를 표시하는 함수입니다.
/// 사용자가 '예'를 선택하면 true를 반환하고, '아니오'를 선택하면 false를 반환합니다.
Future<bool> showExitAppDialog(BuildContext context) async {
  if (_isDialogShowing) return false; // 중복 다이얼로그 방지

  _isDialogShowing = true;
  final localizations = AppLocalizations.of(context)!;

  final shouldExit = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // 바깥 터치로 닫히지 않게
    builder: (context) => AlertDialog(
      title: Text(localizations.translate('exitTitle')),
      content: Text(localizations.translate('exitContent')),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // 앱에 머무름
          },
          child: Text(
            localizations.translate('no'),
            style: const TextStyle(color: Colors.lightBlue),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // 앱 종료
          },
          child: Text(
            localizations.translate('yes'),
            style: const TextStyle(color: Colors.lightBlue),
          ),
        ),
      ],
    ),
  );

  _isDialogShowing = false;
  return shouldExit ?? false; // 다이얼로그가 닫히면 false 반환
}
