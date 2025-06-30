import 'local_note_repository.dart';
import '../../../../model/note_model.dart';
import '../../../../data_sources/local/note_local_datasource.dart';

class LocalNoteRepositoryImpl implements LocalNoteRepository {
  final LocalNoteDataSource localDataSource;

  LocalNoteRepositoryImpl(this.localDataSource);

  @override
  Future<void> addNote(NoteModel note) async {
    await localDataSource.insertNote(note);
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    await localDataSource.updateNote(note);
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    return await localDataSource.getAllNotes();
  }

  @override
  Future<NoteModel?> getNoteById(String noteId) {
    return localDataSource.getNoteById(noteId);
  }

  @override
  Future<void> deleteNote(String id) async {
    await localDataSource.deleteNote(id);
  }
}
