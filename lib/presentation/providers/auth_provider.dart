import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? _currentUser;
  bool _isLoading = true;
  StreamSubscription<AuthState>? _authStateSubscription;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Get initial session state
    final session = _supabase.auth.currentSession;
    _currentUser = session?.user;
    _isLoading = false;
    notifyListeners();

    // Listen to auth state changes
    _authStateSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      print('AuthProvider: Auth event - $event, Session: ${session != null}');
      _currentUser = session?.user;
      notifyListeners();
    });
  }

  Future<String?> signUpWithEmail(String email, String password, {Map<String, dynamic>? data}) async {
    try {
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: data, // Optional data like user type (patient/doctor)
      );
      if (res.user != null) {
        _currentUser = res.user;
        notifyListeners();
        print('Sign up successful: ${res.user!.id}');
        // Note: Supabase might require email confirmation
        return null; // Success
      } else {
        // This case might happen if email confirmation is required but user object isn't immediately available
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
      if (res.user != null) {
        _currentUser = res.user;
        notifyListeners();
        print('Sign in successful: ${res.user!.id}');
        return null; // Success
      } else {
        // Should not happen with signInWithPassword unless there's an issue
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
      // TODO: Configure Google Sign-In specific settings in Supabase dashboard
      // and potentially platform-specific setup (AndroidManifest.xml, Info.plist)
      final bool success = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        // TODO: Add webClientId for web/desktop platforms if needed
        // webClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
        // TODO: Add iosClientId for iOS if needed
        // iosClientId: 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com',
        // Redirect URL might be needed depending on platform and setup
        // redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      if (success) {
        // The auth state listener will handle the user update
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
      _currentUser = null;
      notifyListeners();
      print('Sign out successful');
    } on AuthException catch (e) {
      print('Sign out error: ${e.message}');
    } catch (e) {
      print('Sign out unexpected error: $e');
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

