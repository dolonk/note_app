import '../../model/note_model.dart';
import '../repositories/notes/note_repository.dart';

class NoteUseCase {
  final NoteRepository repository;

  NoteUseCase(this.repository);

  Future<void> addNote(NoteModel note) => repository.addNote(note);

  Future<void> updateNote(NoteModel note) => repository.updateNote(note);

  Future<List<NoteModel>> getAllNotes(String userId) => repository.getAllNotes(userId);

  Future<NoteModel?> getNoteById(String noteId) => repository.getNoteById(noteId);

  Future<void> deleteNote(String noteId) => repository.deleteNote(noteId);
}
