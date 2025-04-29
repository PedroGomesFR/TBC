import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mytuberculose_app/presentation/providers/auth_provider.dart'; // Import AuthProvider

void main() {
  // TODO: Initialize Supabase here when the key is available
  // WidgetsFlutterBinding.ensureInitialized();
  // await Supabase.initialize(
  //   url: 'YOUR_SUPABASE_URL', // Replace with actual URL
  //   anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with actual key
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the MaterialApp with MultiProvider to provide the Auth state
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add other providers here later (e.g., TreatmentProvider, AppointmentProvider)
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr', ''), // French
          // Locale('en', ''), // English - Add later if needed
        ],
        onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), // Changed seed color for variety
          useMaterial3: true,
        ),
        // TODO: Implement routing and initial screen logic based on auth state
        home: const PlaceholderAuthScreen(), // Placeholder for auth/home screen logic
      ),
    );
  }
}

// Placeholder screen - will be replaced by actual login/signup or home screen based on auth state
class PlaceholderAuthScreen extends StatelessWidget {
  const PlaceholderAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example of accessing the provider (though not used yet)
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Écran d\'authentification/accueil (Placeholder)'),
            const SizedBox(height: 20),
            // Example button using the provider (placeholder action)
            ElevatedButton(
              onPressed: () => authProvider.signIn('test@example.com', 'password'),
              child: const Text('Test Connexion (Placeholder)'),
            ),
            ElevatedButton(
              onPressed: () => authProvider.signOut(),
              child: const Text('Test Déconnexion (Placeholder)'),
            ),
          ],
        ),
      ),
    );
  }
}

