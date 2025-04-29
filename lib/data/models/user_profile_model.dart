import 'package:flutter/material.dart';

// Base class for user profiles
abstract class UserProfile {
  final String id; // Corresponds to Supabase Auth User ID
  final String email;
  final String userType; // 'patient' or 'doctor'
  String? fullName;
  // Add other common fields if needed

  UserProfile({
    required this.id,
    required this.email,
    required this.userType,
    this.fullName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'user_type': userType,
      'full_name': fullName,
      // Add common fields to map
    };
  }
}

class PatientProfile extends UserProfile {
  String? linkedDoctorId; // ID of the linked doctor
  // Add other patient-specific fields (e.g., date of birth, address)

  PatientProfile({
    required String id,
    required String email,
    String? fullName,
    this.linkedDoctorId,
  }) : super(id: id, email: email, userType: 'patient', fullName: fullName);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'linked_doctor_id': linkedDoctorId,
      // Add patient-specific fields to map
    });
    return map;
  }

  factory PatientProfile.fromMap(Map<String, dynamic> map) {
    return PatientProfile(
      id: map['id'] as String,
      email: map['email'] as String,
      fullName: map['full_name'] as String?,
      linkedDoctorId: map['linked_doctor_id'] as String?,
      // Extract patient-specific fields from map
    );
  }
}

class DoctorProfile extends UserProfile {
  String? medicalId; // Professional ID
  String? specialty;
  String? linkingCode; // Unique code for patients to link
  // List<String>? linkedPatientIds; // List of linked patient IDs - Consider separate table for scalability

  DoctorProfile({
    required String id,
    required String email,
    String? fullName,
    this.medicalId,
    this.specialty,
    this.linkingCode,
    // this.linkedPatientIds,
  }) : super(id: id, email: email, userType: 'doctor', fullName: fullName);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'medical_id': medicalId,
      'specialty': specialty,
      'linking_code': linkingCode,
      // 'linked_patient_ids': linkedPatientIds, // Store as JSONB or separate table?
    });
    return map;
  }

  factory DoctorProfile.fromMap(Map<String, dynamic> map) {
    return DoctorProfile(
      id: map['id'] as String,
      email: map['email'] as String,
      fullName: map['full_name'] as String?,
      medicalId: map['medical_id'] as String?,
      specialty: map['specialty'] as String?,
      linkingCode: map['linking_code'] as String?,
      // linkedPatientIds: (map['linked_patient_ids'] as List<dynamic>?)?.cast<String>(),
    );
  }
}

