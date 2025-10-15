class Exam {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'duration_minutes': durationMinutes,
    'created_by': createdBy,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    durationMinutes: json['duration_minutes'] as int,
    createdBy: json['created_by'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Exam copyWith({String? id, String? title, String? description, int? durationMinutes, String? createdBy, DateTime? createdAt, DateTime? updatedAt}) => Exam(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
