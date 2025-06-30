import 'note_repository.dart';
import '../../../model/note_model.dart';
import '../../../data_sources/remote/note_remote_datasource.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource remote;

  NoteRepositoryImpl(this.remote);

  @override
  Future<void> addNote(NoteModel note) => remote.addNote(note);

  @override
  Future<void> updateNote(NoteModel note) => remote.updateNote(note);

  @override
  Future<List<NoteModel>> getAllNotes(String userId) => remote.getAllNotes(userId);

  @override
  Future<NoteModel?> getNoteById(String noteId) => remote.getNoteById(noteId);

  @override
  Future<void> deleteNote(String noteId) => remote.deleteNote(noteId);
}
