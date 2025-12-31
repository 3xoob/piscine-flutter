import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'note_model.dart';

class Database {
  static const String _dbFileName = 'database.db';
  static const String _noteTable = 'notes';

  static const String _createNoteTableQuery = '''
CREATE TABLE $_noteTable(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  date TEXT NOT NULL
)
''';

  sqflite.Database? _db;

  /// Creates (or opens) the SQLite database and ensures the Note table exists.
  Future<void> create() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dbPath = p.join(dir.path, _dbFileName);

    _db = await sqflite.openDatabase(
      dbPath,
      version: 1,
      onCreate: (sqflite.Database db, int version) async {
        await db.execute(_createNoteTableQuery);
      },
    );
  }

  sqflite.Database get _database {
    final db = _db;
    if (db == null) {
      throw StateError(
        'Database has not been created. Call create() before using it.',
      );
    }
    return db;
  }

  Future<List<Note>> getAllNotes() async {
    final List<Map<String, dynamic>> rows =
        await _database.query(_noteTable, orderBy: 'date DESC, id DESC');
    return rows.map(Note.fromMap).toList();
  }

  Future<void> deleteAllNotes() async {
    await _database.delete(_noteTable);
  }

  Future<Note> addNote({required Note note}) async {
    final noteMap = note.toMap()..remove('id');
    final int id = await _database.insert(_noteTable, noteMap);
    return note.copyWith(id: id);
  }

  Future<int> deleteNote({required Note note}) async {
    if (note.id == null) {
      return 0;
    }
    return _database.delete(
      _noteTable,
      where: 'id = ?',
      whereArgs: <Object?>[note.id],
    );
  }

  Future<int> updateNote({
    required Note oldNote,
    required Note newNote,
  }) async {
    if (oldNote.id == null) {
      return 0;
    }

    final Map<String, dynamic> updatedMap =
        newNote.copyWith(id: oldNote.id).toMap()..remove('id');

    return _database.update(
      _noteTable,
      updatedMap,
      where: 'id = ?',
      whereArgs: <Object?>[oldNote.id],
    );
  }

  Future<void> close() async {
    final db = _db;
    if (db != null && db.isOpen) {
      await db.close();
      _db = null;
    }
  }
}

