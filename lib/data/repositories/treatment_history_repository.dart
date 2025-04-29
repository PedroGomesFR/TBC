import 
"package:mytuberculose_app/data/datasources/local_database_helper.dart";
import "package:mytuberculose_app/data/models/treatment_history_model.dart";

class TreatmentHistoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Add a new treatment history record
  Future<int> addTreatmentHistory(TreatmentHistory history) async {
    final db = await _dbHelper.database;
    return await db.insert("treatment_history", history.toMap());
  }

  // Get all treatment history records (potentially filtered by date range or medication)
  Future<List<TreatmentHistory>> getAllTreatmentHistory() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query("treatment_history", orderBy: "date DESC");
    return List.generate(maps.length, (i) {
      return TreatmentHistory.fromMap(maps[i]);
    });
  }

  // Get history for a specific medication
  Future<List<TreatmentHistory>> getHistoryForMedication(int medicationId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "treatment_history",
      where: "medication_id = ?",
      whereArgs: [medicationId],
      orderBy: "date DESC",
    );
    return List.generate(maps.length, (i) {
      return TreatmentHistory.fromMap(maps[i]);
    });
  }

  // Get history for a specific date range
  Future<List<TreatmentHistory>> getHistoryForDateRange(DateTime start, DateTime end) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "treatment_history",
      where: "date >= ? AND date <= ?",
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: "date DESC",
    );
    return List.generate(maps.length, (i) {
      return TreatmentHistory.fromMap(maps[i]);
    });
  }

  // Update a history record (e.g., change status or add notes)
  Future<int> updateTreatmentHistory(TreatmentHistory history) async {
    final db = await _dbHelper.database;
    return await db.update(
      "treatment_history",
      history.toMap(),
      where: "id = ?",
      whereArgs: [history.id],
    );
  }

  // Delete a history record (use with caution)
  Future<int> deleteTreatmentHistory(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      "treatment_history",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

