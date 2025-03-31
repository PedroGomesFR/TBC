import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'treatment_screen.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'treatments.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE treatments(
        id INTEGER PRIMARY KEY,
        name TEXT,
        image TEXT,
        description TEXT,
        reminderTime TEXT
      )
    ''');
  }

  Future<void> insertTreatment(Treatment treatment, String reminderTime) async {
    Database db = await database;
    await db.insert(
      'treatments',
      {
        'name': treatment.name,
        'image': treatment.image,
        'description': treatment.description,
        'reminderTime': reminderTime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTreatments() async {
    Database db = await database;
    return await db.query('treatments');
  }

  Future<void> deleteTreatment(int id) async {
    Database db = await database;
    await db.delete(
      'treatments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
