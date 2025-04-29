class MedicationWithReminders extends Medication {
  final List<String>? reminderTimes;

  MedicationWithReminders({
    int? id,
    required String name,
    String? dosage,
    String? frequency,
    String? instructions,
    String? sideEffects,
    String? interactions,
    int? stock,
    this.reminderTimes,
  }) : super(
          id: id,
          name: name,
          dosage: dosage,
          frequency: frequency,
          instructions: instructions,
          sideEffects: sideEffects,
          interactions: interactions,
          stock: stock,
        );
}

// Basic model for a medication
class Medication {
  final int? id; // Nullable for new medications not yet in DB
  final String name;
  final String? dosage;
  final String? frequency;
  final String? instructions;
  final String? sideEffects;
  final String? interactions;
  final int? stock; // Added stock field
  // TODO: Add field for reminder times?
  // TODO: Add field for image URL/path?

  Medication({
    this.id,
    required this.name,
    this.dosage,
    this.frequency,
    this.instructions,
    this.sideEffects,
    this.interactions,
    this.stock, // Added stock to constructor
  });

  // Convert Medication to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'instructions': instructions,
      'sideEffects': sideEffects,
      'interactions': interactions,
      'stock': stock, // Added stock to map
    };
  }

  // Create Medication from Map
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] as int?,
      name: map['name'] as String,
      dosage: map['dosage'] as String?,
      frequency: map['frequency'] as String?,
      instructions: map['instructions'] as String?,
      sideEffects: map['sideEffects'] as String?,
      interactions: map['interactions'] as String?,
      stock: map['stock'] as int?, // Added stock from map
    );
  }

  @override
  String toString() {
    return 'Medication{id: $id, name: $name, stock: $stock}';
  }
}
