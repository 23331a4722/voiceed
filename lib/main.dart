import 'package:flutter/material.dart';
import 'package:voiceed/screens/dashboard_page.dart';
import 'package:voiceed/screens/landing_page.dart';
import 'package:voiceed/services/auth_service.dart';
import 'package:voiceed/services/exam_attempt_service.dart';
import 'package:voiceed/services/exam_service.dart';
import 'package:voiceed/services/question_service.dart';
import 'package:voiceed/services/voice_service.dart';
import 'package:voiceed/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeServices();
  runApp(const MyApp());
}

Future<void> _initializeServices() async {
  await VoiceService().initialize();
  await AuthService().initialize();
  await ExamService().initialize();
  await QuestionService().initialize();
  await ExamAttemptService().initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return MaterialApp(
      title: 'VoiceEd - Inclusive Exams for All',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: authService.isLoggedIn ? const DashboardPage() : const LandingPage(),
    );
  }
}
