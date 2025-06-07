import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personal_test/transport/app_language_provider.dart';

class ClubDetailScreen extends StatefulWidget {
  final dynamic club; // Consider defining a proper Club model class for type safety

  const ClubDetailScreen({super.key, required this.club});

  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  // Helper function to get localized description based on the current global language.
  String _getLocalizedDescription(dynamic club, MenuLanguage currentLanguage) {
    switch (currentLanguage) {
      case MenuLanguage.korean:
        return club.clubDescription.isNotEmpty ? club.clubDescription : '설명 없음';
      case MenuLanguage.english:
        return club.clubDescriptionEn.isNotEmpty ? club.clubDescriptionEn : 'No description available.';
      case MenuLanguage.chinese:
        return club.clubDescriptionZh.isNotEmpty ? club.clubDescriptionZh : '无说明。';
    }
  }

  // Helper function to get localized labels based on the current global language.
  String _getLocalizedLabel(String type, MenuLanguage currentLanguage) {
    switch (currentLanguage) {
      case MenuLanguage.korean:
        if (type == 'category') return '분류:';
        if (type == 'description') return '클럽 설명:';
        return '';
      case MenuLanguage.english:
        if (type == 'category') return 'Category:';
        if (type == 'description') return 'Club Description:';
        return '';
      case MenuLanguage.chinese:
        if (type == 'category') return '分类:';
        if (type == 'description') return '俱乐部说明:';
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the current language from the AppLanguageProvider
    final appLanguageProvider = Provider.of<AppLanguageProvider>(context);
    final currentLanguage = appLanguageProvider.currentMenuLanguage; // Get the global language

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue, // lightBlue 유지
        centerTitle: true,
        title: Text(
          widget.club.clubName,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.club.clubName,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.lightBlue),
            ),
            const SizedBox(height: 10),
            Text(
              '${_getLocalizedLabel('category', currentLanguage)} ${widget.club.clubCategory}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Divider(height: 30, thickness: 1),
            Text(
              _getLocalizedDescription(widget.club, currentLanguage),
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}