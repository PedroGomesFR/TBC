import 'package:flutter/material.dart';

// Basic model for a medication
class Medication {
  final int? id; // Nullable for new medications not yet in DB
  final String name;
  final String? dosage;
  final String? photoPath; // Path to local image
  final String? frequency;
  final String? instructions;
  final String? sideEffects;
  final String? interactions;

  Medication({
    this.id,
    required this.name,
    this.dosage,
    this.photoPath,
    this.frequency,
    this.instructions,
    this.sideEffects,
    this.interactions,
  });

  // Convert a Medication into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'photo_path': photoPath,
      'frequency': frequency,
      'instructions': instructions,
      'side_effects': sideEffects,
      'interactions': interactions,
    };
  }

  // Implement toString to make it easier to see information when debugging.
  @override
  String toString() {
    return 'Medication{id: $id, name: $name, dosage: $dosage}';
  }

  // Create a Medication from a Map
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] as int?,
      name: map['name'] as String,
      dosage: map['dosage'] as String?,
      photoPath: map['photo_path'] as String?,
      frequency: map['frequency'] as String?,
      instructions: map['instructions'] as String?,
      sideEffects: map['side_effects'] as String?,
      interactions: map['interactions'] as String?,
    );
  }
}

// Placeholder list of medications based on the initial document
// This list can be used to populate the database initially
final List<Medication> predefinedMedications = [
  Medication(name: 'Rifadine 300mg', dosage: '300mg'),
  Medication(name: 'Rifater', dosage: 'Combinaison'), // Example dosage
  Medication(name: 'Rifinah 300mg /150 mg', dosage: '300mg / 150mg'),
  Medication(name: 'DEXAMBUTOL 500mg', dosage: '500mg'),
  Medication(name: 'Myambutol 400mg', dosage: '400mg'),
  Medication(name: 'Pirilène 500mg', dosage: '500mg'),
  Medication(name: 'Rimactan 300mg', dosage: '300mg'),
  Medication(name: 'RIMIFON 50mg', dosage: '50mg'),
  Medication(name: 'RIMIFON 150mg', dosage: '150mg'),
];

