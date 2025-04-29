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

  // TODO: Add methods for serialization/deserialization (toMap, fromMap) for DB interaction
}

// Placeholder list of appointments for UI development
final List<Appointment> placeholderAppointments = [
  Appointment(
    id: 1,
    type: 'Consultation Pneumologue',
    specialty: 'Pneumologie',
    date: DateTime.now().add(const Duration(days: 7, hours: 10)),
    notes: 'Rendez-vous de suivi annuel.',
  ),
  Appointment(
    id: 2,
    type: 'Prise de sang',
    specialty: 'Laboratoire',
    date: DateTime.now().add(const Duration(days: 3, hours: 8)),
    notes: 'À jeun.',
  ),
  Appointment(
    id: 3,
    type: 'Consultation Généraliste',
    specialty: 'Médecine Générale',
    date: DateTime.now().add(const Duration(days: 14, hours: 15)),
  ),
];

