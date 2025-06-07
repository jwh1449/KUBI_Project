import 'package:flutter/material.dart';
import 'package:personal_test/localization/app_localizations.dart';


// 화면 전환 로직은 HomeScreen에서 IndexedStack으로 처리

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap; // onTap 콜백 함수를 추가합니다.

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap, // 생성자에 onTap을 필수 인자로 추가합니다.
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.lightBlue,
      unselectedItemColor: Colors.grey,
      iconSize: 36,
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.announcement), label: localizations.translate('announcements')),
        BottomNavigationBarItem(
            icon: const Icon(Icons.map), label: localizations.translate('map')),
        BottomNavigationBarItem(
            icon: const Icon(Icons.home), label: localizations.translate('home')),
        BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu), label: localizations.translate('cafeteriaInfo')),
        BottomNavigationBarItem(
            icon: const Icon(Icons.record_voice_over), label: localizations.translate('practice')),
      ],
      currentIndex: currentIndex,
      onTap: onTap, // 외부에서 전달받은 onTap 함수를 BottomNavigationBar에 직접 연결합니다.
    );
  }
}