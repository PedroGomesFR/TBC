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
        // Fallback or handle error - maybe return a base profile?
        // For now, return null if type is unknown/missing
        return null;
      }
    } on PostgrestException catch (e) {
      // Handle specific errors, e.g., 'PGRST116' for no rows found
      if (e.code == 'PGRST116') {
        print('No profile found for user $userId');
        return null;
      } else {
        print('Error fetching profile for user $userId: ${e.message}');
        // Rethrow or handle other errors
        rethrow;
      }
    } catch (e) {
      print('Unexpected error fetching profile for user $userId: $e');
      rethrow;
    }
  }

  // Create or update user profile
  // Uses upsert to handle both creation and update based on the primary key (id)
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

  // TODO: Add methods for specific profile operations if needed
  // e.g., findDoctorByCode, linkPatientToDoctor, etc.
}

