import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static late final DatabaseHelper _instance;
  static late Database _db;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance = DatabaseHelper._internal();
    return _instance;
  }

  Future<Database> get db async {
    _db = await initDatabase();
    return _db;
  }

  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'students.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Student (
            id INTEGER PRIMARY KEY,
            nama TEXT,
            nim TEXT,
            mata_kuliah TEXT,
            nilai_uas REAL,
            nilai_uts REAL,
            nilai_tugas REAL
          )
        ''');
      },
    );
  }

  Future<void> insertStudent(Map<String, dynamic> studentData) async {
    Database db = await this.db;
    await db.insert('Student', studentData);
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    Database db = await this.db;
    return db.query('Student');
  }

  Future<void> deleteStudent(int id) async {
    Database db = await this.db;
    await db.delete(
      'Student',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateStudent(int id, Map<String, dynamic> newData) async {
    Database db = await this.db;
    await db.update(
      'Student',
      newData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
