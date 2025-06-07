import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSettingsScreen extends StatefulWidget {
  final String userName;
  final String userCollege;
  final String userDepartment;

  const AppSettingsScreen({
    required this.userName,
    required this.userCollege,
    required this.userDepartment,
    super.key,
  });

  @override
  AppSettingsScreenState createState() => AppSettingsScreenState();
}

class AppSettingsScreenState extends State<AppSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('change language'.tr),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        centerTitle: true, // AppBar 제목을 가운데 정렬
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 24),
          _buildSectionTitle("🌍 Language"),
          _buildCard([
            ListTile(
              title: Text("Change Language".tr),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showLanguageChangeDialog(context),
            ),
          ]),
        ],
      ),
    );
  }

  // 언어 변경 다이얼로그
  void _showLanguageChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Change Language".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption("Korean", const Locale('ko', 'KR')),
            _buildLanguageOption("English", const Locale('en', 'US')),
            _buildLanguageOption("Chinese", const Locale('zh', 'CN')),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, Locale locale) {
    return ListTile(
      title: Text(language),
      onTap: () {
        Get.updateLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  // UI 헬퍼 메서드
  Widget _buildCard(List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
    );
  }
}