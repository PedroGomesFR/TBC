import 
"package:mytuberculose_app/data/datasources/local_database_helper.dart";
import "package:mytuberculose_app/data/models/appointment_model.dart";

class AppointmentRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Add a new appointment
  Future<int> addAppointment(Appointment appointment) async {
    final db = await _dbHelper.database;
    return await db.insert("appointments", appointment.toMap());
  }

  // Get all appointments, ordered by date (most recent first)
  Future<List<Appointment>> getAllAppointments() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query("appointments", orderBy: "date DESC");
    return List.generate(maps.length, (i) {
      return Appointment.fromMap(maps[i]);
    });
  }

  // Get appointments for a specific date range
  Future<List<Appointment>> getAppointmentsForDateRange(DateTime start, DateTime end) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      "appointments",
      where: "date >= ? AND date <= ?",
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: "date DESC",
    );
    return List.generate(maps.length, (i) {
      return Appointment.fromMap(maps[i]);
    });
  }

  // Update an appointment
  Future<int> updateAppointment(Appointment appointment) async {
    final db = await _dbHelper.database;
    return await db.update(
      "appointments",
      appointment.toMap(),
      where: "id = ?",
      whereArgs: [appointment.id],
    );
  }

  // Delete an appointment
  Future<int> deleteAppointment(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      "appointments",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

