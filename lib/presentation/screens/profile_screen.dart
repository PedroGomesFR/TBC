import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mytuberculose_app/presentation/providers/auth_provider.dart';
import 'package:mytuberculose_app/presentation/screens/auth/login_screen.dart'; // Import login screen for navigation
// TODO: Import AppLocalizations when needed
// TODO: Import screens for navigation (Edit Profile, Settings, etc.)

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to AuthProvider for user changes
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    // Use user data if available, otherwise placeholders
    final String userName = user?.userMetadata?['full_name'] ?? user?.email?.split('@')[0] ?? "Utilisateur"; // Placeholder logic
    final String userEmail = user?.email ?? "non connecté"; // Placeholder logic

    // TODO: Localize titles and labels
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () async {
              await authProvider.signOut();
              // Navigate to login screen and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false, // Remove all routes
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          // TODO: Add user profile picture later (fetch from profile data)
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'U', // Display first initial
              style: TextStyle(fontSize: 40, color: Colors.grey[700]),
            ),
            // child: Icon(Icons.person, size: 50),
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
              // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_information_outlined),
            title: const Text('Associer/Gérer mon médecin'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Doctor Linking Screen (Task 5.1)
              // Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorLinkScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Paramètres'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Settings Screen (notifications, language, theme, etc.)
              // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Aide et Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Help/Support Screen or show dialog
              // Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('À propos de l\"application'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to About Screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
            },
          ),
          const Divider(),
          // Optional: Add danger zone for account deletion later
        ],
      ),
    );
  }
}

