import 'dart:io';

import 'package:notes_app/core/model/notes_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static DatabaseService? _databaseService;
  static Database? _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colColor = 'color';
  String colDate = 'date';

  DatabaseService._createInstance();

  factory DatabaseService() {
    _databaseService ??= DatabaseService._createInstance();

    return _databaseService!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();

    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes.db';

    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);

    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colColor INTEGER, $colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await database;

    var result = await db.query(noteTable, orderBy: '$colPriority ASC');

    return result;
  }

  Future<int> insertNote(NotesModel note) async {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());

    return result;
  }

  Future<int> updateNote(NotesModel notesModel) async {
    var db = await database;
    var result = await db.update(
      noteTable,
      notesModel.toMap(),
      where: '$colId = ?',
      whereArgs: [notesModel.id],
    );
    return result;
  }

  Future<int> deleteNote(int id) async {
    var db = await database;

    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');

    return result;
  }

  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $noteTable');

    int result = Sqflite.firstIntValue(x) ?? 0;

    return result;
  }

  Future<List<NotesModel>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<NotesModel> noteList = [];

    for (int i = 0; i < count; i++) {
      noteList.add(NotesModel.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
