import '../domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    super.id,
    super.userId,
    required super.title,
    required super.content,
    required super.tags,
    required super.priority,
    required super.color,
    super.reminderDate,
    required super.createdAt,
    super.isSynced = false,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String?,
      userId: json['user_id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tags: json['tags'] ?? '',
      priority: json['priority'] ?? '',
      color: json['color'] ?? 0,
      reminderDate: json['reminder_date'] != null ? DateTime.parse(json['reminder_date']) : null,
      createdAt: DateTime.parse(json['created_at']),
      isSynced: json['is_synced'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'content': content,
      'tags': tags,
      'priority': priority,
      'color': color,
      'reminder_date': reminderDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
    };
  }

  NoteModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? tags,
    String? priority,
    int? color,
    DateTime? reminderDate,
    DateTime? createdAt,
    bool? isSynced,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      reminderDate: reminderDate ?? this.reminderDate,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
