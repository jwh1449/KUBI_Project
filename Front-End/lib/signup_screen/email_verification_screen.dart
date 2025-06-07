import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../login/login_screen.dart';
import '../widget/user_provider.dart';


class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? country;
  final String? college;
  final String? department;
  final bool agreeToTerms;
  final bool agreeToPrivacy;
  final bool consentMarketing;

  const EmailVerificationScreen({
    Key? key,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.country,
    this.college,
    this.department,
    required this.agreeToTerms,
    required this.agreeToPrivacy,
    required this.consentMarketing,
  }) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isEmailVerified = false;
  late User? _user;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _isEmailVerified = _user?.emailVerified ?? false;

    print('[EmailVerificationScreen] Initial emailVerified status: $_isEmailVerified');

    if (!_isEmailVerified) {
      _sendVerificationEmail();

      _timer = Timer.periodic(
        const Duration(seconds: 3),
            (timer) => _checkEmailVerified(),
      );
    } else {
      print('[EmailVerificationScreen] Email already verified on init. Saving data and navigating.');
      // 이메일이 이미 인증된 경우, 바로 데이터를 저장하고 다음 화면으로 이동
      _saveUserDataToFirestore(shouldNavigate: true);
    }
  }

  @override
  void dispose() {
    print('[EmailVerificationScreen] Disposing timer.');
    _timer.cancel();
    super.dispose();
  }

  Future<void> _sendVerificationEmail() async {
    if (_user != null) {
      try {
        await _user!.sendEmailVerification();
        print('[EmailVerificationScreen] Verification email sent to: ${_user!.email}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Verification email has been resent.')),
          );
        }
      } catch (e) {
        print('[EmailVerificationScreen] Error sending verification email: $e');

        if (e.toString().contains("firebase_auth/too-many-requests")) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Email verification is blocked due to too many requests. Try again later.'),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                  Text('Failed to send verification email. Please try again.')),
            );
          }
        }
      }
    } else {
      print('[EmailVerificationScreen] Error: Current user is null when trying to send email.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
              Text('Failed to retrieve user information. Please try again.')),
        );
      }
    }
  }

  Future<void> _checkEmailVerified() async {
    print('[EmailVerificationScreen] Checking email verification status...');
    await _user?.reload();
    _user = FirebaseAuth.instance.currentUser;

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isEmailVerified = _user?.emailVerified ?? false;
    });

    print('[EmailVerificationScreen] Email Verified status after reload and delay: $_isEmailVerified');

    if (_isEmailVerified) {
      print('[EmailVerificationScreen] Email is verified. Cancelling timer and saving data.');
      _timer.cancel();
      // 이메일 인증이 완료되면 데이터를 저장하고 다음 화면으로 이동
      await _saveUserDataToFirestore(shouldNavigate: true);
    } else {
      print('[EmailVerificationScreen] Email is NOT yet verified. Retrying...');
    }
  }

  void _navigateToLoginScreen() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verification is complete. Please log in.')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      print('[EmailVerificationScreen] Navigated to LoginScreen.');
    }
  }

  Future<void> _saveUserDataToFirestore({bool shouldNavigate = false}) async {
    if (_user == null) {
      print('[EmailVerificationScreen] Error: Current user is null. Cannot save user data to Firestore.');
      return;
    }

    try {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(_user!.uid);

      final DateTime now = DateTime.now();
      final DateTime expiresAtDate = now.add(const Duration(minutes: 30));
      final Timestamp expiresAtTimestamp = Timestamp.fromDate(expiresAtDate);

      print('[EmailVerificationScreen] Attempting to save user data to Firestore for UID: ${_user!.uid}');
      await userDocRef.set({
        'uid': _user!.uid,
        'email': widget.email,
        'emailVerified': _user!.emailVerified,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': expiresAtTimestamp,
        'fullName': widget.fullName,
        'phoneNumber': widget.phoneNumber,
        'country': widget.country,
        'college': widget.college, // Firestore 필드명 'college'
        'department': widget.department, // Firestore 필드명 'department'
        'agreeToTerms': widget.agreeToTerms,
        'agreeToPrivacy': widget.agreeToPrivacy,
        'consentMarketing': widget.consentMarketing,
      }, SetOptions(merge: true));

      print('[EmailVerificationScreen] User data successfully saved to Firestore for UID: ${_user!.uid}');

      // ✨ 중요: UserProvider의 상태를 즉시 업데이트합니다.
      // 이 코드는 HomeScreen이 로드될 때 UserProvider가 이미 최신 데이터를 가지고 있도록 돕습니다.
      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUserData(
          widget.fullName,
          widget.college,
          widget.department,
        );
        print('[EmailVerificationScreen] UserProvider data set: Name=${widget.fullName}, College=${widget.college}, Department=${widget.department}');

        // ⭐️ 수정: 여기서 녹음 안내 팝업 상태를 저장하는 로직을 제거합니다.
        // 이 팝업은 사용자가 홈 화면에 처음 진입했을 때만 보여줘야 합니다.
        // await SharedPreferencesHelper.saveHasShownRecordVoicePopup(true); // 이 줄을 제거했습니다.
      }

      if (shouldNavigate) {
        _navigateToLoginScreen();
      }

    } catch (e) {
      print('[EmailVerificationScreen] Error saving user data to Firestore: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save user data. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(
            color: Colors.white),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'A verification email has been sent to ${widget.email}.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (_isEmailVerified)
              Column(
                children: [
                  const Text(
                    'Email verification complete.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _saveUserDataToFirestore(shouldNavigate: true); // 변경: 버튼 클릭 시에도 저장 후 이동
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Go to Login'),
                  ),
                ],
              )
            else
              const Text(
                'Please verify your email and wait.',
                style: TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 24),
            if (!_isEmailVerified)
              ElevatedButton(
                onPressed: _sendVerificationEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Resend Verification Email'),
              ),
          ],
        ),
      ),
    );
  }
}