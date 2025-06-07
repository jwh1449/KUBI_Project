// lib/sentence_selection/sentence_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:personal_test/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../pronunciation_screens/home_pronunciation_practice.dart';
import 'package:personal_test/widget/user_provider.dart';

class SentenceSelectionScreen extends StatefulWidget {
  final String? userRecordedAudioPath;

  const SentenceSelectionScreen({
    Key? key,
    this.userRecordedAudioPath,
  }) : super(key: key);

  @override
  State<SentenceSelectionScreen> createState() => _SentenceSelectionScreenState();
}

class _SentenceSelectionScreenState extends State<SentenceSelectionScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  String _selectedSentence = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        setState(() {
          _selectedSentence = localizations.translate('defaultPracticeSentence');
          _textEditingController.text = _selectedSentence;
        });
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final String? userName = userProvider.userName;
    final String? userCollegeRawKey = userProvider.userCollegeRawKey;
    final String? userDepartmentRawKey = userProvider.userDepartmentRawKey;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('selectPracticeSentence'),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: localizations.translate('enterPracticeSentence'),
                hintText: localizations.translate('sentenceHint'),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedSentence = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedSentence.isNotEmpty
                  ? () {
                // 중요: 이 부분이 PronunciationPracticeScreen으로 데이터를 전달하는 부분입니다.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PronunciationPracticeScreen(
                      correctText: _selectedSentence, // 사용자가 선택/입력한 문장
                      userRecordedAudioPath: widget.userRecordedAudioPath, // VoiceRecorderOverlay에서 온 파일 경로
                      userName: userName ?? '',
                      userCollege: userCollegeRawKey ?? '',
                      userDepartment: userDepartmentRawKey ?? '',
                    ),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(localizations.translate('startPractice'), style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 30),
            Text(
              localizations.translate('orChoosePredefined'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildSentenceTile(localizations.translate('predefinedSentence1')),
                  _buildSentenceTile(localizations.translate('predefinedSentence2')),
                  _buildSentenceTile(localizations.translate('predefinedSentence3')),
                  _buildSentenceTile(localizations.translate('predefinedSentence4')),
                  _buildSentenceTile(localizations.translate('predefinedSentence5')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentenceTile(String sentence) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        title: Text(sentence, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          setState(() {
            _textEditingController.text = sentence;
            _selectedSentence = sentence;
          });
        },
      ),
    );
  }
}