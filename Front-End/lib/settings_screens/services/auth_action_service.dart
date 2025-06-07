// lib/settings_screens/services/auth_action_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_test/home_screens/shared_preferences_helper.dart';

class AuthActionService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 로그아웃 로직
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await SharedPreferencesHelper.clearAllUserVoiceData();
    } on FirebaseAuthException {
      rethrow; // FirebaseAuthException을 호출자에게 다시 던짐
    } catch (e) {
      // 그 외의 일반적인 오류
      throw Exception('Failed to sign out: $e');
    }
  }

  // 재인증 로직: 비밀번호를 받아서 재인증 시도
  // 성공 시 true, 실패 시 false 또는 FirebaseAuthException을 호출자에게 던짐
  Future<bool> reauthenticateUser(String email, String password) async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(code: 'no-user-logged-in', message: 'No user is currently logged in.');
    }

    if (user.providerData.any((info) => info.providerId == 'password')) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, // 현재 로그인된 user의 email 사용
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        return true; // 재인증 성공
      } on FirebaseAuthException {
        rethrow; // FirebaseAuthException을 호출자에게 다시 던짐
      } catch (e) {
        throw Exception('Failed to reauthenticate: $e');
      }
    } else {
      throw FirebaseAuthException(code: 'reauthentication-method-not-supported', message: 'Reauthentication method not supported for this user.');
    }
  }

  // 회원 탈퇴 로직
  // 성공 시 true, 'requires-recent-login' 오류 시 false, 그 외 오류 시 FirebaseAuthException 또는 Exception 던짐
  Future<bool> deleteAccount() async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(code: 'no-user-logged-in', message: 'No user is currently logged in.');
    }

    try {
      await user.delete(); // Firebase 사용자 계정 삭제
      await SharedPreferencesHelper.clearAllUserVoiceData(); // 로컬 데이터 삭제
      return true; // 삭제 성공
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return false; // 재인증 필요함을 나타내기 위해 false 반환
      }
      rethrow; // 그 외 FirebaseAuthException은 호출자에게 다시 던짐
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}