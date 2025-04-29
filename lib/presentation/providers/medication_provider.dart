import 'package:flutter/material.dart';
import 'package:mytuberculose_app/data/models/medication_model.dart';
import 'package:mytuberculose_app/data/repositories/medication_repository.dart';
import 'package:mytuberculose_app/data/repositories/treatment_history_repository.dart'; // Import history repo
import 'package:mytuberculose_app/data/models/treatment_history_model.dart'; // Import history model

class MedicationProvider with ChangeNotifier {
  final MedicationRepository _repository = MedicationRepository();
  final TreatmentHistoryRepository _historyRepository = TreatmentHistoryRepository(); // Add history repo
  List<Medication> _medications = [];
  bool _isLoading = false;

  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;

  MedicationProvider() {
    fetchMedications();
  }

  Future<void> fetchMedications() async {
    _isLoading = true;
    notifyListeners();
    try {
      _medications = await _repository.getAllMedications();
    } catch (e) {
      print("Error fetching medications: $e");
      // Handle error appropriately
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedication(Medication medication) async {
    try {
      await _repository.addMedication(medication);
      await fetchMedications(); // Refresh the list after adding
    } catch (e) {
      print("Error adding medication: $e");
      // Handle error appropriately
    }
  }

  Future<void> updateMedication(Medication medication) async {
    try {
      await _repository.updateMedication(medication);
      await fetchMedications(); // Refresh the list after updating
    } catch (e) {
      print("Error updating medication: $e");
      // Handle error appropriately
    }
  }

  // Mark medication as taken, add history, and decrement stock
  Future<void> markMedicationTaken(int medicationId) async {
    try {
      // 1. Add history record
      final historyRecord = TreatmentHistory(
        medicationId: medicationId,
        date: DateTime.now(),
        status: TreatmentStatus.taken,
      );
      await _historyRepository.addTreatmentHistory(historyRecord);

      // 2. Decrement stock
      await _repository.decrementMedicationStock(medicationId);

      // 3. Refresh medication list to show updated stock
      await fetchMedications();

      print("Medication ID $medicationId marked as taken, stock decremented.");

    } catch (e) {
      print("Error marking medication taken: $e");
      // Handle error appropriately
    }
  }

  // Mark medication as skipped and add history
  Future<void> markMedicationSkipped(int medicationId) async {
    try {
      final historyRecord = TreatmentHistory(
        medicationId: medicationId,
        date: DateTime.now(),
        status: TreatmentStatus.skipped,
      );
      await _historyRepository.addTreatmentHistory(historyRecord);
      // No stock change for skipped doses
      // No need to fetchMedications unless history influences the main list display
      print("Medication ID $medicationId marked as skipped.");
    } catch (e) {
      print("Error marking medication skipped: $e");
      // Handle error appropriately
    }
  }

  Future<void> deleteMedication(int id) async {
    try {
      await _repository.deleteMedication(id);
      await fetchMedications(); // Refresh the list after deleting
    } catch (e) {
      print("Error deleting medication: $e");
      // Handle error appropriately
    }
  }
}

