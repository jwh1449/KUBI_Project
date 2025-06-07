// lib/settings_screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // User 객체
import 'package:provider/provider.dart';
import 'package:personal_test/localization/app_localizations.dart';
import 'package:personal_test/transport/app_language_provider.dart';
import 'package:personal_test/widget/user_provider.dart';
import '../login/login_screen.dart'; // 로그인 화면으로 이동
import 'customer_support_screens/support_and_limitations_screen.dart';
import 'app_info.dart';
import 'consent_settings_screen.dart';
import 'account_settings/account_settings_screen.dart';
import 'package:personal_test/settings_screens/services/auth_action_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // AuthActionService 인스턴스 생성
  final AuthActionService _authActionService = AuthActionService(); // ✨

  // --- 로그아웃 함수 ---
  Future<void> _logout(BuildContext context, AppLocalizations localizations) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations.translate('logoutDialogTitle')),
          content: Text(localizations.translate('logoutDialogContent')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(localizations.translate('noButton'), style: const TextStyle(color: Colors.lightBlue)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  await _authActionService.signOut(); // ✨ AuthActionService의 signOut 호출
                  if (mounted) {
                    Provider.of<UserProvider>(context, listen: false).clearUserData();
                  }

                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar( // 성공 메시지 표시
                      SnackBar(content: Text(localizations.translate('logoutSuccess'))),
                    );
                  }
                } on FirebaseAuthException catch (e) { // FirebaseAuthException 처리
                  print("로그아웃 오류 (FirebaseAuthException): ${e.code} - ${e.message}");
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localizations.translate('logoutFailedMessage'))),
                    );
                  }
                } catch (e) { // 그 외 일반 Exception 처리
                  print("로그아웃 오류 (일반): $e");
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localizations.translate('logoutFailedMessage'))),
                    );
                  }
                }
              },
              child: Text(localizations.translate('yesButton'), style: const TextStyle(color: Colors.lightBlue)),
            ),
          ],
        );
      },
    );
  }

  // --- 재인증 함수 ---
  Future<bool> _reauthenticateUser(BuildContext context, AppLocalizations localizations) async {
    final TextEditingController passwordController = TextEditingController(); // 지역변수 사용
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.translate('noUserLoggedIn'))),
        );
      }
      return false;
    }

    // 이메일/비밀번호 사용자인 경우에만 재인증 다이얼로그 표시
    if (user.providerData.any((info) => info.providerId == 'password')) {
      return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(localizations.translate('reauthenticateTitle')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(localizations.translate('reauthenticateContent')),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: localizations.translate('passwordLabel'),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false); // 취소
                },
                child: Text(localizations.translate('cancelButton'), style: const TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    // ✨ AuthActionService의 reauthenticateUser 호출
                    bool reauthSuccess = await _authActionService.reauthenticateUser(user.email!, passwordController.text);
                    if (mounted) {
                      Navigator.of(dialogContext).pop(reauthSuccess); // 재인증 성공 여부 반환
                    }
                  } on FirebaseAuthException catch (e) { // FirebaseAuthException 처리
                    print("재인증 오류 (FirebaseAuthException): ${e.code} - ${e.message}");
                    String message = localizations.translate('reauthenticationFailed');
                    if (e.code == 'wrong-password') {
                      message = localizations.translate('wrongPassword');
                    } else if (e.code == 'invalid-email') {
                      message = localizations.translate('invalidEmail');
                    } else if (e.code == 'no-user-logged-in') {
                      message = localizations.translate('noUserLoggedIn');
                    } else if (e.code == 'reauthentication-method-not-supported') {
                      message = localizations.translate('reauthenticationMethodNotSupported');
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                    Navigator.of(dialogContext).pop(false); // 재인증 실패
                  } catch (e) { // 그 외 일반 Exception 처리
                    print("일반 재인증 오류: $e");
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localizations.translate('reauthenticationFailed'))),
                      );
                    }
                    Navigator.of(dialogContext).pop(false); // 재인증 실패
                  }
                },
                child: Text(localizations.translate('confirmButton'), style: const TextStyle(color: Colors.lightBlue)),
              ),
            ],
          );
        },
      ) ?? false; // null이면 false 반환
    }
    // 다른 제공업체 (Google, Apple 등)를 사용한 경우
    else {
      // 재인증 다이얼로그 없이 바로 실패 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.translate('reauthenticationMethodNotSupported'))),
        );
      }
      return false;
    }
  }


  // --- 회원 탈퇴 함수 ---
  Future<void> _deleteAccount(BuildContext context, AppLocalizations localizations) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations.translate('deleteAccountDialogTitle')),
          content: Text(localizations.translate('deleteAccountDialogContent')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // 아니요 버튼: 다이얼로그 닫기
              },
              child: Text(localizations.translate('noButton'), style: const TextStyle(color: Colors.lightBlue)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // 원래 다이얼로그 닫기

                User? user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localizations.translate('noUserLoggedIn'))),
                    );
                  }
                  return;
                }

                try {
                  // ✨ AuthActionService의 deleteAccount 호출
                  bool requiresReauth = !await _authActionService.deleteAccount(); // false가 반환되면 재인증 필요

                  if (requiresReauth) { // 'requires-recent-login' 오류로 인해 false가 반환된 경우
                    print("재인증 필요: deleteAccount 반환값 false");
                    bool reauthenticated = await _reauthenticateUser(context, localizations);
                    if (reauthenticated) {
                      // 재인증 성공 후 다시 계정 삭제 시도
                      try {
                        bool finalSuccess = await _authActionService.deleteAccount(); // ✨ 다시 호출
                        if (finalSuccess) {
                          _handleAccountDeletionSuccess(context, localizations);
                        } else {
                          // 재인증 후에도 다시 requires-recent-login이 발생하거나 다른 이유로 실패
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(localizations.translate('accountDeletionFailed'))),
                            );
                          }
                        }
                      } on FirebaseAuthException catch (e) {
                        print("재인증 후 계정 삭제 오류 (FirebaseAuthException): ${e.code} - ${e.message}");
                        String message = localizations.translate('accountDeletionFailed');
                        if (e.code == 'network-request-failed') { message = localizations.translate('networkError'); }
                        if (mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))); }
                      } catch (e) {
                        print("재인증 후 계정 삭제 오류 (일반): $e");
                        if (mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localizations.translate('accountDeletionFailed')))); }
                      }
                    } else { // 재인증 실패
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localizations.translate('reauthenticationFailedTryAgain'))),
                        );
                      }
                    }
                  } else { // 재인증 없이 바로 삭제 성공
                    _handleAccountDeletionSuccess(context, localizations);
                  }
                } on FirebaseAuthException catch (e) {
                  // requires-recent-login 외의 다른 FirebaseAuthException 발생
                  print("계정 삭제 오류 (FirebaseAuthException): ${e.code} - ${e.message}");
                  String message = localizations.translate('accountDeletionFailed');
                  if (e.code == 'network-request-failed') { message = localizations.translate('networkError'); }
                  if (mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))); }
                } catch (e) {
                  // 일반적인 오류
                  print("일반 계정 삭제 오류: $e");
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localizations.translate('accountDeletionFailed'))),
                    );
                  }
                }
              },
              child: Text(localizations.translate('yesButton'), style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // 계정 삭제 성공 시 공통 로직
  void _handleAccountDeletionSuccess(BuildContext context, AppLocalizations localizations) async {
    // SharedPreferencesHelper.clearAllUserVoiceData()는 AuthActionService에서 호출되므로 여기서 제거해도 됩니다.
    if (mounted) {
      Provider.of<UserProvider>(context, listen: false).clearUserData();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.translate('accountDeletionComplete'))),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final String userName = userProvider.userName ?? localizations.translate('guest');
    final String userCollege = userProvider.userCollegeRawKey ?? localizations.translate('noCollegeSelected');
    final String userDepartment = userProvider.userDepartmentRawKey ?? localizations.translate('noDepartmentSelected');

    return Scaffold(
      body: Column(
        children: [
          // 상단 헤더 (변경 없음)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            width: double.infinity,
            color: Colors.lightBlue,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text(
                  localizations.translate('settingsScreenTitle'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 설정 목록 (변경 없음)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle(localizations.translate("accountAndAppSettingsSection")),
                _buildSettingItem(localizations.translate("accountManagementItem"), onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
                  );
                }),
                _buildSectionTitle(localizations.translate("usageGuideSection")),
                _buildSettingItem(localizations.translate("appInfoItem"), onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AppInfo()),
                  );
                }),
                _buildSettingItem(localizations.translate("customerSupportItem"), onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SupportAndLimitationsScreen()),
                  );
                }),
                _buildSectionTitle(localizations.translate("otherFeaturesSection")),
                _buildSettingItem(
                  localizations.translate("consentSettingsItem"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ConsentSettingsScreen()),
                    );
                  },
                ),
                _buildSettingItem(
                  localizations.translate("logoutItem"),
                  isLogout: true,
                  onTap: () => _logout(context, localizations), // ✨ 기존처럼 직접 호출
                ),
                _buildSettingItem(
                  localizations.translate("deleteAccountItem"),
                  isDeleteAccount: true,
                  onTap: () => _deleteAccount(context, localizations), // ✨ 기존처럼 직접 호출
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // _buildSectionTitle, _buildSettingItem, _buildLanguageButton (변경 없음)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, {String? trailing, bool isLogout = false, bool isDeleteAccount = false, VoidCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isLogout || isDeleteAccount ? FontWeight.bold : FontWeight.normal,
            color: isDeleteAccount ? Colors.red : Colors.black87,
          ),
        ),
        trailing: trailing != null ? Text(trailing, style: const TextStyle(color: Colors.grey)) : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLanguageButton(String text, Locale locale, AppLanguageProvider appLanguage, bool isSelected) {
    return ElevatedButton(
      onPressed: () {
        appLanguage.changeLanguage(locale);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.lightBlue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      child: Text(text),
    );
  }
}