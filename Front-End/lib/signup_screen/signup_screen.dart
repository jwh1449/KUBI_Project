// lib/login_screen/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_test/localization/app_localizations.dart';
import 'package:personal_test/home_screens/home_screen.dart';
import 'package:personal_test/signup_screen/email_verification_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final fullNameController = TextEditingController();
  bool agreeToTerms = false;
  bool agreeToPrivacy = false;
  bool consentMarketing = false;

  final countries = [
    'Ghana', 'नेपाल', 'Aotearoa', 'Danmark', 'Deutschland', 'ປະເທດລາວ',
    'Latvija', 'россия', 'România', 'Rwanda', 'Lietuva', 'malaysia', 'México',
    'Монгол', 'USA', 'မြန်မာ', 'Беларусь', 'Burundi', 'brasil', 'brunei',
    'المملكة العربية السعودية', 'قطر', 'ශ්‍රී ලංකාව', 'España', 'slovenski',
    'singapura', 'Argentina', 'Éire', 'Eesti', 'salvador', 'UK', 'australia',
    'uganda', "O'zbekiston", 'ایران', 'भारत', 'Indonesia', '日本', 'Zambia',
    '中国', 'Česko', 'Қазақстан', 'កម្ពុជា។', 'Canada', 'kenya', 'Кыргызстан',
    '한국',
    '台湾', 'точикистон', 'tanzania', 'ประเทศไทย', 'Türkiye', 'Perú', 'Polska',
    'France', 'Pilipinas', 'Magyarország', '香港'
  ];
  String? selectedCountry;

  // Firestore에 저장될 '원시 키'를 저장할 변수
  String? selectedCollegeRawKey;
  String? selectedDepartmentRawKey;

  // 단과대학 드롭다운에 표시될 아이템 목록 (allCollegeAndDepartmentInfo 맵의 키를 가져옵니다)
  List<String> get _collegeRawKeys => allCollegeAndDepartmentInfo.keys.toList();

  // 선택된 단과대학에 따라 학과 드롭다운에 표시될 아이템 목록을 동적으로 생성
  Map<String, List<String>> get _departmentsByCollegeRawKeys {
    Map<String, List<String>> result = {};
    allCollegeAndDepartmentInfo.forEach((collegeRawKey, collegeData) {
      if (collegeData.containsKey('departments') && collegeData['departments'] is List) {
        result[collegeRawKey] = (collegeData['departments'] as List)
            .map<String>((dept) => dept['original_key'] as String)
            .toList();
      }
    });
    return result;
  }

  // 드롭다운 아이템을 위한 현지화된 이름 맵
  Map<String, String>? _localizedCollegeDisplayNames;
  Map<String, String>? _localizedDepartmentDisplayNames;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocalizedNames();
      if(mounted) {
        setState(() {}); // 현지화된 이름 로드 후 UI 업데이트
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  // 로컬라이제이션 맵을 초기화하는 함수
  void _initializeLocalizedNames() {
    final localizations = AppLocalizations.of(context)!;
    _localizedCollegeDisplayNames = {};
    _localizedDepartmentDisplayNames = {};

    allCollegeAndDepartmentInfo.forEach((collegeRawKey, collegeData) {
      // 현지화된 이름이 없으면 rawCollegeKey의 밑줄을 공백으로 대체하여 표시
      _localizedCollegeDisplayNames![collegeRawKey] = collegeData[localizations.locale.languageCode] ?? collegeRawKey.replaceAll('_', ' ');
      if (collegeData.containsKey('departments') && collegeData['departments'] is List) {
        for (var deptData in collegeData['departments']) {
          if (deptData is Map<String, dynamic> && deptData.containsKey('original_key')) {
            // 현지화된 이름이 없으면 original_key의 밑줄을 공백으로 대체하여 표시
            _localizedDepartmentDisplayNames![deptData['original_key']] = deptData[localizations.locale.languageCode] ?? deptData['original_key'].replaceAll('_', ' ');
          }
        }
      }
    });
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password';
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,12}$')
        .hasMatch(value)) {
      return '8-12 chars, letters, nums, symbols';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  void _showAgreementDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue)),
        content: SingleChildScrollView(
          child: Text(content, style: const TextStyle(fontSize: 16)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.lightBlue)),
          ),
        ],
      ),
    );
  }

  // 필드를 초기화하는 새로운 메서드
  void _resetFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    fullNameController.clear();
    setState(() {
      agreeToTerms = false;
      agreeToPrivacy = false;
      consentMarketing = false;
      selectedCountry = null;
      selectedCollegeRawKey = null; // 원시 키 초기화
      selectedDepartmentRawKey = null; // 원시 키 초기화
    });
    _formKey.currentState?.reset(); // Form 위젯의 상태도 초기화
  }

  Future<void> _createUserAndNavigate() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!agreeToTerms || !agreeToPrivacy) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must agree to the Terms of Service and Privacy Policy.')),
        );
        return;
      }

      // 단과대학과 학과 선택 여부 확인
      if (selectedCollegeRawKey == null || selectedDepartmentRawKey == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both college and department.')),
        );
        return;
      }

      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Firebase Auth 계정 생성 성공 후 EmailVerificationScreen으로 이동
        // Firestore 저장은 EmailVerificationScreen에서 이메일 인증 완료 후에 수행됨
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful. Please verify your email.')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmailVerificationScreen(
                email: emailController.text.trim(),
                fullName: fullNameController.text.trim(),
                phoneNumber: phoneController.text.trim().isNotEmpty ? phoneController.text.trim() : null,
                country: selectedCountry,
                college: selectedCollegeRawKey,
                department: selectedDepartmentRawKey,
                agreeToTerms: agreeToTerms,
                agreeToPrivacy: agreeToPrivacy,
                consentMarketing: consentMarketing,
              ),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Sign-up failed. Please try again.';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'An account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is invalid.';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        const errorMessage = 'An unexpected error occurred. Please try again.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(errorMessage)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_localizedCollegeDisplayNames == null || _localizedDepartmentDisplayNames == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 60),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your name.' : null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email.';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: validatePassword,
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    obscureText: true,
                    validator: validateConfirmPassword,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (Optional)',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Select Country',
                    ),
                    value: selectedCountry,
                    hint: const Text('Select your country'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCountry = newValue;
                      });
                    },
                    items: countries.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) =>
                    value == null ? 'Please select your country.' : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Select College',
                    ),
                    value: selectedCollegeRawKey,
                    hint: const Text('Select your college'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCollegeRawKey = newValue;
                        selectedDepartmentRawKey = null; // 단과대학 변경 시 학과 초기화
                      });
                    },
                    items: _collegeRawKeys
                        .map((rawCollegeKey) =>
                        DropdownMenuItem<String>(
                            value: rawCollegeKey,
                            child: Text(_localizedCollegeDisplayNames![rawCollegeKey] ?? rawCollegeKey)
                        ))
                        .toList(),
                    validator: (value) =>
                    value == null ? 'Please select your college.' : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Select Department',
                    ),
                    value: selectedDepartmentRawKey,
                    hint: const Text('Select your department'),
                    items: selectedCollegeRawKey == null
                        ? []
                        : (_departmentsByCollegeRawKeys[selectedCollegeRawKey!] ?? [])
                        .map((rawDeptKey) =>
                        DropdownMenuItem<String>(
                            value: rawDeptKey,
                            child: Text(_localizedDepartmentDisplayNames![rawDeptKey] ?? rawDeptKey.replaceAll('_', ' '))
                        ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() => selectedDepartmentRawKey = newValue);
                    },
                    validator: (value) =>
                    value == null ? 'Please select your department.' : null,
                  ),
                  const SizedBox(height: 20),
                  CheckboxListTile(
                    title: GestureDetector(
                      onTap: () => _showAgreementDialog('Terms of Service', 'This Terms of Service (hereinafter referred to as "Terms") applies to all users of the KUBI app (hereinafter referred to as "the Service"). By using the Service, users are deemed to have agreed to the following Terms. Please read the Terms carefully before using the Service.\n\n'
                          '1. Service Provision\n'
                          'The Service provides a mobile application that supports foreign students with Korean pronunciation correction and Korean language learning. Users can utilize features such as pronunciation feedback, speech recognition, translation, and checking academic announcements through this Service.\n\n'
                          '2. Personal Data Processing and Use\n'
                          'The Service collects users personal information for the purpose of learning support and service improvement only. Information such as name, email address, country, and major provided by the user will be used to offer personalized learning and communication features. For more details, please refer to the [Privacy Policy].\n\n'
                          '3. Service Use Regulations\n'
                          'Users must only use the features of the Service for personal learning purposes.\n'
                          'It is prohibited to use features such as speech recognition, translation, and pronunciation feedback for illegal or inappropriate content.\n'
                          'All content provided by the Service (text, voice, images, etc.) is protected by copyright, and users may not reproduce or distribute it without permission.\n\n'
                          '4. Changes and Termination of Service\n'
                          'The Service is continually improved for user convenience. The service provider may add or modify features at any time, and is not responsible for any inconvenience caused. Additionally, the service provider may suspend the Service in compliance with legal obligations.\n\n'
                          '5. Limitation of Liability\n'
                          'While the Service strives to ensure the accuracy of the features provided, the Service is not responsible for issues arising from technical errors or network failures. Users bear all risks associated with using the Service.\n\n'
                          '6. User Behavior Regulations\n'
                          'Users must not engage in the following actions while using the Service:\n'
                          '• Sharing inappropriate content, such as defamation or offensive language.\n'
                          '• Using the Service for illegal purposes.\n'
                          '• Inserting malicious programs or codes that may affect the Service\'s operation.\n\n'
                          '7. Changes to Terms\n'
                          'The Terms of Service may be amended to improve the Service or to meet legal requirements. Changes to the Terms will be notified to users through in-app notifications or emails, and users will be deemed to have agreed to the amended Terms.\n\n'
                          '8. Legal Disputes\n'
                          'Any disputes related to these Terms will be governed by Korean law, and in case of a dispute, the Seoul Central District Court will be the court of first instance.',
                      ),
                      child: const Text('I agree to the Terms of Service', style: TextStyle(color: Colors.black)),
                    ),
                    value: agreeToTerms,
                    onChanged: (bool? newValue) {
                      setState(() {
                        agreeToTerms = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.lightBlue,
                    secondary: TextButton(
                      onPressed: () => _showAgreementDialog(
                        'Terms of Service',
                        'This Terms of Service (hereinafter referred to as "Terms") applies to all users of the KUBI app (hereinafter referred to as "the Service"). By using the Service, users are deemed to have agreed to the following Terms. Please read the Terms carefully before using the Service.\n\n'
                            '1. Service Provision\n'
                            'The Service provides a mobile application that supports foreign students with Korean pronunciation correction and Korean language learning. Users can utilize features such as pronunciation feedback, speech recognition, translation, and checking academic announcements through this Service.\n\n'
                            '2. Personal Data Processing and Use\n'
                            'The Service collects users personal information for the purpose of learning support and service improvement only. Information such as name, email address, country, and major provided by the user will be used to offer personalized learning and communication features. For more details, please refer to the [Privacy Policy].\n\n'
                            '3. Service Use Regulations\n'
                            'Users must only use the features of the Service for personal learning purposes.\n'
                            'It is prohibited to use features such as speech recognition, translation, and pronunciation feedback for illegal or inappropriate content.\n'
                            'All content provided by the Service (text, voice, images, etc.) is protected by copyright, and users may not reproduce or distribute it without permission.\n\n'
                            '4. Changes and Termination of Service\n'
                            'The Service is continually improved for user convenience. The service provider may add or modify features at any time, and is not responsible for any inconvenience caused. Additionally, the service provider may suspend the Service in compliance with legal obligations.\n\n'
                            '5. Limitation of Liability\n'
                            'While the Service strives to ensure the accuracy of the features provided, the Service is not responsible for issues arising from technical errors or network failures. Users bear all risks associated with using the Service.\n\n'
                            '6. User Behavior Regulations\n'
                            'Users must not engage in the following actions while using the Service:\n'
                            '• Sharing inappropriate content, such as defamation or offensive language.\n'
                            '• Using the Service for illegal purposes.\n'
                            '• Inserting malicious programs or codes that may affect the Service\'s operation.\n\n'
                            '7. Changes to Terms\n'
                            'The Terms of Service may be amended to improve the Service or to meet legal requirements. Changes to the Terms will be notified to users through in-app notifications or emails, and users will be deemed to have agreed to the amended Terms.\n\n'
                            '8. Legal Disputes\n'
                            'Any disputes related to these Terms will be governed by Korean law, and in case of a dispute, the Seoul Central District Court will be the court of first instance.',
                      ),
                      child: const Text('View', style: TextStyle(color: Colors.lightBlue)),
                    ),
                  ),
                  CheckboxListTile(
                    title: GestureDetector(
                      onTap: () => _showAgreementDialog('Privacy Policy', 'KUBI app collects and processes users\' personal information to provide Korean language learning and pronunciation correction services to foreign students. Protecting users\' personal information is of utmost importance, and this Privacy Policy provides information on how users\' personal data is collected, used, and protected. By using the app, users are deemed to have agreed to this policy.\n\n1. Personal Information Collected\n- During Registration: User’s name, email address, country, major, etc.\n- While Using the Service: Voice data and text data collected during pronunciation correction, speech recognition, and translation services.\n- Device Information: Device type, operating system, app version, etc.\n\n2. Purposes of Using Personal Information\n- Providing Services: Providing pronunciation correction, speech recognition, translation functions, and academic announcements, etc.\n- Personalized Learning Experience: Providing tailored learning materials and feedback based on the user’s major, country, and learning preferences.\n- Service Improvement: Analyzing user experience to improve app performance and functionality.\n- Compliance with Legal Obligations: Processing personal data in accordance with legal requirements and regulations.\n\n3. Retention and Use Period of Personal Information\n- Personal information is retained until the user either withdraws from the service or deletes the app.\n- However, personal information may be retained for a certain period if required by legal obligations.\n\n4. Provision of Personal Information to Third Parties\n- Personal information will not be provided to third parties under normal circumstances. However, it may be provided when required by law.\n\n5. Ensuring the Security of Personal Information\n- Data Encryption: Encryption technology is used to securely protect personal information.\n- Access Control: Access to personal information is limited to authorized employees and individuals with the necessary permissions.\n\n6. User Rights\n- Access and Correction: Users can access and correct their personal information at any time.\n- Withdrawal of Consent: Users can withdraw consent for personal data processing at any time. However, withdrawal may limit access to some features of the service.\n- Deletion Requests: Users can request the deletion of their personal information, and the data will be promptly deleted upon request.\n\n7. Changes to Privacy Policy\n- This Privacy Policy may be updated to improve the service or comply with legal requirements. Users will be notified of any changes through in-app notifications or email.'),
                      child: const Text('I agree to the Privacy Policy', style: TextStyle(color: Colors.black)),
                    ),
                    value: agreeToPrivacy,
                    onChanged: (bool? newValue) {
                      setState(() {
                        agreeToPrivacy = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.lightBlue,
                    secondary: TextButton(
                      onPressed: () => _showAgreementDialog(
                        'Privacy Policy',
                        '''
KUBI app collects and processes users' personal information to provide Korean language learning and pronunciation correction services to foreign students. Protecting users' personal information is of utmost importance, and this Privacy Policy provides information on how users' personal data is collected, used, and protected. By using the app, users are deemed to have agreed to this policy.

1. Personal Information Collected
- During Registration: User’s name, email address, country, major, etc.
- While Using the Service: Voice data and text data collected during pronunciation correction, speech recognition, and translation services.
- Device Information: Device type, operating system, app version, etc.

2. Purposes of Using Personal Information
- Providing Services: Providing pronunciation correction, speech recognition, translation functions, and academic announcements, etc.
- Personalized Learning Experience: Providing tailored learning materials and feedback based on the user’s major, country, and learning preferences.
- Service Improvement: Analyzing user experience to improve app performance and functionality.
- Compliance with Legal Obligations: Processing personal data in accordance with legal requirements and regulations.

3. Retention and Use Period of Personal Information
- Personal information is retained until the user either withdraws from the service or deletes the app.
- However, personal information may be retained for a certain period if required by legal obligations.

4. Provision of Personal Information to Third Parties
- Personal information will not be provided to third parties under normal circumstances. However, it may be provided when required by law.

5. Ensuring the Security of Personal Information
- Data Encryption: Encryption technology is used to securely protect personal information.
- Access Control: Access to personal information is limited to authorized employees and individuals with the necessary permissions.

6. User Rights
- Access and Correction: Users can access and correct their personal information at any time.
- Withdrawal of Consent: Users can withdraw consent for personal data processing at any time. However, withdrawal may limit access to some features of the service.
- Deletion Requests: Users can request the deletion of their personal information, and the data will be promptly deleted upon request.

7. Changes to Privacy Policy
- This Privacy Policy may be updated to improve the service or comply with legal requirements. Users will be notified of any changes through in-app notifications or email.
''',
                      ),
                      child: const Text('View', style: TextStyle(color: Colors.lightBlue)),
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text('I agree to receive marketing messages (optional)', style: TextStyle(color: Colors.black)),
                    value: consentMarketing,
                    onChanged: (bool? newValue) {
                      setState(() {
                        consentMarketing = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.lightBlue,
                    secondary: TextButton(
                      onPressed: () {
                        _showAgreementDialog(
                          'Marketing Consent',
                          '''
KUBI app may collect and use your personal information for marketing purposes. This includes sending promotional materials, updates about the app, new features, and other related content to improve your experience.

1. Purpose of Marketing Data Collection
- Sending promotional emails, notifications, and app-related updates.
- Providing offers and information related to services, events, and news that may be of interest to you.
- Improving personalized marketing efforts based on your preferences and usage patterns within the app.

2. Types of Marketing Data Collected
- Contact Information: Email address, phone number, and other means of communication.
- Usage Data: Your activity within the app, including features used, preferences, and behavior.
- Demographic Information: Information suchs as age, location, and language preferences.

3. How Marketing Data is Used
- Promotional Emails/Notifications: We may send emails or push notifications to inform you about special offers, new updates, or upcoming features of the app.
- Personalized Marketing: Based on your app usage and preferences, we may personalize offers and notifications to suit your interests.

4. Opting Out of Marketing Communications
- You have the right to opt out of receiving marketing communications at any time. You can unsubscribe from emails or disable push notifications through the app's settings.
- If you opt out, you may still receive important service-related communications, suchs as updates on terms or system alerts.

5. Sharing of Marketing Data with Third Parties
- Your marketing data will not be shared with third parties without your consent, except when required by law.

6. Retention of Marketing Data
- Your marketing data will be retained for as long as you remain a user of the app, or until you opt out of marketing communications. After opting out, we will stop using your data for marketing purposes but may retain it for service-related needs.

7. Changes to Marketing Data Use
- Any changes to how your marketing data is collected or used will be communicated through in-app notifications or emails.
''',
                        );
                      },
                      child: const Text('View', style: TextStyle(color: Colors.lightBlue)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedCollegeRawKey != null && selectedDepartmentRawKey != null ? _createUserAndNavigate : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}