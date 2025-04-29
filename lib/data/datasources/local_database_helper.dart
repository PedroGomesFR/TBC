import "package:sqflite/sqflite.dart";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "mytuberculose.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade, // Add if schema changes later
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dosage TEXT,
        frequency TEXT,
        instructions TEXT,
        sideEffects TEXT,
        interactions TEXT,
        stock INTEGER -- Added stock column
      )
      """);

    await db.execute("""
      CREATE TABLE treatment_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicationId INTEGER NOT NULL,
        date TEXT NOT NULL, -- Store as ISO8601 string
        status TEXT NOT NULL, -- e.g., 'taken', 'skipped', 'reported'
        notes TEXT,
        FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE
      )
      """);

    await db.execute("""
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        specialty TEXT,
        date TEXT NOT NULL, -- Store as ISO8601 string
        notes TEXT
      )
      """);

    await db.execute("""
      CREATE TABLE quiz_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        score INTEGER NOT NULL,
        totalQuestions INTEGER NOT NULL
      )
      """);

    // TODO: Add table for reminders?
    // TODO: Add table for user profile?

    print("Database tables created");

    // TODO: Optionally pre-populate medications table here if needed
    // await _prepopulateMedications(db);
  }

  // Example pre-population (adjust as needed)
  // Future<void> _prepopulateMedications(Database db) async {
  //   await db.insert("medications", {
  //     "name": "Isoniazide",
  //     "dosage": "300mg",
  //     "frequency": "1 fois par jour",
  //     "stock": 30 // Example initial stock
  //   });
  //   await db.insert("medications", {
  //     "name": "Rifampicine",
  //     "dosage": "600mg",
  //     "frequency": "1 fois par jour",
  //     "stock": 30
  //   });
  //   // Add other standard TB meds
  //   print("Medications table prepopulated");
  // }

  // TODO: Implement _onUpgrade if schema changes in future versions
  // Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < 2) {
  //     // await db.execute("ALTER TABLE medications ADD COLUMN new_column TEXT;");
  //   }
  // }
}

