import 'package:flutter/material.dart';
import 'package:mytuberculose_app/presentation/screens/info/info_living_with_tb_screen.dart';
import 'package:mytuberculose_app/presentation/screens/info/info_resources_screen.dart';
import 'package:mytuberculose_app/presentation/screens/info/info_symptoms_diagnosis_screen.dart';
import 'package:mytuberculose_app/presentation/screens/info/info_transmission_prevention_screen.dart';
import 'package:mytuberculose_app/presentation/screens/info/info_treatment_screen.dart';
import 'package:mytuberculose_app/presentation/screens/info/info_what_is_tb_screen.dart';
// TODO: Import AppLocalizations when needed

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Localize title and category names
    // Define routes mapping to actual screen widgets
    final Map<String, Widget Function(BuildContext)> infoRoutes = {
      '/info/what_is_tb': (context) => const InfoWhatIsTbScreen(),
      '/info/transmission_prevention': (context) => const InfoTransmissionPreventionScreen(),
      '/info/symptoms_diagnosis': (context) => const InfoSymptomsDiagnosisScreen(),
      '/info/treatment': (context) => const InfoTreatmentScreen(),
      '/info/living_with_tb': (context) => const InfoLivingWithTbScreen(),
      '/info/resources': (context) => const InfoResourcesScreen(),
    };

    // Define the categories with their titles, icons, and route keys
    final List<Map<String, dynamic>> infoCategories = [
      {'title': 'Qu\"est-ce que la tuberculose ?', 'icon': Icons.help_outline, 'route': '/info/what_is_tb'},
      {'title': 'Transmission et Prévention', 'icon': Icons.shield_outlined, 'route': '/info/transmission_prevention'},
      {'title': 'Symptômes et Diagnostic', 'icon': Icons.sick_outlined, 'route': '/info/symptoms_diagnosis'},
      {'title': 'Traitement de la Tuberculose', 'icon': Icons.medication_outlined, 'route': '/info/treatment'},
      {'title': 'Vivre avec la Tuberculose', 'icon': Icons.health_and_safety_outlined, 'route': '/info/living_with_tb'},
      {'title': 'Ressources Utiles', 'icon': Icons.link_outlined, 'route': '/info/resources'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations sur la Tuberculose'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: infoCategories.length,
        itemBuilder: (context, index) {
          final category = infoCategories[index];
          final String routeKey = category['route'] as String;
          final Widget Function(BuildContext)? screenBuilder = infoRoutes[routeKey];

          return ListTile(
            leading: Icon(category['icon'] as IconData? ?? Icons.info_outline),
            title: Text(category['title'] as String? ?? 'Information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: screenBuilder != null
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: screenBuilder),
                    );
                  }
                : () {
                    // Fallback if route is not defined
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Section "${category['title']}" non disponible.')), // Localize
                    );
                  },
          );
        },
      ),
    );
  }
}

// Placeholder for detail screen - can be expanded later (or removed if not needed)
/*
class InfoDetailScreen extends StatelessWidget {
  final String topic;
  const InfoDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Contenu détaillé pour "$topic" à venir...'),
        ),
      ),
    );
  }
}
*/

