// lib/settings_screens/customer_support_screens/support_and_limitations_screen.dart

import 'package:flutter/material.dart';
import 'package:personal_test/localization/app_localizations.dart';

class SupportAndLimitationsScreen extends StatefulWidget {
  const SupportAndLimitationsScreen({super.key});

  @override
  SupportAndLimitationsScreenState createState() =>
      SupportAndLimitationsScreenState();
}

class SupportAndLimitationsScreenState
    extends State<SupportAndLimitationsScreen> {

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Transform.translate(
          offset: const Offset(-8.0, 0),
          child: Text(localizations.translate('usageLimitations'), style: const TextStyle(color: Colors.white)), // 제목을 "사용 제한 사항"으로 변경
        ),
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🚫 ${localizations.translate('usageLimitations')}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildLimitItem(
              localizations.translate('excessiveRequestsLimitationTitle'),
              localizations.translate('excessiveRequestsLimitationDescription'),
            ),
            _buildLimitItem(
              localizations.translate('pronunciationCorrectionServiceLimitationTitle'),
              localizations.translate('pronunciationCorrectionServiceLimitationDescription'),
            ),
            _buildLimitItem(
              localizations.translate('personalInformationProtectionLimitationTitle'),
              localizations.translate('personalInformationProtectionLimitationDescription'),
            ),
            _buildLimitItem(
              localizations.translate('inappropriateContentBlockingTitle'),
              localizations.translate('inappropriateContentBlockingDescription'),
            ),
            _buildLimitItem(
              localizations.translate('serviceAvailabilityLimitationTitle'),
              localizations.translate('serviceAvailabilityLimitationDescription'),
            ),
            // 🌟🌟🌟 추가된 부분 시작 🌟🌟🌟
            const SizedBox(height: 30), // 위 제한 사항 카드들과 간격
            Text(
              localizations.translate('customerInquiryContact'), // 이제 이 키를 사용합니다.
              style: TextStyle(fontSize: 16, color: Colors.grey[600]), // 회색 텍스트 스타일
            ),
            // 🌟🌟🌟 추가된 부분 끝 🌟🌟🌟
          ],
        ),
      ),
    );
  }

  Widget _buildLimitItem(String title, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}