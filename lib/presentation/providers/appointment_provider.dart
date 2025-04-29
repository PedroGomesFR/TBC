import 'package:flutter/material.dart';
import 'package:mytuberculose_app/data/models/appointment_model.dart';
import 'package:mytuberculose_app/data/repositories/appointment_repository.dart';

class AppointmentProvider with ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository();
  List<Appointment> _appointments = [];
  bool _isLoading = false;

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;

  AppointmentProvider() {
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    _isLoading = true;
    notifyListeners();
    try {
      _appointments = await _repository.getAllAppointments();
    } catch (e) {
      print("Error fetching appointments: $e");
      // Handle error appropriately
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    try {
      await _repository.addAppointment(appointment);
      await fetchAppointments(); // Refresh the list after adding
    } catch (e) {
      print("Error adding appointment: $e");
      // Handle error appropriately
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      await _repository.updateAppointment(appointment);
      await fetchAppointments(); // Refresh the list after updating
    } catch (e) {
      print("Error updating appointment: $e");
      // Handle error appropriately
    }
  }

  Future<void> deleteAppointment(int id) async {
    try {
      await _repository.deleteAppointment(id);
      await fetchAppointments(); // Refresh the list after deleting
    } catch (e) {
      print("Error deleting appointment: $e");
      // Handle error appropriately
    }
  }
}

