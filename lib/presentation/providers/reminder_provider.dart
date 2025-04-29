import 'package:flutter/material.dart';
import 'package:mytuberculose_app/core/services/notification_service.dart';
import 'package:mytuberculose_app/data/models/medication_model.dart';
// TODO: Potentially need MedicationProvider or Repository to get medication details

class ReminderProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  // Schedule reminders for a specific medication
  // This is a basic example; needs refinement based on how medication times are stored
  Future<void> scheduleMedicationReminders(Medication medication) async {
    if (medication.id == null) {
      print("Cannot schedule reminder for medication without ID");
      return;
    }

    // TODO: Get specific reminder times for this medication
    // For now, let's assume a placeholder time (e.g., 8:00 AM)
    // In reality, this should come from the medication data or user settings
    const TimeOfDay reminderTime = TimeOfDay(hour: 8, minute: 0);

    // TODO: Localize title and body
    await _notificationService.scheduleDailyMedicationReminder(
      id: medication.id!, // Use medication ID as notification ID (ensure uniqueness)
      title: 'Rappel Prise Médicament', // Localize
      body: 'N\"oubliez pas de prendre votre ${medication.name} (${medication.dosage ?? ''})', // Localize
      time: reminderTime,
    );

    print("Scheduled reminders for ${medication.name}");
    // No need to notifyListeners unless UI depends on reminder status
  }

  // Cancel reminders for a specific medication
  Future<void> cancelMedicationReminders(int medicationId) async {
    await _notificationService.cancelNotification(medicationId);
    print("Cancelled reminders for medication ID $medicationId");
  }

  // TODO: Add methods for scheduling appointment reminders
  // TODO: Add methods for scheduling special alerts (e.g., missed doses)
}

