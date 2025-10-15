class Question {
  final String id;
  final String examId;
  final String text;
  final List<String> options;
  final String correctAnswer;
  final DateTime createdAt;
  final DateTime updatedAt;

  Question({
    required this.id,
    required this.examId,
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'exam_id': examId,
    'text': text,
    'options': options,
    'correct_answer': correctAnswer,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'] as String,
    examId: json['exam_id'] as String,
    text: json['text'] as String,
    options: List<String>.from(json['options'] as List),
    correctAnswer: json['correct_answer'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Question copyWith({String? id, String? examId, String? text, List<String>? options, String? correctAnswer, DateTime? createdAt, DateTime? updatedAt}) => Question(
    id: id ?? this.id,
    examId: examId ?? this.examId,
    text: text ?? this.text,
    options: options ?? this.options,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
