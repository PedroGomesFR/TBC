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
        print('Unknown user type for user $userId: $userType');
        return null;
      }
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        print('No profile found for user $userId');
        return null;
      } else {
        print('Error fetching profile for user $userId: ${e.message}');
        rethrow;
      }
    } catch (e) {
      print('Unexpected error fetching profile for user $userId: $e');
      rethrow;
    }
  }

  // Create or update user profile
  Future<void> upsertUserProfile(UserProfile profile) async {
    try {
      await _supabase.from(_tableName).upsert(profile.toMap());
      print('Profile upserted successfully for user ${profile.id}');
    } catch (e) {
      print('Error upserting profile for user ${profile.id}: $e');
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
      print('Profile updated successfully for user $userId');
    } catch (e) {
      print('Error updating profile for user $userId: $e');
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
        print('Failed to generate a unique linking code after $maxAttempts attempts.');
        return null; // Indicate failure
      }

      await _supabase
          .from(_tableName)
          .update({'linking_code': newCode})
          .eq('id', doctorId)
          .eq('user_type', 'doctor'); // Ensure it's a doctor
      
      print('Generated new linking code $newCode for doctor $doctorId');
      return newCode;
    } catch (e) {
      print('Error generating linking code for doctor $doctorId: $e');
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
        print('No doctor found with linking code $code');
        return null;
      }
    } catch (e) {
      print('Error finding doctor by linking code $code: $e');
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
      print('Patient $patientId linked to doctor $doctorId');
      return true;
    } catch (e) {
      print('Error linking patient $patientId to doctor $doctorId: $e');
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
      print('Patient $patientId unlinked from doctor');
      return true;
    } catch (e) {
      print('Error unlinking patient $patientId: $e');
      return false;
    }
  }

}

