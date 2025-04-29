import 'package:flutter/material.dart';
import 'package:mytuberculose_app/data/models/medication_model.dart';
import 'package:mytuberculose_app/data/models/treatment_history_model.dart'; // Import history model
import 'package:mytuberculose_app/data/repositories/treatment_history_repository.dart'; // Import history repo
import 'package:mytuberculose_app/presentation/screens/treatment_history_screen.dart'; // Import history screen
// TODO: Import AppLocalizations when needed

class MedicationDetailScreen extends StatelessWidget {
  final Medication medication;
  final TreatmentHistoryRepository _historyRepository = TreatmentHistoryRepository(); // Instantiate repo

  MedicationDetailScreen({super.key, required this.medication});

  // Function to add a history record
  Future<void> _addHistoryRecord(BuildContext context, TreatmentStatus status) async {
    // Ensure medication has an ID before proceeding
    if (medication.id == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur: Impossible d\'enregistrer l\'historique pour un médicament non sauvegardé.')), // Localize
      );
      return;
    }

    try {
      final newRecord = TreatmentHistory(
        medicationId: medication.id!, // Use medication ID
        date: DateTime.now(),
        status: status,
        // TODO: Add option to include notes?
      );
      await _historyRepository.addTreatmentHistory(newRecord);
      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prise marquée comme ${_getStatusText(status)}')), // Localize
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement: $e')), // Localize - Corrected escape
      );
    }
  }

  // Helper to get status text (duplicate from history screen, consider moving to model or utils)
  String _getStatusText(TreatmentStatus status) {
    switch (status) {
      case TreatmentStatus.taken: return 'Pris';
      case TreatmentStatus.skipped: return 'Oublié';
      case TreatmentStatus.reported: return 'Signalé';
      case TreatmentStatus.pending: return 'En attente';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Localize titles and labels
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            tooltip: 'Voir l\'historique pour ce médicament', // Localize - Corrected escape
            onPressed: medication.id == null ? null : () { // Disable if medication ID is null (not from DB)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TreatmentHistoryScreen(medicationId: medication.id!),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Icon(
                Icons.medication_liquid, // Placeholder icon
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow(context, 'Nom', medication.name),
            _buildDetailRow(context, 'Dosage', medication.dosage ?? 'Non spécifié'),
            _buildDetailRow(context, 'Fréquence', medication.frequency ?? 'Non spécifié'),
            _buildDetailRow(context, 'Stock Restant', medication.stock?.toString() ?? 'Non suivi'), // Display stock
            const Divider(height: 30),
            _buildSectionTitle(context, 'Instructions d\'utilisation'), // Corrected escape
            Text(medication.instructions ?? 'Aucune instruction spécifique.'),
            const Divider(height: 30),
            _buildSectionTitle(context, 'Effets Secondaires Possibles'),
            Text(medication.sideEffects ?? 'Aucun effet secondaire commun listé.'),
            const Divider(height: 30),
            _buildSectionTitle(context, 'Interactions Médicamenteuses'),
            Text(medication.interactions ?? 'Aucune interaction connue listée.'),
            const Divider(height: 30),
            // Buttons for marking status
            if (medication.id != null) // Only show buttons if medication has an ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Marquer Pris'), // Localize
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[100]),
                    onPressed: () => _addHistoryRecord(context, TreatmentStatus.taken),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Marquer Oublié'), // Localize
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
                    onPressed: () => _addHistoryRecord(context, TreatmentStatus.skipped),
                  ),
                  // TODO: Add 'Reported' button?
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label : ', style: Theme.of(context).textTheme.titleMedium),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

