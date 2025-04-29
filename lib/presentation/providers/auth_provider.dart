import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mytuberculose_app/data/models/user_profile_model.dart';
import 'package:mytuberculose_app/data/repositories/user_profile_repository.dart';

class AuthProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final UserProfileRepository _profileRepository = UserProfileRepository();
  User? _currentUser;
  UserProfile? _userProfile;
  bool _isLoading = true;
  StreamSubscription<AuthState>? _authStateSubscription;

  User? get currentUser => _currentUser;
  UserProfile? get userProfile => _userProfile;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Get initial session state
    final session = _supabase.auth.currentSession;
    _currentUser = session?.user;
    if (_currentUser != null) {
      await _fetchUserProfile(_currentUser!.id);
    }
    _isLoading = false;
    notifyListeners();

    // Listen to auth state changes
    _authStateSubscription = _supabase.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      print('AuthProvider: Auth event - $event, Session: ${session != null}');
      _currentUser = session?.user;
      if (_currentUser != null) {
        // Fetch or create profile when user logs in or signs up
        await _fetchOrCreateUserProfile(_currentUser!);
      } else {
        _userProfile = null; // Clear profile on sign out
      }
      notifyListeners();
    });
  }

  Future<void> _fetchUserProfile(String userId) async {
    try {
      _userProfile = await _profileRepository.getUserProfile(userId);
      print('Fetched profile for user $userId: ${_userProfile?.userType}');
    } catch (e) {
      print('Error fetching profile during init: $e');
      // Handle error appropriately, maybe sign out user?
    }
  }

  Future<void> _fetchOrCreateUserProfile(User user) async {
    try {
      _userProfile = await _profileRepository.getUserProfile(user.id);
      if (_userProfile == null) {
        print('No profile found for user ${user.id}, creating one...');
        // Extract user type from metadata if available (set during signup)
        final userType = user.userMetadata?['user_type'] as String? ?? 'patient'; // Default to patient
        final email = user.email!;

        if (userType == 'patient') {
          _userProfile = PatientProfile(id: user.id, email: email);
        } else if (userType == 'doctor') {
          _userProfile = DoctorProfile(id: user.id, email: email);
        } else {
          print('Cannot create profile: Unknown user type $userType');
          return; // Or handle as error
        }
        await _profileRepository.upsertUserProfile(_userProfile!);
        print('Created profile for user ${user.id} with type $userType');
      } else {
         print('Found existing profile for user ${user.id}: ${_userProfile!.userType}');
      }
    } catch (e) {
      print('Error fetching or creating profile: $e');
      // Handle error appropriately
    }
  }

  Future<String?> signUpWithEmail(String email, String password, {Map<String, dynamic>? data}) async {
    try {
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: data, // Contains user_type
      );
      // The auth state listener (_fetchOrCreateUserProfile) will handle profile creation
      if (res.user != null) {
        print('Sign up successful: ${res.user!.id}');
        // Note: Supabase might require email confirmation
        return null; // Success
      } else {
        print('Sign up requires confirmation or failed without error.');
        return 'Inscription réussie, veuillez vérifier votre email pour confirmer.'; // Indicate confirmation needed
      }
    } on AuthException catch (e) {
      print('Sign up error: ${e.message}');
      return e.message; // Return error message
    } catch (e) {
      print('Sign up unexpected error: $e');
      return 'Une erreur inattendue est survenue.';
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // The auth state listener (_fetchOrCreateUserProfile) will handle profile fetching/creation
      if (res.user != null) {
        print('Sign in successful: ${res.user!.id}');
        return null; // Success
      } else {
        print('Sign in failed without specific error.');
        return 'Échec de la connexion.';
      }
    } on AuthException catch (e) {
      print('Sign in error: ${e.message}');
      return e.message; // Return error message
    } catch (e) {
      print('Sign in unexpected error: $e');
      return 'Une erreur inattendue est survenue.';
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final bool success = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        // TODO: Add webClientId/iosClientId if needed based on platform setup
        // webClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
        // iosClientId: 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com',
        // redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      // The auth state listener (_fetchOrCreateUserProfile) will handle profile fetching/creation after redirect
      if (success) {
        print('Google Sign-In initiated successfully.');
        return null; // Indicate success (or initiation)
      } else {
        print('Google Sign-In failed to initiate.');
        return 'Impossible de lancer la connexion Google.';
      }
    } on AuthException catch (e) {
      print('Google Sign-In error: ${e.message}');
      return e.message;
    } catch (e) {
      print('Google Sign-In unexpected error: $e');
      return 'Une erreur inattendue est survenue lors de la connexion Google.';
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      // Auth listener will set _currentUser and _userProfile to null
      print('Sign out successful');
    } on AuthException catch (e) {
      print('Sign out error: ${e.message}');
    } catch (e) {
      print('Sign out unexpected error: $e');
    }
  }

  // Method to update the current user's profile
  Future<String?> updateUserProfile(UserProfile updatedProfile) async {
    if (_currentUser == null || _userProfile == null || _currentUser!.id != updatedProfile.id) {
      return "Utilisateur non connecté ou ID de profil invalide.";
    }
    try {
      await _profileRepository.upsertUserProfile(updatedProfile);
      _userProfile = updatedProfile; // Update local profile state
      notifyListeners();
      print("Profile updated successfully in provider.");
      return null; // Success
    } catch (e) {
      print("Error updating profile in provider: $e");
      return "Erreur lors de la mise à jour du profil.";
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

