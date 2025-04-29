import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'package:mytuberculose_app/presentation/providers/auth_provider.dart';
import 'package:mytuberculose_app/presentation/providers/medication_provider.dart';
import 'package:mytuberculose_app/presentation/providers/reminder_provider.dart';
import 'package:mytuberculose_app/presentation/providers/appointment_provider.dart';
import 'package:mytuberculose_app/presentation/screens/main_navigation_screen.dart';
import 'package:mytuberculose_app/core/services/notification_service.dart';
// TODO: Import login/splash screen later

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Notification Service
  await NotificationService().init();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://snfeishlpfcovfldzfgv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNuZmVpc2hscGZjb3ZmbGR6Zmd2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU4MjU4MTEsImV4cCI6MjA2MTQwMTgxMX0.DOgNsp73x8grE7WEg0_BPXs1PDyO1-0vqTSBhVaet6o',
  );
  print("Supabase initialized!");

  runApp(const MyApp());
}

// Get a reference to the Supabase client
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the MaterialApp with MultiProvider to provide the states
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        // TODO: Implement routing and initial screen logic based on auth state
        // For now, directly show the main navigation screen
        // Later, this will depend on authProvider.isAuthenticated
        home: const MainNavigationScreen(), // Show main navigation for now
        // Example using AuthProvider (needs splash/login screens):
        // home: Consumer<AuthProvider>(
        //   builder: (context, authProvider, _) {
        //     if (authProvider.isLoading) {
        //       return const SplashScreen(); // Show loading screen
        //     } else if (authProvider.isAuthenticated) {
        //       return const MainNavigationScreen(); // User is logged in
        //     } else {
        //       return const LoginScreen(); // User needs to log in
        //     }
        //   },
        // ),
      ),
    );
  }
}

