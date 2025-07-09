import '../../model/note_model.dart';
import '../repositories/notes/remote/remote_note_repository.dart';

class RemoteNoteUseCase {
  final RemoteNoteRepository repository;

  RemoteNoteUseCase(this.repository);

  Future<void> addNote(NoteModel note) => repository.addNote(note);

  Future<void> updateNote(NoteModel note) => repository.updateNote(note);

  Future<List<NoteModel>> getAllNotes(String userId) => repository.getAllNotes(userId);

  Future<void> deleteNote(String noteId) => repository.deleteNote(noteId);
}
