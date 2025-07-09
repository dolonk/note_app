import '../../../../model/note_model.dart';

abstract class RemoteNoteRepository {
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<List<NoteModel>> getAllNotes(String userId);
  Future<void> deleteNote(String noteId);
}
