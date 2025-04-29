import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mytuberculose_app/data/models/user_profile_model.dart';

class UserProfileRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _tableName = 'profiles'; // Assuming the table name is 'profiles'

  // Fetch user profile by ID
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', userId)
          .single();

      // Determine profile type and create the correct object
      final userType = response['user_type'] as String?;
      if (userType == 'patient') {
        return PatientProfile.fromMap(response);
      } else if (userType == 'doctor') {
        return DoctorProfile.fromMap(response);
      } else {
        return null;
      }
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return null;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Create or update user profile
  Future<void> upsertUserProfile(UserProfile profile) async {
    try {
      await _supabase.from(_tableName).upsert(profile.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Update specific fields of a user profile
  Future<void> updateUserProfileField(String userId, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from(_tableName)
          .update(updates)
          .eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  // --- Doctor-Patient Linking --- 

  // Generate a unique 6-character alphanumeric code
  String _generateLinkingCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  // Generate or regenerate linking code for a doctor
  Future<String?> generateDoctorLinkingCode(String doctorId) async {
    try {
      String newCode;
      bool codeExists;
      int attempts = 0;
      const maxAttempts = 10; // Prevent infinite loop

      // Ensure the generated code is unique (unlikely collision, but good practice)
      do {
        newCode = _generateLinkingCode();
        final check = await _supabase
            .from(_tableName)
            .select('id')
            .eq('linking_code', newCode)
            .limit(1);
        codeExists = check.isNotEmpty;
        attempts++;
      } while (codeExists && attempts < maxAttempts);

      if (codeExists) {
        return null; // Indicate failure
      }

      await _supabase
          .from(_tableName)
          .update({'linking_code': newCode})
          .eq('id', doctorId)
          .eq('user_type', 'doctor'); // Ensure it's a doctor
      
      return newCode;
    } catch (e) {
      return null;
    }
  }

  // Find doctor by linking code
  Future<DoctorProfile?> findDoctorByLinkingCode(String code) async {
    if (code.isEmpty) return null;
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('linking_code', code.toUpperCase()) // Store/compare codes case-insensitively if needed
          .eq('user_type', 'doctor')
          .limit(1);

      if (response.isNotEmpty) {
        return DoctorProfile.fromMap(response.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Link patient to a doctor
  Future<bool> linkPatientToDoctor(String patientId, String doctorId) async {
    try {
      await _supabase
          .from(_tableName)
          .update({'linked_doctor_id': doctorId})
          .eq('id', patientId)
          .eq('user_type', 'patient'); // Ensure it's a patient
      return true;
    } catch (e) {
      return false;
    }
  }

  // Unlink patient from doctor
  Future<bool> unlinkPatientFromDoctor(String patientId) async {
     try {
      await _supabase
          .from(_tableName)
          .update({'linked_doctor_id': null})
          .eq('id', patientId)
          .eq('user_type', 'patient');
      return true;
    } catch (e) {
      return false;
    }
  }

}

