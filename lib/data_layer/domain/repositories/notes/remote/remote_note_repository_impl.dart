import 'remote_note_repository.dart';
import 'package:flutter/foundation.dart';
import '../../../../model/note_model.dart';
import '../../../../data_sources/remote/note_remote_datasource.dart';
import '../../../../../utils/exceptions/supabase_exception_handler.dart';

class RemoteNoteRepositoryImpl implements RemoteNoteRepository {
  final RemoteNoteDataSource remote;

  RemoteNoteRepositoryImpl(this.remote);

  @override
  Future<void> addNote(NoteModel note) async {
    try {
      await remote.addNote(note);
    } catch (e) {
      final error = SupabaseExceptionHandler.parse(e);
      debugPrint("📝 Add Note Error: $error");
      throw Exception(error);
    }
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    try {
      await remote.updateNote(note);
    } catch (e) {
      final error = SupabaseExceptionHandler.parse(e);
      debugPrint("📝 Update Note Error: $error");
      throw Exception(error);
    }
  }

  @override
  Future<List<NoteModel>> getAllNotes(String userId) async {
    try {
      return await remote.getAllNotes(userId);
    } catch (e) {
      final error = SupabaseExceptionHandler.parse(e);
      debugPrint("📒 Get All Notes Error: $error");
      throw Exception(error);
    }
  }

  @override
  Future<void> deleteNote(String noteId) async {
    try {
      await remote.deleteNote(noteId);
    } catch (e) {
      final error = SupabaseExceptionHandler.parse(e);
      debugPrint("🗑️ Delete Note Error: $error");
      throw Exception(error);
    }
  }
}
