import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../data_layer/domain/use_cases/local_note_use_case.dart';
import '../../../data_layer/model/note_model.dart';
import '../../../data_layer/domain/use_cases/remote_note_use_case.dart';

class NoteProvider with ChangeNotifier {
  final RemoteNoteUseCase _remoteUseCase = sl<RemoteNoteUseCase>();
  final LocalNoteUseCase _localUseCase = sl<LocalNoteUseCase>();

  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 🟢 Add Note: save locally first → then sync remotely
  Future<void> addNote(NoteModel note) async {
    try {
      await _localUseCase.addNote(note);
      _notes.insert(0, note);
      notifyListeners();

      await _remoteUseCase.addNote(note); // try syncing
    } catch (e) {
      _error = "Failed to add note";
      notifyListeners();
    }
  }

  /// 🟢 Update Note
  Future<void> updateNote(NoteModel note) async {
    try {
      await _localUseCase.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) _notes[index] = note;
      notifyListeners();

      await _remoteUseCase.updateNote(note);
    } catch (e) {
      _error = "Failed to update note";
      notifyListeners();
    }
  }

  /// 🟢 Delete Note
  Future<void> deleteNote(String noteId) async {
    try {
      await _localUseCase.deleteNote(noteId);
      _notes.removeWhere((n) => n.id == noteId);
      notifyListeners();

      await _remoteUseCase.deleteNote(noteId);
    } catch (e) {
      _error = "Failed to delete note";
      notifyListeners();
    }
  }

  /// 🟢 Get a note by ID (in-memory)
  NoteModel? getNoteById(String id) {
    return _notes.firstWhere(
      (n) => n.id == id,
      orElse:
          () => NoteModel(
            id: '',
            title: '',
            content: '',
            tags: '',
            priority: '',
            color: 0,
            createdAt: DateTime.now(),
          ),
    );
  }

  /// 🟢 Fetch all notes: remote first → fallback to local
  Future<void> fetchNotes(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notes = await _remoteUseCase.getAllNotes(userId);
    } catch (e) {
      try {
        _notes = await _localUseCase.getAllNotes('');
      } catch (e) {
        _error = "Failed to load notes locally.";
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🟢 Get a note by ID (local DB)
  Future<NoteModel?> getNoteByIdOffline(String noteId) async {
    try {
      return await _localUseCase.getNoteById(noteId);
    } catch (_) {
      return null;
    }
  }
}
