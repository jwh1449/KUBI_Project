import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 📢 알림 설정, 언어 변경, 음성/자막 설정을 포함하는 통합된 설정 화면
class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  AppSettingsScreenState createState() => AppSettingsScreenState();
}

class AppSettingsScreenState extends State<AppSettingsScreen> {
  // ✅ 알림 설정 상태
  bool announcementNotifications = true;
  bool pronunciationFeedback = true;
  bool chatNotifications = true;
  bool mealNotifications = false;
  bool eventNotifications = true;
  bool appUpdateNotifications = true;

  TimeOfDay pronunciationFeedbackTime = TimeOfDay(hour: 10, minute: 0);
  TimeOfDay mealNotificationTime = TimeOfDay(hour: 8, minute: 0);

  // ✅ 음성/자막 설정 상태
  bool subtitlesEnabled = true;
  bool backgroundMusicEnabled = false;
  double speechSpeed = 1.0;
  bool feedbackVoiceEnabled = true;
  String selectedBackgroundMusic = '자연의 소리';

  final List<String> backgroundMusicOptions = ['자연의 소리', '배경 음악', '심플 음악'];

  // ⏰ 시간 선택
  Future<void> _selectTime(BuildContext context, TimeOfDay currentTime, void Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (picked != null && picked != currentTime) {
      setState(() {
        onTimeSelected(picked);
      });
    }
  }

  // 🌍 언어 변경 다이얼로그
  void _showLanguageChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("change language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(context, "한국어"),
              _buildLanguageOption(context, "English"),
              _buildLanguageOption(context, "中文"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language) {
    return ListTile(
      title: Text(language),
      onTap: () {
        // TODO: 언어 변경 로직 추가
        Navigator.pop(context);
      },
    );
  }

  // 🎛 전체 화면 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text("🔔 App settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _buildSwitchTile('📢 Notice notification', announcementNotifications, (value) {
            setState(() => announcementNotifications = value);
          }),
          _buildSwitchTile('🗣 Pronunciation correction feedback notification', pronunciationFeedback, (value) {
            setState(() => pronunciationFeedback = value);
          }),
          if (pronunciationFeedback) _buildTimePickerTile('Feedback time setting', pronunciationFeedbackTime, (newTime) {
            setState(() => pronunciationFeedbackTime = newTime);
          }),
          _buildSwitchTile('💬 Chat/Message Notifications', chatNotifications, (value) {
            setState(() => chatNotifications = value);
          }),
          _buildSwitchTile("🍽 Today's meal reminder", mealNotifications, (value) {
            setState(() => mealNotifications = value);
          }),
          if (mealNotifications) _buildTimePickerTile('Set meal reminder time', mealNotificationTime, (newTime) {
            setState(() => mealNotificationTime = newTime);
          }),
          _buildSwitchTile('🎉 Event and activity notifications', eventNotifications, (value) {
            setState(() => eventNotifications = value);
          }),
          _buildSwitchTile('🔄 App update notification', appUpdateNotifications, (value) {
            setState(() => appUpdateNotifications = value);
          }),

          const SizedBox(height: 20),
          const Text("🌍 Language settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text("Change language"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showLanguageChangeDialog(context),
          ),

          const SizedBox(height: 20),
          const Text("🎙 Voice/Subtitle Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (backgroundMusicEnabled)
            DropdownButton<String>(
              value: selectedBackgroundMusic,
              onChanged: (String? newValue) {
                setState(() => selectedBackgroundMusic = newValue!);
              },
              items: backgroundMusicOptions.map((String music) {
                return DropdownMenuItem<String>(
                  value: music,
                  child: Text(music),
                );
              }).toList(),
            ),
          Text('voice rate: ${speechSpeed.toStringAsFixed(1)}x'),
          Slider(
            min: 0.5,
            max: 2.0,
            value: speechSpeed,
            onChanged: (value) {
              setState(() => speechSpeed = value);
            },
          ),
          _buildSwitchTile('Pronunciation feedback voice activated', feedbackVoiceEnabled, (value) {
            setState(() => feedbackVoiceEnabled = value);
          }),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Your settings have been saved!')),
              );
            },
            child: const Text('Save settings'),
          ),
        ],
      ),
    );
  }

  // 스위치 타일
  Widget _buildSwitchTile(String title, bool value, void Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      value: value,
      onChanged: onChanged,
    );
  }

  // 시간 선택 타일
  Widget _buildTimePickerTile(String title, TimeOfDay time, void Function(TimeOfDay) onTimeSelected) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: Text(DateFormat.jm().format(DateTime(2023, 1, 1, time.hour, time.minute))),
      trailing: const Icon(Icons.access_time),
      onTap: () => _selectTime(context, time, onTimeSelected),
    );
  }
}
