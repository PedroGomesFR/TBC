import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:mytuberculose_app/data/models/medication_model.dart';
import 'package:mytuberculose_app/presentation/providers/medication_provider.dart'; // Import MedicationProvider
import 'package:mytuberculose_app/presentation/screens/medication_detail_screen.dart';
import 'package:mytuberculose_app/presentation/screens/treatment_history_screen.dart'; // Import History Screen
// TODO: Import AppLocalizations when needed

class TreatmentsScreen extends StatelessWidget {
  const TreatmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Provider to get medication data
    final medicationProvider = Provider.of<MedicationProvider>(context);
    final List<Medication> medications = medicationProvider.medications;

    // TODO: Localize title and labels
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Traitements'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            tooltip: 'Voir tout l\'historique', // Localize
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TreatmentHistoryScreen(), // Navigate to overall history
                ),
              );
            },
          ),
          // TODO: Add filter/sort options?
        ],
      ),
      body: medicationProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : medications.isEmpty
              ? const Center(child: Text('Aucun médicament trouvé.')) // Localize
              : ListView.builder(
                  itemCount: medications.length,
                  itemBuilder: (context, index) {
                    final medication = medications[index];
                    return ListTile(
                      leading: const Icon(Icons.medication_liquid), // Placeholder icon
                      title: Text(medication.name),
                      subtitle: Text(medication.dosage ?? 'Dosage non spécifié'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
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
      // TODO: Add FloatingActionButton to add custom medications later?
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigate to add medication screen
      //   },
      //   tooltip: 'Ajouter Médicament',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

