import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mytuberculose_app/presentation/providers/auth_provider.dart';
// TODO: Import AppLocalizations when needed

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get actual user data from AuthProvider/Supabase later
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    const String userName = "Utilisateur Exemple"; // Placeholder
    const String userEmail = "utilisateur@example.com"; // Placeholder

    // TODO: Localize titles and labels
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () {
              // Placeholder action - actual logout needs Supabase
              authProvider.signOut();
              // TODO: Navigate back to login screen after logout
              print("Logout button pressed (placeholder)");
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            // TODO: Add user profile picture later
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              userName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Center(
            child: Text(
              userEmail,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 30),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Modifier le profil'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Edit Profile Screen
              print('Edit profile tapped');
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_information_outlined),
            title: const Text('Associer/Gérer mon médecin'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Doctor Linking Screen (Task 5.1)
              print('Link doctor tapped');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Paramètres'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Settings Screen (notifications, language, etc.)
              print('Settings tapped');
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Aide et Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Help/Support Screen or show dialog
              print('Help tapped');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('À propos de l\"application'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to About Screen
              print('About tapped');
            },
          ),
          const Divider(),
          // Optional: Add danger zone for account deletion later
        ],
      ),
    );
  }
}

