// lib/transport/change_major_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_test/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:personal_test/widget/user_provider.dart';
import 'package:personal_test/home_screens/home_screen.dart'; // allCollegeAndDepartmentInfo 맵을 사용

// 학과 변경 UI
class ChangeMajorScreen extends StatefulWidget {
  final String? initialMajor;
  final String? initialCollege;

  const ChangeMajorScreen({super.key, this.initialMajor, this.initialCollege});

  @override
  ChangeMajorScreenState createState() => ChangeMajorScreenState();
}

class ChangeMajorScreenState extends State<ChangeMajorScreen> {
  String? _selectedMajor; // 현재 선택된 학과의 '원시 키' (예: 'dept_green_energy_engineering')
  String? _selectedCollege; // 현재 선택된 단과대학의 '원시 키' (예: 'college_engineering')

  // 언어에 독립적인 '원시 키' 데이터를 저장하는 맵
  // 이 맵은 언어 변경과 무관하게 항상 동일하며, 로컬라이제이션 키를 사용합니다.
  final Map<String, List<String>> _rawMajorsByCollege = {
    'college_engineering': [
      'dept_green_energy_engineering',
      'dept_electronic_ai_systems_engineering',
      'dept_mechanical_engineering',
      'dept_electrical_engineering',
      'dept_construction_convergence',
    ],
    'college_humanities_social_design_sports': [
      'dept_global_talent',
      'dept_human_sports',
      'dept_multi_design',
      'dept_social_welfare',
      'dept_life_design',
      'dept_early_childhood_education',
    ],
  };

  // '원시 키'에 해당하는 '현지화된 이름'을 저장하는 맵 (널 허용)
  // 이 맵은 `_initializeLocalizedNames()`에서 context를 사용하여 초기화됩니다.
  Map<String, String>? _localizedCollegeNames;
  Map<String, String>? _localizedMajorNames;

  @override
  void initState() {
    super.initState();
    // 위젯 생성 시 초기값을 설정합니다 (AccountSettingsScreen에서 전달받은 Firestore의 '원시 키' 값).
    _selectedMajor = widget.initialMajor;
    _selectedCollege = widget.initialCollege;

    // build 메서드 이전에 context를 사용할 수 있도록 `WidgetsBinding.instance.addPostFrameCallback` 사용
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocalizedNames(); // 현지화된 이름 초기화
      // _localizedCollegeNames와 _localizedMajorNames가 초기화된 후 UI를 업데이트합니다.
      if (mounted) {
        setState(() {});
      }
    });
  }

  // 로컬라이제이션 맵을 초기화하는 함수
  void _initializeLocalizedNames() {
    final localizations = AppLocalizations.of(context)!;

    // allCollegeAndDepartmentInfo 맵을 사용하여 모든 단과대학 및 학과 현지화
    // 이 방식이 AppLocalizations.of(context)!.translate()를 개별적으로 호출하는 것보다 더 견고합니다.
    _localizedCollegeNames = {};
    _localizedMajorNames = {};

    allCollegeAndDepartmentInfo.forEach((collegeRawKey, collegeData) {
      _localizedCollegeNames![collegeRawKey] = collegeData[localizations.locale.languageCode] ?? collegeRawKey.replaceAll('_', ' ');
      if (collegeData.containsKey('departments') && collegeData['departments'] is List) {
        for (var deptData in collegeData['departments']) {
          if (deptData is Map<String, dynamic> && deptData.containsKey('original_key')) {
            _localizedMajorNames![deptData['original_key']] = deptData[localizations.locale.languageCode] ?? deptData['original_key'].replaceAll('_', ' ');
          }
        }
      }
    });
  }

  // 학과 선택 변경 핸들러: '원시 키'를 받아서 _selectedMajor에 저장
  void _handleMajorChanged(String? rawMajorKey) {
    setState(() {
      _selectedMajor = rawMajorKey;
    });
  }

  // 단과대학 선택 변경 핸들러: '원시 키'를 받아서 _selectedCollege에 저장
  void _handleCollegeChanged(String? rawCollegeKey) {
    setState(() {
      _selectedCollege = rawCollegeKey;
      _selectedMajor = null; // 단과대학 변경 시 학과 선택을 초기화합니다.
    });
  }

  // Firestore에 학과 및 단과대학 정보를 저장하는 함수
  Future<void> _saveMajor() async {
    final user = FirebaseAuth.instance.currentUser;
    final localizations = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: false); // UserProvider 인스턴스 가져오기

    // 사용자 로그인 상태, 학과 및 단과대학 선택 여부 확인
    if (user != null && _selectedMajor != null && _selectedCollege != null) {
      try {
        // Firestore에 '원시 키'를 저장합니다.
        // 회원가입 화면에서 'college', 'department'로 필드명을 변경했으므로, 여기서도 동일하게 사용
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'college': _selectedCollege,   // Firestore 필드명: 'college'
          'department': _selectedMajor,  // Firestore 필드명: 'department'
        });

        // ⭐️ UserProvider의 상태를 업데이트합니다.
        userProvider.updateUserData(
          newCollegeRawKey: _selectedCollege,
          newDepartmentRawKey: _selectedMajor,
        );

        if (mounted) {
          // 사용자에게 보여줄 메시지에는 '현지화된 이름'을 사용합니다.
          final String majorText = _localizedMajorNames![_selectedMajor!] ?? _selectedMajor!;
          final String collegeText = _localizedCollegeNames![_selectedCollege!] ?? _selectedCollege!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.translate('departmentChanged', {'major': majorText, 'college': collegeText}))),
          );

          // 변경이 성공했으므로 이전 화면으로 돌아갑니다.
          // AccountSettingsScreen에서 pop의 결과를 받아 처리할 수 있습니다.
          Navigator.pop(context, true); // 성공 시 true 반환
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.translate('failedToSaveDepartmentCollege'))),
          );
        }
        debugPrint("학과 및 단과대학 정보 저장 중 오류 발생: $e");
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.translate('pleaseSelectDepartmentCollege'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // _localizedCollegeNames와 _localizedMajorNames 맵이 초기화될 때까지 로딩 인디케이터를 표시합니다.
    if (_localizedCollegeNames == null || _localizedMajorNames == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // 현재 선택된 학과 및 단과대학의 '현지화된 이름'을 가져옵니다.
    // _selectedMajor와 _selectedCollege는 '원시 키'를 가지고 있으므로,
    // 해당 맵에서 '원시 키'에 맞는 '현지화된 문자열'을 찾아 표시합니다.
    final String displayMajor = _selectedMajor != null
        ? (_localizedMajorNames![_selectedMajor!] ?? _selectedMajor!)
        : localizations.translate('noDepartmentSelected');

    final String displayCollege = _selectedCollege != null
        ? (_localizedCollegeNames![_selectedCollege!] ?? _selectedCollege!)
        : localizations.translate('noCollegeSelected');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 학과 및 단과대학 정보 표시 (플레이스홀더 치환)
            Text(
              localizations.translate('currentDepartment', {'department': displayMajor}),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              localizations.translate('currentCollege', {'college': displayCollege}),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(localizations.translate('selectNewCollegeAndDepartment'), style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: localizations.translate('selectCollege'),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  floatingLabelStyle: const TextStyle(color: Colors.lightBlue),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                value: _selectedCollege, // 드롭다운의 실제 값은 '원시 키'
                // 드롭다운 아이템 목록은 '원시 키' 맵인 _rawMajorsByCollege.keys를 사용합니다.
                items: _rawMajorsByCollege.keys.map((rawCollegeKey) {
                  return DropdownMenuItem<String>(
                    value: rawCollegeKey, // DropdownMenuItem의 값은 '원시 키'
                    // 표시되는 텍스트는 '현지화된 이름' (널 체크 후 안전하게 접근)
                    child: Text(_localizedCollegeNames![rawCollegeKey] ?? rawCollegeKey),
                  );
                }).toList(),
                onChanged: _handleCollegeChanged,
              ),
            ),
            const SizedBox(height: 20),
            // 단과대학이 선택되었을 때만 학과 목록을 표시합니다.
            if (_selectedCollege != null)
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // 학과 목록은 선택된 단과대학의 '원시 키' 리스트를 사용합니다.
                children: (_rawMajorsByCollege[_selectedCollege!] ?? []).map((rawMajorKey) {
                  return RadioListTile<String>(
                    // 표시되는 텍스트는 '현지화된 이름' (널 체크 후 안전하게 접근)
                    title: Text(_localizedMajorNames![rawMajorKey] ?? rawMajorKey),
                    value: rawMajorKey, // RadioListTile의 값은 '원시 키'
                    groupValue: _selectedMajor,
                    onChanged: _handleMajorChanged,
                    activeColor: Colors.lightBlue,
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // 학과와 단과대학이 모두 선택되었을 때만 버튼 활성화
                onPressed: _selectedMajor != null && _selectedCollege != null ? _saveMajor : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                ),
                child: Text(localizations.translate('changeDepartment')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

