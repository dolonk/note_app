import '../../model/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteNoteDataSource {
  final SupabaseClient client;

  RemoteNoteDataSource(this.client);

  Future<void> addNote(NoteModel note) async {
    await client.from('notes').upsert(note.toJson());
  }

  Future<void> updateNote(NoteModel note) async {
    if (note.id == null) throw Exception("Note ID is required for update");

    await client.from('notes').update(note.toJson()).eq('id', note.id!);
  }

  Future<void> deleteNote(String noteId) async {
    await client.from('notes').delete().eq('id', noteId);
  }

  Future<List<NoteModel>> getAllNotes(String userId) async {
    final response = await client
        .from('notes')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => NoteModel.fromJson(e)).toList();
  }
}
