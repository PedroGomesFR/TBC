import 
"package:mytuberculose_app/data/datasources/local_database_helper.dart";
import "package:mytuberculose_app/data/models/medication_model.dart";

class MedicationRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Add a new medication
  Future<int> addMedication(Medication medication) async {
    final db = await _dbHelper.database;
    return await db.insert("medications", medication.toMap());
  }

  // Get all medications
  Future<List<Medication>> getAllMedications() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query("medications");
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }

  // Get a single medication by ID
  Future<Medication?> getMedicationById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "medications",
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Medication.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Update a medication
  Future<int> updateMedication(Medication medication) async {
    final db = await _dbHelper.database;
    return await db.update(
      "medications",
      medication.toMap(),
      where: "id = ?",
      whereArgs: [medication.id],
    );
  }

  // Decrement stock for a medication
  Future<int> decrementMedicationStock(int id) async {
    final db = await _dbHelper.database;
    // Fetch current stock first
    final currentMed = await getMedicationById(id);
    if (currentMed != null && currentMed.stock != null && currentMed.stock! > 0) {
      return await db.update(
        "medications",
        {"stock": currentMed.stock! - 1},
        where: "id = ?",
        whereArgs: [id],
      );
    } else {
      print("Cannot decrement stock for medication ID $id: Not found or stock is null/zero.");
      return 0; // Indicate no update occurred
    }
  }

  // Delete a medication
  Future<int> deleteMedication(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      "medications",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

