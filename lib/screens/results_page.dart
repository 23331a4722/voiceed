import 'package:flutter/material.dart';
import 'package:voiceed/screens/dashboard_page.dart';
import 'package:voiceed/services/voice_service.dart';

class ResultsPage extends StatefulWidget {
  final String examTitle;
  final double score;
  final int totalQuestions;
  final int correctAnswers;

  const ResultsPage({super.key, required this.examTitle, required this.score, required this.totalQuestions, required this.correctAnswers});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> with SingleTickerProviderStateMixin {
  final _voiceService = VoiceService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnimation = CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
    _animationController.forward();
    
    _announceResults();
  }

  Future<void> _announceResults() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final message = 'Results for ${widget.examTitle}. You scored ${widget.score.toStringAsFixed(1)} percent. You answered ${widget.correctAnswers} out of ${widget.totalQuestions} questions correctly. ${_getPerformanceFeedback()}';
    await _voiceService.speak(message);
  }

  String _getPerformanceFeedback() {
    if (widget.score >= 90) {
      return 'Outstanding performance! Excellent work!';
    } else if (widget.score >= 75) {
      return 'Great job! Well done!';
    } else if (widget.score >= 60) {
      return 'Good effort! Keep practicing!';
    } else {
      return 'Keep learning and try again!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final passed = widget.score >= 60;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              passed ? const Color(0xFF10B981) : theme.colorScheme.error,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: Center(
                        child: Icon(
                          passed ? Icons.check_circle : Icons.cancel,
                          size: 100,
                          color: passed ? const Color(0xFF10B981) : theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text('Exam Complete!', style: theme.textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(widget.examTitle, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9)), textAlign: TextAlign.center),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Column(
                      children: [
                        Text('Your Score', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
                        const SizedBox(height: 16),
                        Text('${widget.score.toStringAsFixed(1)}%', style: theme.textTheme.displayLarge?.copyWith(color: passed ? const Color(0xFF10B981) : theme.colorScheme.error, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: 24),
                        ResultRow(label: 'Total Questions', value: widget.totalQuestions.toString()),
                        const SizedBox(height: 16),
                        ResultRow(label: 'Correct Answers', value: widget.correctAnswers.toString(), valueColor: const Color(0xFF10B981)),
                        const SizedBox(height: 16),
                        ResultRow(label: 'Incorrect Answers', value: (widget.totalQuestions - widget.correctAnswers).toString(), valueColor: theme.colorScheme.error),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: passed ? const Color(0xFF10B981).withValues(alpha: 0.1) : theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(_getPerformanceFeedback(), style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: passed ? const Color(0xFF10B981) : theme.colorScheme.error), textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _voiceService.stop();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashboardPage()), (route) => false);
                      },
                      icon: const Icon(Icons.home, size: 28),
                      label: const Text('Back to Dashboard'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _voiceService.stop();
    super.dispose();
  }
}

class ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const ResultRow({super.key, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
        Text(value, style: theme.textTheme.titleLarge?.copyWith(color: valueColor ?? theme.colorScheme.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
