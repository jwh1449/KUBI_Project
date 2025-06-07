import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  String? _userName;
  String? _userCollegeRawKey; // 단과대학 raw key
  String? _userDepartmentRawKey; // 학과 raw key
  bool _isUserDataLoaded = false; // 사용자 데이터 로딩 상태 추가

  String? get userName => _userName;
  String? get userCollegeRawKey => _userCollegeRawKey;
  String? get userDepartmentRawKey => _userDepartmentRawKey;
  bool get isUserDataLoaded => _isUserDataLoaded;

  UserProvider() {
    _loadUserData();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        clearUserData();
      } else {
        _loadUserData(); // 로그인 상태가 변경되면 다시 로드
      }
    });
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>; // 데이터 맵으로 캐스팅

          _userName = data['fullName']; // Firestore의 'fullName' 필드와 일치해야 합니다.

          // ⭐️ 수정: Firestore에서 'college' 및 'department' 필드를 직접 읽습니다.
          // 이전에 사용하던 대체 필드명(userCollege, userDepartment, major) 로직을 제거하여
          // Firestore에 저장된 정확한 필드명을 사용하도록 강제합니다.
          _userCollegeRawKey = data['college'];
          _userDepartmentRawKey = data['department'];

          _isUserDataLoaded = true;
        } else {
          // 문서가 없으면 null로 설정
          _userName = null;
          _userCollegeRawKey = null;
          _userDepartmentRawKey = null;
          _isUserDataLoaded = true; // 문서가 없어도 로딩은 완료된 것으로 간주
        }
      } catch (e) {
        debugPrint("UserProvider: 사용자 데이터 로드 중 오류 발생: $e");
        // 오류 발생 시에도 null로 설정하고 로딩 완료로 간주하여 무한 로딩 방지
        _userName = null;
        _userCollegeRawKey = null;
        _userDepartmentRawKey = null;
        _isUserDataLoaded = true;
      }
    } else {
      // 사용자 없음 시 null로 설정하고 로딩 완료로 간주
      _userName = null;
      _userCollegeRawKey = null;
      _userDepartmentRawKey = null;
      _isUserDataLoaded = true;
    }
    notifyListeners();
  }

  Future<void> refreshUserDataFromFirestore() async {
    _isUserDataLoaded = false; // 로딩 상태 초기화
    notifyListeners(); // 로딩 상태 변경을 알림
    await _loadUserData(); // 데이터 다시 로드
  }

  void setUserData(String? name, String? collegeRawKey, String? departmentRawKey) {
    _userName = name;
    _userCollegeRawKey = collegeRawKey;
    _userDepartmentRawKey = departmentRawKey;
    _isUserDataLoaded = true; // 명시적으로 데이터 설정 시 로드 완료로 간주
    notifyListeners(); // 변경사항을 리스너에게 알립니다.
  }

  void updateUserData({String? newUserName, String? newCollegeRawKey, String? newDepartmentRawKey}) {
    bool changed = false;
    if (newUserName != null && _userName != newUserName) {
      _userName = newUserName;
      changed = true;
    }
    if (newCollegeRawKey != null && _userCollegeRawKey != newCollegeRawKey) {
      _userCollegeRawKey = newCollegeRawKey;
      changed = true;
    }
    if (newDepartmentRawKey != null && _userDepartmentRawKey != newDepartmentRawKey) {
      _userDepartmentRawKey = newDepartmentRawKey;
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  void clearUserData() {
    _userName = null;
    _userCollegeRawKey = null;
    _userDepartmentRawKey = null;
    _isUserDataLoaded = false;
    notifyListeners();
  }
}