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
        description TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY,
        treatmentId INTEGER,
        reminderTime TEXT,
        FOREIGN KEY (treatmentId) REFERENCES treatments(id)
      )
    ''');
  }

  Future<void> insertTreatment(Treatment treatment) async {
    Database db = await database;
    int treatmentId = await db.insert(
      'treatments',
      {
        'name': treatment.name,
        'image': treatment.image,
        'description': treatment.description,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    for (var time in treatment.reminders) {
      await db.insert(
        'reminders',
        {
          'treatmentId': treatmentId,
          'reminderTime': '${time.hour}:${time.minute}',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<Map<Treatment, List<String>>> getTreatmentsWithReminders() async {
    Database db = await database;
    List<Map<String, dynamic>> treatments = await db.query('treatments');
    Map<Treatment, List<String>> treatmentMap = {};

    for (var treatmentData in treatments) {
      Treatment treatment = Treatment.fromMap(treatmentData);

      List<Map<String, dynamic>> reminders = await db.query(
        'reminders',
        where: 'treatmentId = ?',
        whereArgs: [treatmentData['id']],
      );

      List<String> reminderTimes = reminders
          .map((reminder) => reminder['reminderTime'] as String)
          .toList();

      treatmentMap[treatment] = reminderTimes;
    }

    return treatmentMap;
  }

  Future<void> deleteTreatment(int id) async {
    Database db = await database;
    await db.delete(
      'treatments',
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'reminders',
      where: 'treatmentId = ?',
      whereArgs: [id],
    );
  }
}
