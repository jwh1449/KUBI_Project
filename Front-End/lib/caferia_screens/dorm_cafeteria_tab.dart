import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:personal_test/transport/app_language_provider.dart';
import 'package:flutter/foundation.dart'; // kIsWeb import

// MealItem Data Model
class MealItem {
  final int id;
  final String menuDate;
  final String mealTime; // e.g., "점심", "저녁"
  final String menuItems; // Korean menu
  final String menuEn;    // English menu
  final String menuZh;    // Chinese menu

  MealItem({
    required this.id,
    required this.menuDate,
    required this.mealTime,
    required this.menuItems,
    required this.menuEn,
    required this.menuZh,
  });

  // Factory constructor to create a MealItem from JSON data.
  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      id: json['id'] as int? ?? 0,
      menuDate: json['menuDate'] as String? ?? '',
      mealTime: json['mealTime'] as String? ?? '',
      menuItems: json['menuItems'] as String? ?? 'No meal information',
      menuEn: json['menuEn'] as String? ?? 'No meal information',
      menuZh: json['menuZh'] as String? ?? '没有菜单信息',
    );
  }
}

// DormitoryCafeteriaScreen Widget
class DormitoryCafeteriaScreen extends StatefulWidget {
  const DormitoryCafeteriaScreen({Key? key}) : super(key: key);

  @override
  DormitoryCafeteriaScreenState createState() => DormitoryCafeteriaScreenState();
}

class DormitoryCafeteriaScreenState extends State<DormitoryCafeteriaScreen> {
  DateTime _selectedDate = DateTime.now();
  late List<DateTime> _currentWeekDays;
  // 변경: List<MealItem> 대신 Map<String, MealItem>으로 변경 (특정 mealType을 키로 사용하기 위함)
  Map<String, Map<String, List<MealItem>>> _allMealData = {};
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _updateCurrentWeekDays(_selectedDate);
    _fetchMeals();
  }

  void _updateCurrentWeekDays(DateTime date) {
    // 월요일부터 금요일까지 5일만 표시
    final firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1)); // 현재 주의 월요일
    _currentWeekDays = List.generate(5, (i) => firstDayOfWeek.add(Duration(days: i)));

    if (!_currentWeekDays.any((d) => _isSameDay(d, _selectedDate))) {
      // 선택된 날짜가 현재 주에 없으면 (예: 주말에 앱 실행 시) 첫째 날로 설정
      _selectedDate = _currentWeekDays.first;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _fetchMeals() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('https://joljak-backend-production.up.railway.app/api/dormmenus'),
      );

      if (response.statusCode == 200) {
        final jsonString = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(jsonString);
        Map<String, Map<String, List<MealItem>>> fetchedMeals = {};

        for (var itemJson in data) {
          final mealItem = MealItem.fromJson(itemJson);
          // Assuming menuDate format like "05.29(수)"
          final datePart = mealItem.menuDate.split('(')[0];

          // Current year is used because the API response does not contain year
          final currentYear = DateTime.now().year;
          DateTime parsedDate;
          try {
            // Adjust parsing for 'yyyy.MM.dd' format
            parsedDate = DateFormat('yyyy.MM.dd').parse('$currentYear.$datePart');
          } catch (e) {
            // 날짜 파싱 실패 시 디버깅 메시지 추가
            print('Date parsing failed for ${mealItem.menuDate}: $e');
            continue; // Skip this item if date parsing fails
          }
          final formattedDateKey = DateFormat('yyyy-MM-dd').format(parsedDate);

          fetchedMeals
              .putIfAbsent(formattedDateKey, () => {})
              .putIfAbsent(mealItem.mealTime, () => [])
              .add(mealItem);
        }

        if (mounted) { // mounted check
          setState(() {
            _allMealData = fetchedMeals;
          });
        }
      } else {
        _hasError = true;
        if (mounted) { // mounted check
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_getLocalizedText('Failed to load menu: ${response.statusCode}', '식단을 불러오는데 실패했습니다: ${response.statusCode}', '未能加载菜单: ${response.statusCode}'))),
          );
        }
      }
    } catch (e) {
      _hasError = true;
      if (mounted) { // mounted check
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_getLocalizedText('Network error occurred. Please try again.', '네트워크 오류가 발생했습니다. 다시 시도해주세요.', '发生网络错误，请重试。'))),
        );
      }
    } finally {
      if (mounted) { // mounted check
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _selectDay(DateTime day) {
    setState(() {
      _selectedDate = day;
    });
  }

  String _getMealContent(String mealTime) {
    final currentLanguage = Provider.of<AppLanguageProvider>(context).currentMenuLanguage;

    final formattedDateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final mealsForSelectedDate = _allMealData[formattedDateKey];

    if (mealsForSelectedDate == null || !mealsForSelectedDate.containsKey(mealTime)) {
      return _getNoInfoMessage(currentLanguage);
    }

    final mealItems = mealsForSelectedDate[mealTime];
    if (mealItems == null || mealItems.isEmpty) {
      return _getNoInfoMessage(currentLanguage);
    }

    // 기숙사 식당은 보통 한 끼에 하나의 식단만 제공하는 경우가 많으므로 첫 번째 항목을 사용
    final mealItem = mealItems.first;
    String content;

    switch (currentLanguage) {
      case MenuLanguage.korean:
        if (mealItem.menuItems.contains('식단 정보 없음') || mealItem.menuItems == '메뉴 없음') {
          return _getNoInfoMessage(currentLanguage);
        }
        content = mealItem.menuItems;
        break;
      case MenuLanguage.english:
        if (mealItem.menuEn.contains('No meal information') || mealItem.menuEn == 'No menu') {
          return _getNoInfoMessage(currentLanguage);
        }
        content = mealItem.menuEn;
        break;
      case MenuLanguage.chinese:
        if (mealItem.menuZh.contains('没有菜单信息') || mealItem.menuZh == '没有菜单') {
          return _getNoInfoMessage(currentLanguage);
        }
        content = mealItem.menuZh;
        break;
    }
    // Ensures each item is on a new line if separated by ', ' in the API response.
    return content.split(', ').join('\n');
  }

  String _getNoInfoMessage(MenuLanguage language) {
    switch (language) {
      case MenuLanguage.korean:
        return '식단 정보 없음';
      case MenuLanguage.english:
        return 'No meal information';
      case MenuLanguage.chinese:
        return '没有菜单信息';
    }
  }

  // 일반 텍스트를 언어에 따라 지역화
  String _getLocalizedText(String enText, String koText, String zhText) {
    final currentLanguage = Provider.of<AppLanguageProvider>(context).currentMenuLanguage;
    switch (currentLanguage) {
      case MenuLanguage.korean:
        return koText;
      case MenuLanguage.english:
        return enText;
      case MenuLanguage.chinese:
        return zhText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    // lastDayOfCurrentWeek를 원래대로 '일요일'로 설정하여 금요일도 현재 주로 포함되게 함
    final lastDayOfCurrentWeek = now.add(Duration(days: 6 - now.weekday));
    // 선택된 날짜가 현재 주의 일요일보다 미래이고, 평일(월-금)인 경우를 확인
    final isSelectedDateFutureAndWeekday = _selectedDate.isAfter(lastDayOfCurrentWeek) &&
        (_selectedDate.weekday >= DateTime.monday && _selectedDate.weekday <= DateTime.friday);

    return Scaffold(
      body: SingleChildScrollView( // ✨ Scaffold body를 SingleChildScrollView로 감쌉니다.
        padding: EdgeInsets.only(
          left: 16.0,
          top: 16.0,
          right: 16.0,
          // 웹 환경에서는 MediaQuery.of(context).padding.bottom이 0일 수 있으므로 kIsWeb 체크
          bottom: kIsWeb ? 16.0 : MediaQuery.of(context).padding.bottom + 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    _getLocalizedText("Samcheok Campus", "삼척캠퍼스", "三陟校区"),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              _getLocalizedText("Dormitory Cafeteria", "기숙사 식당", "宿舍食堂"),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),

            Center(
              child: Text(
                "${DateFormat('yyyy.MM.dd').format(_currentWeekDays.first)} ~ ${DateFormat('yyyy.MM.dd').format(_currentWeekDays.last)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8.0),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _currentWeekDays.map((day) {
                  final dayOfWeek = DateFormat('EEE', Localizations.localeOf(context).languageCode).format(day);
                  final dayOfMonth = DateFormat('d').format(day);
                  final isSelected = _isSameDay(day, _selectedDate);
                  final isToday = _isSameDay(day, now);

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: InkWell(
                        onTap: () => _selectDay(day),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.lightBlue
                                : (isToday ? Colors.lightBlue.withOpacity(0.2) : Colors.white),
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: isSelected ? Colors.lightBlue : Colors.grey[300]!,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayOfWeek,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                dayOfMonth,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20.0),

            // 여기서 Expanded를 제거합니다.
            _isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : _hasError
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_getLocalizedText('Failed to load menu.', '식단을 불러오는 데 실패했습니다.', '未能加载菜单。')),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _fetchMeals,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_getLocalizedText('Try Again', '다시 시도', '重试')),
                  ),
                ],
              ),
            )
                : isSelectedDateFutureAndWeekday
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _getLocalizedText(
                      'Next week\'s menu will be updated every Monday.',
                      '다음 주 식단은 매주 월요일에 업데이트됩니다.',
                      '下周菜单每周一更新。'),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : Column( // ✨ 이 Column은 이제 Expanded의 자식이 아닙니다.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(thickness: 1.0),
                Text(
                  _getLocalizedText("Lunch", "점심", "午餐"),
                  style: TextStyle(color: Colors.lightBlue[400], fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4.0),
                Text(
                  _getMealContent('점심'),
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(thickness: 1.0),
                const SizedBox(height: 8.0),

                Text(
                  _getLocalizedText("Dinner", "저녁", "晚餐"),
                  style: TextStyle(color: Colors.lightBlue[400], fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4.0),
                Text(
                  _getMealContent('저녁'),
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(thickness: 1.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}