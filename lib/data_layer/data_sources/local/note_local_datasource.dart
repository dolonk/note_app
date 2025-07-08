import 'dart:async';
import 'package:path/path.dart';
import '../../model/note_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalNoteDataSource {
  Future<void> insertNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<List<NoteModel>> getAllNotes();
  Future<NoteModel?> getNoteById(String noteId);
  Future<void> deleteNote(String id);
}

class LocalNoteDataSourceImpl implements LocalNoteDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Init if null
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE notes(
            id TEXT PRIMARY KEY,
            user_id TEXT,
            title TEXT,
            content TEXT,
            tags TEXT,
            priority TEXT,
            color INTEGER,
            reminder_date TEXT,
            created_at TEXT,
            updated_at TEXT,
            is_synced INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  @override
  Future<void> insertNote(NoteModel note) async {
    final db = await database;
    await db.insert('notes', {'id': note.id, ...note.toJson()}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    final db = await database;
    await db.update('notes', note.toJson(), where: 'id = ?', whereArgs: [note.id]);
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes', orderBy: 'created_at DESC');

    return maps.map((json) => NoteModel.fromJson(json)).toList();
  }

  @override
  Future<NoteModel?> getNoteById(String noteId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes', where: 'id = ?', whereArgs: [noteId], limit: 1);

    if (maps.isNotEmpty) {
      return NoteModel.fromJson(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
