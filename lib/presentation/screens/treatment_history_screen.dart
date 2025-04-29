import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytuberculose_app/data/models/treatment_history_model.dart';
import 'package:mytuberculose_app/data/repositories/treatment_history_repository.dart';
// TODO: Import MedicationRepository/Provider to get medication names
// TODO: Import AppLocalizations

class TreatmentHistoryScreen extends StatefulWidget {
  // Optional: Pass medicationId to filter history for a specific medication
  final int? medicationId;

  const TreatmentHistoryScreen({super.key, this.medicationId});

  @override
  State<TreatmentHistoryScreen> createState() => _TreatmentHistoryScreenState();
}

class _TreatmentHistoryScreenState extends State<TreatmentHistoryScreen> {
  final TreatmentHistoryRepository _repository = TreatmentHistoryRepository();
  late Future<List<TreatmentHistory>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    if (widget.medicationId != null) {
      _historyFuture = _repository.getHistoryForMedication(widget.medicationId!);
    } else {
      // Load all history for now, add date filtering later
      _historyFuture = _repository.getAllTreatmentHistory();
    }
  }

  // Helper to get icon based on status
  Widget _getStatusIcon(TreatmentStatus status) {
    switch (status) {
      case TreatmentStatus.taken:
        return const Icon(Icons.check_circle_outline, color: Colors.green);
      case TreatmentStatus.skipped:
        return const Icon(Icons.cancel_outlined, color: Colors.red);
      case TreatmentStatus.reported:
        return const Icon(Icons.report_problem_outlined, color: Colors.orange);
      case TreatmentStatus.pending:
        return const Icon(Icons.hourglass_empty_outlined, color: Colors.grey);
    }
  }

  // Helper to get status text
  String _getStatusText(TreatmentStatus status) {
    switch (status) {
      case TreatmentStatus.taken:
        return 'Pris'; // Localize
      case TreatmentStatus.skipped:
        return 'Oublié'; // Localize
      case TreatmentStatus.reported:
        return 'Signalé'; // Localize
      case TreatmentStatus.pending:
        return 'En attente'; // Localize
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        // TODO: Localize title
        title: Text(widget.medicationId != null
            ? 'Historique du Médicament' // TODO: Add medication name
            : 'Historique des Prises'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // TODO: Add filtering options (date range)
      ),
      body: FutureBuilder<List<TreatmentHistory>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}')); // Localize
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun historique trouvé.')); // Localize
          }

          final historyList = snapshot.data!;

          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final history = historyList[index];
              return ListTile(
                leading: _getStatusIcon(history.status),
                // TODO: Show medication name if viewing all history
                title: Text('${_getStatusText(history.status)} - ${dateFormat.format(history.date)}'),
                subtitle: history.notes != null && history.notes!.isNotEmpty
                    ? Text(history.notes!)
                    : null,
                onTap: () {
                  // TODO: Allow editing notes or status?
                  print('Tapped on history item ${history.id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}

