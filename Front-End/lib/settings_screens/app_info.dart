// lib/settings_screens/app_info.dart

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:personal_test/localization/app_localizations.dart';

// 앱 정보 화면
class AppInfo extends StatefulWidget {
  const AppInfo({super.key});

  @override
  AppInfoState createState() => AppInfoState();
}

class AppInfoState extends State<AppInfo> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  // 앱 버전 정보를 가져오는 함수
  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version; // 앱 버전 가져오기
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // 현지화 인스턴스 가져오기

    return Scaffold(
      appBar: AppBar(
        // SettingsScreen의 AppBar 형식 적용
        title: Transform.translate(
          offset: const Offset(-8.0, 0), // 왼쪽으로 8픽셀 이동
          child: Text(localizations.translate('appInformation'), style: const TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true, // 제목을 중앙에 정렬
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(localizations.translate('appVersion')),
            subtitle: Text(localizations.translate('version', {'versionNumber': appVersion})),
          ),
          const Divider(),
        ],
      ),
    );
  }
}