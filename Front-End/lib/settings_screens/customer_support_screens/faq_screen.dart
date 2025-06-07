import 'package:flutter/material.dart';
import 'package:personal_test/localization/app_localizations.dart';

// FAQ 화면
class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // 현지화 인스턴스 가져오기

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('frequentlyAskedQuestions'), style: const TextStyle(color: Colors.white)), // ✨ 현지화
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFAQItem(
            localizations.translate('faq1_question'), // ✨ 현지화
            localizations.translate('faq1_answer'),   // ✨ 현지화
          ),
          _buildFAQItem(
            localizations.translate('faq2_question'), // ✨ 현지화
            localizations.translate('faq2_answer'),   // ✨ 현지화
          ),
          _buildFAQItem(
            localizations.translate('faq3_question'), // ✨ 현지화
            localizations.translate('faq3_answer'),   // ✨ 현지화
          ),
          // 필요에 따라 더 많은 FAQ 항목 추가
        ],
      ),
    );
  }

  // FAQ 항목 UI 생성
  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(answer, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}