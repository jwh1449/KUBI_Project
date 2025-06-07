// lib/localization/app_localizations.dart
import 'package:flutter/material.dart';

// AppLocalizations 클래스 (일반적으로 flutter gen-l10n으로 자동 생성됨)
// 여기서는 예시를 위해 간소화된 형태를 보여줍니다.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // LocalizationsDelegate는 보통 자동 생성되지만, 여기서는 예시를 위해 포함합니다.
  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  // ==== 번역 문자열 맵 정의 ====
  // 각 언어 코드(예: 'en', 'ko', 'zh')를 키로 하고, 해당 언어의 번역 맵을 값으로 가집니다.
  // 플레이스홀더는 {variableName} 형식으로 사용합니다.
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': { // 영어 (en) 번역
      // home
      "appTitle": "KUBI",
      "toggleLanguage": "Toggle Language",
      "settings": "Settings",
      "helloUser": "{userName}",
      "college": "{collegeName}",
      "department": "{departmentName}",
      "recordVoicePrompt": "Please record and register your voice.",
      "voiceRegistered": "Your voice has been registered.",
      "currentVoiceFile": "Current Voice File",
      "recordingStarted": "Recording started.",
      "recordingError": "Recording error: {error}",
      "voiceRecordedSuccessfully": "Your voice has been successfully registered!",
      "failedToRecordVoice": "Failed to record voice.",
      "errorStoppingRecording": "Error stopping recording: {error}",
      "exitTitle": "Exit App",
      "exitContent": "Are you sure you want to exit the app?",
      "no": "No",
      "yes": "Yes",
      "home": "Home",
      "announcements": "Announcements",
      "cafeteriaInfo": "Cafeteria Info",
      "pronunciationPractice": "Pronunciation Practice",
      "clubInfo": "Club Info",
      "map": "Map",
      "communicationTitle": "Communication",
      "practice": "Practice",
      "microphonePermissionNeeded": "Microphone Permission Needed",
      "microphonePermissionContent": "Microphone permission is required for pronunciation evaluation. Please enable it in settings.",
      "openSettings": "Open Settings",
      "cancel": "Cancel",
      "recordVoiceNeeded": "Voice Registration Required",
      "recordVoiceDialogContent": "Please register your voice for accurate pronunciation evaluation.",
      "startRecording": "Start Recording",
      "doLater": "Do Later",
      "reviewVoiceRecording": "Review Voice Recording",
      "playRecordedVoice": "Listen to your recorded voice.",
      "listen": "Listen",
      "retakeQuestion": "Would you like to re-record?",
      "retake": "Re-record",
      "useThisVoice": "Use This Voice",
      "audioPlaybackError": "Audio playback error: {error}",
      "voiceSavedSuccessfully": "Voice successfully saved.",
      "reRecordingStarted": "Re-recording started.",
      "listenRegisteredVoice": "Listen to Registered Voice",
      "reRecordingInitiated": "Re-recording initiated.",
      "voiceRecordingRequired": "You must record your voice first to use this feature.",
      "voiceRecordingRequiredWithPrompt": "Voice recording is required for this feature. Please record your voice.",
      "deleteVoiceFile": "Delete Voice File",
      "voiceFileDeleted": "Voice file deleted successfully.",
      "microphonePermissionGranted": "Microphone permission granted.",
      "microphonePermissionPermanentlyDenied": "Microphone permission has been permanently denied. Please allow it in settings.",
      "microphonePermissionDenied": "Microphone permission denied. Please enable it in settings.",
      "recordVoiceExplain": "We recommend recording for at least 60 seconds.",
      "stopRecording": "Stop Recording",
      "readyForVoiceFeatures": "Your voice has been successfully registered. You are now ready to use voice features.",
      "listenVoice": "Listen to Voice",
      "reRecordVoice": "Re-record Voice",
      "voiceRegistrationNeededTitle": "Voice Registration Needed",
      "voiceRegistrationNeededContent": "To use features like pronunciation practice and communication, please register your voice first. Would you like to record it now?",
      "startRecordingButton": "Start Recording Now",
      "doLaterButton": "Do Later",
      "voiceRecording": "Voice Recording",
      'stopPlaying':"Stop Playing",
      'firstRecordingCompleted': 'First recording completed. From now on, recorded voices will be saved.',
      'exampleTextTitle' : "Example text",
      'pleaseStopRecordingFirst' : "Cannot close window while recording.",



      // 공지사항
      'all': 'All',
      'samcheok_dogye': 'Samcheok/Dogye',
      'covid_response': 'COVID-19 Response',
      'searchAnnouncements': 'Search announcements...',
      'filterByCategory': 'Filter by Category',
      'failedToLoadAnnouncements': 'Failed to load announcements: {errorMessage}', // 플레이스홀더 변경: %s -> {errorMessage}
      'networkError': 'A network error occurred. Please try again.',
      'couldNotLoadAnnouncements': 'Could not load announcements.',
      'tryAgain': 'Try Again',
      'noAnnouncementsFound': 'No announcements found',
      "announcementDetails": "Announcement Details",
      'loadMore' :"Load More",

      //동아리 정보
      "clubInformation": "Club Information",
      "noName": "No Name",
      "noCategory": "No Category",
      "noDescription": "No Description",
      "noDescriptionZh": "无说明",
      "failedToLoadClubInfo": "Failed to load club information:",
      "unableToLoadClubInfo": "Unable to load club information.",
      "noRegisteredClubInfo": "No registered club information available.",
      "availableClubs": "Available Clubs",
      "category": "Category",

      //식단표
      "weeklyMenu": "Weekly Menu",
      "studentCafeteria": "Student Cafeteria",
      "dormCafeteria": "Dorm Cafeteria",

      //발음 연습 고르기
      "recordingStartError": "Error starting recording: ",
      "recordingStopped": "Recording stopped.",
      "noRecordingToStop": "No recording to stop.",
      "recordingStopError": "Error stopping recording: ",
      "selectPracticeSentence": "Select Practice Sentence",
      "enterPracticeSentence": "Enter practice sentence",
      "sentenceHint": "Type your sentence here, or choose from below",
      "recordedFile": "Recorded file",
      "playingRecordedAudio": "Playing recorded audio...",
      "playRecordedAudio": "Play Recorded Audio",
      "startPractice": "Start Practice",
      "orChoosePredefined": "Or choose a predefined sentence:",
      "predefinedSentence1": "안녕하세요, 오늘 어떠세요?",
      "predefinedSentence2": "저는 플러터 개발을 배우고 있습니다.",
      "predefinedSentence3": "다시 한번 말씀해주시겠어요?",
      "predefinedSentence4": "오늘 날씨가 매우 좋네요.",
      "predefinedSentence5": "도와주셔서 감사합니다.",
      "defaultPracticeSentence": "연습하면 완벽해진다.",

      //발음 연습
      "pronunciation_practice": "Pronunciation Practice",
      "correct_sentence": "Correct Sentence:",
      "press_mic_to_speak": "Press the microphone to speak.",
      "read_sentence_above": "Read the sentence above.",
      "generating_tts_correct_sentence": "Generating TTS for the correct sentence...",
      "correct_sentence_audio_generated": "Correct sentence audio generated.",
      "error_generating_audio": "Error generating audio:",
      "listening": "Listening...",
      "speak_sentence_now": "Speak the sentence now.",
      "recording_error": "Recording error:",
      "error_starting_recording": "Error starting recording:",
      "recording_complete_sending_to_server": "Recording complete. Sending to server...",
      "speech_recognition_failed": "Speech recognition failed.",
      "tts_attempting_user_recording_mfcc": "TTS: Attempting to generate TTS for correct sentence with user's recording (MFCC base audio):",
      "tts_no_user_recording_default_mfcc": "TTS: No user recording path, attempting to generate TTS with default speaker (MFCC base audio).",
      "error_calculating_mfcc_similarity": "Error calculating MFCC similarity:",
      "recognized": "Recognized:",
      "cer": "CER(accuracy)",
      "mfccSimilarity": "MFCC(Similarity)",
      "mfcc_similarity_error": "MFCC Similarity: Error -",
      "mfcc_similarity_na_audio_missing": "MFCC Similarity: N/A (Audio path missing for comparison)",
      "debug_mfcc_comparison_failed": "DEBUG: MFCC similarity calculation failed: TTS file or user recording file path is ultimately invalid.",
      "speech_recognition_failed_try_again": "Speech recognition failed. Please try again.",
      "error_during_speech_recognition": "An error occurred during speech recognition:",
      "no_recording_to_play": "No recording to play. Please record your voice first.",
      "failed_to_play_local_audio": "Failed to play local audio:",
      "failed_to_play_recording": "Failed to play recording:",
      "practice_result_saved": "Practice result saved:",
      "no_text_to_speak": "No text to speak.",
      "no_recognized_text_to_display_result": "No recognized text to display result.",
      "view_my_recordings": "View My Recordings",
      "listen_correct_sentence_tts_your_voice": "Listen to the correct sentence (TTS with your voice)",
      "pause_recording": "Pause recording",
      "play_your_recording": "Play your recording",
      "viewresult": "View Result",
      "listenAndPractice": "Press the speaker icon to listen to the cloned TTS pronunciation, then press the microphone to speak.",
      "personalizedAudioNotReady": "Cloned TTS is not ready. Please press the speaker button first.",
      "preparingPersonalizedAudio": "Preparing cloned TTS...",
      "personalizedAudioReady": "Cloned TTS is ready!",
      "speakNow": "Speak now.",
      "analyzingPronunciation": "Recording complete. Analyzing your pronunciation...",
      "correctSentence": "Correct Sentence:",
      "listenToCorrectSentence": "Listen to the correct sentence",
      "noVoiceFileFoundForPersonalization": "User voice file not found for personalization.",
      "cannotProceedWithoutVoice": "Cannot proceed without user voice file.",
      "userVoiceFileDoesNotExist": "User voice file does not exist.",
      "ttsServerError": "TTS server error ({statusCode}): {error}",
      "failedToPrepareAudio": "Failed to prepare personalized audio. Cannot proceed with practice.",
      "personalizedAudioBeingPrepared": "Personalized pronunciation audio is being prepared. Please wait.",
      "personalizedAudioNotFoundRecreating": "Personalized audio file not found. Re-creating...",
      "playPersonalizedAudioError": "Failed to play personalized pronunciation: {error}",
      "playingPersonalizedAudio": "Playing cloned TTS... Listen carefully!",
      "personalizedAudioNotReadyToRecord": "Personalized audio is not ready. Please play it first to generate it.",
      "processingRequest": "Processing your request. Please wait.",
      "errorStartingRecording": "Error starting recording: {error}",
      "speechRecognitionFailed": "Speech recognition failed.",
      "error": "Error: {error}",
      "mfccAudioMissing": "N/A (Audio files missing or invalid.)",
      "speechRecognitionFailedTryAgain": "Speech recognition failed. Please try again.",
      "speechRecognitionError": "Speech recognition error: {error}",
      "errorDuringSpeechRecognition": "An error occurred during speech recognition.",
      "noValidRecordingToPlay": "No valid recording to play. Please record your voice first.",
      "failedToPlayRecording": "Failed to play recording: {error}",
      "pauseYourRecording": "Pause your recording",
      "playYourRecording": "Play your recording",
      "viewResult": "View Result",
      "noRecognizedText": "No recognized text to display result.",
      "pressMicToSpeak": "Press the microphone to speak.",
      "guideListenAndSpeak": "Press the speaker icon to listen to the personalized pronunciation, then press the microphone to speak.",
      "analysisCompleteProceedToResult" : "Pronunciation analysis complete. check your score!",

      //발음 연습 결과
      'pronunciationResult': 'Pronunciation Result',
      'yourSpeech': 'Your Speech:',
      'aiFeedback': 'AI Feedback:',
      "similarityScore": "Similarity Score", // <--- Add this line
      'excellentPronunciationFeedback': 'Excellent! That was almost perfect pronunciation. The next goal is perfect accuracy!',
      'veryGoodPronunciationFeedback': 'Very good! You spoke clearly and confidently. Try to focus on reducing the small errors.',
      'goodJobPronunciationFeedback': 'Good job. It seems like you need more practice with pronunciation in certain parts. Check out the types of errors.',
      'morePracticeNeededFeedback': 'More practice is needed. Understand each error type and try again slowly.',
      'omittedAndAddedWordsFeedback': '\n\nYou have omitted some words and added unnecessary words. Please listen to the original sentence more carefully.',
      'omittedWordsFeedback': '\n\nYou missed some important words. Listen to the original sentence again and check for the words you missed.',
      'addedWordsFeedback': '\n\nYou added unnecessary words. Try practicing pronouncing them concisely.',
      'cerCharacterErrorRate': 'CER (Character Error Rate):',
      'accuracy': 'Accuracy:',
      'missingWords': 'Missing Words :',
      'deletionLegend': 'Delete (it\'s in the answer but I didn\'t say it)',
      'noDeletedWords': 'No words deleted.',
      'extraWords': 'Extra Words :',
      'insertionLegend': 'Insert (not in the answer but added)',
      'noAddedWords': 'No words added.',
      'backToPractice': 'Back to Practice',
      "pronunciationResultTitle": "Pronunciation Result",
      "originalSentence": "Original Sentence:",
      "yourRecognition": "Your Recognition:",
      "accuracyScores": "Accuracy Scores:",
      "cerCharacterErrorRate": "CER (accuracy): {cerValue}",
      "noScoreInformation": "No score information available.",
      "practiceAgain": "Practice Again",
      "mfcc_Similarity": "MFCC(Similarity): {mfccSimilarityScore}",

      //소통하기
      "yourLanguage": "Your Language",
      "tapMicAndSpeak": "Tap the microphone and speak",
      "translatedKorean": "Translated Korean",
      "translationWillAppear": "Translation will appear here.",
      "replayTranslatedText": "Replay translated text",
      "startSpeakingInYourLanguage": "Start speaking in your language...",
      "failedToStartRecording": "Failed to start recording: {errorMessage}",
      "noAudioRecorded": "No audio was recorded.",
      "processingAudio": "Processing audio...",
      "translationFailed": "Translation failed.",
      "translationApiError": "Translation API error: Status {statusCode}, Response: {responseBody}",
      "translationNetworkError": "Translation network error: {errorMessage}",
      "sttApiError": "STT API error: Status {statusCode}",
      "sttNetworkError": "STT network error: {errorMessage}",
      "ttsApiError": "TTS API error: Status {statusCode}",
      "ttsNetworkError": "TTS network error: {errorMessage}",
      "communicationError": "An error occurred during communication: {errorMessage}",
      "playingTranslatedText": "Playing translated text...",
      "noTranslatedTextToPlay": "No translated text to play.",
      "english": "English",
      "chinese": "Chinese",
      "korean": "Korean",
      "noAudioRecordedMessage": "Audio recording is required. Please record your voice.",

      //계정 관리
      'accountManagement': 'Account Management',
      'changePassword': 'Change password',
      'changeMajor': 'Change major',

      //학과 변경 (여기 키들은 ChangeMajorScreen.dart에서 사용하는 '원시 키'와 일치해야 합니다.)
      "changeMajorTitle": "Change Major",
      "noUserLoggedIn": "No user logged in.",
      "selectCollegeAndDepartment": "Please select both college and department.",
      "accountInfoUpdatedSuccessfully": "Account information updated successfully.",
      "accountInfoUpdateFailed": "Failed to update account information.",
      "editPersonalInfo": "Edit Personal Info",
      "fullName": "Full Name",
      "pleaseSelectCollege": "Please select a college.",
      "pleaseSelectDepartment": "Please select a department.",
      "saveChanges": "Save Changes",


      // 아래 키들은 '원시 키'로, translate 메서드에서 사용됩니다.
      'college_engineering': 'College of Engineering',
      'dept_green_energy_engineering': 'Department of Green Energy Engineering',
      'dept_electronic_ai_systems_engineering': 'Department of Electronic and AI Systems Engineering',
      'dept_mechanical_engineering': 'Department of Mechanical Engineering',
      'dept_electrical_engineering': 'Department of Electrical Engineering',
      'dept_construction_convergence': 'Department of Construction Convergence',
      'college_humanities_social_design_sports': 'Humanities and Social Sciences, Design Sports College',
      'dept_global_talent': 'Department of Global Talent',
      'dept_human_sports': 'Department of Human Sports',
      'dept_multi_design': 'Department of Multi-Design',
      'dept_social_welfare': 'Department of Social Welfare',
      'dept_life_design': 'Department of Life Design',
      'dept_early_childhood_education': 'Department of Early Childhood Education',
      'college_natural_science': 'College of Natural Science', // 예시로 추가
      'dept_computer_science': 'Department of Computer Science', // 예시로 추가
      'college_arts_physical_education': 'College of Arts and Physical Education', // 예시로 추가
      'dept_korean_literature': 'Department of Korean Literature', // 예시로 추가
      'departmentChanged': 'Department changed to \'{major}\' and College to \'{college}\'.', // 플레이스홀더 변경: {department} -> {major}
      'failedToSaveDepartmentCollege': 'Failed to save department and college information. Please try again.',
      'pleaseSelectDepartmentCollege': 'Please select a department and college.',
      'changeDepartment': 'Change Department',

      //비밀번호 변경
      'userInformationNotFound': 'User information not found.',
      'passwordChangedSuccessfully': 'Password changed successfully.',
      'newPasswordMismatch': 'New password and confirmation password do not match.',
      'currentPasswordMismatch': 'Current password does not match.',
      'userNotFoundLoginAgain': 'User not found. Please log in again.',
      'authenticationErrorOccurred': 'Authentication error occurred. Please try again.',
      'weakPassword': 'Password is too weak. Please enter at least 6 characters.',
      'failedToChangePassword': 'Failed to change password. Please try again.',
      'currentPassword': 'Current Password',
      'enterCurrentPassword': 'Please enter your current password.',
      'newPassword': 'New Password',
      'enterNewPassword': 'Please enter a new password.',
      'passwordLengthRequirement': 'Password must be at least 6 characters long.',
      'confirmNewPassword': 'Confirm New Password',
      'reEnterNewPassword': 'Please re-enter the new password.',
      'changePasswordButton': 'Change Password',

      // 이용 제한 설정
      "inquiryFrom": "Inquiry from",
      "unknownUser": "Unknown User",
      'customerSupport': 'Customer Support',
      'kubiAppInquiry': 'KUBI App Inquiry',
      'imageAttachedSeparately': '\n\n[Image attached separately in email app]',
      'inquiryPreparationMessage': 'Your inquiry is being prepared in your email app.',
      'couldNotLaunchEmailApp': 'Could not launch email app.',
      'galleryPermissionNeeded': 'Gallery access permission is required. Please allow permission in settings.',
      'enterYourInquiry': 'Enter your inquiry.',
      'attachScreenshot': 'Attach Screenshot',
      'attachedScreenshotPreview': 'Attached Screenshot Preview:',
      'sendInquiry': 'Send Inquiry',
      'viewFaq': 'View Frequently Asked Questions (FAQ)',
      'usageLimitations': 'Usage Limitations',
      'excessiveRequestsLimitationTitle': '📊 Excessive Requests Limitation',
      'excessiveRequestsLimitationDescription': 'If excessive requests are made to the server, access to the service may be restricted for a period. Please avoid generating excessive traffic.',
      'pronunciationCorrectionServiceLimitationTitle': '🛑 Pronunciation Correction Service Limitation',
      'pronunciationCorrectionServiceLimitationDescription': 'You can receive pronunciation correction up to 5 times a day. If exceeded, you will need to wait until the next day.',
      'personalInformationProtectionLimitationTitle': '🔒 Personal Information Protection Limitation',
      'personalInformationProtectionLimitationDescription': 'If incorrect information is entered or privacy policies are violated, access to the app may be restricted. Please adhere to the terms of service.',
      'inappropriateContentBlockingTitle': '🚫 Inappropriate Content Blocking',
      'inappropriateContentBlockingDescription': 'If abusive language or inappropriate content is entered, access to the service may be restricted.',
      'serviceAvailabilityLimitationTitle': '⚠️ Service Availability Limitation',
      'serviceAvailabilityLimitationDescription': 'Some services (e.g., pronunciation correction) are only available during certain hours.',
      'customerInquiryContact':"Customer Inquiry\nEmail: rlagustj3325@gmail.com\nPhone Number: 010-9039-3862",
      //앱 버전
      'appInformation': 'App Information',
      'appVersion': 'App Version',
      'version': 'Version {versionNumber}', // 플레이스홀더 변경: %s -> {versionNumber}

      //이용, 정보, 마케팅
      "viewMarketingConsent": "View Marketing Consent",
      'consentSettings': 'Consent Settings',
      'marketingConsentChanged': 'Marketing information reception consent setting has been changed.',
      'ok': 'OK',
      'pleaseReviewConsentSettings': 'Please review your consent settings:',
      'termsOfServiceTitle': 'Terms of Service',
      'termsOfServiceDetails': '''This Terms of Service (hereinafter referred to as "Terms") applies to all users of the KUBI app (hereinafter referred to as "the Service"). By using the Service, users are deemed to have agreed to the following Terms. Please read the Terms carefully before using the Service.

1. Service Provision
The Service provides a mobile application that supports foreign students with Korean pronunciation correction and Korean language learning. Users can utilize features such as pronunciation feedback, speech recognition, translation, and checking academic announcements through this Service.

2. Personal Data Processing and Use
The Service collects users personal information for the purpose of learning support and service improvement only. Information such as name, email address, country, and major provided by the user will be used to offer personalized learning and communication features. For more details, please refer to the [Privacy Policy].

3. Service Use Regulations
Users must only use the features of the Service for personal learning purposes.
It is prohibited to use features such as speech recognition, translation, and pronunciation feedback for illegal or inappropriate content.
All content provided by the Service (text, voice, images, etc.) is protected by copyright, and users may not reproduce or distribute it without permission.

4. Changes and Termination of Service
The Service is continually improved for user convenience. The service provider may add or modify features at any time, and is not responsible for any inconvenience caused. Additionally, the service provider may suspend the Service in compliance with legal obligations.

5. Limitation of Liability
While the Service strives to ensure the accuracy of the features provided, the Service is not responsible for issues arising from technical errors or network failures. Users bear all risks associated with using the Service.

6. User Behavior Regulations
Users must not engage in the following actions while using the Service:
• Sharing inappropriate content, such as defamation or offensive language.
• Using the Service for illegal purposes.
• Inserting malicious programs or codes that may affect the Service\'s operation.

7. Changes to Terms
The Terms of Service may be amended to improve the Service or to meet legal requirements. Changes to the Terms will be notified to users through in-app notifications or emails, and users will be deemed to have agreed to the amended Terms.

8. Legal Disputes
Any disputes related to these Terms will be governed by Korean law, and in case of a dispute, the Seoul Central District Court will be the court of first instance.''',
      'viewTermsOfService': 'View Terms of Service',
      'agreedToTerms': 'You have agreed to the Terms of Service.',
      'notAgreedToTerms': 'You have not agreed to the Terms of Service.',
      'privacyPolicyTitle': 'Privacy Policy',
      'privacyPolicyDetails': '''
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
      'viewPrivacyPolicy': 'View Privacy Policy',
      'agreedToPrivacy': 'You have agreed to the Privacy Policy.',
      'notAgreedToPrivacy': 'You have not agreed to the Privacy Policy.',
      'marketingConsentHeader': 'Marketing Consent',
      'marketingConsentDetails': '''
KUBI app may collect and use your personal information for marketing purposes. This includes sending promotional materials, updates about the app, new features, and other related content to improve your experience.

1. Purpose of Marketing Data Collection
- Sending promotional emails, notifications, and app-related updates.
- Providing offers and information related to services, events, and news that may be of interest to you.
- Improving personalized marketing efforts based on your preferences and usage patterns within the app.

2. Types of Marketing Data Collected
- Contact Information: Email address, phone number, and other means of communication.
- Usage Data: Your activity within the app, including features used, preferences, and behavior.
- Demographic Information: Information such as age, location, and language preferences.

3. How Marketing Data is Used
- Promotional Emails/Notifications: We may send emails or push notifications to inform you about special offers, new updates, or upcoming features of the app.
- Personalized Marketing: Based on your app usage and preferences, we may personalize offers and notifications to suit your interests.

4. Opting Out of Marketing Communications
- You have the right to opt out of receiving marketing communications at any time. You can unsubscribe from emails or disable push notifications through the app's settings.
- If you opt out, you may still receive important service-related communications, such as updates on terms or system alerts.

5. Sharing of Marketing Data with Third Parties
- Your marketing data will not be shared with third parties without your consent, except when required by law.

6. Retention of Marketing Data
- Your marketing data will be retained for as long as you remain a user of the app, or until you opt out of marketing communications. After opting out, we will stop using your data for marketing purposes but may retain it for service-related needs.

7. Changes to Marketing Data Use
- Any changes to how your marketing data is collected or used will be communicated through in-app notifications or emails.
      ''',
      'receiveUpdatesAndPromotionalOffers': 'Receive updates and promotional offers.',

      //로그아웃
      'logout': 'Log out',
      'logoutConfirmationTitle': 'Log out',
      'logoutConfirmationContent': 'Are you sure you want to log out?',
      'cancellation': 'Cancellation',
      'check': 'Check',
      "logoutSuccess": "You have been logged out successfully.",
      'loggedOutMessage': 'You have been logged out.',


      //설정 창
      "settingsScreenTitle": "Settings",
      "logoutDialogTitle": "Logout",
      "logoutDialogContent": "Are you sure you want to log out?",
      "noButton": "No",
      "yesButton": "Yes",
      "logoutFailedMessage": "Logout failed. Please try again.",
      "deleteAccountDialogTitle": "Delete Account",
      "deleteAccountDialogContent": "Are you sure you want to delete your account? All data will be deleted and cannot be recovered.",
      "accountDeletionComplete": "Account deletion complete.",
      "accountDeletionFailed": "Account deletion failed. Please try again.",
      "reloginRequiredForDeletion": "For security, you must log in again to delete your account.",
      "accountAndAppSettingsSection": "Account & App Settings",
      "accountManagementItem": "Account Management",
      "usageGuideSection": "Usage Guide",
      "appInfoItem": "App Info",
      "customerSupportItem": "Customer Support",
      "otherFeaturesSection": "Other Features",
      "consentSettingsItem": "Consent Settings",
      "logoutItem": "Logout",
      "deleteAccountItem": "Delete Account",
      "generalAccountDeletionError": "General Account Deletion Error",
      "accountDeletionError": "Account Deletion Error",
      "reauthenticateTitle": "Re-authentication Required",
      "reauthenticateContent": "For security purposes, please re-enter your password to continue.",
      "passwordLabel": "Password",
      "cancelButton": "Cancel",
      "confirmButton": "Confirm",
      "reauthenticationFailed": "Re-authentication failed.",
      "wrongPassword": "Wrong password. Please try again.",
      "invalidEmail": "Invalid email. Please check your email.",
      "reauthenticationMethodNotSupported": "Re-authentication for this login method is not yet supported.",
      "requiresRecentLogin": "This operation requires recent authentication. Please re-authenticate.",
      "reauthenticationFailedTryAgain": "Re-authentication failed. Please try again.",
      "guest": "Guest",
      "noCollegeSelected": "No College Selected",
      "noDepartmentSelected": "No Department Selected",
      "currentDepartment": "Current Department: {department}",
      "currentCollege": "Current College: {college}",
      "selectNewCollegeAndDepartment": "Select your new college and department:",
      "selectCollege": "Select College",

      //학교 지도
      "campusMap": "Campus Map",

      //소통해요
      "pronunciationPracticeTitle": "Pronunciation Practice",
      "viewMyRecordings": "View My Recordings",
      "listenCorrectSentence": "Listen to the correct sentence (TTS with your voice)",
      "pressMicToSpeak": "Press the microphone to speak.",
      "recordingCompleteSending": "Recording complete. Sending to server...",
      "speechRecognitionFailed": "Speech recognition failed. Please try again.",
      "speechRecognitionError": "Speech recognition error: ",
      "anErrorOccurredDuringSpeechRecognition": "An error occurred during speech recognition: ",
      "noRecordingToPlay": "No recording to play. Please record your voice first.",
      "failedToPlayRecording": "Failed to play recording: ",
      "pauseRecording": "Pause recording",
      "playYourRecording": "Play your recording",
      "noRecognizedText": "No recognized text to display result.",
      "noTextToSpeak": "No text to speak.",
      "generatingTTScorrectSentence": "Generating TTS for the correct sentence...",
      "correctSentenceAudioGenerated": "Correct sentence audio generated.",
      "errorGeneratingAudio": "Error generating audio: ",
      "cerLabel": "CER:",
      "mfccSimilarityLabel": "MFCC Similarity:",
      "notApplicable": "N/A",
      "mfccAudioPathMissing": "N/A (Audio path missing for comparison)",
      "enterTextInYourLanguage": "Enter text in your language",
      "typeHere": "Type here...",
      "recordMyVoice": "Record My Voice",
      "translateButton": "Translate",
      "speakButton": "Speak",
      "yourInputText": "Your Input Text",
      "translatedText": "Translated Text",
      "translating": "Translating...",
      "translationComplete": "Translation complete.",
      "noTranslatedTextToSpeak": "No translated text to speak.",
      "speaking": "Speaking...",
      "speechComplete": "Speech complete.",
      "ttsError": "TTS Error: ",
      "resultPlaceholder": "Your pronunciation evaluation result will appear here.",

      //지도
      'map1': 'Campus Map',
      'close': 'Close',
      'latitude': 'Latitude',
      'longitude': 'Longitude',

      //tts
      "ttsLoadingAlreadyInProgress": "Already loading. Returning existing Future.",
      "ttsDefaultSpeakerAudioLoadStart": "Default speaker audio file load started: ",
      "ttsDefaultSpeakerAudioLoadedTempPath": "Default speaker audio file loaded to temporary path: ",
      "ttsDefaultSpeakerAudioLoadError": "Serious error occurred while loading default speaker audio file: ",
      "ttsTextEmpty": "Text to convert is empty. Not sending request.",
      "ttsDefaultSpeakerAudioLoadingWait": "Waiting for default speaker audio loading to complete...",
      "ttsSpeakerAudioFileNotFound": "TTS server requires speaker_audio file, but default or specified speaker audio file is invalid. Path: ",
      "ttsAddingSpeakerAudioToRequest": "Adding speaker audio file: {filePath} to request.",
      "ttsMultipartRequestReady": "Preparing MultipartRequest to TTS server. Text: \"{text}\", speaker_audio file: {filePath}",
      "ttsServerUrl": "TTS Server URL: ",
      "ttsServerResponseStatusCode": "TTS Server Response Status Code: ",
      "ttsServerResponseContentType": "TTS Server Response Content-Type: ",
      "ttsAudioBytesReceivedDirectly": "Audio bytes received directly (Content-Type: {contentType})",
      "ttsServerResponseBodyJson": "TTS Server Response Body (JSON): ",
      "ttsBase64DecodedAudioReceived": "Audio bytes received after Base64 decoding",
      "ttsNoValidAudioContentInJson": "No valid audio content in TTS response JSON.",
      "ttsUnexpectedContentType": "TTS server returned unexpected Content-Type: ",
      "ttsGeneratedAudioFileSaved": "Generated TTS audio file saved: ",
      "ttsAudioPlaybackStart": "Audio playback started",
      "ttsServerError": "TTS server error: {statusCode} - {response}",
      "ttsCommunicationOrPlaybackFailedException": "TTS server communication or audio playback failed exception: ",
      "ttsCommunicationOrPlaybackFailed": "TTS server communication or audio playback failed: ",
      "ttsAudioPlaybackStopped": "Current TTS audio playback stopped.",
      "ttsTemporarySpeakerAudioFileDeleted": "Temporary speaker audio file deleted: ",
      "ttsTemporarySpeakerAudioFileDeleteError": "Error deleting temporary speaker audio file: ",
      "ttsGeneratedAudioFileDeleted": "Generated TTS audio file deleted: ",
      "ttsGeneratedAudioFileDeleteError": "Error deleting generated TTS audio file: ",

      //stt
      "microphonePermissionNotGranted": "Microphone permission not granted.",
      "recordingStartFailed": "Recording start failed: ",
      "recordingStoppedFilePathNotFound": "Recording stopped but file path not found.",
      "recordingStopOrAudioUploadFailed": "Recording stop or audio upload failed: ",
      "recognitionFailed": "Recognition failed",
      "sttServerError": "STT server error: ",
      "sttServerCommunicationFailed": "Failed to communicate with STT server: ",
    },
    'ko': { // 한국어 (ko) 번역
      //home
      "appTitle": "쿠비",
      "toggleLanguage": "언어 전환",
      "settings": "설정",
      "helloUser": "{userName}",
      "college": "{collegeName}",
      "department": "{departmentName}",
      "recordVoicePrompt": "목소리를 녹음하여 등록해주세요.",
      "voiceRegistered": "목소리가 등록되었습니다.",
      "currentVoiceFile": "현재 음성 파일",
      "recordingStarted": "녹음이 시작되었습니다.",
      "recordingError": "녹음 중 오류가 발생했습니다: {error}",
      "voiceRecordedSuccessfully": "목소리 녹음이 성공적으로 완료되었습니다!",
      "failedToRecordVoice": "목소리 녹음에 실패했습니다.",
      "errorStoppingRecording": "녹음 중지 중 오류가 발생했습니다: {error}",
      "exitTitle": "앱 종료",
      "exitContent": "앱을 종료하시겠습니까?",
      "no": "아니요",
      "yes": "예",
      "home": '홈',
      "announcements": "공지사항",
      "cafeteriaInfo": "식단 정보",
      "pronunciationPractice": "발음 연습",
      "clubInfo": "동아리 정보",
      "map": "지도",
      "communicationTitle": "소통",
      "practice": "연습",
      "microphonePermissionNeeded": "마이크 권한 필요",
      "microphonePermissionContent": "정확한 발음 평가를 위해 마이크 권한이 필요합니다. 설정에서 권한을 허용해주세요.",
      "openSettings": "설정 열기",
      "cancel": "취소",
      "recordVoiceNeeded": "목소리 등록 필요",
      "recordVoiceDialogContent": "정확한 발음 평가를 위해 목소리를 등록해주세요.",
      "startRecording": "녹음 시작",
      "doLater": "나중에 할게요",
      "reviewVoiceRecording": "목소리 녹음 검토",
      "playRecordedVoice": "녹음된 목소리를 들어보세요.",
      "listen": "듣기",
      "retakeQuestion": "다시 녹음하시겠습니까?",
      "retake": "다시 녹음",
      "useThisVoice": "이대로 사용",
      "audioPlaybackError": "오디오 재생 중 오류 발생: {error}",
      "voiceSavedSuccessfully": "목소리가 성공적으로 저장되었습니다.",
      "reRecordingStarted": "재녹음이 시작되었습니다.",
      "listenRegisteredVoice": "등록된 목소리 듣기",
      "reRecordingInitiated": "재녹음을 시작합니다.",
      "voiceRecordingRequired": "이 기능을 사용하려면 먼저 목소리를 녹음해야 합니다.",
      "voiceRecordingRequiredWithPrompt": "음성 녹음이 필요합니다. 음성 녹음을 해주세요.",
      "deleteVoiceFile": "음성 파일 삭제",
      "voiceFileDeleted": "음성 파일이 성공적으로 삭제되었습니다.",
      "microphonePermissionGranted": "마이크 권한이 허용되었습니다.",
      "microphonePermissionPermanentlyDenied": "마이크 권한이 영구적으로 거부되었습니다. 설정에서 허용해주세요.",
      "microphonePermissionDenied": "마이크 권한이 거부되었습니다. 설정에서 허용해주세요.",
      "recordVoiceExplain": "60초 이상 녹음하길 권장합니다.",
      "stopRecording": "녹음 중지",
      "readyForVoiceFeatures": "음성이 성공적으로 등록되었습니다. 이제 음성 기능을 사용할 준비가 되었습니다.",
      "listenVoice": "음성 듣기",
      "reRecordVoice": "음성 재녹음",
      "voiceRegistrationNeededTitle": "음성 등록 필요",
      "voiceRegistrationNeededContent": "발음 연습 및 소통하기와 같은 기능을 사용하려면 먼저 음성을 등록해야 합니다. 지금 녹음하시겠습니까?",
      "startRecordingButton": "지금 녹음 시작",
      "doLaterButton": "나중에 하기",
      "voiceRecording": "음성 녹음",
      'stopPlaying': "재생 중지",
      'firstRecordingCompleted': '첫 녹음이 완료되었습니다. 이제부터 녹음되는 음성은 저장됩니다.',
      'exampleTextTitle' : "예시 텍스트",
      'pleaseStopRecordingFirst' : "녹음 중 창 닫기 불가",

      //공지사항
      'all': '전체',
      'samcheok_dogye': '삼척·도계',
      'covid_response': '코로나19대응',
      'searchAnnouncements': '공지사항 검색...',
      'filterByCategory': '카테고리 필터링',
      'failedToLoadAnnouncements': '공지사항을 불러오는데 실패했습니다: {errorMessage}', // 플레이스홀더 변경
      'networkError': '네트워크 오류가 발생했습니다. 다시 시도해주세요.',
      'couldNotLoadAnnouncements': '공지사항을 불러올 수 없습니다.',
      'tryAgain': '다시 시도',
      'noAnnouncementsFound': '공지사항을 찾을 수 없습니다.',
      "announcementDetails": "공지사항 세부정보",
      'loadMore' :"더 보기",

      //동아리 정보
      "clubInformation": "동아리 정보",
      "noName": "이름 없음",
      "noCategory": "분류 없음",
      "noDescription": "설명 없음",
      "noDescriptionZh": "설명 없음 (중국어)",
      "failedToLoadClubInfo": "동아리 정보를 불러오는데 실패했습니다:",
      "unableToLoadClubInfo": "동아리 정보를 불러올 수 없습니다.",
      "noRegisteredClubInfo": "등록된 동아리 정보가 없습니다.",
      "availableClubs": "이용 가능한 동아리",
      "category": "분류",

      //식단표
      "weeklyMenu": "금주의 식단",
      "studentCafeteria": "학생 식당",
      "dormCafeteria": "기숙사 식당",

      //발음 연습 문장 고르기
      "recordingStartError": "녹음 시작 중 오류: ",
      "recordingStopped": "녹음이 중지되었습니다.",
      "noRecordingToStop": "중지할 녹음이 없습니다.",
      "recordingStopError": "녹음 중지 중 오류: ",
      "selectPracticeSentence": "연습 문장 선택",
      "enterPracticeSentence": "연습 문장 입력",
      "sentenceHint": "여기에 문장을 입력하거나, 아래에서 선택하세요.",
      "recordedFile": "녹음된 파일",
      "playingRecordedAudio": "녹음된 오디오 재생 중...",
      "playRecordedAudio": "녹음된 오디오 재생",
      "startPractice": "연습 시작",
      "orChoosePredefined": "또는 미리 정의된 문장 선택:",
      "predefinedSentence1": "안녕하세요, 오늘 어떠세요?",
      "predefinedSentence2": "저는 플러터 개발을 배우고 있습니다.",
      "predefinedSentence3": "다시 한번 말씀해주시겠어요?",
      "predefinedSentence4": "오늘 날씨가 매우 좋네요.",
      "predefinedSentence5": "도와주셔서 감사합니다.",
      "defaultPracticeSentence": "연습하면 완벽해진다.",

      //발음 연습
      "pronunciation_practice": "발음 연습",
      "correct_sentence": "올바른 문장:",
      "press_mic_to_speak": "말하려면 마이크를 누르세요.",
      "read_sentence_above": "위에 있는 문장을 읽으세요.",
      "generating_tts_correct_sentence": "올바른 문장 TTS 생성 중...",
      "correct_sentence_audio_generated": "올바른 문장 오디오가 생성되었습니다.",
      "error_generating_audio": "오디오 생성 오류:",
      "listening": "듣는 중...",
      "speak_sentence_now": "지금 문장을 말하세요.",
      "recording_error": "녹음 오류:",
      "error_starting_recording": "녹음 시작 오류:",
      "recording_complete_sending_to_server": "녹음 완료. 서버로 전송 중...",
      "speech_recognition_failed": "음성 인식이 실패했습니다.",
      "tts_attempting_user_recording_mfcc": "TTS: 사용자 녹음 파일로 올바른 문장 TTS 생성 시도 (MFCC 기준 오디오):",
      "tts_no_user_recording_default_mfcc": "TTS: 사용자 녹음 파일 경로가 없어 기본 화자 오디오로 TTS 생성 시도 (MFCC 기준 오디오).",
      "error_calculating_mfcc_similarity": "MFCC 유사도 계산 중 오류 발생:",
      "recognized": "인식된 문장",
      "cer": "CER(정확도)",
      "mfccSimilarity": "MFCC(유사도)",
      "mfcc_similarity_error": "MFCC 유사도: 오류 -",
      "mfcc_similarity_na_audio_missing": "MFCC 유사도: N/A (비교를 위한 오디오 경로 없음)",
      "debug_mfcc_comparison_failed": "디버그: MFCC 유사도 계산 실패: TTS 파일 또는 사용자 녹음 파일 경로가 최종적으로 유효하지 않음.",
      "speech_recognition_failed_try_again": "음성 인식이 실패했습니다. 다시 시도해 주세요.",
      "error_during_speech_recognition": "음성 인식 중 오류가 발생했습니다:",
      "no_recording_to_play": "재생할 녹음이 없습니다. 먼저 음성을 녹음해주세요.",
      "failed_to_play_local_audio": "로컬 오디오 재생 실패:",
      "failed_to_play_recording": "녹음 재생 실패:",
      "practice_result_saved": "연습 결과가 저장되었습니다:",
      "no_text_to_speak": "말할 텍스트가 없습니다.",
      "no_recognized_text_to_display_result": "결과를 표시할 인식된 텍스트가 없습니다.",
      "view_my_recordings": "내 녹음 보기",
      "listen_correct_sentence_tts_your_voice": "올바른 문장 듣기 (내 목소리로 TTS)",
      "pause_recording": "녹음 일시 중지",
      "play_your_recording": "내 녹음 재생",
      "viewResult": "결과 보기",
      "playingPersonalizedAudio": "복제시킨 TTS를 재생 중입니다... 주의 깊게 들어보세요!",
      "correctSentence": "정답 문장",
      "speakNow": "이제 문장을 말해보세요.",
      "listenAndPractice": "스피커 아이콘을 눌러 복제된 TTS 발음을 듣고, 마이크를 눌러 말해보세요.",
      "personalizedAudioNotReady": "복제된 TTS가 준비되지 않았습니다. 먼저 스피커 버튼을 눌러주세요.",
      "preparingPersonalizedAudio": "복제된 TTS를 준비 중입니다...",
      "personalizedAudioReady": "복제된 TTS가 준비되었습니다!",
      "analyzingPronunciation": "녹음 완료. 발음을 분석 중입니다...",
      "listenToCorrectSentence": "원문 듣기",
      "noVoiceFileFoundForPersonalization": "복제시킨 TTS를 위한 사용자 음성 파일을 찾을 수 없습니다.",
      "cannotProceedWithoutVoice": "사용자 음성 파일 없이는 진행할 수 없습니다.",
      "userVoiceFileDoesNotExist": "사용자 음성 파일이 존재하지 않습니다.",
      "ttsServerError": "TTS 서버 오류 ({statusCode}): {error}",
      "failedToPrepareAudio": "복제시킨 TTS를 준비하지 못했습니다. 연습을 진행할 수 없습니다.",
      "personalizedAudioBeingPrepared": "복제시킨 TTS를 준비 중입니다. 잠시 기다려 주세요.",
      "personalizedAudioNotFoundRecreating": "복제시킨 TTS를 찾을 수 없습니다. 다시 생성 중입니다...",
      "playPersonalizedAudioError": "복제시킨 TTS를 재생하지 못했습니다: {error}",
      "personalizedAudioNotReadyToRecord": "복제시킨 TTS가 준비되지 않았습니다. 먼저 재생하여 생성해주세요.",
      "processingRequest": "요청을 처리 중입니다. 잠시 기다려 주세요.",
      "errorStartingRecording": "녹음 시작 오류: {error}",
      "speechRecognitionFailed": "음성 인식이 실패했습니다.",
      "error": "오류: {error}",
      "mfccAudioMissing": "N/A (오디오 파일 누락 또는 유효하지 않음.)",
      "speechRecognitionFailedTryAgain": "음성 인식이 실패했습니다. 다시 시도해주세요.",
      "speechRecognitionError": "음성 인식 오류: {error}",
      "errorDuringSpeechRecognition": "음성 인식 중 오류가 발생했습니다.",
      "noValidRecordingToPlay": "재생할 유효한 녹음이 없습니다. 먼저 음성을 녹음해주세요.",
      "failedToPlayRecording": "녹음 재생 실패: {error}",
      "pauseYourRecording": "내 녹음 일시 정지",
      "playYourRecording": "내 녹음 재생",
      "noRecognizedText": "결과를 표시할 인식된 텍스트가 없습니다.",
      "pressMicToSpeak": "마이크를 눌러 말하세요.",
      "guideListenAndSpeak": "스피커 아이콘을 눌러 복제시킨 TTS를 듣고, 마이크를 눌러 말하세요.",
      "analysisCompleteProceedToResult" : "발음 분석 완료. 점수를 확인하세요!",

      //발음 결과
      'pronunciationResult': '발음 결과',
      'yourSpeech': '내가 말한 문장:',
      'aiFeedback': 'AI 피드백:',
      "similarityScore": "유사도 점수", // <--- 이 줄을 추가합니다.
      'excellentPronunciationFeedback': '훌륭합니다! 거의 완벽한 발음이었습니다. 다음 목표는 완벽한 정확도입니다!',
      'veryGoodPronunciationFeedback': '아주 좋습니다! 명확하고 자신감 있게 말했습니다. 작은 오류들을 줄이는 데 집중해 보세요.',
      'goodJobPronunciationFeedback': '잘했어요. 특정 부분의 발음 연습이 더 필요한 것 같습니다. 오류 유형을 확인해 보세요.',
      'morePracticeNeededFeedback': '더 많은 연습이 필요합니다. 각 오류 유형을 이해하고 천천히 다시 시도해 보세요.',
      'omittedAndAddedWordsFeedback': '\n\n일부 단어를 빠뜨리고 불필요한 단어를 추가했습니다. 원문을 더 주의 깊게 들어보세요.',
      'omittedWordsFeedback': '\n\n중요한 단어를 놓쳤습니다. 원문을 다시 듣고 놓친 단어를 확인해 보세요.',
      'addedWordsFeedback': '\n\n불필요한 단어를 추가했습니다. 간결하게 발음하는 연습을 해보세요.',
      'accuracy': '정확도:',
      'missingWords': '누락된 단어 :',
      'deletionLegend': '삭제 (정답에는 있지만 내가 말하지 않은 부분)',
      'noDeletedWords': '삭제된 단어가 없습니다.',
      'extraWords': '추가된 단어 :',
      'insertionLegend': '추가 (정답에는 없지만 내가 추가한 부분)',
      'noAddedWords': '추가된 단어가 없습니다.',
      'backToPractice': '연습으로 돌아가기',
      "pronunciationResultTitle": "발음 결과",
      "originalSentence": "원문:",
      "yourRecognition": "인식된 발음:",
      "accuracyScores": "정확도 점수:",
      "cerCharacterErrorRate": "CER(정확도): {cerValue}",
      "noScoreInformation": "점수 정보가 없습니다.",
      "practiceAgain": "다시 연습하기",
      "mfcc_Similarity": "MFCC(유사도): {mfccSimilarityScore}",

      //소통하기
      "yourLanguage": "내 언어",
      "tapMicAndSpeak": "마이크를 누르고 말하세요",
      "translatedKorean": "번역된 한국어",
      "translationWillAppear": "번역이 여기에 표시됩니다.",
      "replayTranslatedText": "번역된 텍스트 다시 듣기",
      "startSpeakingInYourLanguage": "내 언어로 말하기 시작...",
      "failedToStartRecording": "녹음 시작 실패: {errorMessage}",
      "noAudioRecorded": "녹음된 오디오가 없습니다.",
      "processingAudio": "오디오 처리 중...",
      "translationFailed": "번역이 실패했습니다.",
      "translationApiError": "번역 API 오류: 상태 코드 {statusCode}, 응답: {responseBody}",
      "translationNetworkError": "번역 네트워크 오류: {errorMessage}",
      "sttApiError": "STT API 오류: 상태 코드 {statusCode}",
      "sttNetworkError": "STT 네트워크 오류: {errorMessage}",
      "ttsApiError": "TTS API 오류: 상태 코드 {statusCode}",
      "ttsNetworkError": "TTS 네트워크 오류: {errorMessage}",
      "communicationError": "통신 중 오류 발생: {errorMessage}",
      "playingTranslatedText": "번역된 텍스트 재생 중...",
      "noTranslatedTextToPlay": "재생할 번역된 텍스트가 없습니다.",
      "english": "영어",
      "chinese": "중국어",
      "korean": "한국어",
      "noAudioRecordedMessage": "음성 녹음이 필요합니다. 음성 녹음을 해주세요.",

      //계정관리
      'accountManagement': '계정 관리',
      'changePassword': '비밀번호 변경',
      'changeMajor': '학과/전공 변경',

      //학과 변경
      "changeMajorTitle": "학과 변경",
      "noUserLoggedIn": "로그인된 사용자가 없습니다.",
      "selectCollegeAndDepartment": "단과대학과 학과를 모두 선택해주세요.",
      "accountInfoUpdatedSuccessfully": "계정 정보가 성공적으로 업데이트되었습니다.",
      "accountInfoUpdateFailed": "계정 정보 업데이트에 실패했습니다.",
      "editPersonalInfo": "개인 정보 편집",
      "fullName": "이름",
      "pleaseSelectCollege": "단과대학을 선택해주세요.",
      "pleaseSelectDepartment": "학과를 선택해주세요.",
      "saveChanges": "변경 사항 저장",

      //비밀번호 변경
      'userInformationNotFound': '사용자 정보를 찾을 수 없습니다.',
      'passwordChangedSuccessfully': '비밀번호가 성공적으로 변경되었습니다.',
      'newPasswordMismatch': '새 비밀번호와 확인 비밀번호가 일치하지 않습니다.',
      'currentPasswordMismatch': '현재 비밀번호가 일치하지 않습니다.',
      'userNotFoundLoginAgain': '사용자를 찾을 수 없습니다. 다시 로그인해주세요.',
      'authenticationErrorOccurred': '인증 오류가 발생했습니다. 다시 시도해주세요.',
      'weakPassword': '비밀번호가 너무 약합니다. 6자리 이상 입력해주세요.',
      'failedToChangePassword': '비밀번호 변경에 실패했습니다. 다시 시도해주세요.',
      'currentPassword': '현재 비밀번호',
      'enterCurrentPassword': '현재 비밀번호를 입력해주세요.',
      'newPassword': '새 비밀번호',
      'enterNewPassword': '새 비밀번호를 입력해주세요.',
      'passwordLengthRequirement': '비밀번호는 최소 6자리 이상이어야 합니다.',
      'confirmNewPassword': '새 비밀번호 확인',
      'reEnterNewPassword': '새 비밀번호를 다시 입력해주세요.',
      'changePasswordButton': '비밀번호 변경',

      //자주 묻는 질문
      'frequentlyAskedQuestions': '자주 묻는 질문',
      'faq1_question': '1. 발음 교정은 어떻게 요청하나요?',
      'faq1_answer': '발음 교정을 요청하려면 "발음 교정 요청" 버튼을 누르세요.',
      'faq2_question': '2. 번역 기능은 어떻게 사용하나요?',
      'faq2_answer': '메인 화면에서 "번역" 버튼을 눌러 번역 기능을 사용할 수 있습니다.',
      'faq3_question': '3. 하루에 몇 번 발음 교정을 받을 수 있나요?',
      'faq3_answer': '발음 교정 서비스는 하루에 5번까지 이용 가능합니다.',

      // 이용 제한 설정
      "inquiryFrom": "문의 발신자",
      "unknownUser": "알 수 없는 사용자",
      'customerSupport': '고객 지원',
      'kubiAppInquiry': 'KUBI 앱 문의',
      'imageAttachedSeparately': '\n\n[이메일 앱에서 이미지가 별도로 첨부됩니다]',
      'inquiryPreparationMessage': '이메일 앱에서 문의가 준비되고 있습니다.',
      'couldNotLaunchEmailApp': '이메일 앱을 실행할 수 없습니다.',
      'galleryPermissionNeeded': '갤러리 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.',
      'enterYourInquiry': '문의 내용을 입력해주세요.',
      'attachScreenshot': '스크린샷 첨부',
      'attachedScreenshotPreview': '첨부된 스크린샷 미리보기:',
      'sendInquiry': '문의 보내기',
      'viewFaq': '자주 묻는 질문(FAQ) 보기',
      'usageLimitations': '사용 제한 사항',
      'excessiveRequestsLimitationTitle': '📊 과도한 요청 제한',
      'excessiveRequestsLimitationDescription': '서버에 과도한 요청이 발생할 경우, 일정 기간 서비스 접근이 제한될 수 있습니다. 과도한 트래픽 생성을 자제해 주세요.',
      'pronunciationCorrectionServiceLimitationTitle': '🛑 발음 교정 서비스 제한',
      'pronunciationCorrectionServiceLimitationDescription': '발음 교정 서비스는 하루에 5번까지 이용 가능합니다. 초과 시 다음날까지 기다려야 합니다.',
      'personalInformationProtectionLimitationTitle': '🔒 개인정보 보호 제한',
      'personalInformationProtectionLimitationDescription': '잘못된 정보를 입력하거나 개인정보 정책을 위반할 경우, 앱 접근이 제한될 수 있습니다. 서비스 약관을 준수해 주세요.',
      'inappropriateContentBlockingTitle': '🚫 부적절한 콘텐츠 차단',
      'inappropriateContentBlockingDescription': '욕설 또는 부적절한 내용 입력 시, 서비스 이용이 제한될 수 있습니다.',
      'serviceAvailabilityLimitationTitle': '⚠️ 서비스 이용 가능 시간 제한',
      'serviceAvailabilityLimitationDescription': '일부 서비스(예: 발음 교정)는 특정 시간대에만 이용 가능합니다.',
      'customerInquiryContact':"고객님 문의\n이메일 : rlagustj3325@gmail.com\n전화번호 : 010-9039-3862",

      //앱 버전
      'appInformation': '앱 정보',
      'appVersion': '앱 버전',
      'version': '버전 {versionNumber}',

      //이용, 정보, 마케팅
      "viewMarketingConsent": "마케팅 동의 보기",
      'consentSettings': '정보 동의 설정',
      'marketingConsentChanged': '마케팅 정보 수신 동의 설정이 변경되었습니다.',
      'ok': '확인',
      'pleaseReviewConsentSettings': '정보 동의 설정을 확인해 주세요:',
      'termsOfServiceTitle': '서비스 약관',
      'termsOfServiceDetails': '''본 서비스 약관(이하 "약관")은 KUBI 앱(이하 "서비스")의 모든 이용자에게 적용됩니다. 서비스를 이용함으로써 이용자는 다음 약관에 동의하는 것으로 간주됩니다. 서비스를 이용하기 전에 약관을 주의 깊게 읽어 주십시오.

1. 서비스 제공
본 서비스는 한국어 발음 교정 및 한국어 학습을 외국인 학생들에게 지원하는 모바일 애플리케이션을 제공합니다. 이용자는 이 서비스를 통해 발음 피드백, 음성 인식, 번역, 학사 공지 확인 등의 기능을 활용할 수 있습니다.

2. 개인 데이터 처리 및 사용
본 서비스는 학습 지원 및 서비스 개선 목적으로만 이용자의 개인 정보를 수집합니다. 이용자가 제공하는 이름, 이메일 주소, 국가, 전공 등의 정보는 맞춤형 학습 및 커뮤니케이션 기능을 제공하는 데 사용됩니다. 자세한 내용은 [개인정보 처리방침]을 참조하십시오.

3. 서비스 이용 규정
이용자는 서비스의 기능을 개인 학습 목적으로만 사용해야 합니다.
음성 인식, 번역, 발음 피드백 등의 기능을 불법적이거나 부적절한 콘텐츠에 사용하는 것은 금지됩니다.
서비스가 제공하는 모든 콘텐츠(텍스트, 음성, 이미지 등)는 저작권으로 보호되며, 이용자는 무단으로 복제하거나 배포할 수 없습니다.

4. 서비스 변경 및 종료
본 서비스는 이용자의 편의를 위해 지속적으로 개선됩니다. 서비스 제공자는 언제든지 기능을 추가하거나 수정할 수 있으며, 이로 인해 발생하는 불편에 대해 책임지지 않습니다. 또한, 서비스 제공자는 법적 의무를 준수하기 위해 서비스를 중단할 수 있습니다.

5. 책임의 한계
본 서비스는 제공되는 기능의 정확성을 보장하기 위해 노력하지만, 기술적 오류 또는 네트워크 장애로 인해 발생하는 문제에 대해서는 책임지지 않습니다. 이용자는 서비스 사용과 관련된 모든 위험을 부담합니다.

6. 이용자 행동 규정
이용자는 서비스를 이용하는 동안 다음 행위를 해서는 안 됩니다:
• 명예 훼손 또는 불쾌한 언어와 같은 부적절한 콘텐츠 공유.
• 불법적인 목적으로 서비스 사용.
• 서비스 운영에 영향을 미칠 수 있는 악성 프로그램 또는 코드 삽입.

7. 약관 변경
서비스 약관은 서비스 개선 또는 법적 요구 사항을 충족하기 위해 개정될 수 있습니다. 약관 변경은 앱 내 알림 또는 이메일을 통해 이용자에게 통지되며, 이용자는 개정된 약관에 동의하는 것으로 간주됩니다.

8. 법적 분쟁
본 약관과 관련된 모든 분쟁은 대한민국 법률의 적용을 받으며, 분쟁 발생 시 서울중앙지방법원을 1심 관할 법원으로 합니다.''',
      'viewTermsOfService': '서비스 약관 보기',
      'agreedToTerms': '서비스 약관에 동의하셨습니다.',
      'notAgreedToTerms': '서비스 약관에 동의하지 않으셨습니다.',
      'privacyPolicyTitle': '개인정보 처리방침',
      'privacyPolicyDetails': '''
KUBI 앱은 외국인 학생들에게 한국어 학습 및 발음 교정 서비스를 제공하기 위해 사용자의 개인 정보를 수집하고 처리합니다. 사용자의 개인 정보 보호는 최우선 과제이며, 본 개인정보 처리방침은 사용자의 개인 데이터가 어떻게 수집, 사용 및 보호되는지에 대한 정보를 제공합니다. 앱을 사용함으로써 사용자는 본 정책에 동의하는 것으로 간주됩니다.

1. 수집하는 개인 정보
- 가입 시: 사용자 이름, 이메일 주소, 국가, 전공 등
- 서비스 이용 중: 발음 교정, 음성 인식, 번역 서비스 이용 중 수집되는 음성 데이터 및 텍스트 데이터
- 기기 정보: 기기 종류, 운영 체제, 앱 버전 등

2. 개인 정보 사용 목적
- 서비스 제공: 발음 교정, 음성 인식, 번역 기능 및 학사 공지 제공 등
- 맞춤형 학습 경험: 사용자 전공, 국가 및 학습 선호도에 따른 맞춤형 학습 자료 및 피드백 제공
- 서비스 개선: 사용자 경험 분석을 통한 앱 성능 및 기능 개선
- 법적 의무 준수: 법적 요구 사항 및 규정에 따라 개인 데이터 처리

3. 개인 정보 보유 및 이용 기간
- 개인 정보는 사용자가 서비스 탈퇴 또는 앱 삭제 시까지 보유됩니다.
- 단, 법적 의무에 따라 일정 기간 보관될 수 있습니다.

4. 제3자에게 개인 정보 제공
- 개인 정보는 원칙적으로 제3자에게 제공되지 않습니다. 단, 법률에 의해 요구되는 경우 제공될 수 있습니다.

5. 개인 정보 보안 확보
- 데이터 암호화: 개인 정보를 안전하게 보호하기 위해 암호화 기술이 사용됩니다.
- 접근 제어: 개인 정보에 대한 접근은 승인된 직원 및 필요한 권한을 가진 사람으로 제한됩니다.

6. 사용자 권리
- 접근 및 수정: 사용자는 언제든지 자신의 개인 정보에 접근하고 수정할 수 있습니다.
- 동의 철회: 사용자는 언제든지 개인 데이터 처리에 대한 동의를 철회할 수 있습니다. 단, 철회 시 서비스의 일부 기능 접근이 제한될 수 있습니다.
- 삭제 요청: 사용자는 자신의 개인 정보 삭제를 요청할 수 있으며, 요청 시 데이터는 즉시 삭제됩니다.

7. 개인정보 처리방침 변경
- 본 개인정보 처리방침은 서비스 개선 또는 법적 요구 사항을 준수하기 위해 업데이트될 수 있습니다. 사용자에게 변경 사항은 앱 내 알림 또는 이메일을 통해 통지됩니다.
  ''',
      'viewPrivacyPolicy': '개인정보 처리방침 보기',
      'agreedToPrivacy': '개인정보 처리방침에 동의하셨습니다.',
      'notAgreedToPrivacy': '개인정보 처리방침에 동의하지 않으셨습니다.',
      'marketingConsentHeader': '마케팅 정보 수신 동의',
      'marketingConsentDetails': '''
KUBI 앱은 사용자의 개인 정보를 마케팅 목적으로 수집하고 사용할 수 있습니다. 여기에는 앱 경험을 개선하기 위한 프로모션 자료, 앱 업데이트, 새로운 기능 및 기타 관련 콘텐츠 전송이 포함됩니다.

1. 마케팅 데이터 수집 목적
- 프로모션 이메일, 알림 및 앱 관련 업데이트 전송.
- 관심 있을 수 있는 서비스, 이벤트 및 뉴스 관련 제안 및 정보 제공.
- 앱 내에서의 선호도 및 사용 패턴을 기반으로 한 개인화된 마케팅 활동 개선.

2. 수집하는 마케팅 데이터 유형
- 연락처 정보: 이메일 주소, 전화번호 및 기타 통신 수단.
- 사용 데이터: 앱 내 활동, 사용된 기능, 선호도 및 행동.
- 인구통계 정보: 연령, 위치 및 언어 선호도와 같은 정보.

3. 마케팅 데이터 사용 방법
- 프로모션 이메일/알림: 특별 행사, 새로운 업데이트 또는 앱의 예정된 기능에 대해 알려드리기 위해 이메일 또는 푸시 알림을 보낼 수 있습니다.
- 개인화된 마케팅: 앱 사용 및 선호도를 기반으로 사용자의 관심사에 맞는 제안 및 알림을 개인화할 수 있습니다.

4. 마케팅 커뮤니케이션 수신 거부
- 사용자는 언제든지 마케팅 커뮤니케이션 수신을 거부할 권리가 있습니다. 앱 설정에서 이메일 구독을 취소하거나 푸시 알림을 비활성화할 수 있습니다.
- 수신 거부하더라도 약관 업데이트 또는 시스템 알림과 같은 중요한 서비스 관련 통신은 계속 받을 수 있습니다.

5. 제3자와의 마케팅 데이터 공유
- 법률에 의해 요구되는 경우를 제외하고, 사용자의 동의 없이 마케팅 데이터는 제3자와 공유되지 않습니다.

6. 마케팅 데이터 보유
- 마케팅 데이터는 사용자가 앱 사용자 상태를 유지하는 동안 또는 마케팅 커뮤니케이션 수신을 거부할 때까지 보유됩니다. 수신 거부 후에는 마케팅 목적으로 데이터를 사용하지 않지만, 서비스 관련 필요에 따라 보관할 수 있습니다.

7. 마케팅 데이터 사용 변경
- 마케팅 데이터 수집 또는 사용 방식에 대한 변경 사항은 앱 내 알림 또는 이메일을 통해 전달됩니다.
      ''',
      'receiveUpdatesAndPromotionalOffers': '업데이트 및 프로모션 제안 수신.',

      //로그아웃
      'logout': '로그아웃',
      'logoutConfirmationTitle': '로그아웃',
      'logoutConfirmationContent': '로그아웃하시겠습니까?',
      'cancellation': '취소',
      'check': '확인',
      "logoutSuccess": "로그아웃 되었습니다.",
      'loggedOutMessage': '로그아웃되었습니다.',


      //설정 창
      "settingsScreenTitle": "설정",
      "logoutDialogTitle": "로그아웃",
      "logoutDialogContent": "정말 로그아웃 하시겠습니까?",
      "noButton": "아니요",
      "yesButton": "예",
      "logoutFailedMessage": "로그아웃에 실패했습니다. 다시 시도해주세요.",
      "deleteAccountDialogTitle": "회원 탈퇴",
      "deleteAccountDialogContent": "정말 회원 탈퇴 하시겠습니까? 모든 데이터가 삭제되며 복구할 수 없습니다.",
      "accountDeletionComplete": "회원 탈퇴가 완료되었습니다.",
      "accountDeletionFailed": "회원 탈퇴에 실패했습니다. 다시 시도해주세요.",
      "reloginRequiredForDeletion": "보안을 위해 다시 로그인해야 회원 탈퇴가 가능합니다.",
      "accountAndAppSettingsSection": "계정 및 앱 설정",
      "accountManagementItem": "계정 관리",
      "usageGuideSection": "이용 안내",
      "appInfoItem": "앱 정보",
      "customerSupportItem": "고객 지원",
      "otherFeaturesSection": "기타 기능",
      "consentSettingsItem": "정보 동의 설정",
      "logoutItem": "로그아웃",
      "deleteAccountItem": "회원 탈퇴",
      "accountDeletionError": "회원 탈퇴 오류",
      "generalAccountDeletionError": "일반 회원 탈퇴 오류",
      "reauthenticateTitle": "재인증 필요",
      "reauthenticateContent": "보안을 위해 계속하려면 비밀번호를 다시 입력해주세요.",
      "passwordLabel": "비밀번호",
      "cancelButton": "취소",
      "confirmButton": "확인",
      "reauthenticationFailed": "재인증에 실패했습니다.",
      "wrongPassword": "비밀번호가 틀렸습니다. 다시 시도해주세요.",
      "invalidEmail": "유효하지 않은 이메일입니다. 이메일을 확인해주세요.",
      "reauthenticationMethodNotSupported": "해당 로그인 방식의 재인증은 아직 지원되지 않습니다.",
      "requiresRecentLogin": "이 작업은 최근 인증이 필요합니다. 다시 인증해주세요.",
      "reauthenticationFailedTryAgain": "재인증에 실패했습니다. 다시 시도해주세요.",
      "guest": "비회원",
      "noCollegeSelected": "선택된 대학 없음",
      "noDepartmentSelected": "선택된 학과 없음",
      "currentDepartment": "현재 학과: {department}",
      "currentCollege": "현재 단과대학: {college}",
      "selectNewCollegeAndDepartment": "새로운 단과대학과 학과를 선택해주세요:",
      "selectCollege": "단과대학 선택",
      "changeDepartment": "학과 변경",
      "departmentChanged": "학과가 성공적으로 변경되었습니다! 새로운 학과: {major}, 단과대학: {college}",
      "failedToSaveDepartmentCollege": "학과 및 단과대학 정보 저장에 실패했습니다. 다시 시도해주세요.",
      "pleaseSelectDepartmentCollege": "단과대학과 학과를 모두 선택해주세요.",

      //학교 지도
      "campusMap": "캠퍼스 지도",

      //소통해요
      "pronunciationPracticeTitle": "발음 연습",
      "viewMyRecordings": "내 녹음 보기",
      "listenCorrectSentence": "정확한 문장 듣기 (내 목소리로 TTS)",
      "pressMicToSpeak": "마이크를 눌러 말하세요.",
      "recordingCompleteSending": "녹음 완료. 서버로 전송 중...",
      "speechRecognitionFailed": "음성 인식 실패. 다시 시도해주세요.",
      "speechRecognitionError": "음성 인식 오류: ",
      "anErrorOccurredDuringSpeechRecognition": "음성 인식 중 오류가 발생했습니다: ",
      "noRecordingToPlay": "재생할 녹음 파일이 없습니다. 먼저 녹음해주세요.",
      "failedToPlayRecording": "녹음 재생 실패: ",
      "pauseRecording": "녹음 일시정지",
      "playYourRecording": "내 녹음 재생",
      "noRecognizedText": "표시할 인식된 텍스트가 없습니다.",
      "noTextToSpeak": "말할 텍스트가 없습니다.",
      "generatingTTScorrectSentence": "정확한 문장 TTS 생성 중...",
      "correctSentenceAudioGenerated": "정확한 문장 오디오 생성됨.",
      "errorGeneratingAudio": "오디오 생성 오류: ",
      "cerLabel": "CER:",
      "mfccSimilarityLabel": "MFCC 유사도:",
      "notApplicable": "N/A",
      "mfccAudioPathMissing": "N/A (비교를 위한 오디오 경로 누락)",
      "enterTextInYourLanguage": "내 언어로 텍스트 입력",
      "typeHere": "여기에 입력...",
      "recordMyVoice": "내 목소리 녹음",
      "translateButton": "번역",
      "speakButton": "말하기",
      "yourInputText": "내 입력 텍스트",
      "translatedText": "번역된 텍스트",
      "translating": "번역 중...",
      "translationComplete": "번역 완료.",
      "noTranslatedTextToSpeak": "말할 번역된 텍스트가 없습니다.",
      "speaking": "말하는 중...",
      "speechComplete": "말하기 완료.",
      "ttsError": "TTS 오류: ",
      "resultPlaceholder": "여기에 발음 평가 결과가 표시됩니다.",

      //지도
      'map1': '강원대학교 삼척캠퍼스 지도',
      'close': '닫기',
      'latitude': '위도',
      'longitude': '경도',

      //tts
      "ttsLoadingAlreadyInProgress": "이미 로딩 중입니다. 기존 Future를 반환합니다.",
      "ttsDefaultSpeakerAudioLoadStart": "기본 화자 오디오 파일 로드 시작: ",
      "ttsDefaultSpeakerAudioLoadedTempPath": "기본 화자 오디오 파일이 임시 경로에 로드되었습니다: ",
      "ttsDefaultSpeakerAudioLoadError": "기본 화자 오디오 파일을 로드하는 중 심각한 오류 발생: ",
      "ttsTextEmpty": "변환할 텍스트가 비어 있습니다. 요청을 보내지 않습니다.",
      "ttsDefaultSpeakerAudioLoadingWait": "기본 화자 오디오 로딩 완료 대기...",
      "ttsSpeakerAudioFileNotFound": "TTS 서버는 speaker_audio 파일을 필수로 요구하지만, 기본 또는 지정된 스피커 오디오 파일이 유효하지 않습니다. 경로: ",
      "ttsAddingSpeakerAudioToRequest": "스피커 오디오 파일: {filePath}를 요청에 추가합니다.",
      "ttsMultipartRequestReady": "TTS 서버로 MultipartRequest 전송 준비. 텍스트: \"{text}\", speaker_audio 파일: {filePath}",
      "ttsServerUrl": "TTS 서버 URL: ",
      "ttsServerResponseStatusCode": "TTS 서버 응답 상태 코드: ",
      "ttsServerResponseContentType": "TTS 서버 응답 Content-Type: ",
      "ttsAudioBytesReceivedDirectly": "오디오 바이트 직접 수신 (Content-Type: {contentType})",
      "ttsServerResponseBodyJson": "TTS 서버 응답 본문 (JSON): ",
      "ttsBase64DecodedAudioReceived": "Base64 디코딩 후 오디오 바이트 수신",
      "ttsNoValidAudioContentInJson": "TTS 응답 JSON에 유효한 오디오 콘텐츠가 없습니다.",
      "ttsUnexpectedContentType": "TTS 서버가 예상치 못한 Content-Type을 반환했습니다: ",
      "ttsGeneratedAudioFileSaved": "생성된 TTS 오디오 파일 저장됨: ",
      "ttsAudioPlaybackStart": "오디오 재생 시작",
      "ttsServerError": "TTS 서버 오류: {statusCode} - {response}",
      "ttsCommunicationOrPlaybackFailedException": "TTS 서버 통신 또는 오디오 재생 실패 예외: ",
      "ttsCommunicationOrPlaybackFailed": "TTS 서버 통신 또는 오디오 재생 실패: ",
      "ttsAudioPlaybackStopped": "현재 TTS 오디오 재생 중지됨.",
      "ttsTemporarySpeakerAudioFileDeleted": "임시 스피커 오디오 파일 삭제: ",
      "ttsTemporarySpeakerAudioFileDeleteError": "임시 스피커 오디오 파일 삭제 중 오류 발생: ",
      "ttsGeneratedAudioFileDeleted": "생성된 TTS 오디오 파일 삭제: ",
      "ttsGeneratedAudioFileDeleteError": "생성된 TTS 오디오 파일 삭제 중 오류 발생: ",

      //stt
      "microphonePermissionNotGranted": "마이크 권한이 허용되지 않았습니다.",
      "recordingStartFailed": "녹음 시작 실패: ",
      "recordingStoppedFilePathNotFound": "녹음이 중지되었지만 파일 경로를 찾을 수 없습니다.",
      "recordingStopOrAudioUploadFailed": "녹음 중지 또는 오디오 전송 실패: ",
      "recognitionFailed": "인식 실패",
      "sttServerError": "STT 서버 오류: ",
      "sttServerCommunicationFailed": "STT 서버와 통신 실패: ",
    },
    // 중국어 (zh) 번역을 여기에 추가
    'zh': {
      //홈 화면
      "appTitle": "KUBI",
      "toggleLanguage": "切换语言",
      "settings": "设置",
      "helloUser": "{userName}",
      "college": "{collegeName}",
      "department": "{departmentName}",
      "recordVoicePrompt": "请录制并注册您的声音。",
      "voiceRegistered": "您的声音已注册。",
      "currentVoiceFile": "当前语音文件",
      "recordingStarted": "录音已开始。",
      "recordingError": "录音错误：{error}",
      "voiceRecordedSuccessfully": "您的声音已成功注册！",
      "failedToRecordVoice": "录音失败。",
      "errorStoppingRecording": "停止录音错误：{error}",
      "exitTitle": "退出应用",
      "exitContent": "您确定要退出应用程序吗？",
      "no": "不",
      "yes": "是",
      "home":"家",
      "announcements": "公告",
      "cafeteriaInfo": "食堂信息",
      "pronunciationPractice": "发音练习",
      "clubInfo": "社团信息",
      "map": "地图",
      "communicationTitle": "交流",
      "practice": "练习",
      "microphonePermissionNeeded": "需要麦克风权限",
      "microphonePermissionContent": "发音评估需要麦克风权限。请在设置中启用。",
      "openSettings": "打开设置",
      "cancel": "取消",
      "recordVoiceNeeded": "需要注册声音",
      "recordVoiceDialogContent": "请注册您的声音以进行准确的发音评估。",
      "startRecording": "开始录音",
      "doLater": "稍后进行",
      "reviewVoiceRecording": "审查录音",
      "playRecordedVoice": "听听您录制的声音。",
      "listen": "听",
      "retakeQuestion": "您想重新录制吗？",
      "retake": "重新录制",
      "useThisVoice": "使用此声音",
      "audioPlaybackError": "音频播放错误：{error}",
      "voiceSavedSuccessfully": "声音已成功保存。",
      "reRecordingStarted": "重新录制已开始。",
      "listenRegisteredVoice": "听已注册的声音",
      "reRecordingInitiated": "重新录制已启动。",
      "voiceRecordingRequired": "您必须先录制声音才能使用此功能。",
      "voiceRecordingRequiredWithPrompt": "此功能需要录音。请录制您的声音。",
      "deleteVoiceFile": "删除语音文件",
      "voiceFileDeleted": "语音文件已成功删除。",
      "microphonePermissionGranted": "麦克风权限已允许。",
      "microphonePermissionPermanentlyDenied": "麦克风权限已被永久拒绝。请在设置中允许。",
      "microphonePermissionDenied": "麦克风权限被拒绝。请在设置中启用。",
      "recordVoiceExplain": "我们建议录制至少 60 秒。",
      "stopRecording": "停止录音",
      "readyForVoiceFeatures": "您的声音已成功注册。您现在可以使用语音功能了。",
      "listenVoice": "听声音",
      "reRecordVoice": "重新录制声音",
      "voiceRegistrationNeededTitle": "需要注册语音",
      "voiceRegistrationNeededContent": "要使用发音练习和交流等功能，请先注册您的声音。您现在想录音吗？",
      "startRecordingButton": "立即开始录音",
      "doLaterButton": "稍后进行",
      "voiceRecording": "语音录制",
      'stopPlaying': "停止播放",
      'firstRecordingCompleted': '第一次录音已完成。从现在起，录制的声音将被保存。',
      'exampleTextTitle' : "示例文本",
      'pleaseStopRecordingFirst' : "录音中无法关闭窗口。",

      // 공시사항
      'all': '全部',
      'samcheok_dogye': '三陟/道溪',
      'covid_response': '新冠疫情应对',
      'searchAnnouncements': '搜索公告...',
      'filterByCategory': '按类别筛选',
      'failedToLoadAnnouncements': '加载公告失败: {errorMessage}',
      'networkError': '发生网络错误。请重试。',
      'couldNotLoadAnnouncements': '无法加载公告。',
      'tryAgain': '重试',
      'noAnnouncementsFound': '未找到公告',
      "announcementDetails": "公告详情",
      'loadMore' :"加载更多",

      // 동아리 정보
      "clubInformation": "社团信息",
      "noName": "无名称",
      "noCategory": "无分类",
      "noDescription": "无说明",
      "noDescriptionZh": "无说明",
      "failedToLoadClubInfo": "未能加载社团信息:",
      "unableToLoadClubInfo": "无法加载社团信息。",
      "noRegisteredClubInfo": "没有可用的注册社团信息。",
      "availableClubs": "可用社团",
      "category": "类别",

      //식단표
      "weeklyMenu": "每周菜单",
      "studentCafeteria": "学生食堂",
      "dormCafeteria": "宿舍食堂",

      //발음 연습 고르기
      "recordingStartError": "开始录音时出错：",
      "recordingStopped": "录音已停止。",
      "noRecordingToStop": "没有可停止的录音。",
      "recordingStopError": "停止录音时出错：",
      "selectPracticeSentence": "选择练习句子",
      "enterPracticeSentence": "输入练习句子",
      "sentenceHint": "在此处输入您的句子，或从下方选择",
      "recordedFile": "已录制文件",
      "playingRecordedAudio": "正在播放录制音频...",
      "playRecordedAudio": "播放录制音频",
      "startPractice": "开始练习",
      "orChoosePredefined": "或选择预定义句子：",
      "predefinedSentence1": "안녕하세요, 오늘 어떠세요？",
      "predefinedSentence2": "저는 플러터 개발을 배우고 있습니다.",
      "predefinedSentence3": "다시 한번 말씀해주시겠어요？",
      "predefinedSentence4": "오늘 날씨가 좋네요.",
      "predefinedSentence5": "도와주셔서 감사합니다.",
      "defaultPracticeSentence": "연습하면 완벽해진다.",

      // 발음 연습
      "pronunciation_practice": "发音练习",
      "correct_sentence": "正确句子:",
      "press_mic_to_speak": "按麦克风说话。",
      "read_sentence_above": "请朗读上面的句子。",
      "generating_tts_correct_sentence": "正在为正确句子生成TTS...",
      "correct_sentence_audio_generated": "正确句子音频已生成。",
      "error_generating_audio": "生成音频时出错:",
      "listening": "正在聆听...",
      "speak_sentence_now": "现在请说出句子。",
      "recording_error": "录音错误:",
      "error_starting_recording": "启动录音时出错:",
      "recording_complete_sending_to_server": "录音完成。正在发送到服务器...",
      "speech_recognition_failed": "语音识别失败。",
      "tts_attempting_user_recording_mfcc": "TTS: 尝试使用用户录音生成正确句子TTS（MFCC基准音频）:",
      "tts_no_user_recording_default_mfcc": "TTS: 没有用户录音路径，尝试使用默认说话人生成TTS（MFCC基准音频）。",
      "error_calculating_mfcc_similarity": "计算MFCC相似度时出错:",
      "recognized": "已识别:",
      "cer": "CER(准确性)",
      "mfccSimilarity": "MFCC(相似度)",
      "mfcc_similarity_error": "MFCC相似度: 错误 -",
      "mfcc_similarity_na_audio_missing": "MFCC相似度: 不可用（缺少比较音频路径）",
      "debug_mfcc_comparison_failed": "调试: MFCC相似度计算失败: TTS文件或用户录音文件路径最终无效。",
      "speech_recognition_failed_try_again": "语音识别失败。请再试一次。",
      "error_during_speech_recognition": "语音识别期间发生错误:",
      "no_recording_to_play": "没有可播放的录音。请先录制您的声音。",
      "failed_to_play_local_audio": "播放本地音频失败:",
      "failed_to_play_recording": "播放录音失败:",
      "practice_result_saved": "练习结果已保存:",
      "no_text_to_speak": "没有要说的文本。",
      "no_recognized_text_to_display_result": "没有可显示结果的已识别文本。",
      "view_my_recordings": "查看我的录音",
      "listen_correct_sentence_tts_your_voice": "听正确句子（用您的声音生成TTS）",
      "pause_recording": "暂停录音",
      "play_your_recording": "播放您的录音",
      "viewResult": "查看结果",
      "playingPersonalizedAudio": "正在播放克隆的语音合成...请仔细听！",
      "correctSentence": "正确句子",
      "speakNow": "现在请说出句子。",
      "listenAndPractice": "按下扬声器图标收听克隆语音合成（TTS）发音，然后按下麦克风说话。",
      "personalizedAudioNotReady": "克隆语音合成（TTS）尚未准备好。请先按下扬声器按钮。",
      "preparingPersonalizedAudio": "正在准备克隆语音合成（TTS）…",
      "personalizedAudioReady": "克隆语音合成（TTS）已准备就绪！",
      "analyzingPronunciation": "录音完成。正在分析您的发音...",
      "listenToCorrectSentence": "听原文",
      "noVoiceFileFoundForPersonalization": "未找到用于个性化语音的用户语音文件。",
      "cannotProceedWithoutVoice": "没有用户语音文件无法进行。",
      "userVoiceFileDoesNotExist": "用户语音文件不存在。",
      "ttsServerError": "TTS 服务器错误 ({statusCode}): {error}",
      "failedToPrepareAudio": "未能准备个性化音频。无法继续练习。",
      "personalizedAudioBeingPrepared": "正在准备个性化发音音频。请稍候。",
      "personalizedAudioNotFoundRecreating": "未找到个性化音频文件。正在重新创建...",
      "playPersonalizedAudioError": "未能播放个性化发音: {error}",
      "personalizedAudioNotReadyToRecord": "个性化音频未准备就绪。请先播放它以生成。",
      "processingRequest": "正在处理您的请求。请稍候。",
      "errorStartingRecording": "开始录音错误: {error}",
      "speechRecognitionFailed": "语音识别失败。",
      "error": "错误: {error}",
      "mfccAudioMissing": "N/A (音频文件缺失或无效。)",
      "speechRecognitionFailedTryAgain": "语音识别失败。请再试一次。",
      "speechRecognitionError": "语音识别错误: {error}",
      "errorDuringSpeechRecognition": "语音识别期间发生错误。",
      "noValidRecordingToPlay": "没有有效的录音可播放。请先录制您的语音。",
      "failedToPlayRecording": "播放录音失败: {error}",
      "pauseYourRecording": "暂停您的录音",
      "playYourRecording": "播放您的录音",
      "noRecognizedText": "没有可显示结果的已识别文本。",
      "pressMicToSpeak": "按下麦克风讲话。",
      "guideListenAndSpeak": "按下扬声器图标收听个性化发音，然后按下麦克风讲话。",
      "analysisCompleteProceedToResult" : "发音分析完成。请查看您的分数！",


      // 발음 연습 결과
      'pronunciationResult': '发音结果',
      'yourSpeech': '您的说话:',
      'aiFeedback': 'AI反馈:',
      "similarityScore": "相似度得分",
      'excellentPronunciationFeedback': '太棒了！发音几乎完美。下一个目标是完美准确！',
      'veryGoodPronunciationFeedback': '非常好！您说得清晰自信。尝试减少小错误。',
      'goodJobPronunciationFeedback': '做得好。您似乎需要在某些部分的发音上多加练习。检查错误类型。',
      'morePracticeNeededFeedback': '需要更多练习。理解每种错误类型并慢慢重试。',
      'omittedAndAddedWordsFeedback': '\n\n您遗漏了一些单词并添加了不必要的单词。请更仔细地听原句。',
      'omittedWordsFeedback': '\n\n您遗漏了一些重要单词。再听一遍原句并检查您遗漏的单词。',
      'addedWordsFeedback': '\n\n您添加了不必要的单词。尝试练习简洁发音。',
      'accuracy': '准确性:',
      'missingWords': '缺失单词 :',
      'deletionLegend': '删除 (答案中有但我没说)',
      'noDeletedWords': '没有删除的单词。',
      'extraWords': '多余单词 :',
      'insertionLegend': '插入 (答案中没有但我添加的)',
      'noAddedWords': '没有添加的单词。',
      'backToPractice': '返回练习',
      "pronunciationResultTitle": "发音结果",
      "originalSentence": "原文:",
      "yourRecognition": "您的识别:",
      "accuracyScores": "准确性分数:",
      "cerCharacterErrorRate": "CER(准确性): {cerValue}",
      "noScoreInformation": "没有分数信息。",
      "practiceAgain": "再次练习",
      "mfcc_Similarity": "MFCC(相似度): {mfccSimilarityScore}",

      //소통하기
      "yourLanguage": "您的语言",
      "tapMicAndSpeak": "点击麦克风开始讲话",
      "translatedKorean": "翻译成韩语",
      "translationWillAppear": "翻译结果将显示在这里。",
      "replayTranslatedText": "重播翻译的文本",
      "startSpeakingInYourLanguage": "请用您的语言开始讲话...",
      "failedToStartRecording": "录音失败: {errorMessage}",
      "noAudioRecorded": "未录制任何音频。",
      "processingAudio": "正在处理音频...",
      "translationFailed": "翻译失败。",
      "translationApiError": "翻译API错误: 状态码 {statusCode}, 响应: {responseBody}",
      "translationNetworkError": "翻译网络错误: {errorMessage}",
      "sttApiError": "STT API错误: 状态码 {statusCode}",
      "sttNetworkError": "STT网络错误: {errorMessage}",
      "ttsApiError": "TTS API错误: 状态码 {statusCode}",
      "ttsNetworkError": "TTS网络错误: {errorMessage}",
      "communicationError": "通信过程中发生错误: {errorMessage}",
      "playingTranslatedText": "正在播放翻译的文本...",
      "noTranslatedTextToPlay": "没有可播放的翻译文本。",
      "english": "英语",
      "chinese": "中文",
      "korean": "韩语",
      "noAudioRecordedMessage": "需要录音。请录制您的声音。",

      // 계정 관리
      'accountManagement': '账户管理',
      'changePassword': '更改密码',
      'changeMajor': '更改专业',

      // 학과 변경
      "changeMajorTitle": "更改专业",
      "noUserLoggedIn": "没有用户登录。",
      "selectCollegeAndDepartment": "请选择学院和专业。",
      "accountInfoUpdatedSuccessfully": "账户信息更新成功。",
      "accountInfoUpdateFailed": "账户信息更新失败。",
      "editPersonalInfo": "编辑个人信息",
      "fullName": "姓名",
      "pleaseSelectCollege": "请选择学院。",
      "pleaseSelectDepartment": "请选择专业。",
      "saveChanges": "保存更改",


      // 비밀번호 변경
      'userInformationNotFound': '未找到用户信息。',
      'passwordChangedSuccessfully': '密码更改成功。',
      'newPasswordMismatch': '新密码和确认密码不匹配。',
      'currentPasswordMismatch': '当前密码不匹配。',
      'userNotFoundLoginAgain': '未找到用户。请重新登录。',
      'authenticationErrorOccurred': '发生身份验证错误。请重试。',
      'weakPassword': '密码太弱。请输入至少6个字符。',
      'failedToChangePassword': '更改密码失败。请重试。',
      'currentPassword': '当前密码',
      'enterCurrentPassword': '请输入您当前的密码。',
      'newPassword': '新密码',
      'enterNewPassword': '请输入新密码。',
      'passwordLengthRequirement': '密码长度必须至少为6个字符。',
      'confirmNewPassword': '确认新密码',
      'reEnterNewPassword': '请重新输入新密码。',
      'changePasswordButton': '更改密码',

      // 자주 묻는 질문
      'frequentlyAskedQuestions': '常见问题',
      'faq1_question': '1. 如何请求发音纠正？',
      'faq1_answer': '要请求发音纠正，请按下“请求发音纠正”按钮。',
      'faq2_question': '2. 如何使用翻译功能？',
      'faq2_answer': '您可以通过按下主屏幕上的“翻译”按钮来使用翻译功能。',
      'faq3_question': '3. 每天可以接受多少次发音纠正？',
      'faq3_answer': '发音纠正服务每天最多可用5次。',

      // 고객/문의하기
      "inquiryFrom": "咨询人",
      "unknownUser": "未知用户",
      'customerSupport': '客户支持',
      'kubiAppInquiry': 'KUBI应用查询',
      'imageAttachedSeparately': '\n\n[图片在邮件应用中单独附加]',
      'inquiryPreparationMessage': '您的查询正在邮件应用中准备。',
      'couldNotLaunchEmailApp': '无法启动邮件应用。',
      'galleryPermissionNeeded': '需要图库访问权限。请在设置中允许权限。',
      'enterYourInquiry': '输入您的查询。',
      'attachScreenshot': '附加截图',
      'attachedScreenshotPreview': '附加截图预览:',
      'sendInquiry': '发送查询',
      'viewFaq': '查看常见问题解答 (FAQ)',
      'usageLimitations': '使用限制',
      'excessiveRequestsLimitationTitle': '📊 过度请求限制',
      'excessiveRequestsLimitationDescription': '如果向服务器发出过多请求，服务访问可能会在一段时间内受到限制。请避免产生过多的流量。',
      'pronunciationCorrectionServiceLimitationTitle': '🛑 发音纠正服务限制',
      'pronunciationCorrectionServiceLimitationDescription': '发音纠正服务每天最多可以使用5次。如果超出，您需要等到第二天。',
      'personalInformationProtectionLimitationTitle': '🔒 个人信息保护限制',
      'personalInformationProtectionLimitationDescription': '如果输入不正确的信息或违反隐私政策，应用访问可能会受到限制。请遵守服务条款。',
      'inappropriateContentBlockingTitle': '🚫 不当内容阻止',
      'inappropriateContentBlockingDescription': '如果输入辱骂性语言或不当内容，服务访问可能会受到限制。',
      'serviceAvailabilityLimitationTitle': '⚠️ 服务可用性限制',
      'serviceAvailabilityLimitationDescription': '某些服务（例如发音纠正）仅在特定时间可用。',
      'customerInquiryContact':"客户咨询\n电子邮件：rlagustj3325@gmail.com\n电话号码：010-9039-3862",

      // 앱 정보
      'appInformation': '应用信息',
      'appVersion': '应用版本',
      'version': '版本 {versionNumber}',

      // 개인, 정보, 마게팅 정보
      "viewMarketingConsent": "查看营销同意",
      'consentSettings': '同意设置',
      'marketingConsentChanged': '营销信息接收同意设置已更改。',
      'ok': '确定',
      'pleaseReviewConsentSettings': '请查看您的同意设置:',
      'termsOfServiceTitle': '服务条款',
      'termsOfServiceDetails': '''本服务条款（以下简称“条款”）适用于 KUBI 应用程序（以下简称“服务”）的所有用户。通过使用本服务，用户即被视为已同意以下条款。请在使用本服务前仔细阅读本条款。

1. 服务提供
本服务提供一个移动应用程序，支持外国学生进行韩语发音纠正和韩语学习。用户可以通过本服务使用发音反馈、语音识别、翻译和查看学业公告等功能。

2. 个人数据处理和使用
本服务仅为学习支持和改进服务目的收集用户个人信息。用户提供的姓名、电子邮件地址、国家和专业等信息将用于提供个性化学习和通信功能。更多详情，请参阅[隐私政策]。

3. 服务使用规定
用户必须仅将本服务的功能用于个人学习目的。
禁止将语音识别、翻译和发音反馈等功能用于非法或不当内容。
本服务提供的所有内容（文本、语音、图像等）均受版权保护，未经许可，用户不得复制或分发。

4. 服务变更和终止
本服务不断改进以方便用户。服务提供商可以随时添加或修改功能，并对由此造成的不便不承担责任。此外，服务提供商可能会根据法律义务暂停服务。

5. 责任限制
尽管本服务努力确保所提供功能的准确性，但对于因技术错误或网络故障引起的问题，本服务不承担责任。用户承担使用本服务相关的所有风险。

6. 用户行为规定
用户在使用本服务时不得从事以下行为：
• 分享不当内容，例如诽谤或冒犯性语言。
• 将本服务用于非法目的。
• 插入可能影响本服务操作的恶意程序或代码。

7. 条款变更
本服务条款可能会根据服务改进或满足法律要求进行修订。条款的更改将通过应用内通知或电子邮件通知用户，用户将被视为已同意修订后的条款。

8. 法律纠纷
与本条款相关的任何争议均受韩国法律管辖，如果发生争议，首尔中央地方法院将作为一审法院。''',
      'viewTermsOfService': '查看服务条款',
      'agreedToTerms': '您已同意服务条款。',
      'notAgreedToTerms': '您未同意服务条款。',
      'privacyPolicyTitle': '隐私政策',
      'privacyPolicyDetails': '''
KUBI 应用收集并处理用户的个人信息，以为外国学生提供韩语学习和发音纠正服务。保护用户的个人信息至关重要，本隐私政策提供了关于如何收集、使用和保护用户个人数据的信息。使用本应用即表示用户同意本政策。

1. 收集的个人信息
- 注册期间：用户的姓名、电子邮件地址、国家、专业等。
- 使用服务期间：在发音纠正、语音识别和翻译服务期间收集的语音数据和文本数据。
- 设备信息：设备类型、操作系统、应用版本等。

2. 个人信息的使用目的
- 提供服务：提供发音纠正、语音识别、翻译功能和学术公告等。
- 个性化学习体验：根据用户的专业、国家和学习偏好提供量身定制的学习材料和反馈。
- 服务改进：分析用户体验以改进应用性能和功能。
- 遵守法律义务：根据法律要求和法规处理个人数据。

3. 个人信息的保留和使用期限
- 个人信息将保留至用户退出服务或删除应用。
- 但是，如果法律义务要求，个人信息可能会保留一段时间。

4. 向第三方提供个人信息
- 个人信息在通常情况下不会向第三方提供。但是，在法律要求时可能会提供。

5. 确保个人信息的安全
- 数据加密：使用加密技术安全保护个人信息。
- 访问控制：个人信息的访问仅限于授权员工和具有必要权限的个人。

6. 用户权利
- 访问和更正：用户可以随时访问和更正其个人信息。
- 同意撤回：用户可以随时撤回对个人数据处理的同意。但是，撤回可能会限制对服务某些功能的访问。
- 删除请求：用户可以请求删除其个人信息，数据将在收到请求后立即删除。

7. 隐私政策的变更
- 本隐私政策可能会更新以改进服务或遵守法律要求。任何更改将通过应用内通知或电子邮件通知用户。
''',
      'viewPrivacyPolicy': '查看隐私政策',
      'agreedToPrivacy': '您已同意隐私政策。',
      'notAgreedToPrivacy': '您未同意隐私政策。',
      'marketingConsentHeader': '营销同意',
      'marketingConsentDetails': '''
KUBI 应用程序可能会出于营销目的收集和使用您的个人信息。这包括发送促销材料、关于应用程序的更新、新功能以及其他相关内容，以改善您的体验。

1. 营销数据收集目的
- 发送促销电子邮件、通知和应用程序相关更新。
- 提供可能对您感兴趣的服务、活动和新闻相关的优惠和信息。
- 根据您在应用程序内的偏好和使用模式改进个性化营销工作。

2. 收集的营销数据类型
- 联系信息：电子邮件地址、电话号码和其他通信方式。
- 使用数据：您在应用程序内的活动，包括使用的功能、偏好和行为。
- 人口统计信息：年龄、位置和语言偏好等信息。

3. 营销数据的使用方式
- 促销电子邮件/通知：我们可能会发送电子邮件或推送通知，告知您关于应用程序的特别优惠、新更新或即将推出的功能。
- 个性化营销：根据您的应用程序使用情况和偏好，我们可能会个性化优惠和通知以适应您的兴趣。

4. 退出营销通信
- 您有权随时选择退出接收营销通信。您可以通过应用程序的设置取消订阅电子邮件或禁用推送通知。
- 如果您选择退出，您仍然可能收到重要的服务相关通信，例如条款更新或系统警报。

5. 与第三方共享营销数据
- 您的营销数据不会在未经您同意的情况下与第三方共享，除非法律要求。

6. 营销数据保留
- 您的营销数据将保留，只要您是应用程序的用户，或者直到您选择退出营销通信。选择退出后，我们将停止将您的数据用于营销目的，但可能会为了服务相关需求而保留。

7. 营销数据使用变更
- 营销数据收集或使用方式的任何更改将通过应用程序内通知或电子邮件进行沟通。
      ''',
      'receiveUpdatesAndPromotionalOffers': '接收更新和促销优惠。',

      // 로그아웃
      'logout': '登出',
      'logoutConfirmationTitle': '登出',
      'logoutConfirmationContent': '您确定要登出吗？',
      'cancellation': '取消',
      'check': '确认',
      "logoutSuccess": "您已成功退出。",
      'loggedOutMessage': '您已登出。',

      // 설정 창
      "settingsScreenTitle": "设置",
      "logoutDialogTitle": "退出登录",
      "logoutDialogContent": "确定要退出登录吗？",
      "noButton": "否",
      "yesButton": "是",
      "logoutFailedMessage": "退出登录失败。请重试。",
      "d"
          "eleteAccountDialogTitle": "注销账户",
      "deleteAccountDialogContent": "确定要注销账户吗？所有数据都将被删除且无法恢复。",
      "accountDeletionComplete": "账户注销完成。",
      "accountDeletionFailed": "账户注销失败。请重试。",
      "reloginRequiredForDeletion": "为了安全，您必须重新登录才能注销账户。",
      "accountAndAppSettingsSection": "账户与应用设置",
      "accountManagementItem": "账户管理",
      "usageGuideSection": "使用指南",
      "appInfoItem": "应用信息",
      "customerSupportItem": "客户支持",
      "otherFeaturesSection": "其他功能",
      "consentSettingsItem": "隐私同意设置",
      "logoutItem": "退出登录",
      "deleteAccountItem": "注销账户",
      "accountDeletionError": "账户删除错误",
      "generalAccountDeletionError": "일반 회원 탈퇴 오류",
      "reauthenticateTitle": "需要重新验证",
      "reauthenticateContent": "出于安全目的，请重新输入您的密码以继续。",
      "passwordLabel": "密码",
      "cancelButton": "取消",
      "confirmButton": "确认",
      "reauthenticationFailed": "重新验证失败。",
      "wrongPassword": "密码错误。请重试。",
      "invalidEmail": "无效的电子邮件。请检查您的电子邮件。",
      "reauthenticationMethodNotSupported": "暂不支持此登录方式的重新验证。",
      "requiresRecentLogin": "此操作需要近期验证。请重新验证。",
      "reauthenticationFailedTryAgain": "重新验证失败。请重试。",
      "guest": "访客",
      "noCollegeSelected": "未选择大学",
      "noDepartmentSelected": "未选择专业",
      "currentDepartment": "当前专业: {department}",
      "currentCollege": "当前学院: {college}",
      "selectNewCollegeAndDepartment": "请选择您新的学院和专业：",
      "selectCollege": "选择学院",
      "changeDepartment": "更改专业",
      "departmentChanged": "专业更改成功！新专业: {major}, 学院: {college}",
      "failedToSaveDepartmentCollege": "保存学院和专业信息失败。请重试。",
      "pleaseSelectDepartmentCollege": "请选择学院和专业。",

      // 학교 지도
      "campusMap": "校园地图",

      //소통해요
      "pronunciationPracticeTitle": "发音练习",
      "viewMyRecordings": "查看我的录音",
      "listenCorrectSentence": "听正确句子 (用你的声音合成)",
      "pressMicToSpeak": "按下麦克风说话。",
      "recordingCompleteSending": "录音完成。正在发送到服务器...",
      "speechRecognitionFailed": "语音识别失败。请重试。",
      "speechRecognitionError": "语音识别错误：",
      "anErrorOccurredDuringSpeechRecognition": "语音识别时发生错误：",
      "noRecordingToPlay": "没有可播放的录音。请先录音。",
      "failedToPlayRecording": "播放录音失败：",
      "pauseRecording": "暂停录音",
      "playYourRecording": "播放你的录音",
      "noRecognizedText": "没有识别到的文本可显示结果。",
      "noTextToSpeak": "没有文本可说。",
      "generatingTTScorrectSentence": "正在为正确句子生成TTS...",
      "correctSentenceAudioGenerated": "正确句子音频已生成。",
      "errorGeneratingAudio": "生成音频时出错：",
      "cerLabel": "CER：",
      "mfccSimilarityLabel": "MFCC 相似度：",
      "notApplicable": "不适用",
      "mfccAudioPathMissing": "不适用（缺少音频路径以进行比较）",
      "enterTextInYourLanguage": "用你的语言输入文本",
      "typeHere": "在此输入...",
      "recordMyVoice": "录制我的声音",
      "translateButton": "翻译",
      "speakButton": "说话",
      "yourInputText": "你的输入文本",
      "translatedText": "翻译后的文本",
      "translating": "正在翻译...",
      "translationComplete": "翻译完成。",
      "noTranslatedTextToSpeak": "没有翻译文本可说。",
      "speaking": "正在说话...",
      "speechComplete": "说话完成。",
      "ttsError": "TTS 错误：",
      "resultPlaceholder": "您的发音评估结果将在此处显示。",

      //지도
      'map1': '江原大学三陟校区地图',
      'close': '关闭',
      'latitude': '纬度',
      'longitude': '经度',

      //tts
      "ttsLoadingAlreadyInProgress": "正在加载中。返回现有Future。",
      "ttsDefaultSpeakerAudioLoadStart": "默认说话人音频文件加载开始：",
      "ttsDefaultSpeakerAudioLoadedTempPath": "默认说话人音频文件已加载到临时路径：",
      "ttsDefaultSpeakerAudioLoadError": "加载默认说话人音频文件时发生严重错误：",
      "ttsTextEmpty": "待转换文本为空。不发送请求。",
      "ttsDefaultSpeakerAudioLoadingWait": "等待默认说话人音频加载完成...",
      "ttsSpeakerAudioFileNotFound": "TTS 服务器要求 speaker_audio 文件，但默认或指定说话人音频文件无效。路径：",
      "ttsAddingSpeakerAudioToRequest": "将说话人音频文件：{filePath}添加到请求中。",
      "ttsMultipartRequestReady": "准备向 TTS 服务器发送 MultipartRequest。文本：\"{text}\"，说话人音频文件：{filePath}",
      "ttsServerUrl": "TTS 服务器 URL：",
      "ttsServerResponseStatusCode": "TTS 服务器响应状态码：",
      "ttsServerResponseContentType": "TTS 服务器响应 Content-Type：",
      "ttsAudioBytesReceivedDirectly": "直接接收音频字节 (Content-Type: {contentType})",
      "ttsServerResponseBodyJson": "TTS 服务器响应体 (JSON)：",
      "ttsBase64DecodedAudioReceived": "Base64 解码后接收音频字节",
      "ttsNoValidAudioContentInJson": "TTS 响应 JSON 中没有有效的音频内容。",
      "ttsUnexpectedContentType": "TTS 服务器返回了意外的 Content-Type：",
      "ttsGeneratedAudioFileSaved": "生成的 TTS 音频文件已保存：",
      "ttsAudioPlaybackStart": "音频播放开始",
      "ttsServerError": "TTS 服务器错误：{statusCode} - {response}",
      "ttsCommunicationOrPlaybackFailedException": "TTS 服务器通信或音频播放失败异常：",
      "ttsCommunicationOrPlaybackFailed": "TTS 服务器通信或音频播放失败：",
      "ttsAudioPlaybackStopped": "当前 TTS 音频播放已停止。",
      "ttsTemporarySpeakerAudioFileDeleted": "临时说话人音频文件已删除：",
      "ttsTemporarySpeakerAudioFileDeleteError": "删除临时说话人音频文件时出错：",
      "ttsGeneratedAudioFileDeleted": "生成的 TTS 音频文件已删除：",
      "ttsGeneratedAudioFileDeleteError": "删除生成的 TTS 音频文件时出错： ",

      //stt
      "microphonePermissionNotGranted": "未授予麦克风权限。",
      "recordingStartFailed": "录音启动失败：",
      "recordingStoppedFilePathNotFound": "录音已停止但未找到文件路径。",
      "recordingStopOrAudioUploadFailed": "录音停止或音频上传失败：",
      "recognitionFailed": "识别失败",
      "sttServerError": "STT 服务器错误：",
      "sttServerCommunicationFailed": "与 STT 服务器通信失败："

    },
  };

  // 이 메소드는 주어진 키에 해당하는 번역된 문자열을 반환합니다.
  // 선택적으로 인자(args) 맵을 받아 문자열 내의 플레이스홀더를 치환합니다.
  String translate(String key, [Map<String, dynamic>? args]) {
    String? text = _localizedValues[locale.languageCode]?[key];
    if (text == null) {
      text = _localizedValues['en']?[key] ?? 'Missing key: $key';
    }

    // 인자 치환 (예: {department} -> 실제 값)
    if (args != null) {
      args.forEach((argKey, argValue) {
        text = text!.replaceAll('{${argKey}}', argValue.toString());
      });
    }
    return text!;
  }
}

// 이 델리게이트는 일반적으로 flutter gen-l10n으로 자동 생성됩니다.
// AppLocalizationsDelegate.dart 파일에 있어야 합니다.
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // 지원하는 언어 코드 목록을 여기에 추가
    return ['en', 'ko', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}