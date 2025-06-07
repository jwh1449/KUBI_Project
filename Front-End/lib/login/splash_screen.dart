import 'package:flutter/material.dart';
import 'login_screen.dart';

//앱 누르고 1초 잠깐 로고 보여주기
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    Future.delayed(Duration(seconds: 1), () {
      _controller.forward().then((_) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen())); // LoginScreen으로 전환
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {              //앱 아이콘
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: Center(), // Center 위젯을 직접 child로 사용
      ),
    );
  }
}