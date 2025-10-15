import 'package:flutter/material.dart';
import 'package:voiceed/models/exam.dart';
import 'package:voiceed/theme.dart';
import 'package:voiceed/services/question_service.dart';

class ExamCard extends StatefulWidget {
  final Exam exam;
  final VoidCallback onTap;

  const ExamCard({super.key, required this.exam, required this.onTap});

  @override
  State<ExamCard> createState() => _ExamCardState();
}

class _ExamCardState extends State<ExamCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  int _questionCount = 0;
  final _questionService = QuestionService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _loadQuestionCount();
  }

  Future<void> _loadQuestionCount() async {
    final questions = await _questionService.getQuestionsByExamId(widget.exam.id);
    if (mounted) {
      setState(() {
        _questionCount = questions.length;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceMD),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: (_) {
                setState(() => _isPressed = true);
                _controller.forward();
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);
                _controller.reverse();
                widget.onTap();
              },
              onTapCancel: () {
                setState(() => _isPressed = false);
                _controller.reverse();
              },
              child: Container(
                padding: EdgeInsets.all(AppDimensions.spaceLG),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                  border: Border.all(
                    color: _isPressed 
                        ? theme.colorScheme.primary.withValues(alpha: 0.4)
                        : theme.colorScheme.primary.withValues(alpha: 0.1),
                    width: _isPressed ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isPressed
                          ? theme.colorScheme.primary.withValues(alpha: 0.15)
                          : theme.colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: _isPressed ? 15 : 10,
                      offset: Offset(0, _isPressed ? 8 : 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primaryContainer,
                            theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.quiz_rounded,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: AppDimensions.spaceLG),
                    
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.exam.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppDimensions.spaceSM),
                          Text(
                            widget.exam.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppDimensions.spaceMD),
                          
                          // Duration and Questions Info
                          Row(
                            children: [
                              _buildInfoChip(
                                icon: Icons.access_time_rounded,
                                label: '${widget.exam.durationMinutes} min',
                                theme: theme,
                              ),
                              SizedBox(width: AppDimensions.spaceSM),
                              _buildInfoChip(
                                icon: Icons.quiz_outlined,
                                label: '$_questionCount questions',
                                theme: theme,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppDimensions.spaceMD),
                    
                    // Arrow Icon
                    Container(
                      padding: EdgeInsets.all(AppDimensions.spaceSM),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical: AppDimensions.spaceSM,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.secondary,
          ),
          SizedBox(width: AppDimensions.spaceSM),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}