// lib/screens/account_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personal_test/settings_screens/account_settings/change_password_screen.dart';
import 'package:personal_test/settings_screens/account_settings/change_major_screen.dart';
import 'package:personal_test/localization/app_localizations.dart';
import 'package:personal_test/widget/user_provider.dart';

// 계정 관리 창
class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  AccountSettingsScreenState createState() => AccountSettingsScreenState();
}

class AccountSettingsScreenState extends State<AccountSettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!userProvider.isUserDataLoaded) {
      userProvider.refreshUserDataFromFirestore().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } else {
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);

    if (_isLoading || !userProvider.isUserDataLoaded) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: Text(localizations.translate('accountManagement'), style: const TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Transform.translate(
          offset: const Offset(-8.0, 0),
          child: Text(localizations.translate('accountManagement'), style: const TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: double.infinity,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.lightBlue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.lightBlue,
              tabs: [
                Tab(text: localizations.translate('changePassword')),
                Tab(text: localizations.translate('changeMajor')),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            const ChangePasswordScreen(),
            // ⭐️ initialMajor와 initialCollege를 ChangeMajorScreen으로 전달
            ChangeMajorScreen(
              initialMajor: userProvider.userDepartmentRawKey,
              initialCollege: userProvider.userCollegeRawKey,
            ),
          ],
        ),
      ),
    );
  }
}