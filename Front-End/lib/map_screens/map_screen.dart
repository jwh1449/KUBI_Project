import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:personal_test/transport/app_language_provider.dart';
import 'package:personal_test/localization/app_localizations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  String _selectedBuildingKey = "학생회관"; // 드롭다운 기본 선택 값
  String? _tappedMarkerKey; // 탭된 마커의 키를 저장 (없으면 null)

  // 상세 설명을 추가한 places 데이터
  final Map<String, dynamic> places = {
    "학생회관": {
      "lat": 37.4526, "lon": 129.1642,
      "ko": "학생회관", "en": "Student Hall", "zh": "学生会馆",
      "description_ko": "학생들이 모여 식사, 휴식, 동아리 활동을 할 수 있는 공간입니다.",
      "description_en": "A space for students to dine, relax, and participate in club activities.",
      "description_zh": "为学生提供用餐、休息和社团活动的空间。"
    },
    "공동실험실습관": {
      "lat": 37.453638, "lon": 129.160049,
      "ko": "공동실험실습관", "en": "Joint Lab", "zh": "共同实验实习馆",
      "description_ko": "실험과 실습을 위한 공용 연구 공간입니다.",
      "description_en": "A shared research space for experiments and practical training.",
      "description_zh": "为实验和实训提供的公共研究空间。"
    },
    "1공학관": {
      "lat": 37.453051, "lon": 129.160907,
      "ko": "1공학관", "en": "Eng. Bldg. 1", "zh": "工学楼1",
      "description_ko": "기초 공학 수업과 실습이 진행되는 건물입니다.",
      "description_en": "A building for basic engineering classes and lab sessions.",
      "description_zh": "进行基础工程课程和实验的建筑。"
    },
    "2공학관": {
      "lat": 37.453605, "lon": 129.161203,
      "ko": "2공학관", "en": "Eng. Bldg. 2", "zh": "工学楼2",
      "description_ko": "전공 수업과 실험이 진행되는 공학관입니다.",
      "description_en": "An engineering building used for major classes and experiments.",
      "description_zh": "用于专业课程和实验的工学楼。"
    },
    "3공학관": {
      "lat": 37.452, "lon": 129.1609,
      "ko": "3공학관", "en": "Eng. Bldg. 3", "zh": "工学楼3",
      "description_ko": "공학 관련 수업과 연구가 이루어지는 건물입니다.",
      "description_en": "A building for engineering classes and research.",
      "description_zh": "进行工程课程和研究的建筑。"
    },
    "4공학관": {
      "lat": 37.452, "lon": 129.1593,
      "ko": "4공학관", "en": "Eng. Bldg. 4", "zh": "工学楼4",
      "description_ko": "실험실과 강의실이 위치한 공학관입니다.",
      "description_en": "An engineering building housing laboratories and lecture rooms.",
      "description_zh": "设有实验室和教室的工学楼。"
    },
    "5공학관": {
      "lat": 37.4531, "lon": 129.1593,
      "ko": "5공학관", "en": "Eng. Bldg. 5", "zh": "工学楼5",
      "description_ko": "전문 실습과 수업이 이루어지는 건물입니다.",
      "description_en": "A building for specialized practical training and classes.",
      "description_zh": "用于专业实训和教学的建筑。"
    },
    "인문사회과학관": {
      "lat": 37.4525, "lon": 129.1588,
      "ko": "인문사회과학관", "en": "Humanities & SS Bldg.", "zh": "人文社会科学馆",
      "description_ko": "인문학 및 사회과학 계열의 강의가 이루어지는 건물입니다.",
      "description_en": "A building for lectures in humanities and social sciences.",
      "description_zh": "进行人文学与社会科学课程的建筑。"
    },
    "조형관": {
      "lat": 37.4547, "lon": 129.1635,
      "ko": "조형관", "en": "Design Bldg.", "zh": "造型馆",
      "description_ko": "예술 및 디자인 관련 강의와 작업이 이루어지는 공간입니다.",
      "description_en": "A space for art and design classes and projects.",
      "description_zh": "进行艺术与设计课程及创作的空间。"
    },
    "언장관": {
      "lat": 37.4511, "lon": 129.1596,
      "ko": "언장관", "en": "Eonjung Dorm.", "zh": "恩藏宿舍",
      "description_ko": "학생들을 위한 기숙사 중 하나입니다.",
      "description_en": "One of the dormitories for students.",
      "description_zh": "为学生提供住宿的宿舍之一。"
    },
    "두타관": {
      "lat": 37.4546, "lon": 129.1586,
      "ko": "두타관", "en": "Doota Dorm.", "zh": "杜塔宿舍",
      "description_ko": "쾌적한 환경을 제공하는 기숙사 건물입니다.",
      "description_en": "A dormitory providing a pleasant living environment.",
      "description_zh": "提供舒适生活环境的宿舍楼。"
    },
    "해솔관": {
      "lat": 37.4539, "lon": 129.1587,
      "ko": "해솔관", "en": "Haesol Dorm.", "zh": "海솔宿舍",
      "description_ko": "학생용 생활관으로 다양한 편의 시설을 갖추고 있습니다.",
      "description_en": "A student dormitory equipped with various amenities.",
      "description_zh": "配备多种便利设施的学生宿舍。"
    },
    "강의동": {
      "lat": 37.4531, "lon": 129.1624,
      "ko": "강의동", "en": "Lecture Hall", "zh": "讲义楼",
      "description_ko": "대규모 강의가 진행되는 주요 강의동입니다.",
      "description_en": "A main lecture building for large classes.",
      "description_zh": "举行大型讲座的主要教学楼。"
    },
    "삼척도서관": {
      "lat": 37.4542, "lon": 129.1623,
      "ko": "삼척도서관", "en": "Samcheok Lib.", "zh": "三陟图书馆",
      "description_ko": "학습과 자료 열람이 가능한 도서관입니다.",
      "description_en": "A library for study and access to academic resources.",
      "description_zh": "可供学习和查阅资料的图书馆。"
    },
    "삼척도서관 옥외휴게실": {
      "lat": 37.454, "lon": 129.162,
      "ko": "삼척도서관 옥외휴게실", "en": "Samcheok Lib. Outdoor Rest", "zh": "三陟图书馆户外休息区",
      "description_ko": "도서관 옆에 위치한 야외 휴게 공간입니다.",
      "description_en": "An outdoor rest area next to the library.",
      "description_zh": "位于图书馆旁的户外休息区。"
    },
    "전산정보원": {
      "lat": 37.4526, "lon": 129.1617,
      "ko": "전산정보원", "en": "Comp. Info. Ctr.", "zh": "计算机信息中心",
      "description_ko": "IT 인프라 및 정보 시스템을 관리하는 기관입니다.",
      "description_en": "The institute managing IT infrastructure and information systems.",
      "description_zh": "负责信息技术基础设施与信息系统的机构。"
    },
    "대학본부": {
      "lat": 37.4523, "lon": 129.1619,
      "ko": "대학본부", "en": "Univ. HQ", "zh": "大学总部",
      "description_ko": "학교의 행정과 운영을 담당하는 본부 건물입니다.",
      "description_en": "The main administrative building of the university.",
      "description_zh": "The main administrative building of the university."
    },
    "그린에너지연구관": {
      "lat": 37.4519, "lon": 129.1625,
      "ko": "그린에너지연구관", "en": "Green Energy Rsch. Bldg.", "zh": "绿色能源研究馆",
      "description_ko": "수업을 듣거나 카페에서 휴식을 할 수 있는 장소입니다.", // 설명 업데이트
      "description_en": "A place where you can attend classes or relax at a cafe.",
      "description_zh": "可以上课或在咖啡馆休息的地方。"
    },
    "제2학생회관": {
      "lat": 37.4529, "lon": 129.166,
      "ko": "제2학생회관", "en": "Student Hall 2", "zh": "学生会馆2",
      "description_ko": "학생 복지와 동아리 활동이 이루어지는 공간입니다.",
      "description_en": "A space for student welfare and club activities.",
      "description_zh": "提供学生福利和社团活动的空间。"
    },
    "복합스포츠센터": {
      "lat": 37.4536, "lon": 129.1654,
      "ko": "복합스포츠센터", "en": "Complex Sports Ctr.", "zh": "综合体育中心",
      "description_ko": "다양한 실내 스포츠 활동이 가능한 시설입니다.",
      "description_en": "A facility for various indoor sports activities.",
      "description_zh": "可进行多种室内体育活动的设施。"
    },
    "체육관": {
      "lat": 37.4531, "lon": 129.1656,
      "ko": "체육관", "en": "Gymnasium", "zh": "体育馆",
      "description_ko": "체육 수업과 운동 경기가 열리는 장소입니다.",
      "description_en": "A venue for PE classes and sports events.",
      "description_zh": "用于体育课和运动比赛的场所。"
    },
    "생활체육관": {
      "lat": 37.4528, "lon": 129.165,
      "ko": "생활체육관", "en": "Life Sports Ctr.", "zh": "生活体育馆",
      "description_ko": "생활 체육 활동을 위한 공간입니다.",
      "description_en": "A space for everyday sports and physical activity.",
      "description_zh": "用于日常体育活动的空间。"
    },
    "창업보육센터": {
      "lat": 37.4514, "lon": 129.159,
      "ko": "창업보육센터", "en": "Business Incubation Ctr.", "zh": "创业孵化中心",
      "description_ko": "창업을 준비하는 학생들을 위한 지원 공간입니다.",
      "description_en": "A support center for students preparing to start businesses.",
      "description_zh": "为准备创业的学生提供支持的空间。"
    },
    "CU강원대정문점": {
      "lat": 37.4512, "lon": 129.1623,
      "ko": "CU강원대정문점", "en": "CU KNU Front Gate", "zh": "江原大学正门CU便利店",
      "description_ko": "정문 근처에 위치한 편의점입니다.",
      "description_en": "A convenience store near the main gate.",
      "description_zh": "位于正门附近的便利店。"
    },
    "대운동장": {
      "lat": 37.4543, "lon": 129.1646,
      "ko": "대운동장", "en": "Main Stadium", "zh": "大运动场",
      "description_ko": "야외 스포츠 활동이 이루어지는 대형 운동장입니다.",
      "description_en": "A large stadium for outdoor sports activities.",
      "description_zh": "进行户外体育活动的大型运动场。"
    },
    "야외음악당": {
      "lat": 37.4535, "lon": 129.1667,
      "ko": "야외음악당", "en": "Outdoor Music Hall", "zh": "户外音乐厅",
      "description_ko": "공연과 행사가 열리는 야외 공간입니다.",
      "description_en": "An outdoor space for performances and events.",
      "description_zh": "举办演出和活动的户外场所。"
    }
  };

  @override
  void initState() {
    super.initState();
    // 초기 센터를 학생회관으로 설정
    if (places.containsKey(_selectedBuildingKey)) {
      final initialLoc = places[_selectedBuildingKey]!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(LatLng(initialLoc['lat'], initialLoc['lon']), 17.0);
      });
    }
  }

  List<Marker> _buildMarkers(AppLocalizations localizations, String currentLangCode) {
    return places.entries.map((entry) {
      final String key = entry.key; // 각 장소의 키 (예: "학생회관")
      final Map<String, dynamic> placeData = entry.value; // 장소 데이터 전체 가져오기
      final String name = placeData[currentLangCode] ?? placeData['ko'];
      final double lat = placeData['lat'];
      final double lon = placeData['lon'];

      // 현재 탭된 마커인지 확인
      final bool isTapped = (_tappedMarkerKey == key);
      // 탭된 마커는 더 큰 사이즈를 가짐
      final double markerSize = isTapped ? 100.0 : 80.0;
      final double iconSize = isTapped ? 50.0 : 40.0;
      final double fontSize = isTapped ? 12.0 : 10.0;
      final Color iconColor = isTapped ? Colors.blue : Colors.red; // 탭된 마커는 파란색으로 변경

      return Marker(
        width: markerSize,
        height: markerSize,
        point: LatLng(lat, lon),
        child: GestureDetector(
          onTap: () {
            // 마커를 탭했을 때 상태 업데이트
            setState(() {
              _tappedMarkerKey = key;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final dialogLocalizations = AppLocalizations.of(context)!;
                // 현재 언어에 맞는 설명을 가져오기
                final String descriptionKey = 'description_$currentLangCode';
                final String description = placeData[descriptionKey] ?? placeData['description_ko']; // 해당 언어가 없으면 한국어 설명 사용

                return AlertDialog(
                  title: Text(name),
                  content: Column(
                    mainAxisSize: MainAxisSize.min, // 내용에 따라 다이얼로그 크기 조절
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description), // 추가된 설명 표시
                      ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.lightBlue,
                      ),
                      child: Text(dialogLocalizations.translate('close')),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _tappedMarkerKey = null;
                        });
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Column(
            children: [
              Icon(
                Icons.location_pin,
                color: iconColor, // 탭된 마커 색상 변경
                size: iconSize, // 탭된 마커 아이콘 크기 변경
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: fontSize, // 탭된 마커 텍스트 크기 변경
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: const [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.white,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _moveToLocation(String key) {
    if (places.containsKey(key)) {
      final loc = places[key]!;
      _mapController.move(LatLng(loc['lat'], loc['lon']), 17.0);
      setState(() {
        _selectedBuildingKey = key;
        _tappedMarkerKey = key; // 드롭다운으로 이동 시에도 해당 마커를 크게 표시
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Provider.of<AppLanguageProvider>(context).appLocale;
    final String currentLangCode = currentLocale.languageCode;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          localizations.translate('map1'),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false, // 이 줄을 추가하여 뒤로가기 버튼 자동 생성 방지
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBuildingKey,
                isExpanded: true,
                iconEnabledColor: Colors.lightBlue,
                onChanged: (val) {
                  if (val != null) {
                    _moveToLocation(val);
                  }
                },
                items: places.keys.map((key) {
                  final loc = places[key]!;
                  final String displayName = loc[currentLangCode] ?? loc['ko'];

                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(
                      displayName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(37.4526, 129.1642),
                    initialZoom: 17.0,
                    minZoom: 13.0,
                    maxZoom: 18.0,
                    keepAlive: true,
                    onTap: (tapPosition, latLng) {
                      setState(() {
                        _tappedMarkerKey = null;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.kangwon_uni_map',
                    ),
                    MarkerLayer(
                      markers: _buildMarkers(localizations, currentLangCode),
                    ),
                  ],
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoomInBtn',
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom + 1,
                          );
                        },
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoomOutBtn',
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom - 1,
                          );
                        },
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}