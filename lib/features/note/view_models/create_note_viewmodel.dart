import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../provider/note_provider.dart';
import '../../../utils/enum/note_enum.dart';
import '../../../core/di/service_locator.dart';
import '../../../data_layer/model/note_model.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateNoteViewModel extends ChangeNotifier {
  final NoteModel? existingNote;

  CreateNoteViewModel(this.existingNote) {
    if (existingNote != null) {
      titleController.text = existingNote!.title;
      contentController.text = existingNote!.content;
      tagController.text = existingNote!.tags;
      priority = existingNote!.priority;
      selectedColor = Color(existingNote!.color);
      reminderDate = existingNote!.reminderDate;
    }
  }

  final noteProvider = sl<NoteProvider>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final tagController = TextEditingController();

  String priority = 'Normal';
  Color selectedColor = Colors.yellow.shade100;
  DateTime? reminderDate;

  void pickColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  void pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      reminderDate = picked;
      notifyListeners();
    }
  }

  void submitNote(BuildContext context) {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    final tags = tagController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      DSnackBar.warning(title: 'Title and Content are required');
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      DSnackBar.error(title: "User not logged in");
      return;
    }

    final isEditing = existingNote != null;

    final note = NoteModel(
      id: isEditing ? existingNote!.id : const Uuid().v4(),
      userId: userId,
      title: title,
      content: content,
      tags: tags,
      priority: priority,
      color: selectedColor.toARGB32(),
      reminderDate: reminderDate,
      createdAt: isEditing ? existingNote!.createdAt : DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    final action = isEditing ? noteProvider.updateNote(note) : noteProvider.addNote(note);

    action.then((_) {
      if (!context.mounted) return;

      final state = noteProvider.operationState;
      if (state == NoteOperationState.success) {
        DSnackBar.success(title: isEditing ? "✅ Note updated!" : "✅ Note created!");
        if (!isEditing)
          _reset();
        else
          Navigator.pop(context);
      } else if (state == NoteOperationState.error) {
        DSnackBar.error(title: noteProvider.error ?? "❌ Failed to ${isEditing ? "update" : "create"} note.");
      }
    });
  }

  void _reset() {
    titleController.clear();
    contentController.clear();
    tagController.clear();
    priority = 'Normal';
    selectedColor = Colors.yellow.shade100;
    reminderDate = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    tagController.dispose();
    super.dispose();
  }
}
