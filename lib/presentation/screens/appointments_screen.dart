import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:mytuberculose_app/data/models/appointment_model.dart'; // Import the model
import 'package:mytuberculose_app/presentation/providers/appointment_provider.dart'; // Import the provider
import 'package:provider/provider.dart'; // Import provider
// TODO: Import AppLocalizations when needed

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch appointments from the provider
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final List<Appointment> appointments = appointmentProvider.appointments;

    // Sort appointments by date (most recent first)
    appointments.sort((a, b) => b.date.compareTo(a.date));

    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final DateFormat timeFormat = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        // TODO: Localize title
        title: const Text('Mes Rendez-vous'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Ajouter un rendez-vous', // Localize later
            onPressed: () {
              // TODO: Implement Add/Edit Appointment Screen (Task 3.4.2)
              // Example: Show a dialog or navigate to a new screen
              _showAddAppointmentDialog(context, appointmentProvider);
            },
          ),
        ],
      ),
      body: appointments.isEmpty
          ? const Center(child: Text('Aucun rendez-vous planifié.')) // Localize later
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: Icon(
                      _getAppointmentIcon(appointment.type),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(appointment.type),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (appointment.specialty != null)
                          Text(appointment.specialty!),
                        Text(
                          '${dateFormat.format(appointment.date)} à ${timeFormat.format(appointment.date)}',
                        ),
                        if (appointment.notes != null && appointment.notes!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              appointment.notes!,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Supprimer', // Localize later
                          onPressed: () async {
                            // Confirmation dialog
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmer la suppression'), // Localize later
                                  content: const Text('Voulez-vous vraiment supprimer ce rendez-vous ?'), // Localize later
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Annuler'), // Localize later
                                      onPressed: () => Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: const Text('Supprimer'), // Localize later
                                      onPressed: () => Navigator.of(context).pop(true),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirm == true && appointment.id != null) {
                              await appointmentProvider.deleteAppointment(appointment.id!);
                            }
                          },
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    isThreeLine: appointment.notes != null && appointment.notes!.isNotEmpty,
                    onTap: () {
                      // TODO: Navigate to Appointment Detail/Edit Screen
                       _showAddAppointmentDialog(context, appointmentProvider, existingAppointment: appointment);
                    },
                  ),
                );
              },
            ),
    );
  }

  // Helper function to get an icon based on appointment type (can be expanded)
  IconData _getAppointmentIcon(String type) {
    if (type.toLowerCase().contains('pneumologue')) {
      return Icons.medical_services_outlined; // Or a lung icon if available
    } else if (type.toLowerCase().contains('sang')) {
      return Icons.bloodtype_outlined;
    } else if (type.toLowerCase().contains('généraliste')) {
      return Icons.person_outline;
    } else if (type.toLowerCase().contains('radio')) {
      return Icons.monitor_heart_outlined; // Placeholder
    }
    return Icons.event_note_outlined;
  }

  // Placeholder for Add/Edit Dialog/Screen
  void _showAddAppointmentDialog(BuildContext context, AppointmentProvider provider, {Appointment? existingAppointment}) {
    final formKey = GlobalKey<FormState>(); // Renamed to avoid conflict
    String type = existingAppointment?.type ?? 'Consultation';
    String? specialty = existingAppointment?.specialty;
    DateTime selectedDate = existingAppointment?.date ?? DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(existingAppointment?.date ?? DateTime.now());
    String? notes = existingAppointment?.notes;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(existingAppointment == null ? 'Ajouter un rendez-vous' : 'Modifier le rendez-vous'), // Localize later
          content: StatefulBuilder( // Use StatefulBuilder to update date/time in dialog
            builder: (BuildContext context, StateSetter setStateDialog) { // Renamed setState
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        initialValue: type,
                        decoration: const InputDecoration(labelText: 'Type de rendez-vous'), // Localize later
                        validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un type' : null,
                        onSaved: (value) => type = value!,
                      ),
                      TextFormField(
                        initialValue: specialty,
                        decoration: const InputDecoration(labelText: 'Spécialité (optionnel)'), // Localize later
                        onSaved: (value) => specialty = value,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'), // Localize later
                          ),
                          TextButton(
                            child: const Text('Choisir'), // Localize later
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null && picked != selectedDate) {
                                setStateDialog(() { // Use renamed setState
                                  selectedDate = picked;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Heure: ${selectedTime.format(context)}'), // Localize later
                          ),
                          TextButton(
                            child: const Text('Choisir'), // Localize later
                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              if (picked != null && picked != selectedTime) {
                                setStateDialog(() { // Use renamed setState
                                  selectedTime = picked;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: notes,
                        decoration: const InputDecoration(labelText: 'Notes (optionnel)'), // Localize later
                        maxLines: 3,
                        onSaved: (value) => notes = value,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'), // Localize later
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(existingAppointment == null ? 'Ajouter' : 'Modifier'), // Localize later
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  final combinedDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  final newAppointment = Appointment(
                    id: existingAppointment?.id, // Keep id for update
                    // userId: 'temp_user', // Removed userId as it's not in the model
                    type: type,
                    specialty: specialty,
                    date: combinedDateTime,
                    notes: notes,
                  );

                  if (existingAppointment == null) {
                    await provider.addAppointment(newAppointment);
                  } else {
                    await provider.updateAppointment(newAppointment); // Use updateAppointment
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

