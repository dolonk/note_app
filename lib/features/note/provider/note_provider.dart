import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../data_layer/domain/use_cases/local_note_use_case.dart';
import '../../../data_layer/model/note_model.dart';
import '../../../data_layer/domain/use_cases/remote_note_use_case.dart';
import '../../../utils/enum/note_enum.dart';
import '../../../utils/network_manager/network_manager.dart';

class NoteProvider with ChangeNotifier {
  final RemoteNoteUseCase _remoteUseCase = sl<RemoteNoteUseCase>();
  final LocalNoteUseCase _localUseCase = sl<LocalNoteUseCase>();

  List<NoteModel> _notes = [];

  // ✅ Enum-based states
  NoteFetchState _fetchState = NoteFetchState.initial;
  NoteOperationState _operationState = NoteOperationState.idle;

  String? _error;

  List<NoteModel> get notes => _notes;
  NoteFetchState get fetchState => _fetchState;
  NoteOperationState get operationState => _operationState;
  String? get error => _error;

  late StreamSubscription<bool> _connectivitySubscription;

  /// 🟢 Initialize Auto Sync
  void initializeAutoSync(String userId) {
    _connectivitySubscription = InternetManager.instance.isConnectedStream.listen((isConnected) {
      if (isConnected) {
        syncUnsyncedNotes(userId);
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  /// 🟢 Add Note
  Future<void> addNote(NoteModel note) async {
    _operationState = NoteOperationState.creating;
    _error = null;
    notifyListeners();

    try {
      final offlineNote = note.copyWith(isSynced: false);
      await _localUseCase.addNote(offlineNote);
      _notes.insert(0, offlineNote);
      notifyListeners();

      final isConnected = await InternetManager.instance.isConnected();
      if (isConnected) {

        print("offlineNote: ${offlineNote.toJson()}");
        await _remoteUseCase.addNote(offlineNote);
        final syncedNote = offlineNote.copyWith(isSynced: true);


        await _localUseCase.updateNote(syncedNote);
        _notes[_notes.indexWhere((n) => n.id == note.id)] = syncedNote;
      }

      print('Data save successfully');
      _operationState = NoteOperationState.success;
    } catch (e) {
      _operationState = NoteOperationState.error;
      _error = "Failed to add note";
    }

    notifyListeners();
  }

  /// 🟢 Update Note
  Future<void> updateNote(NoteModel note) async {
    _operationState = NoteOperationState.updating;
    _error = null;
    notifyListeners();

    try {
      final offlineNote = note.copyWith(isSynced: false);
      await _localUseCase.updateNote(offlineNote);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) _notes[index] = offlineNote;
      notifyListeners();

      final isConnected = await InternetManager.instance.isConnected();
      if (isConnected) {
        await _remoteUseCase.updateNote(offlineNote);
        final syncedNote = offlineNote.copyWith(isSynced: true);
        await _localUseCase.updateNote(syncedNote);
        _notes[index] = syncedNote;
      }

      _operationState = NoteOperationState.success;
    } catch (e) {
      _operationState = NoteOperationState.error;
      _error = "Failed to update note";
    }

    notifyListeners();
  }

  /// 🟢 Delete Note
  Future<void> deleteNote(String noteId) async {
    _operationState = NoteOperationState.deleting;
    _error = null;
    notifyListeners();

    try {
      await _localUseCase.deleteNote(noteId);
      _notes.removeWhere((n) => n.id == noteId);
      notifyListeners();

      final isConnected = await InternetManager.instance.isConnected();
      if (isConnected) {
        await _remoteUseCase.deleteNote(noteId);
      }

      _operationState = NoteOperationState.success;
    } catch (e) {
      _operationState = NoteOperationState.error;
      _error = "Failed to delete note";
    }

    notifyListeners();
  }

  /// 🟢 Sync All
  Future<void> syncUnsyncedNotes(String userId) async {
    _operationState = NoteOperationState.syncing;
    notifyListeners();

    try {
      final unsyncedNotes = _notes.where((n) => !n.isSynced).toList();

      for (final note in unsyncedNotes) {
        await _remoteUseCase.addNote(note);
        final syncedNote = note.copyWith(isSynced: true);
        await _localUseCase.updateNote(syncedNote);
        final index = _notes.indexWhere((n) => n.id == note.id);
        if (index != -1) _notes[index] = syncedNote;
      }

      _operationState = NoteOperationState.success;
    } catch (e) {
      _operationState = NoteOperationState.error;
      _error = "Sync failed: $e";
    }

    notifyListeners();
  }

  /// 🟢 Fetch Notes
  Future<void> fetchNotes(String userId) async {
    _fetchState = NoteFetchState.loading;
    _error = null;
    notifyListeners();

    try {
      _notes = await _remoteUseCase.getAllNotes(userId);
      _fetchState = NoteFetchState.success;
    } catch (_) {
      try {
        _notes = await _localUseCase.getAllNotes('');
        _fetchState = NoteFetchState.success;
      } catch (e) {
        _fetchState = NoteFetchState.error;
        _error = "Failed to load notes locally.";
      }
    }

    notifyListeners();
  }

  NoteModel? getNoteById(String id) {
    try {
      return _notes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<NoteModel?> getNoteByIdOffline(String noteId) async {
    try {
      return await _localUseCase.getNoteById(noteId);
    } catch (_) {
      return null;
    }
  }
}
