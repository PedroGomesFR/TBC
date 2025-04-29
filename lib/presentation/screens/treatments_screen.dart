import 'package:flutter/material.dart';
import 'package:mytuberculose_app/data/models/medication_model.dart'; // Import the model
import 'package:mytuberculose_app/presentation/screens/medication_detail_screen.dart'; // Import detail screen
// TODO: Import AppLocalizations when needed

class TreatmentsScreen extends StatelessWidget {
  const TreatmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the predefined list for now
    final List<Medication> medications = predefinedMedications;

    return Scaffold(
      appBar: AppBar(
        // TODO: Localize title
        title: const Text('Mes Traitements'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final medication = medications[index];
          return ListTile(
            // TODO: Add placeholder for medication image (photoPath)
            leading: const Icon(Icons.medication_liquid), // Placeholder icon
            title: Text(medication.name),
            subtitle: Text(medication.dosage ?? 'Dosage non spécifié'), // Show dosage if available
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to Medication Details Screen (Task 3.1.2)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicationDetailScreen(medication: medication),
                ),
              );
            },
          );
        },
      ),
      // TODO: Add FloatingActionButton to potentially add custom medications later?
    );
  }
}

