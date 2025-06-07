import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_test/localization/app_localizations.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<String> _practiceHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPracticeHistory();
  }

  Future<void> _loadPracticeHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('practiceHistory') ?? [];

    setState(() {
      _practiceHistory = history.reversed.toList();
      _isLoading = false;
    });
  }

  void _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('practiceHistory');
    setState(() {
      _practiceHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // 현지화 인스턴스 가져오기

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue, // 파란색 배경 (lightBlue로 변경됨)
        title: Text(
          localizations.translate('practiceHistory'), // 현지화 적용
          style: const TextStyle(color: Colors.white), // 흰색 글씨
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white), // 파란 배경에 흰 아이콘
            tooltip: localizations.translate('clearAll'), // 현지화 적용
            onPressed: _practiceHistory.isEmpty
                ? null
                : () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(localizations.translate('clearHistory'), style: const TextStyle(color: Colors.lightBlue)), // 현지화 적용 및 lightBlue
                  content: Text(localizations.translate('confirmDeleteRecords')), // 현지화 적용
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(localizations.translate('cancel'), style: const TextStyle(color: Colors.lightBlue)), // 현지화 적용 및 lightBlue
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearHistory();
                      },
                      child: Text(localizations.translate('delete'), style: const TextStyle(color: Colors.red)), // 현지화 적용
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.lightBlue)) // lightBlue로 변경됨
          : _practiceHistory.isEmpty
          ? Center(
        child: Text(
          localizations.translate('noPracticeHistoryYet'), // 현지화 적용
          style: const TextStyle(fontSize: 18, color: Colors.lightBlue), // lightBlue로 변경됨
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _practiceHistory.length,
        separatorBuilder: (_, __) => const Divider(color: Colors.lightBlue), // lightBlue로 변경됨
        itemBuilder: (context, index) {
          final item = _practiceHistory[index];
          return ListTile(
            leading: const Icon(Icons.record_voice_over, color: Colors.lightBlue), // lightBlue로 변경됨
            title: Text(item),
            subtitle: Text(
              localizations.translate('practiceNumber', {'number': (_practiceHistory.length - index).toString()}), // 현지화 적용
              style: const TextStyle(color: Colors.blueGrey),
            ),
          );
        },
      ),
    );
  }
}