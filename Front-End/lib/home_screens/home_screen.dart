import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:personal_test/localization/app_localizations.dart';
import 'package:personal_test/transport/app_language_provider.dart';
import 'package:personal_test/widget/user_provider.dart';
import '../announcement_screen/home_announcements.dart';
import '../caferia_screens/home_cafeteria_info.dart';
import '../map_screens/map_screen.dart';
import '../settings_screens/settings_screen.dart';
import '../club_screens/home_club_info.dart';
import '../sentence_selection/sentence_selection_screen.dart';
import '../communication_screen/communication_screen.dart';
import 'shared_preferences_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import '../home_screens/voice_recorder_overlay.dart';
import '../home_screens/exit_app_dialog.dart';
import '../widget/app_bottom_navigation_bar.dart';

final Map<String, Map<String, dynamic>> allCollegeAndDepartmentInfo = {
  'college_engineering': {
    'en': 'College of Engineering',
    'ko': '공과대학',
    'zh': '工学院',
    'departments': [
      {'original_key': 'dept_green_energy_engineering', 'en': 'Department of Green Energy Engineering', 'ko': '그린에너지공학과', 'zh': '绿色能源工程系'},
      {'original_key': 'dept_electronic_ai_systems_engineering', 'en': 'Department of Electronic and AI Systems Engineering', 'ko': '전자및AI시스템공학과', 'zh': '电子与人工智能系统工程系'},
      {'original_key': 'dept_mechanical_engineering', 'en': 'Department of Mechanical Engineering', 'ko': '기계공학과', 'zh': '机械工程系'},
      {'original_key': 'dept_electrical_engineering', 'en': 'Department of Electrical Engineering', 'ko': '전기공학과', 'zh': '电气工程系'},
      {'original_key': 'dept_construction_convergence', 'en': 'Department of Construction Convergence', 'ko': '건설융합공학과', 'zh': '建设融合工程系'},
    ],
  },
  'college_humanities_social_design_sports': {
    'en': 'Humanities and Social Sciences, Design Sports College',
    'ko': '인문사회디자인스포츠대학',
    'zh': '人文社会设计体育学院',
    'departments': [
      {'original_key': 'dept_global_talent', 'en': 'Department of Global Talent', 'ko': '글로벌인재학부', 'zh': '全球人才系'},
      {'original_key': 'dept_human_sports', 'en': 'Department of Human Sports', 'ko': '인간스포츠학부', 'zh': '人类体育系'},
      {'original_key': 'dept_multi_design', 'en': 'Department of Multi-Design', 'ko': '멀티디자인학부', 'zh': '多重设计系'},
      {'original_key': 'dept_social_welfare', 'en': 'Department of Social Welfare', 'ko': '사회복지학과', 'zh': '社会福利系'},
      {'original_key': 'dept_life_design', 'en': 'Department of Life Design', 'ko': '라이프디자인학과', 'zh': '生活设计系'},
      {'original_key': 'dept_early_childhood_education', 'en': 'Department of Early Childhood Education', 'ko': '유아교육과', 'zh': '幼儿教育系'},
    ],
  },
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // 초기 선택된 탭 (홈)
  static const int _homeTabIndex = 2; // 홈 탭의 인덱스 상수로 정의

  String? _userVoiceFilePath; // 사용자 음성 파일 경로
  bool _hasShownRecordVoicePopup = false; // 녹음 안내 팝업을 이미 보여줬는지 여부
  bool _showVoiceCardOverlay = false; // 마이크 아이콘을 눌렀을 때 오버레이를 표시할지 여부
  bool _isVoiceRecordingRequiredForCurrentFeature = false; // 현재 선택된 기능이 음성 녹음을 필요로 하는지 여부

  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _loadInitialDataAndCheckPermissions();
  }

  Future<void> _loadInitialDataAndCheckPermissions() async {
    _userVoiceFilePath = await SharedPreferencesHelper.getUserVoicePath();
    _hasShownRecordVoicePopup = await SharedPreferencesHelper.getHasShownRecordVoicePopup();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (!userProvider.isUserDataLoaded) {
      await userProvider.refreshUserDataFromFirestore();
    }

    // 마이크 권한 상태를 확인하고, 필요하다면 요청
    PermissionStatus status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }

    if (mounted) {
      setState(() {
        _initializeWidgetOptions();
      });
    }

    // 마이크 권한이 허용되었고, 사용자 음성 파일이 없고, 팝업을 아직 보여주지 않았다면
    if (mounted && status.isGranted && _userVoiceFilePath == null && !_hasShownRecordVoicePopup) {
      _showRecordVoiceDialog(context);
    }
  }

  void _initializeWidgetOptions() {
    // _HomeContent에는 더 이상 maxHeight를 직접 전달하지 않습니다.
    _widgetOptions = <Widget>[
      const AnnouncementScreen(), // 인덱스 0: 공지사항
      const MapScreen(),          // 인덱스 1: 지도
      _HomeContent(               // 인덱스 2: 홈
        onTabSelected: _onItemTapped,
        userVoiceFilePath: _userVoiceFilePath,
        showVoiceRecordingRequiredSnackBar: _showVoiceRecordingRequiredSnackBar,
        navigateToSettings: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        },
        changeLanguage: (locale) {
          Provider.of<AppLanguageProvider>(context, listen: false).changeLanguage(locale);
        },
        toggleVoiceCardOverlay: () {
          setState(() {
            _showVoiceCardOverlay = !_showVoiceCardOverlay;
          });
        },
        onVoiceRequiredFeatureSelected: (bool isRequired) {
          setState(() {
            _isVoiceRecordingRequiredForCurrentFeature = isRequired;
          });
        },
      ),
      const CafeteriaInfoScreen(), // 인덱스 3: 식당 정보
      SentenceSelectionScreen(userRecordedAudioPath: _userVoiceFilePath ?? ''), // 인덱스 4: 연습
    ];
  }

  // BottomNavigationBar의 onTap에서 호출될 함수.
  void _onItemTapped(int index) {
    if (_showVoiceCardOverlay) {
      setState(() {
        _showVoiceCardOverlay = false;
      });
      return;
    }

    // 발음 교정 (SentenceSelectionScreen) 탭으로 이동 시 사용자 음성 녹음 여부 확인
    if (index == 4 && _userVoiceFilePath == null) {
      _showVoiceRecordingRequiredSnackBar();
      // 음성 녹음이 필요하므로 마이크 아이콘 강조 상태로 설정
      setState(() {
        _isVoiceRecordingRequiredForCurrentFeature = true;
      });
      return;
    }

    setState(() {
      _selectedIndex = index;
      // 다른 탭으로 이동하면 마이크 아이콘 강조 상태를 해제 (홈 탭은 _homeTabIndex 2)
      _isVoiceRecordingRequiredForCurrentFeature = (index == 4);
    });
  }

  Future<void> _savePopupStatus(bool status) async {
    _hasShownRecordVoicePopup = status;
    await SharedPreferencesHelper.saveHasShownRecordVoicePopup(status);
    if (mounted) setState(() {});
  }

  void _showRecordVoiceDialog(BuildContext dialogContext) {
    showDialog(
      context: mounted ? dialogContext : context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('voiceRegistrationNeededTitle')),
          content: Text(AppLocalizations.of(context)!.translate('voiceRegistrationNeededContent')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _savePopupStatus(true);
                if (mounted) {
                  setState(() {
                    _showVoiceCardOverlay = true;
                    // 다이얼로그에서 바로 녹음 시작을 선택했으므로 마이크 아이콘 강조
                    _isVoiceRecordingRequiredForCurrentFeature = true;
                  });
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.lightBlue,
              ),
              child: Text(AppLocalizations.of(context)!.translate('startRecordingButton')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _savePopupStatus(true);
                // 나중에 하기를 선택했으므로 마이크 아이콘 강조 상태 해제
                setState(() {
                  _isVoiceRecordingRequiredForCurrentFeature = false;
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.lightBlue,
              ),
              child: Text(AppLocalizations.of(context)!.translate('doLaterButton')),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          action: _userVoiceFilePath == null
              ? SnackBarAction(
            label: AppLocalizations.of(context)!.translate('startRecordingButton'),
            onPressed: () {
              setState(() {
                _showVoiceCardOverlay = true;
                // 스낵바에서 바로 녹음 시작을 선택했으므로 마이크 아이콘 강조
                _isVoiceRecordingRequiredForCurrentFeature = true;
              });
            },
            textColor: Colors.white,
          )
              : null,
        ),
      );
    }
  }

  void _showVoiceRecordingRequiredSnackBar() {
    _showSnackBar(AppLocalizations.of(context)!.translate('voiceRecordingRequiredWithPrompt'));
  }

  // 시스템 뒤로가기 버튼 및 AppBar 뒤로가기 버튼에 의해 호출될 로직
  Future<void> _handleBackPress() async {
    // 1. 음성 녹음 오버레이가 열려있다면 닫고, 뒤로가기 이벤트를 소비합니다.
    if (_showVoiceCardOverlay) {
      setState(() {
        _showVoiceCardOverlay = false;
        _isVoiceRecordingRequiredForCurrentFeature = false; // 오버레이 닫으면 강조 해제
      });
      return;
    }

    // 2. 현재 선택된 탭이 홈 탭이 아니라면 홈 탭으로 이동하고, 뒤로가기 이벤트를 소비합니다.
    if (_selectedIndex != _homeTabIndex) {
      setState(() {
        _selectedIndex = _homeTabIndex;
        _isVoiceRecordingRequiredForCurrentFeature = false; // 홈 탭 이동 시 강조 해제
      });
      return;
    }

    // 3. 위 두 가지 경우가 아니라면 (즉, 홈 탭에 있고 오버레이가 닫혀있다면) 앱 종료 여부를 묻습니다.
    final bool shouldExit = await showExitAppDialog(context);

    if (shouldExit) {
      // 사용자가 '예'를 선택했으면 앱을 종료합니다.
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appLanguage = Provider.of<AppLanguageProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    if (!userProvider.isUserDataLoaded || _widgetOptions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: Text(localizations.translate('appTitle'), style: const TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: CircularProgressIndicator(), // 로딩 인디케이터 색상은 main.dart의 theme를 따름
        ),
      );
    }

    // 마이크 아이콘을 빨간색으로 강조할 조건
    final bool highlightMicIcon = (_userVoiceFilePath == null &&
        _isVoiceRecordingRequiredForCurrentFeature &&
        !_showVoiceCardOverlay);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        await _handleBackPress();
      },
      child: Scaffold(
        appBar: _selectedIndex == _homeTabIndex
            ? AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(
            localizations.translate('appTitle'),
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0.5,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          actions: [
            Builder(
              builder: (BuildContext innerContext) {
                return PopupMenuButton<Locale>(
                  icon: const Icon(Icons.language, color: Colors.white),
                  onSelected: (Locale newLocale) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        Provider.of<AppLanguageProvider>(context, listen: false).changeLanguage(newLocale);
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
                    const PopupMenuItem<Locale>(
                      value: Locale('en', ''),
                      child: Text('English', style: TextStyle(color: Colors.black)),
                    ),
                    const PopupMenuItem<Locale>(
                      value: Locale('ko', ''),
                      child: Text('한국어', style: TextStyle(color: Colors.black)),
                    ),
                    const PopupMenuItem<Locale>(
                      value: Locale('zh', ''),
                      child: Text('中文', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                  tooltip: localizations.translate('toggleLanguage'),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.mic,
                color: highlightMicIcon ? Colors.red : Colors.white, // 조건에 따라 색상 변경
              ),
              onPressed: () {
                setState(() {
                  _showVoiceCardOverlay = !_showVoiceCardOverlay;
                  // 마이크 오버레이를 닫으면 강조 상태 해제 (사용자가 직접 조작)
                  if (!_showVoiceCardOverlay) {
                    _isVoiceRecordingRequiredForCurrentFeature = false;
                  }
                });
              },
              tooltip: localizations.translate('voiceRecording'),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                ).then((_) {
                  // SettingsScreen에서 돌아왔을 때, 마이크 아이콘 강조 상태를 해제
                  setState(() {
                    _isVoiceRecordingRequiredForCurrentFeature = false;
                  });
                });
              },
              tooltip: localizations.translate('settings'),
            ),
          ],
        )
            : null,
        body: Stack(
          children: [
            // IndexedStack이 직접 전체 사용 가능한 공간을 사용하도록 합니다.
            IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
            VoiceRecorderOverlay(
              isVisible: _showVoiceCardOverlay,
              userVoiceFilePath: _userVoiceFilePath,
              onVoiceFilePathChanged: (newPath) {
                setState(() {
                  _userVoiceFilePath = newPath;
                  _initializeWidgetOptions();
                  // 음성 파일이 등록되면 마이크 아이콘 색상을 기본으로 되돌림
                  _isVoiceRecordingRequiredForCurrentFeature = false;
                });
              },
              onClose: () {
                setState(() {
                  _showVoiceCardOverlay = false;
                  // 오버레이가 닫히면 마이크 아이콘 강조 상태 해제
                  _isVoiceRecordingRequiredForCurrentFeature = false;
                });
              },
              showSnackBar: _showSnackBar,
            ),
          ],
        ),
        bottomNavigationBar: AppBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final Function(int) onTabSelected;
  final String? userVoiceFilePath;
  final VoidCallback showVoiceRecordingRequiredSnackBar;
  final VoidCallback navigateToSettings;
  final Function(Locale) changeLanguage;
  final VoidCallback toggleVoiceCardOverlay;
  final Function(bool) onVoiceRequiredFeatureSelected;

  const _HomeContent({
    required this.onTabSelected,
    this.userVoiceFilePath,
    required this.showVoiceRecordingRequiredSnackBar,
    required this.navigateToSettings,
    required this.changeLanguage,
    required this.toggleVoiceCardOverlay,
    required this.onVoiceRequiredFeatureSelected,
    super.key, // maxHeight 속성 제거
  });

  static const TextStyle headerStyle =
  TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle subHeaderStyle =
  TextStyle(fontSize: 18, color: Colors.grey);
  static const TextStyle cardTitleStyle =
  TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appLanguage = Provider.of<AppLanguageProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final String userName = userProvider.userName ?? localizations.translate('guest');
    final String userCollegeRawKey = userProvider.userCollegeRawKey ?? 'unknown_college';
    final String userDepartmentRawKey = userProvider.userDepartmentRawKey ?? 'unknown_department';

    final currentLanguageCode = appLanguage.appLocale.languageCode;
    final orientation = MediaQuery.of(context).orientation; // 현재 기기 방향 가져오기

    String translatedCollegeName = localizations.translate('noCollegeSelected');
    String translatedDepartmentName = localizations.translate('noDepartmentSelected');

    if (userProvider.isUserDataLoaded) {
      allCollegeAndDepartmentInfo.forEach((collegeOriginalKey, collegeData) {
        if (collegeOriginalKey == userCollegeRawKey) {
          translatedCollegeName = collegeData[currentLanguageCode] ?? collegeOriginalKey;
          for (var deptData in (collegeData['departments'] as List<dynamic>)) {
            if (deptData['original_key'] == userDepartmentRawKey) {
              translatedDepartmentName = deptData[currentLanguageCode] ?? userDepartmentRawKey;
              break;
            }
          }
        }
      });
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이름/단과/학과 카드
            Align( // 카드를 가운데 정렬하기 위해 Align 사용
              alignment: orientation == Orientation.landscape ? Alignment.topCenter : Alignment.topLeft,
              child: ConstrainedBox(
                // 가로 모드일 때 카드의 최대 너비와 높이를 제한합니다.
                constraints: BoxConstraints(
                  maxWidth: orientation == Orientation.landscape ? MediaQuery.of(context).size.width * 0.4 : 400, // 가로모드일 때 화면 너비의 40%
                  maxHeight: orientation == Orientation.landscape ? MediaQuery.of(context).size.height * 0.4 : double.infinity, // 가로모드일 때 화면 높이의 40%
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // 콘텐츠에 따라 크기 조절
                      children: [
                        Text(
                          localizations.translate('helloUser', {'userName': userName}),
                          style: headerStyle,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations.translate('college', {'collegeName': translatedCollegeName}),
                          style: subHeaderStyle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          localizations.translate('department', {'departmentName': translatedDepartmentName}),
                          style: subHeaderStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 기능 카드 GridView
            // GridView 자체에 shrinkWrap: true를 적용하여 Column 내부에서 높이를 유연하게 조절
            GridView.count(
              shrinkWrap: true, // GridView가 자식의 크기에 맞게 자신의 높이를 조절합니다.
              physics: const NeverScrollableScrollPhysics(), // GridView 자체 스크롤 비활성화 (부모 SingleChildScrollView가 스크롤 처리)
              crossAxisCount: orientation == Orientation.landscape ? 3 : 2, // 가로 모드일 때 3열, 세로 모드일 때 2열
              childAspectRatio: 1.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildFeatureCardWithTab(
                  Icons.announcement,
                  localizations.translate('announcements'),
                  0, // 공지사항 탭 인덱스
                  onTabSelected,
                  requiresVoice: false,
                  userVoiceFilePath: userVoiceFilePath,
                  showVoiceRecordingRequiredSnackBar: showVoiceRecordingRequiredSnackBar,
                  onVoiceRequiredFeatureSelected: onVoiceRequiredFeatureSelected,
                ),
                _buildFeatureCardWithTab(
                  Icons.restaurant_menu,
                  localizations.translate('cafeteriaInfo'),
                  3, // 식당 정보 탭 인덱스
                  onTabSelected,
                  requiresVoice: false,
                  userVoiceFilePath: userVoiceFilePath,
                  showVoiceRecordingRequiredSnackBar: showVoiceRecordingRequiredSnackBar,
                  onVoiceRequiredFeatureSelected: onVoiceRequiredFeatureSelected,
                ),
                _buildFeatureCardWithTab(
                  Icons.record_voice_over,
                  localizations.translate('pronunciationPractice'),
                  4, // 연습 탭 인덱스
                  onTabSelected,
                  requiresVoice: true,
                  userVoiceFilePath: userVoiceFilePath,
                  showVoiceRecordingRequiredSnackBar: showVoiceRecordingRequiredSnackBar,
                  onVoiceRequiredFeatureSelected: onVoiceRequiredFeatureSelected,
                ),
                _buildFeatureCardWithTab(
                  Icons.map,
                  localizations.translate('map'),
                  1, // 지도 탭 인덱스
                  onTabSelected,
                  requiresVoice: false,
                  userVoiceFilePath: userVoiceFilePath,
                  showVoiceRecordingRequiredSnackBar: showVoiceRecordingRequiredSnackBar,
                  onVoiceRequiredFeatureSelected: onVoiceRequiredFeatureSelected,
                ),
                _buildFeatureCard(
                  Icons.group,
                  localizations.translate('clubInfo'),
                  context,
                  const ClubInfoScreen(),
                  requiresVoice: false,
                  userVoiceFilePath: userVoiceFilePath,
                  showVoiceRecordingRequiredSnackBar: showVoiceRecordingRequiredSnackBar,
                  onVoiceRequiredFeatureSelected: onVoiceRequiredFeatureSelected,
                ),
                _buildFeatureCard(
                  Icons.translate,
                  localizations.translate('communicationTitle'),
                  context,
                  CommunicationScreen(
                    userName: userName,
                    userCollege: userCollegeRawKey,
                    userDepartment: userDepartmentRawKey,
                    userRecordedAudioPath: userVoiceFilePath ?? '',
                  ),
                  requiresVoice: true,
                  userVoiceFilePath: userVoiceFilePath,
                  showVoiceRecordingRequiredSnackBar: showVoiceRecordingRequiredSnackBar,
                  onVoiceRequiredFeatureSelected: onVoiceRequiredFeatureSelected,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      IconData icon, String title, BuildContext context, Widget destinationScreen,
      {required bool requiresVoice, String? userVoiceFilePath, required VoidCallback showVoiceRecordingRequiredSnackBar, required Function(bool) onVoiceRequiredFeatureSelected}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          // 기능 탭 시 음성 녹음 필요 여부 콜백 호출
          onVoiceRequiredFeatureSelected(requiresVoice);

          if (requiresVoice && userVoiceFilePath == null) {
            showVoiceRecordingRequiredSnackBar();
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          ).then((_) {
            // Push된 화면에서 돌아왔을 때 마이크 아이콘 강조 상태 해제
            onVoiceRequiredFeatureSelected(false);
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.lightBlue),
            const SizedBox(height: 8),
            Text(
              title,
              style: cardTitleStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCardWithTab(
      IconData icon,
      String title,
      int tabIndex,
      Function(int) onTabSelected,
      {required bool requiresVoice, String? userVoiceFilePath, required VoidCallback showVoiceRecordingRequiredSnackBar, required Function(bool) onVoiceRequiredFeatureSelected}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          // 기능 탭 시 음성 녹음 필요 여부 콜백 호출
          onVoiceRequiredFeatureSelected(requiresVoice);

          if (requiresVoice && userVoiceFilePath == null) {
            showVoiceRecordingRequiredSnackBar();
            return;
          }
          onTabSelected(tabIndex);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.lightBlue),
            const SizedBox(height: 8),
            Text(
              title,
              style: cardTitleStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}