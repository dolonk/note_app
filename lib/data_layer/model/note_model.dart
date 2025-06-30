import '../domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    super.id,
    required super.title,
    required super.content,
    required super.tags,
    required super.priority,
    required super.color,
    super.reminderDate,
    required super.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String?,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tags: json['tags'] ?? '',
      priority: json['priority'] ?? '',
      color: json['color'] ?? 0,
      reminderDate: json['reminder_date'] != null ? DateTime.parse(json['reminder_date']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'tags': tags,
      'priority': priority,
      'color': color,
      'reminder_date': reminderDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
