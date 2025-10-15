import 'package:flutter/material.dart';
import 'package:voiceed/models/exam.dart';
import 'package:voiceed/models/question.dart';
import 'package:voiceed/services/exam_service.dart';
import 'package:voiceed/services/question_service.dart';
import 'package:voiceed/services/voice_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _examService = ExamService();
  final _voiceService = VoiceService();
  List<Exam> _exams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExams();
    _voiceService.speak('Admin Panel. Manage your exams and questions.');
  }

  Future<void> _loadExams() async {
    final exams = await _examService.getAllExams();
    setState(() {
      _exams = exams;
      _isLoading = false;
    });
  }

  void _showCreateExamDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final durationController = TextEditingController(text: '30');

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text('Create New Exam', style: theme.textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Exam Title', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Duration (minutes)', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                  final now = DateTime.now();
                  final exam = Exam(
                    id: 'exam_${now.millisecondsSinceEpoch}',
                    title: titleController.text,
                    description: descController.text,
                    durationMinutes: int.tryParse(durationController.text) ?? 30,
                    createdBy: '1',
                    createdAt: now,
                    updatedAt: now,
                  );
                  await _examService.createExam(exam);
                  Navigator.pop(context);
                  _loadExams();
                  _voiceService.speak('Exam created successfully');
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel', style: theme.textTheme.titleLarge), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [theme.colorScheme.secondary.withValues(alpha: 0.05), theme.colorScheme.surface],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [theme.colorScheme.secondary, theme.colorScheme.tertiary]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.admin_panel_settings, size: 48, color: Colors.white),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Exam Management', style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('${_exams.length} exams created', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('All Exams', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
                        IconButton(
                          onPressed: _showCreateExamDialog,
                          icon: const Icon(Icons.add_circle),
                          iconSize: 32,
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_exams.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(48),
                          child: Text('No exams created yet', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey)),
                        ),
                      )
                    else
                      ..._exams.map((exam) => AdminExamCard(
                        exam: exam,
                        onDelete: () async {
                          await _examService.deleteExam(exam.id);
                          _loadExams();
                          _voiceService.speak('Exam deleted');
                        },
                      )),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateExamDialog,
        icon: const Icon(Icons.add),
        label: const Text('Create Exam'),
        backgroundColor: theme.colorScheme.secondary,
      ),
    );
  }
}

class AdminExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback onDelete;

  const AdminExamCard({super.key, required this.exam, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.secondary.withValues(alpha: 0.3), width: 2),
        boxShadow: [BoxShadow(color: theme.colorScheme.secondary.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(exam.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Exam'),
                      content: const Text('Are you sure you want to delete this exam?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            onDelete();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
                color: theme.colorScheme.error,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(exam.description, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.timer, size: 18, color: theme.colorScheme.secondary),
              const SizedBox(width: 6),
              Text('${exam.durationMinutes} minutes', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary)),
              const SizedBox(width: 20),
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text('Created ${_formatDate(exam.createdAt)}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
