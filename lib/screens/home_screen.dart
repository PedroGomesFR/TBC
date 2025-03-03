import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '527609679972-p3v0sbpnr7n788s6u2gu8ma1m6mmev3b.apps.googleusercontent.com', // Remplacez par votre Client ID
  );

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("L'utilisateur a annulé la connexion");
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print("Connexion réussie : ${userCredential.user?.displayName}");
      return userCredential.user;
    } catch (e) {
      print("Erreur lors de la connexion avec Google : $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                User? user = await signInWithGoogle();
                if (user != null) {
                  print("Connexion réussie : ${user.displayName}");
                  setState(() {
                    _currentUser = user;
                    print("Utilisateur connecté : ${_currentUser?.email}");
                  });
                } else {
                  print("Échec de la connexion");
                }
              },
              child: Text('Sign in with Google'),
            ),
            Text(_currentUser?.email ?? 'Pas de connexion'),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }
}