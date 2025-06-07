import 'package:flutter/material.dart';
import 'package:personal_test/localization/app_localizations.dart';


import 'student_cafeteria_tab.dart';
import 'dorm_cafeteria_tab.dart'; // Import the dormitory screen (확인: 클래스 이름은 DormitoryCafeteriaScreen)

class CafeteriaInfoScreen extends StatelessWidget {
  const CafeteriaInfoScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // AccountSettingsScreen과 동일한 제목 스타일 적용
          title: Transform.translate(
            offset: const Offset(-8.0, 0), // AccountSettingsScreen의 Offset(-8.0, 0) 적용
            child: Text(
              localizations.translate('cafeteriaInfo'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.lightBlue, // 배경색 라이트 블루 유지
          iconTheme: const IconThemeData(color: Colors.white), // 아이콘 색상 화이트 유지
          centerTitle: true, // 제목 가운데 정렬 유지
          bottom: PreferredSize( // AccountSettingsScreen과 동일한 PreferredSize 및 Container 사용
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: double.infinity,
              child: TabBar(
                labelColor: Colors.lightBlue,     // 선택된 탭 텍스트 색상을 라이트 블루로
                unselectedLabelColor: Colors.grey, // 선택되지 않은 탭 텍스트 색상을 회색으로
                indicatorColor: Colors.lightBlue,  // 밑줄 색상을 라이트 블루로
                tabs: [
                  Tab(text: localizations.translate('studentCafeteria')),
                  Tab(text: localizations.translate('dormCafeteria')),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            StudentCafeteriaTab(), // 학생 식당 탭
            DormitoryCafeteriaScreen(), // 기숙사 식당 탭
          ],
        ),
      ),
    );
  }
}