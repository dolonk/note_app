class NoteEntity {
  final String? id;
  final String? userId;
  final String title;
  final String content;
  final String tags;
  final String priority;
  final int color;
  final DateTime? reminderDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  NoteEntity({
    this.id,
    this.userId,
    required this.title,
    required this.content,
    required this.tags,
    required this.priority,
    required this.color,
    this.reminderDate,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });
}
