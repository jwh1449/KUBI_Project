import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart'; // kIsWeb import
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:personal_test/transport/app_language_provider.dart';

// MealItem data model definition
class MealItem {
  final int menuId;
  final String menuDate;
  final String menuType;
  final String menuItems; // Korean menu
  final String menuEn;    // English menu
  final String menuZh;    // Chinese menu
  final String mealTime;

  MealItem({
    required this.menuId,
    required this.menuDate,
    required this.menuType,
    required this.mealTime,
    required this.menuItems,
    required this.menuEn,
    required this.menuZh,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      menuId: json['menuId'] as int? ?? 0,
      menuDate: json['menuDate'] as String? ?? '',
      menuType: json['menuType'] as String? ?? '',
      mealTime: json['mealTime'] as String? ?? '',
      menuItems: json['menuItems'] as String? ?? '식단 정보 없음',
      menuEn: json['menuEn'] as String? ?? 'No meal information',
      menuZh: json['menuZh'] as String? ?? '没有菜单信息',
    );
  }
}

class StudentCafeteriaTab extends StatefulWidget {
  const StudentCafeteriaTab({Key? key}) : super(key: key);

  @override
  StudentCafeteriaTabState createState() => StudentCafeteriaTabState();
}

class StudentCafeteriaTabState extends State<StudentCafeteriaTab> {
  DateTime _selectedDate = DateTime.now();
  late List<DateTime> _currentWeekDays;
  Map<String, Map<String, Map<String, MealItem>>> _allMealData = {};
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _updateCurrentWeekDays(_selectedDate);
    _fetchMeals();
  }

  void _updateCurrentWeekDays(DateTime date) {
    final firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));
    _currentWeekDays = List.generate(5, (i) => firstDayOfWeek.add(Duration(days: i)));
    if (!_currentWeekDays.any((d) => _isSameDay(d, _selectedDate))) {
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
        Uri.parse('https://joljak-backend-production.up.railway.app/api/menus'),
      );

      if (response.statusCode == 200) {
        final jsonString = utf8.decode(response.bodyBytes);

        final List<dynamic> data = jsonDecode(jsonString);
        Map<String, Map<String, Map<String, MealItem>>> fetchedMeals = {};

        for (var itemJson in data) {
          final mealItem = MealItem.fromJson(itemJson);
          final currentYear = DateTime.now().year;
          final datePart = mealItem.menuDate.split('(')[0];

          DateTime parsedDate;
          try {
            parsedDate = DateFormat('yyyy.MM.dd').parse('$currentYear.$datePart');
          } catch (e) {
            continue;
          }
          final formattedDateKey = DateFormat('yyyy-MM-dd').format(parsedDate);

          fetchedMeals
              .putIfAbsent(formattedDateKey, () => {})
              .putIfAbsent(mealItem.mealTime, () => {})
              .putIfAbsent(mealItem.menuType, () => mealItem);
        }

        if (mounted) { // mounted check: 비동기 작업 후 setState 호출 전 위젯 마운트 여부 확인
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

  // 언어에 따라 '식단 정보 없음' 메시지 반환
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

  // Provider를 통해 현재 언어를 가져와 식단 내용을 반환
  String _getMealMenu(String mealTime, String mealType) {
    final currentLanguage = Provider.of<AppLanguageProvider>(context).currentMenuLanguage;

    final formattedDateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final mealsForSelectedDate = _allMealData[formattedDateKey];

    if (mealsForSelectedDate == null) {
      return _getNoInfoMessage(currentLanguage);
    }

    final mealsForTime = mealsForSelectedDate[mealTime];
    if (mealsForTime == null) {
      return _getNoInfoMessage(currentLanguage);
    }

    final mealItem = mealsForTime[mealType];

    if (mealItem == null) {
      return _getNoInfoMessage(currentLanguage);
    }

    String content;
    switch (currentLanguage) {
      case MenuLanguage.korean:
        if (mealItem.menuItems == "메뉴 없음" || mealItem.menuItems.contains('식단 정보 없음')) {
          return _getNoInfoMessage(currentLanguage);
        }
        content = mealItem.menuItems;
        break;
      case MenuLanguage.english:
        if (mealItem.menuEn == "No menu" || mealItem.menuEn.contains('No meal information')) {
          return _getNoInfoMessage(currentLanguage);
        }
        content = mealItem.menuEn;
        break;
      case MenuLanguage.chinese:
        if (mealItem.menuZh == "没有菜单" || mealItem.menuZh.contains('没有菜单信息')) {
          return _getNoInfoMessage(currentLanguage);
        }
        content = mealItem.menuZh;
        break;
    }

    // 메뉴 항목을 줄바꿈으로 분리하여 반환
    return content
        .trim()
        .split(RegExp(r',\s*')) // 쉼표와 공백으로 분리
        .where((item) => item.isNotEmpty) // 빈 문자열 제거
        .map((item) => item.trim()) // 각 항목의 양 끝 공백 제거
        .join('\n'); // 줄바꿈으로 다시 결합
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final lastDayOfCurrentWeek = now.add(Duration(days: 6 - now.weekday));
    // 선택된 날짜가 현재 주의 금요일보다 미래이고, 평일(월-금)인 경우를 확인
    final isSelectedDateFutureAndWeekday = _selectedDate.isAfter(lastDayOfCurrentWeek) &&
        (_selectedDate.weekday >= DateTime.monday && _selectedDate.weekday <= DateTime.friday);

    return SingleChildScrollView(
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
            _getLocalizedText("Samcheok-5 Engineering Hall Cafeteria", "삼척-5공학관식당", "三陟-5号工学馆食堂"),
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

          // Weekly Date Selection UI (Mon-Fri day buttons - horizontal scroll)
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

          // 식단 정보 표시 부분
          _isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : _hasError
              ? Center(
            child: Column(
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
                    '下周菜单每周一更新。'
                ),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          )
              : Column( // 이 Column은 이제 Expanded로 감싸지 않아도 됩니다. (SingleChildScrollView가 상위에 있으므로)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(thickness: 1.0),
              // Breakfast Menu
              Text(
                _getLocalizedText("Breakfast for ₩1,000", "천원의 아침밥(1,000)", "1000韩元早餐"),
                style: TextStyle(color: Colors.lightBlue[400], fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(
                _getMealMenu('아침', '천원의아침밥(1,000)'),
                style: const TextStyle(fontSize: 16),
              ),
              const Divider(thickness: 1.0),
              const SizedBox(height: 8.0),

              // Lunch Menu (Set Meal, Rice Bowl, Special Menu)
              Text(
                _getLocalizedText("Lunch", "점심", "午餐"),
                style: TextStyle(color: Colors.lightBlue[400], fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(_getLocalizedText("Set Meal (₩6,000)", "백  반(6,000)", "套餐(6,000韩元)")),
              Text(_getMealMenu('점심', '백  반(6,000)'), style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8.0),
              Text(_getLocalizedText("Rice Bowl (₩5,000)", "덮밥류(5,000)", "盖饭类(5,000韩元)")),
              Text(_getMealMenu('점심', '덮밥류(5,000)'), style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8.0),
              Text(_getLocalizedText("Special Menu (₩5,500)", "특 선 메 뉴(5,500)", "特色菜单(5,500韩元)")),
              Text(_getMealMenu('점심', '특 선 메 뉴(5,500)'), style: const TextStyle(fontSize: 16)),
              const Divider(thickness: 1.0),
              const SizedBox(height: 8.0),

              // Dinner Menu (Set Meal, Rice Bowl, Special Menu)
              Text(
                _getLocalizedText("Dinner", "저녁", "晚餐"),
                style: TextStyle(color: Colors.lightBlue[400], fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(_getLocalizedText("Set Meal (₩6,000)", "백  반(6,000)", "套餐(6,000韩元)")),
              Text(_getMealMenu('저녁', '백  반(6,000)'), style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8.0),
              Text(_getLocalizedText("Rice Bowl (₩5,000)", "덮밥류(5,000)", "盖饭类(5,000韩元)")),
              Text(_getMealMenu('저녁', '덮밥류(5,000)'), style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8.0),
              Text(_getLocalizedText("Special Menu (₩5,500)", "특 선 메 뉴(5,500)", "特色菜单(5,500韩元)")),
              Text(_getMealMenu('저녁', '특 선 메 뉴(5,500)'), style: const TextStyle(fontSize: 16)),
              const Divider(thickness: 1.0),
            ],
          ),
        ],
      ),
    );
  }
}