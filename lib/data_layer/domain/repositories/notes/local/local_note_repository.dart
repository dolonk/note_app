import '../../../../model/note_model.dart';

abstract class LocalNoteRepository {
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<List<NoteModel>> getAllNotes();
  Future<void> deleteNote(String id);
}
