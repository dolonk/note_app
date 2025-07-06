import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../../../core/di/service_locator.dart';
import '../provider/note_provider.dart';
import '../../../utils/enum/note_enum.dart';
import '../../../data_layer/model/note_model.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateNoteViewModel extends ChangeNotifier {
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

    final newNote = NoteModel(
      id: const Uuid().v4(),
      userId: Supabase.instance.client.auth.currentUser?.id,
      title: title,
      content: content,
      tags: tags,
      priority: priority,
      color: selectedColor.value,
      reminderDate: reminderDate,
      createdAt: DateTime.now(),
    );

    noteProvider.addNote(newNote).then((_) {
      if (!context.mounted) return;
      if (noteProvider.operationState == NoteOperationState.success) {
        DSnackBar.success(title: "✅ Note created!");
        _reset();
      } else if (noteProvider.operationState == NoteOperationState.error) {
        DSnackBar.error(title: noteProvider.error ?? "❌ Failed to create note.");
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
