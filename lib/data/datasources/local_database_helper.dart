import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'mytuberculose.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade, // Add if schema changes later
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    // TODO: Define table schemas based on requirements (Phase 1, task 1.11)
    // Example: Medications table
    await db.execute('''
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dosage TEXT,
        photo_path TEXT, // Store path to locally saved image
        frequency TEXT,
        instructions TEXT,
        side_effects TEXT,
        interactions TEXT
      )
    ''');

    // Example: Treatment History table
    await db.execute('''
      CREATE TABLE treatment_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medication_id INTEGER,
        date TEXT NOT NULL, -- Store as ISO8601 string
        status TEXT NOT NULL, -- e.g., 'taken', 'skipped', 'reported'
        notes TEXT,
        FOREIGN KEY (medication_id) REFERENCES medications (id)
      )
    ''');

    // Example: Appointments table
    await db.execute('''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL, -- e.g., 'medical_consultation', 'blood_test', 'clat_followup'
        specialty TEXT, -- e.g., 'pneumologist', 'generalist'
        date TEXT NOT NULL, -- Store as ISO8601 string
        notes TEXT
      )
    ''');

    // Example: Medication Stock table
    await db.execute('''
      CREATE TABLE medication_stock (
        medication_id INTEGER PRIMARY KEY,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (medication_id) REFERENCES medications (id)
      )
    ''');

    // Example: Quiz Scores table
    await db.execute('''
      CREATE TABLE quiz_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL, -- Store as ISO8601 string
        score INTEGER NOT NULL,
        total_questions INTEGER NOT NULL
      )
    ''');

    // Add other tables as needed (e.g., user_preferences, info_progress)
    print("Database tables created");
  }

  // --- CRUD Operations (Examples - to be implemented later) ---

  // Example: Insert medication
  Future<int> insertMedication(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('medications', row);
  }

  // Example: Query all medications
  Future<List<Map<String, dynamic>>> queryAllMedications() async {
    Database db = await database;
    return await db.query('medications');
  }

  // Add more CRUD operations for other tables as features are developed
}

