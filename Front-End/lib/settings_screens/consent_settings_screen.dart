// lib/settings_screens/consent_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_test/localization/app_localizations.dart';

// 정보 동의 설정 창
class ConsentSettingsScreen extends StatefulWidget {
  const ConsentSettingsScreen({super.key});

  @override
  ConsentSettingsScreenState createState() => ConsentSettingsScreenState();
}

class ConsentSettingsScreenState extends State<ConsentSettingsScreen> {
  bool _consentMarketing = false;
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;

  // 텍스트 오버플로우 상태 관리 변수
  bool _isTextExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadConsentInfo();
  }

  Future<void> _loadConsentInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            _agreeToTerms = doc.data()?['agreeToTerms'] ?? false;
            _agreeToPrivacy = doc.data()?['agreeToPrivacy'] ?? false;
            _consentMarketing = doc.data()?['consentMarketing'] ?? false;
          });
        } else {
          // 문서가 없는 경우, 기본값을 false로 유지
          setState(() {
            _consentMarketing = false;
            _agreeToTerms = false;
            _agreeToPrivacy = false;
          });
        }
      } catch (e) {
        print("Firebase 데이터 로드 중 오류 발생: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.translate('loadConsentFailed'))),
          );
        }
      }
    } else {
      // 사용자 로그인 안 됨, 기본값 false 유지
      setState(() {
        _consentMarketing = false;
        _agreeToTerms = false;
        _agreeToPrivacy = false;
      });
    }
  }

  Future<void> _updateMarketingConsent(bool newValue) async {
    final user = FirebaseAuth.instance.currentUser;
    final localizations = AppLocalizations.of(context)!;

    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.translate('notLoggedIn'))),
        );
      }
      return; // 로그인되지 않았으면 함수 종료
    }

    bool previousValue = _consentMarketing;
    setState(() {
      _consentMarketing = newValue;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {'consentMarketing': newValue},
        SetOptions(merge: true),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.translate('marketingConsentChanged'))),
      );
    } catch (e) {
      print("Firebase 데이터 업데이트 중 오류 발생: $e");
      if (mounted) {
        setState(() {
          _consentMarketing = previousValue;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.translate('updateConsentFailed'))),
        );
      }
    }
  }

  void _showAgreementDialog(String title, String content) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlue), textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Text(content, style: const TextStyle(fontSize: 16)),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localizations.translate('ok'), style: const TextStyle(color: Colors.lightBlue)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTermsOfServiceDetails() {
    final localizations = AppLocalizations.of(context)!;
    _showAgreementDialog(
      localizations.translate('termsOfServiceTitle'),
      localizations.translate('termsOfServiceDetails'),
    );
  }

  void _showPrivacyPolicyDetails() {
    final localizations = AppLocalizations.of(context)!;
    _showAgreementDialog(
      localizations.translate('privacyPolicyTitle'),
      localizations.translate('privacyPolicyDetails'),
    );
  }

  void _showMarketingConsentDetails() {
    final localizations = AppLocalizations.of(context)!;
    _showAgreementDialog(
      localizations.translate('marketingConsentHeader'), // 제목은 기존 헤더 사용
      localizations.translate('marketingConsentDetails'), // 상세 내용은 현지화 키 사용
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Transform.translate(
          offset: const Offset(-8.0, 0),
          child: Text(localizations.translate('consentSettings'), style: const TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                localizations.translate('pleaseReviewConsentSettings'),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // 서비스 이용 약관 섹션
            InkWell(
              onTap: _showTermsOfServiceDetails,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      '${localizations.translate('termsOfServiceTitle')}:',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      localizations.translate('viewTermsOfService'),
                      style: const TextStyle(fontSize: 14, color: Colors.lightBlue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                _agreeToTerms ? localizations.translate('agreedToTerms') : localizations.translate('notAgreedToTerms'),
                style: TextStyle(color: _agreeToTerms ? Colors.green : Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // 개인정보 처리방침 섹션
            InkWell(
              onTap: _showPrivacyPolicyDetails,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      '${localizations.translate('privacyPolicyTitle')}:',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      localizations.translate('viewPrivacyPolicy'),
                      style: const TextStyle(fontSize: 14, color: Colors.lightBlue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                _agreeToPrivacy ? localizations.translate('agreedToPrivacy') : localizations.translate('notAgreedToPrivacy'),
                style: TextStyle(color: _agreeToPrivacy ? Colors.green : Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Marketing Consent (체크박스 사용)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    localizations.translate('marketingConsentHeader'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),

                // 마케팅 동의 상세 정보 보기 링크
                InkWell(
                  onTap: _showMarketingConsentDetails,
                  child: Center(
                    child: Text(
                      localizations.translate('viewMarketingConsent'),
                      style: const TextStyle(fontSize: 14, color: Colors.lightBlue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ✨ 이 부분이 가장 크게 변경됩니다.
                Center( // Row 자체를 중앙 정렬
                  child: Padding( // 내부 패딩은 필요 없지만, Row의 크기를 조절하는 데 사용될 수 있습니다.
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 패딩은 유지
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // ✨ Row가 자식들의 크기만큼만 공간을 차지하게 함
                      crossAxisAlignment: CrossAxisAlignment.center, // 세로 중앙 정렬
                      children: [
                        Checkbox(
                          value: _consentMarketing,
                          onChanged: (bool? newValue) {
                            if (newValue != null) {
                              _updateMarketingConsent(newValue);
                            }
                          },
                          activeColor: Colors.lightBlue,
                        ),
                        // const SizedBox(width: 0), // ✨ 간격 완전히 제거 (또는 이 라인 자체를 제거)
                        // Expanded 대신 Flexible을 사용하여 텍스트가 필요한 만큼만 공간을 차지하도록 합니다.
                        Flexible( // ✨ Flexible 사용
                          child: GestureDetector(
                            onLongPressStart: (_) {
                              setState(() {
                                _isTextExpanded = true;
                              });
                            },
                            onLongPressEnd: (_) {
                              setState(() {
                                _isTextExpanded = false;
                              });
                            },
                            onTap: () {
                              _updateMarketingConsent(!_consentMarketing);
                            },
                            child: Text(
                              localizations.translate('receiveUpdatesAndPromotionalOffers'),
                              maxLines: _isTextExpanded ? null : 1,
                              overflow: _isTextExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                              // textAlign: TextAlign.center, // Flexible 내부에서는 필요하면 사용, 아니면 제거 (텍스트 길이에 따라 다름)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}