import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../signup_screen/signup_screen.dart';
import '../home_screens/home_screen.dart';
import 'find_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<String> _recentEmails = [];

  // 로그인 실패 횟수 및 잠금
  int _loginAttempts = 0;
  DateTime? _lockoutUntil;
  static const int MAX_LOGIN_ATTEMPTS = 5;
  static const Duration LOCKOUT_DURATION = Duration(minutes: 3);

  @override
  void initState() {
    super.initState();
    _loadRecentEmails();
    _loadLoginAttempts(); // 앱 시작 시 로그인 시도 횟수 및 잠금 상태 불러오기
  }

  Future<void> _loadRecentEmails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentEmails = prefs.getStringList('recent_emails') ?? [];
    });
  }

  Future<void> _saveRecentEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    _recentEmails.remove(email);
    _recentEmails.insert(0, email);
    if (_recentEmails.length > 5) {
      _recentEmails = _recentEmails.sublist(0, 5);
    }
    await prefs.setStringList('recent_emails', _recentEmails);
    setState(() {});
  }

  Future<void> _loadLoginAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loginAttempts = prefs.getInt('login_attempts') ?? 0;
      final lockoutTimestamp = prefs.getInt('lockout_until');
      if (lockoutTimestamp != null) {
        _lockoutUntil = DateTime.fromMillisecondsSinceEpoch(lockoutTimestamp);
        // 만약 잠금 시간이 이미 지났다면 초기화
        if (_lockoutUntil!.isBefore(DateTime.now())) {
          _loginAttempts = 0;
          _lockoutUntil = null;
          prefs.remove('login_attempts');
          prefs.remove('lockout_until');
        }
      }
    });
  }

  Future<void> _saveLoginAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('login_attempts', _loginAttempts);
    if (_lockoutUntil != null) {
      await prefs.setInt('lockout_until', _lockoutUntil!.millisecondsSinceEpoch);
    } else {
      await prefs.remove('lockout_until');
    }
  }

  Future<void> _resetLoginAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loginAttempts = 0;
      _lockoutUntil = null;
    });
    await prefs.remove('login_attempts');
    await prefs.remove('lockout_until');
  }

  /// 앱 종료 확인 대화상자를 띄우는 함수
  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit'),
        content: const Text('Are you sure you want to exit KUBI?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No', style: TextStyle(color: Colors.lightBlue)),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Yes', style: TextStyle(color: Colors.lightBlue)),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 로그인 시도 전, 잠금 상태 확인
    if (_lockoutUntil != null && _lockoutUntil!.isAfter(DateTime.now())) {
      final remaining = _lockoutUntil!.difference(DateTime.now());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Too many failed login attempts. Please try again after ${remaining.inMinutes} minutes and ${remaining.inSeconds % 60} seconds.'),
        ),
      );
      return;
    } else if (_lockoutUntil != null && _lockoutUntil!.isBefore(DateTime.now())) {
      // 잠금 시간이 지났다면 초기화
      await _resetLoginAttempts();
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = credential.user;

      if (user != null) {
        if (!user.emailVerified) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please verify your email to log in.')),
            );
          }
          await FirebaseAuth.instance.signOut();
          return;
        }

        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          await _saveRecentEmail(_emailController.text.trim());
          await _resetLoginAttempts(); // 로그인 성공 시 시도 횟수 초기화

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User information not found.')),
            );
            await FirebaseAuth.instance.signOut();
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'Email not found.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'User account has been disabled.';
      }

      // 로그인 실패 시 시도 횟수 증가 및 잠금 처리
      setState(() {
        _loginAttempts++;
      });
      await _saveLoginAttempts();

      if (_loginAttempts >= MAX_LOGIN_ATTEMPTS) {
        _lockoutUntil = DateTime.now().add(LOCKOUT_DURATION);
        await _saveLoginAttempts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Too many failed login attempts. You are locked out for ${LOCKOUT_DURATION.inMinutes} minutes.'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$errorMessage (Attempts remaining: ${MAX_LOGIN_ATTEMPTS - _loginAttempts})'),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Unexpected error during login: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred. Please try again.')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: const Text('Log in', style: TextStyle(color: Colors.white)),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.grey),
                    floatingLabelStyle: const TextStyle(color: Colors.lightBlue),
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: _recentEmails.isNotEmpty
                        ? PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.lightBlue),
                      onSelected: (String email) {
                        setState(() {
                          _emailController.text = email;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return _recentEmails.map((email) {
                          return PopupMenuItem<String>(
                            value: email,
                            child: Text(email),
                          );
                        }).toList();
                      },
                    )
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    if (!value.contains('@')) {
                      return 'Invalid email format.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    floatingLabelStyle: TextStyle(color: Colors.lightBlue),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                  )
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                    onPressed: _login,
                    child: const Text('Log in', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SignupScreen()));
                      },
                      child: const Text('Join the membership', style: TextStyle(color: Colors.lightBlue)),
                    ),
                    const Text(' / ', style: TextStyle(color: Colors.lightBlue)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const FindPasswordScreen()));
                      },
                      child: const Text('Find password', style: TextStyle(color: Colors.lightBlue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}