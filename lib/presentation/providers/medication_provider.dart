import 'package:flutter/material.dart';
import 'package:mytuberculose_app/data/models/medication_model.dart';
import 'package:mytuberculose_app/data/repositories/medication_repository.dart';

class MedicationProvider with ChangeNotifier {
  final MedicationRepository _repository = MedicationRepository();
  List<Medication> _medications = [];
  bool _isLoading = false;

  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;

  MedicationProvider() {
    // Initialize and load medications when the provider is created
    _initialize();
  }

  Future<void> _initialize() async {
    await _repository.populateInitialMedications(); // Ensure DB has initial data
    await fetchMedications();
  }

  Future<void> fetchMedications() async {
    _isLoading = true;
    notifyListeners();
    try {
      _medications = await _repository.getAllMedications();
    } catch (e) {
      print("Error fetching medications: $e");
      // Handle error appropriately, maybe set an error state
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add methods for adding, updating, deleting medications later if needed
}

