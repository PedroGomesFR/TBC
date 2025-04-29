import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:mytuberculose_app/data/models/appointment_model.dart'; // Import the model
// TODO: Import AppLocalizations when needed

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use placeholder data for now
    final List<Appointment> appointments = placeholderAppointments;
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
              // TODO: Implement Add/Edit Appointment Screen (Task 3.2.2)
              print('Add appointment button pressed');
              // Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditAppointmentScreen()));
            },
          ),
        ],
      ),
      body: ListView.builder(
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
              trailing: const Icon(Icons.chevron_right),
              isThreeLine: appointment.notes != null && appointment.notes!.isNotEmpty,
              onTap: () {
                // TODO: Navigate to Appointment Detail/Edit Screen
                print('Tapped on appointment ${appointment.id}');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditAppointmentScreen(appointment: appointment)));
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
    }
    return Icons.event_note_outlined;
  }
}

