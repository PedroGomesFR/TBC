import 'package:flutter/material.dart';

// Basic model for an appointment
class Appointment {
  final int? id; // Nullable for new appointments not yet in DB
  final String type; // e.g., 'medical_consultation', 'blood_test'
  final String? specialty; // e.g., 'pneumologist'
  final DateTime date;
  final String? notes;

  Appointment({
    this.id,
    required this.type,
    this.specialty,
    required this.date,
    this.notes,
  });

  // Convert Appointment to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'specialty': specialty,
      'date': date.toIso8601String(), // Store date as ISO8601 string
      'notes': notes,
    };
  }

  // Create Appointment from Map
  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as int?,
      type: map['type'] as String,
      specialty: map['specialty'] as String?,
      date: DateTime.parse(map['date'] as String), // Parse ISO8601 string
      notes: map['notes'] as String?,
    );
  }

  @override
  String toString() {
    return 'Appointment{id: $id, type: $type, date: $date}';
  }
}

// Placeholder list of appointments for UI development (can be removed later)
// final List<Appointment> placeholderAppointments = [
//   Appointment(
//     id: 1,
//     type: 'Consultation Pneumologue',
//     specialty: 'Pneumologie',
//     date: DateTime.now().add(const Duration(days: 7, hours: 10)),
//     notes: 'Rendez-vous de suivi annuel.',
//   ),
//   Appointment(
//     id: 2,
//     type: 'Prise de sang',
//     specialty: 'Laboratoire',
//     date: DateTime.now().add(const Duration(days: 3, hours: 8)),
//     notes: 'À jeun.',
//   ),
//   Appointment(
//     id: 3,
//     type: 'Consultation Généraliste',
//     specialty: 'Médecine Générale',
//     date: DateTime.now().add(const Duration(days: 14, hours: 15)),
//   ),
// ];

