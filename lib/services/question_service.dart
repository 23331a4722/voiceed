import 'dart:convert';
import 'package:voiceed/models/question.dart';
import 'package:voiceed/services/local_storage_service.dart';

class QuestionService {
  static final QuestionService _instance = QuestionService._internal();
  factory QuestionService() => _instance;
  QuestionService._internal();

  static const String _questionsKey = 'questions';

  Future<void> initialize() async {
    final storage = await LocalStorageService.getInstance();
    final questionsData = storage.getString(_questionsKey);
    
    if (questionsData == null) {
      final now = DateTime.now();
      final sampleQuestions = [
        Question(id: 'q1', examId: 'exam1', text: 'What is the capital of France?', options: ['London', 'Paris', 'Berlin', 'Madrid'], correctAnswer: 'Paris', createdAt: now, updatedAt: now),
        Question(id: 'q2', examId: 'exam1', text: 'Which planet is known as the Red Planet?', options: ['Venus', 'Mars', 'Jupiter', 'Saturn'], correctAnswer: 'Mars', createdAt: now, updatedAt: now),
        Question(id: 'q3', examId: 'exam1', text: 'What is the largest ocean on Earth?', options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'], correctAnswer: 'Pacific', createdAt: now, updatedAt: now),
        Question(id: 'q4', examId: 'exam1', text: 'Who wrote Romeo and Juliet?', options: ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'], correctAnswer: 'William Shakespeare', createdAt: now, updatedAt: now),
        Question(id: 'q5', examId: 'exam1', text: 'What is the smallest prime number?', options: ['0', '1', '2', '3'], correctAnswer: '2', createdAt: now, updatedAt: now),
        Question(id: 'q6', examId: 'exam2', text: 'What is the chemical symbol for water?', options: ['O2', 'H2O', 'CO2', 'H2'], correctAnswer: 'H2O', createdAt: now, updatedAt: now),
        Question(id: 'q7', examId: 'exam2', text: 'What force keeps us on the ground?', options: ['Magnetism', 'Electricity', 'Gravity', 'Friction'], correctAnswer: 'Gravity', createdAt: now, updatedAt: now),
        Question(id: 'q8', examId: 'exam2', text: 'What is the process by which plants make food?', options: ['Respiration', 'Photosynthesis', 'Digestion', 'Fermentation'], correctAnswer: 'Photosynthesis', createdAt: now, updatedAt: now),
        Question(id: 'q9', examId: 'exam3', text: 'What is 15 multiplied by 8?', options: ['120', '125', '115', '130'], correctAnswer: '120', createdAt: now, updatedAt: now),
        Question(id: 'q10', examId: 'exam3', text: 'What is the square root of 144?', options: ['10', '11', '12', '13'], correctAnswer: '12', createdAt: now, updatedAt: now),
      ];
      await storage.saveData(_questionsKey, jsonEncode(sampleQuestions.map((q) => q.toJson()).toList()));
    }
  }

  Future<List<Question>> getQuestionsByExamId(String examId) async {
    final storage = await LocalStorageService.getInstance();
    final questionsData = storage.getString(_questionsKey) ?? '[]';
    final List questionsList = jsonDecode(questionsData);
    return questionsList.map((q) => Question.fromJson(q)).where((q) => q.examId == examId).toList();
  }

  Future<void> createQuestion(Question question) async {
    final storage = await LocalStorageService.getInstance();
    final questionsData = storage.getString(_questionsKey) ?? '[]';
    final List questionsList = jsonDecode(questionsData);
    questionsList.add(question.toJson());
    await storage.saveData(_questionsKey, jsonEncode(questionsList));
  }

  Future<void> updateQuestion(Question question) async {
    final storage = await LocalStorageService.getInstance();
    final questionsData = storage.getString(_questionsKey) ?? '[]';
    final List questionsList = jsonDecode(questionsData);
    final index = questionsList.indexWhere((q) => q['id'] == question.id);
    if (index != -1) {
      questionsList[index] = question.toJson();
      await storage.saveData(_questionsKey, jsonEncode(questionsList));
    }
  }

  Future<void> deleteQuestion(String id) async {
    final storage = await LocalStorageService.getInstance();
    final questionsData = storage.getString(_questionsKey) ?? '[]';
    final List questionsList = jsonDecode(questionsData);
    questionsList.removeWhere((q) => q['id'] == id);
    await storage.saveData(_questionsKey, jsonEncode(questionsList));
  }
}
