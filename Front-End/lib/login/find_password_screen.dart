import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../signup_screen/signup_screen.dart';

class FindPasswordScreen extends StatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  State<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('비밀번호 재설정 이메일을 발송했습니다. 메일함을 확인해주세요.')),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = _handleFirebaseError(e.code);
        });
        if (mounted && _errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage!)),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = '예상치 못한 오류가 발생했습니다. 다시 시도해주세요.';
        });
        if (mounted && _errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage!)),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _handleFirebaseError(String errorCode) {
    switch (errorCode) {
      case 'auth/invalid-email':
        return '유효하지 않은 이메일 주소입니다.';
      case 'auth/user-not-found':
        return '해당 이메일로 등록된 사용자를 찾을 수 없습니다.';
      default:
        return '비밀번호 재설정 이메일 발송에 실패했습니다. 다시 시도해주세요.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: const Text('Find Password', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  errorText: _errorMessage,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력하세요.';
                  }
                  if (!value.contains('@')) {
                    return '유효한 이메일 형식이 아닙니다.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _isLoading
                    ? const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(), // 로딩 인디케이터 색상은 main.dart의 theme를 따름
                  ),
                )
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white, // 버튼 텍스트 색상
                  ),
                  onPressed: _isLoading ? null : _resetPassword,
                  child: const Text('Find Password'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 이전 화면(로그인)으로 돌아가기
                },
                child: const Text('Back to Login', style: TextStyle(color: Colors.lightBlue)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.lightBlue)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const SignupScreen())); // 회원가입 화면으로 이동
                    },
                    child: const Text('Sign Up', style: TextStyle(color: Colors.lightBlue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}