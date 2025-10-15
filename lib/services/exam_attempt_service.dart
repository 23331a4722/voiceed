import 'dart:convert';
import 'package:voiceed/models/exam_attempt.dart';
import 'package:voiceed/services/local_storage_service.dart';

class ExamAttemptService {
  static final ExamAttemptService _instance = ExamAttemptService._internal();
  factory ExamAttemptService() => _instance;
  ExamAttemptService._internal();

  static const String _attemptsKey = 'exam_attempts';

  Future<void> initialize() async {
    final storage = await LocalStorageService.getInstance();
    final attemptsData = storage.getString(_attemptsKey);
    if (attemptsData == null) {
      await storage.saveData(_attemptsKey, '[]');
    }
  }

  Future<List<ExamAttempt>> getAttemptsByUserId(String userId) async {
    final storage = await LocalStorageService.getInstance();
    final attemptsData = storage.getString(_attemptsKey) ?? '[]';
    final List attemptsList = jsonDecode(attemptsData);
    return attemptsList.map((a) => ExamAttempt.fromJson(a)).where((a) => a.userId == userId).toList();
  }

  Future<List<ExamAttempt>> getAttemptsByExamId(String examId) async {
    final storage = await LocalStorageService.getInstance();
    final attemptsData = storage.getString(_attemptsKey) ?? '[]';
    final List attemptsList = jsonDecode(attemptsData);
    return attemptsList.map((a) => ExamAttempt.fromJson(a)).where((a) => a.examId == examId).toList();
  }

  Future<void> createAttempt(ExamAttempt attempt) async {
    final storage = await LocalStorageService.getInstance();
    final attemptsData = storage.getString(_attemptsKey) ?? '[]';
    final List attemptsList = jsonDecode(attemptsData);
    attemptsList.add(attempt.toJson());
    await storage.saveData(_attemptsKey, jsonEncode(attemptsList));
  }

  Future<void> updateAttempt(ExamAttempt attempt) async {
    final storage = await LocalStorageService.getInstance();
    final attemptsData = storage.getString(_attemptsKey) ?? '[]';
    final List attemptsList = jsonDecode(attemptsData);
    final index = attemptsList.indexWhere((a) => a['id'] == attempt.id);
    if (index != -1) {
      attemptsList[index] = attempt.toJson();
      await storage.saveData(_attemptsKey, jsonEncode(attemptsList));
    }
  }

  Future<ExamAttempt?> getAttemptById(String id) async {
    final storage = await LocalStorageService.getInstance();
    final attemptsData = storage.getString(_attemptsKey) ?? '[]';
    final List attemptsList = jsonDecode(attemptsData);
    try {
      final attemptJson = attemptsList.firstWhere((a) => a['id'] == id);
      return ExamAttempt.fromJson(attemptJson);
    } catch (e) {
      return null;
    }
  }
}
