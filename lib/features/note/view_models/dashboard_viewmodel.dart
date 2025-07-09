import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../provider/note_provider.dart';
import '../../../core/di/service_locator.dart';

class DashboardViewModel with ChangeNotifier {
  final NoteProvider _noteProvider = sl<NoteProvider>();
  final userId = Supabase.instance.client.auth.currentUser?.id ?? '';

  Future<void> fetchNotes() async {
    await _noteProvider.fetchAndMergeNotes(userId);
  }

  Future<void> deleteNote(String noteId) async {
    await _noteProvider.deleteNote(noteId);
  }

  void initSync() {
    _noteProvider.initializeAutoSync(userId);
  }
}
