import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../data_layer/model/note_model.dart';
import '../../../data_layer/domain/use_cases/note_usecase.dart';

class NoteProvider with ChangeNotifier {
  final NoteUseCase _noteUseCase = sl<NoteUseCase>();

  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 🟢 Fetch all notes for a user
  Future<void> fetchNotes(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _notes = await _noteUseCase.getAllNotes(userId);
    } catch (e) {
      _error = "Failed to load notes";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🟢 Add a new note
  Future<void> addNote(NoteModel note) async {
    try {
      await _noteUseCase.addNote(note);
      _notes.insert(0, note); // Add to top
      notifyListeners();
    } catch (e) {
      _error = "Failed to add note";
      notifyListeners();
    }
  }

  /// 🟢 Update existing note
  Future<void> updateNote(NoteModel note) async {
    try {
      await _noteUseCase.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
        notifyListeners();
      }
    } catch (e) {
      _error = "Failed to update note";
      notifyListeners();
    }
  }

  /// 🟢 Delete a note
  Future<void> deleteNote(String noteId) async {
    try {
      await _noteUseCase.deleteNote(noteId);
      _notes.removeWhere((n) => n.id == noteId);
      notifyListeners();
    } catch (e) {
      _error = "Failed to delete note";
      notifyListeners();
    }
  }

  /// 🟢 Get a single note by ID
  NoteModel? getNoteById(String id) {
    return _notes.firstWhere(
      (n) => n.id == id,
      orElse:
          () => NoteModel(id: '', title: '', content: '', tags: '', priority: '', color: 0, createdAt: DateTime.now()),
    );
  }
}
