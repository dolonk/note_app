import '../../model/note_model.dart';
import 'package:note_app/data_layer/domain/repositories/notes/local/local_note_repository.dart';

class LocalNoteUseCase {
  final LocalNoteRepository localRepository;

  LocalNoteUseCase(this.localRepository);

  Future<void> addNote(NoteModel note) => localRepository.addNote(note);

  Future<void> updateNote(NoteModel note) => localRepository.updateNote(note);

  Future<List<NoteModel>> getAllNotes(String userId) => localRepository.getAllNotes();

  Future<NoteModel?> getNoteById(String noteId) => localRepository.getNoteById(noteId);

  Future<void> deleteNote(String noteId) => localRepository.deleteNote(noteId);
}
