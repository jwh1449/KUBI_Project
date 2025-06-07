import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth 임포트 추가
import 'package:personal_test/firebase_options.dart';

// 화면 임포트
import 'package:personal_test/login/login_screen.dart'; // 로그인 스크린 임포트
import 'package:personal_test/home_screens/home_screen.dart'; // 홈 스크린 임포트

// 프로바이더 및 로컬라이제이션 임포트
import 'package:personal_test/transport/app_language_provider.dart';
import 'package:personal_test/localization/app_localizations.dart';
import 'package:personal_test/widget/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppLanguageProvider>(context, listen: false).fetchLocale();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KUBI App',
      key: ValueKey(appLanguage.appLocale),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // 텍스트 선택 관련 테마 설정
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.lightBlue, // 앱 전체 커서 색상 설정
          selectionHandleColor: Colors.lightBlue, // 텍스트 선택 핸들(물방울 모양 아이콘) 색상 설정
          // selectionColor: Colors.lightBlue.withOpacity(0.3), // 선택된 텍스트의 배경색 (필요시 활성화)
        ),
        // 로딩 인디케이터 테마 설정
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.lightBlue, // 로딩 인디케이터의 기본 색상 설정
        ),
        // ✨ 이 부분을 추가하여 앱 전체의 InputDecoration 기본 테마를 설정합니다. ✨
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue), // 포커스될 때의 밑줄 색상
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // 활성화된 상태의 밑줄 색상 (포커스되지 않았을 때)
          ),
          // 필요에 따라 다른 테마 속성 추가
          labelStyle: TextStyle(color: Colors.grey), // 기본 라벨 색상
          floatingLabelStyle: TextStyle(color: Colors.lightBlue), // 라벨이 떠오를 때의 색상
        ),
      ),
      locale: appLanguage.appLocale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
        Locale('zh', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.emailVerified) {
            print('DEBUG(main.dart): User is logged in and email verified. Navigating to HomeScreen.');
            return const HomeScreen();
          } else {
            print('DEBUG(main.dart): User is not logged in or email not verified. Navigating to LoginScreen.');
            return const LoginScreen();
          }
        },
      ),
    );
  }
}