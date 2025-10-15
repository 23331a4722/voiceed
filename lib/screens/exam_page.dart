import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voiceed/models/exam.dart';
import 'package:voiceed/models/exam_attempt.dart';
import 'package:voiceed/models/question.dart';
import 'package:voiceed/screens/results_page.dart';
import 'package:voiceed/services/auth_service.dart';
import 'package:voiceed/services/exam_attempt_service.dart';
import 'package:voiceed/services/question_service.dart';
import 'package:voiceed/services/voice_service.dart';

class ExamPage extends StatefulWidget {
  final Exam exam;
  const ExamPage({super.key, required this.exam});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final _questionService = QuestionService();
  final _attemptService = ExamAttemptService();
  final _authService = AuthService();
  final _voiceService = VoiceService();
  
  List<Question> _questions = [];
  int _currentIndex = 0;
  Map<String, String> _answers = {};
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isLoading = true;
  bool _isListening = false;
  String? _attemptId;

  @override
  void initState() {
    super.initState();
    _loadExam();
  }

  Future<void> _loadExam() async {
    await _questionService.initialize();
    await _attemptService.initialize();
    
    final questions = await _questionService.getQuestionsByExamId(widget.exam.id);
    final user = _authService.currentUser;
    
    if (user != null) {
      final now = DateTime.now();
      final attempt = ExamAttempt(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.id,
        examId: widget.exam.id,
        answers: {},
        score: 0,
        startedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      await _attemptService.createAttempt(attempt);
      _attemptId = attempt.id;
    }
    
    setState(() {
      _questions = questions;
      _remainingSeconds = widget.exam.durationMinutes * 60;
      _isLoading = false;
    });
    
    _startTimer();
    await _speakCurrentQuestion();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _remainingSeconds--);
      
      if (_remainingSeconds == 300) {
        _voiceService.speak('5 minutes remaining');
      } else if (_remainingSeconds == 60) {
        _voiceService.speak('1 minute remaining');
      } else if (_remainingSeconds <= 0) {
        _submitExam();
      }
    });
  }

  Future<void> _speakCurrentQuestion() async {
    if (_currentIndex >= _questions.length) return;
    
    final question = _questions[_currentIndex];
    final questionText = 'Question ${_currentIndex + 1} of ${_questions.length}. ${question.text}. Options are: A, ${question.options[0]}. B, ${question.options[1]}. C, ${question.options[2]}. D, ${question.options[3]}. Say the option letter to answer.';
    await _voiceService.speak(questionText);
  }

  void _handleVoiceCommand(String command) {
    final cmd = command.toLowerCase().trim();
    
    if (cmd.contains('next') || cmd.contains('next question')) {
      _nextQuestion();
    } else if (cmd.contains('previous') || cmd.contains('previous question')) {
      _previousQuestion();
    } else if (cmd.contains('repeat') || cmd.contains('repeat question')) {
      _speakCurrentQuestion();
    } else if (cmd.contains('submit') || cmd.contains('end exam') || cmd.contains('finish')) {
      _submitExam();
    } else if (cmd.contains('help')) {
      _speakHelp();
    } else if (cmd.contains('option a') || cmd == 'a' || cmd == 'option a') {
      _selectAnswer(0);
    } else if (cmd.contains('option b') || cmd == 'b' || cmd == 'option b') {
      _selectAnswer(1);
    } else if (cmd.contains('option c') || cmd == 'c' || cmd == 'option c') {
      _selectAnswer(2);
    } else if (cmd.contains('option d') || cmd == 'd' || cmd == 'option d') {
      _selectAnswer(3);
    }
  }

  void _selectAnswer(int optionIndex) {
    if (_currentIndex >= _questions.length) return;
    
    final question = _questions[_currentIndex];
    setState(() => _answers[question.id] = question.options[optionIndex]);
    _voiceService.speak('Answer ${String.fromCharCode(65 + optionIndex)} selected');
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
      _speakCurrentQuestion();
    } else {
      _voiceService.speak('This is the last question');
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _speakCurrentQuestion();
    } else {
      _voiceService.speak('This is the first question');
    }
  }

  Future<void> _speakHelp() async {
    await _voiceService.speak('Available commands: Say Next question. Previous question. Repeat question. Option A, B, C, or D to answer. Submit answer. End exam.');
  }

  Future<void> _submitExam() async {
    _timer?.cancel();
    
    double score = 0;
    for (var question in _questions) {
      if (_answers[question.id] == question.correctAnswer) {
        score++;
      }
    }
    
    final percentage = (_questions.isNotEmpty) ? (score / _questions.length) * 100 : 0.0;
    
    if (_attemptId != null) {
      final attempt = await _attemptService.getAttemptById(_attemptId!);
      if (attempt != null) {
        final updated = attempt.copyWith(
          answers: _answers,
          score: percentage.toDouble(),
          completedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _attemptService.updateAttempt(updated);
      }
    }
    
    await _voiceService.speak('Exam submitted. Your score is ${percentage.toStringAsFixed(1)} percent');
    
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultsPage(
        examTitle: widget.exam.title,
        score: percentage.toDouble(),
        totalQuestions: _questions.length,
        correctAnswers: score.toInt(),
      )));
    }
  }

  void _toggleListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _voiceService.startListening((result) {
        _handleVoiceCommand(result);
        setState(() => _isListening = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Exam')),
        body: const Center(child: Text('No questions available for this exam')),
      );
    }
    
    final question = _questions[_currentIndex];
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.title, style: theme.textTheme.titleLarge),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _remainingSeconds < 300 ? theme.colorScheme.errorContainer : theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer, color: _remainingSeconds < 300 ? theme.colorScheme.error : theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_currentIndex + 1) / _questions.length, minHeight: 6),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Question ${_currentIndex + 1} of ${_questions.length}', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3), width: 2),
                    ),
                    child: Text(question.text, style: theme.textTheme.headlineSmall),
                  ),
                  const SizedBox(height: 32),
                  ...List.generate(question.options.length, (index) {
                    final option = question.options[index];
                    final isSelected = _answers[question.id] == option;
                    return OptionButton(
                      label: String.fromCharCode(65 + index),
                      text: option,
                      isSelected: isSelected,
                      onTap: () => _selectAnswer(index),
                    );
                  }),
                ],
              ),
            ),
          ),
          VoiceCommandHints(isListening: _isListening),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _currentIndex > 0 ? _previousQuestion : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton.large(
                  onPressed: _toggleListening,
                  backgroundColor: _isListening ? theme.colorScheme.error : theme.colorScheme.secondary,
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentIndex < _questions.length - 1 ? _nextQuestion : _submitExam,
                    icon: Icon(_currentIndex < _questions.length - 1 ? Icons.arrow_forward : Icons.check),
                    label: Text(_currentIndex < _questions.length - 1 ? 'Next' : 'Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _voiceService.stop();
    super.dispose();
  }
}

class OptionButton extends StatelessWidget {
  final String label;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({super.key, required this.label, required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(label, style: theme.textTheme.titleLarge?.copyWith(color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(text, style: theme.textTheme.bodyLarge?.copyWith(color: isSelected ? Colors.white : theme.colorScheme.onSurface))),
            ],
          ),
        ),
      ),
    );
  }
}

class VoiceCommandHints extends StatelessWidget {
  final bool isListening;
  const VoiceCommandHints({super.key, required this.isListening});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isListening ? Icons.hearing : Icons.mic_off, size: 20, color: theme.colorScheme.tertiary),
              const SizedBox(width: 8),
              Text(isListening ? 'Listening...' : 'Voice Commands Available', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.tertiary)),
            ],
          ),
          if (!isListening) ...[
            const SizedBox(height: 8),
            Text('Say: "Option A/B/C/D", "Next", "Previous", "Repeat", "Submit"', style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic), textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}
