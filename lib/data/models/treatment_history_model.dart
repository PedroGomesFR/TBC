import 'package:flutter/material.dart';

enum TreatmentStatus { taken, skipped, reported, pending }

class TreatmentHistory {
  final int? id;
  final int medicationId;
  final DateTime date; // Represents the specific time the status was recorded or the intended time
  final TreatmentStatus status;
  final String? notes;

  TreatmentHistory({
    this.id,
    required this.medicationId,
    required this.date,
    required this.status,
    this.notes,
  });

  // Convert TreatmentHistory to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medication_id': medicationId,
      'date': date.toIso8601String(), // Store date as ISO8601 string
      'status': status.toString().split('.').last, // Store enum as string
      'notes': notes,
    };
  }

  // Create TreatmentHistory from Map
  factory TreatmentHistory.fromMap(Map<String, dynamic> map) {
    return TreatmentHistory(
      id: map['id'] as int?,
      medicationId: map['medication_id'] as int,
      date: DateTime.parse(map['date'] as String), // Parse ISO8601 string
      status: TreatmentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (map['status'] as String),
        orElse: () => TreatmentStatus.pending, // Default if status string is invalid
      ),
      notes: map['notes'] as String?,
    );
  }

  @override
  String toString() {
    return 'TreatmentHistory{id: $id, medicationId: $medicationId, date: $date, status: $status}';
  }
}

