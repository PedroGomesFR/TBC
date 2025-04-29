import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mytuberculose_app/presentation/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example of accessing auth provider for logout button
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        // Using a generic title for now, could be localized later
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion', // Localize later
            onPressed: () {
              // Placeholder action - actual logout needs Supabase
              authProvider.signOut();
              // TODO: Navigate back to login screen after logout
            },
          ),
        ],
      ),
      body: const Center(child: Text('Écran Profil (Placeholder)')),
    );
  }
}

