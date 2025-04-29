import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mytuberculose_app/presentation/providers/auth_provider.dart';
// TODO: Import AppLocalizations, LoginScreen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // TODO: Add state for user type selection (Patient/Médecin)
  String _userType = 'patient'; // Default to patient
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')), // Localize
      );
      return;
    }
    setState(() { _isLoading = true; });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Include user type in metadata
    final error = await authProvider.signUpWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      data: {'user_type': _userType},
    );

    if (mounted) {
      setState(() { _isLoading = false; });
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur d\"inscription: $error')), // Localize
        );
      } else {
        // Show success message (e.g., check email for confirmation)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription réussie ! Veuillez vérifier votre email pour confirmer votre compte.')), // Localize
        );
        // Optionally navigate back to login after a delay or let user do it
        if (Navigator.canPop(context)) {
           Future.delayed(const Duration(seconds: 2), () {
             if (mounted && Navigator.canPop(context)) {
                Navigator.pop(context);
             }
           });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Localize texts
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Créer un compte MyTuberculose',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // User Type Selection
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Je suis un :', style: Theme.of(context).textTheme.titleMedium), // Localize
                ),
                RadioListTile<String>(
                  title: const Text('Patient'), // Localize
                  value: 'patient',
                  groupValue: _userType,
                  onChanged: (value) {
                    setState(() {
                      _userType = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Professionnel de santé'), // Localize
                  value: 'doctor',
                  groupValue: _userType,
                  onChanged: (value) {
                    setState(() {
                      _userType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer votre mot de passe';
                    }
                    if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.person_add_alt_1),
                        label: const Text('S\"inscrire'),
                        onPressed: _signUpWithEmail,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Navigate back to LoginScreen
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      // Fallback if cannot pop (e.g., deep linked)
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    }
                  },
                  child: const Text('Déjà un compte ? Connectez-vous'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

