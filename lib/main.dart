import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mytuberculose_app/presentation/providers/auth_provider.dart';
import 'package:mytuberculose_app/presentation/providers/medication_provider.dart';
import 'package:mytuberculose_app/presentation/providers/reminder_provider.dart';
import 'package:mytuberculose_app/presentation/providers/appointment_provider.dart'; // Import AppointmentProvider
import 'package:mytuberculose_app/presentation/screens/main_navigation_screen.dart';
import 'package:mytuberculose_app/core/services/notification_service.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Notification Service
  await NotificationService().init();

  // TODO: Initialize Supabase here when the key is available
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
    // Wrap the MaterialApp with MultiProvider to provide the states
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()), // Add AppointmentProvider
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
      ),
    );
  }
}

