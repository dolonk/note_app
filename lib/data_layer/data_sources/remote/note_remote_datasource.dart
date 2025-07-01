import '../../model/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteNoteDataSource {
  final SupabaseClient client;

  RemoteNoteDataSource(this.client);

  Future<void> addNote(NoteModel note) async {
    await client.from('notes').insert(note.toJson());
  }

  Future<void> deleteNote(String noteId) async {
    await client.from('notes').delete().eq('id', noteId);
  }

  Future<void> updateNote(NoteModel note) async {
    if (note.id == null) throw Exception("Note ID is required for update");

    await client.from('notes').update(note.toJson()).eq('id', note.id!);
  }

  Future<List<NoteModel>> getAllNotes(String userId) async {
    final response = await client
        .from('notes')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => NoteModel.fromJson(e)).toList();
  }

  Future<NoteModel?> getNoteById(String noteId) async {
    final response = await client.from('notes').select().eq('id', noteId).maybeSingle();
    if (response == null) return null;
    return NoteModel.fromJson(response);
  }
}
