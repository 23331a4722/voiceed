import 'dart:convert';
import 'package:voiceed/models/exam.dart';
import 'package:voiceed/services/local_storage_service.dart';

class ExamService {
  static final ExamService _instance = ExamService._internal();
  factory ExamService() => _instance;
  ExamService._internal();

  static const String _examsKey = 'exams';

  Future<void> initialize() async {
    final storage = await LocalStorageService.getInstance();
    final examsData = storage.getString(_examsKey);
    
    if (examsData == null) {
      final now = DateTime.now();
      final sampleExams = [
        Exam(id: 'exam1', title: 'General Knowledge Quiz', description: 'Test your general knowledge with this comprehensive quiz covering various topics.', durationMinutes: 30, createdBy: '1', createdAt: now, updatedAt: now),
        Exam(id: 'exam2', title: 'Science Fundamentals', description: 'Explore the basic principles of science including physics, chemistry, and biology.', durationMinutes: 45, createdBy: '1', createdAt: now, updatedAt: now),
        Exam(id: 'exam3', title: 'Mathematics Assessment', description: 'Evaluate your mathematical skills with problems ranging from basic arithmetic to algebra.', durationMinutes: 60, createdBy: '1', createdAt: now, updatedAt: now),
      ];
      await storage.saveData(_examsKey, jsonEncode(sampleExams.map((e) => e.toJson()).toList()));
    }
  }

  Future<List<Exam>> getAllExams() async {
    final storage = await LocalStorageService.getInstance();
    final examsData = storage.getString(_examsKey) ?? '[]';
    final List examsList = jsonDecode(examsData);
    return examsList.map((e) => Exam.fromJson(e)).toList();
  }

  Future<Exam?> getExamById(String id) async {
    final exams = await getAllExams();
    try {
      return exams.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createExam(Exam exam) async {
    final storage = await LocalStorageService.getInstance();
    final exams = await getAllExams();
    exams.add(exam);
    await storage.saveData(_examsKey, jsonEncode(exams.map((e) => e.toJson()).toList()));
  }

  Future<void> updateExam(Exam exam) async {
    final storage = await LocalStorageService.getInstance();
    final exams = await getAllExams();
    final index = exams.indexWhere((e) => e.id == exam.id);
    if (index != -1) {
      exams[index] = exam;
      await storage.saveData(_examsKey, jsonEncode(exams.map((e) => e.toJson()).toList()));
    }
  }

  Future<void> deleteExam(String id) async {
    final storage = await LocalStorageService.getInstance();
    final exams = await getAllExams();
    exams.removeWhere((e) => e.id == id);
    await storage.saveData(_examsKey, jsonEncode(exams.map((e) => e.toJson()).toList()));
  }
}
