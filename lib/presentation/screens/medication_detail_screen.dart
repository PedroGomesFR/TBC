import 'package:flutter/material.dart';
import 'package:mytuberculose_app/data/models/medication_model.dart';
// TODO: Import AppLocalizations when needed

class MedicationDetailScreen extends StatelessWidget {
  final Medication medication;

  const MedicationDetailScreen({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    // TODO: Localize titles and labels
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // TODO: Display medication photo (medication.photoPath)
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
            const Divider(height: 30),
            _buildSectionTitle(context, 'Instructions d\'utilisation'),
            Text(medication.instructions ?? 'Aucune instruction spécifique.'),
            const Divider(height: 30),
            _buildSectionTitle(context, 'Effets Secondaires Possibles'),
            Text(medication.sideEffects ?? 'Aucun effet secondaire commun listé.'),
            const Divider(height: 30),
            _buildSectionTitle(context, 'Interactions Médicamenteuses'),
            Text(medication.interactions ?? 'Aucune interaction connue listée.'),
            // TODO: Add section for user notes?
            // TODO: Add buttons for marking as taken/skipped/reported?
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

