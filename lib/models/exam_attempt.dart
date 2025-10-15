class ExamAttempt {
  final String id;
  final String userId;
  final String examId;
  final Map<String, String> answers;
  final double score;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExamAttempt({
    required this.id,
    required this.userId,
    required this.examId,
    required this.answers,
    required this.score,
    this.startedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'exam_id': examId,
    'answers': answers,
    'score': score,
    'started_at': startedAt?.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory ExamAttempt.fromJson(Map<String, dynamic> json) => ExamAttempt(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    examId: json['exam_id'] as String,
    answers: Map<String, String>.from(json['answers'] as Map),
    score: (json['score'] as num).toDouble(),
    startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
    completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  ExamAttempt copyWith({String? id, String? userId, String? examId, Map<String, String>? answers, double? score, DateTime? startedAt, DateTime? completedAt, DateTime? createdAt, DateTime? updatedAt}) => ExamAttempt(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    examId: examId ?? this.examId,
    answers: answers ?? this.answers,
    score: score ?? this.score,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt ?? this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
