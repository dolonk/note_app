import 'dart:async';
import 'package:flutter/material.dart';
import '../../../utils/enum/note_enum.dart';
import '../../../../core/di/service_locator.dart';
import '../../../data_layer/model/note_model.dart';
import '../../../utils/network_manager/network_manager.dart';
import '../../../data_layer/domain/use_cases/local_note_use_case.dart';
import '../../../data_layer/domain/use_cases/remote_note_use_case.dart';

class NoteProvider with ChangeNotifier {
  final RemoteNoteUseCase _remoteUseCase = sl<RemoteNoteUseCase>();
  final LocalNoteUseCase _localUseCase = sl<LocalNoteUseCase>();

  List<NoteModel> _notes = [];
  NoteFetchState _fetchState = NoteFetchState.initial;
  NoteOperationState _operationState = NoteOperationState.idle;
  String? _error;

  List<NoteModel> get notes => _notes;
  NoteFetchState get fetchState => _fetchState;
  NoteOperationState get operationState => _operationState;
  String? get error => _error;

  StreamSubscription<bool>? _connectivitySubscription;

  /// 🧠 DRY helper
  Future<void> _runIfOnline(Future<void> Function() task) async {
    if (await InternetManager.instance.isConnected()) {
      await task();
    }
  }

  /// 🟢 Add Note
  Future<void> addNote(NoteModel note) async {
    _operationState = NoteOperationState.creating;
    _error = null;
    notifyListeners();

    try {
      final offlineNote = note.copyWith(isSynced: false, updatedAt: DateTime.now().toUtc());

      await _localUseCase.addNote(offlineNote);
      _notes.insert(0, offlineNote);

      await _runIfOnline(() async {
        await _remoteUseCase.addNote(offlineNote);
        final syncedNote = offlineNote.copyWith(isSynced: true);
        await _localUseCase.updateNote(syncedNote);

        final index = _notes.indexWhere((n) => n.id == note.id);
        if (index != -1) {
          _notes[index] = syncedNote;
        }
      });

      _operationState = NoteOperationState.success;
    } catch (e) {
      _operationState = NoteOperationState.error;
      _error = "Failed to add note: $e";
    }

    notifyListeners();
  }

  /// 🟢 Update Note
  Future<void> updateNote(NoteModel note) async {
    _operationState = NoteOperationState.updating;
    _error = null;
    notifyListeners();

    try {
      final offlineNote = note.copyWith(isSynced: false, updatedAt: DateTime.now().toUtc());

      await _localUseCase.updateNote(offlineNote);

      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) _notes[index] = offlineNote;

      await _runIfOnline(() async {
        await _remoteUseCase.updateNote(offlineNote);
        final syncedNote = offlineNote.copyWith(isSynced: true);
        await _localUseCase.updateNote(syncedNote);

        if (index != -1) _notes[index] = syncedNote;
      });

      _operationState = NoteOperationState.success;
    } catch (e) {
      _operationState = NoteOperationState.error;
      _error = "Failed to update note: $e";
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

      await _runIfOnline(() async {
        await _remoteUseCase.deleteNote(noteId);
      });

      _operationState = NoteOperationState.success;
    } catch (e) {
      _operationState = NoteOperationState.error;
      _error = "Failed to delete note: $e";
    }

    notifyListeners();
  }

  /// 🟢 Initialize Auto Sync
  void initializeAutoSync(String userId) {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = InternetManager.instance.isConnectedStream.listen((isConnected) {
      debugPrint("🌐 Connectivity Changed: $isConnected");
      if (isConnected) {
        debugPrint("🚀 Internet available. Attempting auto-sync...");
        syncUnsyncedNotes(userId);
      }
    });
  }

  /// 🟢 Sync Unsynced Notes
  Future<void> syncUnsyncedNotes(String userId) async {
    _operationState = NoteOperationState.syncing;
    notifyListeners();

    try {
      final allNotes = await _localUseCase.getAllNotes(userId);
      final unsyncedNotes = allNotes.where((n) => !n.isSynced).toList();

      debugPrint("📤 Found ${unsyncedNotes.length} unsynced notes");

      if (unsyncedNotes.isEmpty) {
        _operationState = NoteOperationState.success;
        debugPrint("✅ No unsynced notes found.");
        notifyListeners();
        return;
      }

      for (final note in unsyncedNotes) {
        await _remoteUseCase.addNote(note);
        final syncedNote = note.copyWith(isSynced: true);
        await _localUseCase.updateNote(syncedNote);

        final index = _notes.indexWhere((n) => n.id == note.id);
        if (index != -1) {
          _notes[index] = syncedNote;
        } else {
          _notes.insert(0, syncedNote);
        }
      }

      _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      _operationState = NoteOperationState.success;
    } catch (e) {
      _operationState = NoteOperationState.error;
      _error = "Sync failed: $e";
    }

    notifyListeners();
  }

  /// 🟢 Fetch & Merge Notes
  Future<void> fetchAndMergeNotes(String userId) async {
    _fetchState = NoteFetchState.loading;
    _error = null;

    List<NoteModel> localNotes = [];

    try {
      localNotes = await _localUseCase.getAllNotes(userId);
      final remoteNotes = await _remoteUseCase.getAllNotes(userId);

      debugPrint("📲 Remote notes: ${remoteNotes.length}");
      debugPrint("💾 Local notes: ${localNotes.length}");

      final Map<String, NoteModel> mergedMap = {for (var note in localNotes) note.id!: note};

      for (final remoteNote in remoteNotes) {
        final localNote = mergedMap[remoteNote.id!];

        if (localNote == null) {
          mergedMap[remoteNote.id!] = remoteNote;
          await _localUseCase.addNote(remoteNote);
        } else {
          if (remoteNote.updatedAt.isAfter(localNote.updatedAt)) {
            await _localUseCase.updateNote(remoteNote);
            mergedMap[remoteNote.id!] = remoteNote;
          } else if (localNote.updatedAt.isAfter(remoteNote.updatedAt)) {
            await _remoteUseCase.updateNote(localNote);
            mergedMap[localNote.id!] = localNote;
          }
        }
      }

      _notes = mergedMap.values.toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      _fetchState = NoteFetchState.success;
      debugPrint("✅ Final merged notes: ${_notes.length}");
    } catch (e) {
      _fetchState = NoteFetchState.error;
      _error = "⚠️ Merge failed: $e";

      try {
        _notes = localNotes;
        _fetchState = NoteFetchState.success;
        debugPrint("📴 Fallback local notes: ${_notes.length}");
      } catch (e) {
        _fetchState = NoteFetchState.error;
        _error = "Failed to load fallback notes: $e";
      }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
