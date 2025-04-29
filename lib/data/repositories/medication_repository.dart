import 
'package:mytuberculose_app/data/datasources/local_database_helper.dart';
import 'package:mytuberculose_app/data/models/medication_model.dart';

class MedicationRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Insert predefined medications into the database if they don't exist
  Future<void> populateInitialMedications() async {
    final db = await _dbHelper.database;
    // Check if the table is empty before inserting
    final List<Map<String, dynamic>> existing = await db.query('medications', limit: 1);
    if (existing.isEmpty) {
      print('Populating initial medications into the database...');
      for (var med in predefinedMedications) {
        await db.insert('medications', med.toMap());
      }
      print('Initial medications populated.');
    }
  }

  // Get all medications from the database
  Future<List<Medication>> getAllMedications() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('medications');

    // Convert the List<Map<String, dynamic> into a List<Medication>.
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }

  // Insert a new medication
  Future<int> insertMedication(Medication medication) async {
    final db = await _dbHelper.database;
    // Use toMap to convert Medication object to Map for insertion
    return await db.insert('medications', medication.toMap());
  }

  // Update a medication
  Future<int> updateMedication(Medication medication) async {
    final db = await _dbHelper.database;
    return await db.update(
      'medications',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  // Delete a medication
  Future<int> deleteMedication(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get a single medication by ID (useful for detail view)
  Future<Medication?> getMedicationById(int id) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Medication.fromMap(maps.first);
    }
    return null;
  }
}

