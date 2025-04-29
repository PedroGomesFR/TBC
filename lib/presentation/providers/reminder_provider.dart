import 'package:flutter/material.dart';
import 'package:mytuberculose_app/core/services/notification_service.dart';
import 'package:mytuberculose_app/data/models/medication_model.dart';
import 'package:mytuberculose_app/data/models/appointment_model.dart';
import 'package:mytuberculose_app/data/repositories/treatment_history_repository.dart'; // For missed dose check
import 'package:mytuberculose_app/data/models/treatment_history_model.dart'; // For missed dose check
import 'package:intl/intl.dart'; // For date formatting

class ReminderProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final TreatmentHistoryRepository _historyRepository =
      TreatmentHistoryRepository(); // For missed dose check

  // --- Medication Reminders ---

  // Schedule reminders for a specific medication based on its reminderTimes list
  Future<void> scheduleMedicationReminders(Medication medication) async {
    if (medication is! MedicationWithReminders) return;

    if (medication.reminderTimes == null || medication.reminderTimes!.isEmpty) {
      return;
    }

    int baseId =
        medication.id! * 100; // Base ID for this medication's reminders

    // Cancel existing reminders for this medication first to avoid duplicates
    await cancelMedicationReminders(medication.id!);

    int reminderIndex = 0;
    for (String timeString in medication.reminderTimes!) {
      try {
        // Assuming timeString is in "HH:mm" format
        final parts = timeString.split(':');
        if (parts.length == 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          final reminderTime = TimeOfDay(hour: hour, minute: minute);
          final notificationId = baseId + reminderIndex;

          // TODO: Localize title and body
          await _notificationService.scheduleDailyMedicationReminder(
            id: notificationId,
            title: 'Rappel Prise Médicament', // Localize
            body:
                "N'oubliez pas de prendre votre ${medication.name} (${medication.dosage ?? ''}) à ${timeString}", // Localize
            time: reminderTime,
            payload: 'medication_${medication.id}', // Optional payload
          );
          reminderIndex++;
        } else {}
      } catch (e) {}
    }
    // No need to notifyListeners unless UI depends on reminder status
  }

  // Cancel all reminders for a specific medication
  // Assumes a maximum of 10 reminders per medication (IDs from baseId to baseId + 9)
  // A more robust solution might store scheduled IDs elsewhere.
  Future<void> cancelMedicationReminders(int medicationId) async {
    int baseId = medicationId * 100;
    for (int i = 0; i < 10; i++) {
      // Assume max 10 reminders per med
      await _notificationService.cancelNotification(baseId + i);
    }
  }

  // --- Appointment Reminders ---

  // Schedule reminders for an appointment (e.g., 2 days before, 1 day before)
  Future<void> scheduleAppointmentReminders(Appointment appointment) async {
    if (appointment.id == null) {
      return;
    }

    DateTime now = DateTime.now();
    DateTime appointmentDate = appointment.date;
    final DateFormat timeFormat = DateFormat('HH:mm');
    final DateFormat dateFormat = DateFormat('dd/MM');

    // Base ID for appointment reminders (negative to avoid clash with meds)
    int baseId = -appointment.id!;

    // Cancel existing reminders first
    await cancelAppointmentReminders(appointment.id!);

    // Reminder 2 days before (if appointment is > 2 days away)
    DateTime twoDaysBefore = appointmentDate.subtract(const Duration(days: 2));
    if (twoDaysBefore.isAfter(now)) {
      // Schedule for a specific time, e.g., 9:00 AM
      DateTime reminderDateTime = DateTime(
          twoDaysBefore.year, twoDaysBefore.month, twoDaysBefore.day, 9, 0);
      if (reminderDateTime.isAfter(now)) {
        // Ensure reminder time is in the future
        await _notificationService.scheduleNotification(
          id: baseId - 2, // Unique ID for 2-day reminder
          title: 'Rappel Rendez-vous (J-2)', // Localize
          body:
              'Rendez-vous ${appointment.type} le ${dateFormat.format(appointmentDate)} à ${timeFormat.format(appointmentDate)}', // Localize
          scheduledDate: reminderDateTime,
          payload: 'appointment_${appointment.id}',
        );
      }
    }

    // Reminder 1 day before (if appointment is > 1 day away)
    DateTime oneDayBefore = appointmentDate.subtract(const Duration(days: 1));
    if (oneDayBefore.isAfter(now)) {
      // Schedule for a specific time, e.g., 9:00 AM
      DateTime reminderDateTime = DateTime(
          oneDayBefore.year, oneDayBefore.month, oneDayBefore.day, 9, 0);
      if (reminderDateTime.isAfter(now)) {
        // Ensure reminder time is in the future
        await _notificationService.scheduleNotification(
          id: baseId - 1, // Unique ID for 1-day reminder
          title: 'Rappel Rendez-vous (J-1)', // Localize
          body:
              'Rendez-vous ${appointment.type} demain à ${timeFormat.format(appointmentDate)}', // Localize
          scheduledDate: reminderDateTime,
          payload: 'appointment_${appointment.id}',
        );
      }
    }
  }

  // Cancel reminders for a specific appointment
  Future<void> cancelAppointmentReminders(int appointmentId) async {
    int baseId = -appointmentId;
    await _notificationService
        .cancelNotification(baseId - 1); // Cancel 1-day reminder
    await _notificationService
        .cancelNotification(baseId - 2); // Cancel 2-day reminder
  }

  // --- Other Alerts ---

  // Schedule a notification for low medication stock
  Future<void> scheduleLowStockAlert(
      Medication medication, int threshold) async {
    if (medication.id == null || medication.stock == null) return;

    // Use a specific ID range for stock alerts, e.g., medication.id + 10000
    int notificationId = medication.id! + 10000;

    if (medication.stock! <= threshold) {
      await _notificationService.showNotification(
        id: notificationId,
        title: 'Stock de médicament bas', // Localize
        body:
            'Il ne reste que ${medication.stock} dose(s) de ${medication.name}. Pensez à renouveler.', // Localize
        payload: 'low_stock_${medication.id}',
      );
    } else {
      // Optionally cancel the alert if stock is replenished above threshold
      await _notificationService.cancelNotification(notificationId);
    }
  }

  // Check for missed doses and schedule alert if needed (e.g., run daily)
  // This is a simplified check. A robust implementation needs careful state management.
  Future<void> checkAndScheduleMissedDoseAlert({int daysThreshold = 3}) async {
    // Get history for the last 'daysThreshold' days
    DateTime startDate = DateTime.now().subtract(Duration(days: daysThreshold));
    List<TreatmentHistory> recentHistory =
        await _historyRepository.getHistorySince(startDate);

    // Check if any 'taken' status exists in the recent history
    bool takenRecently =
        recentHistory.any((h) => h.status == TreatmentStatus.taken);

    int alertId = 99999; // Fixed ID for the general missed dose alert

    if (!takenRecently && recentHistory.isNotEmpty) {
      // Only alert if there's history but none are 'taken'
      // Schedule an immediate notification (or maybe a daily repeating one?)
      await _notificationService.showNotification(
        id: alertId,
        title: 'Alerte: Prise de traitement', // Localize
        body:
            'Aucune prise de médicament enregistrée depuis $daysThreshold jours. Contactez votre médecin si besoin.', // Localize
        payload: 'missed_dose_alert',
      );
      // TODO: Consider notifying the doctor via Supabase function if linked?
    } else {
      // If doses were taken recently, cancel any existing alert
      await _notificationService.cancelNotification(alertId);
    }
  }

  // TODO: Implement method to handle notification actions (e.g., 'report' a dose)
}
