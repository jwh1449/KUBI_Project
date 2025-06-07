import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_test/localization/app_localizations.dart';

// Password Change UI
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final localizations = AppLocalizations.of(context)!; // 현지화 인스턴스 가져오기

    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = localizations.translate('userInformationNotFound'); // ✨ 현지화
        });
        return;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text.trim(),
      );

      try {
        await user.reauthenticateWithCredential(credential);

        if (_newPasswordController.text.trim() == _confirmNewPasswordController.text.trim()) {
          try {
            await user.updatePassword(_newPasswordController.text.trim());
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.translate('passwordChangedSuccessfully'))), // ✨ 현지화
              );
            }
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmNewPasswordController.clear();
            setState(() {
              _errorMessage = null;
            });
          } on FirebaseAuthException catch (e) {
            setState(() {
              _errorMessage = _handlePasswordError(e.code, localizations); // 현지화 인스턴스 전달
            });
          }
        } else {
          setState(() {
            _errorMessage = localizations.translate('newPasswordMismatch'); // ✨ 현지화
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = _handleAuthError(e.code, localizations); // 현지화 인스턴스 전달
        });
      }
    }
  }

  String _handleAuthError(String errorCode, AppLocalizations localizations) { // 현지화 인스턴스 추가
    switch (errorCode) {
      case 'wrong-password':
        return localizations.translate('currentPasswordMismatch'); // ✨ 현지화
      case 'user-not-found':
        return localizations.translate('userNotFoundLoginAgain'); // ✨ 현지화
      default:
        return localizations.translate('authenticationErrorOccurred'); // ✨ 현지화
    }
  }

  String _handlePasswordError(String errorCode, AppLocalizations localizations) { // 현지화 인스턴스 추가
    switch (errorCode) {
      case 'weak-password':
        return localizations.translate('weakPassword'); // ✨ 현지화
      default:
        return localizations.translate('failedToChangePassword'); // ✨ 현지화
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // 현지화 인스턴스 가져오기

    return SingleChildScrollView( // ✨ 이 부분을 추가합니다.
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: localizations.translate('currentPassword'), // ✨ 현지화
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage, // Display error message here
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  floatingLabelStyle: const TextStyle(color: Colors.lightBlue),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('enterCurrentPassword'); // ✨ 현지화
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration( // const 제거
                  labelText: localizations.translate('newPassword'), // ✨ 현지화
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: const TextStyle(color: Colors.lightBlue),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('enterNewPassword'); // ✨ 현지화
                  }
                  if (value.length < 6) {
                    return localizations.translate('passwordLengthRequirement'); // ✨ 현지화
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmNewPasswordController,
                decoration: InputDecoration( // const 제거
                  labelText: localizations.translate('confirmNewPassword'), // ✨ 현지화
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: const TextStyle(color: Colors.lightBlue),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('reEnterNewPassword'); // ✨ 현지화
                  }
                  if (_newPasswordController.text.trim() != value.trim()) {
                    return localizations.translate('newPasswordMismatch'); // ✨ 현지화
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
                child: Text(
                  localizations.translate('changePasswordButton'), // ✨ 현지화
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}