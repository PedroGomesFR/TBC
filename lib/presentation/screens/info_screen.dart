import 'package:flutter/material.dart';
// TODO: Import AppLocalizations when needed

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Localize title and category names
    final List<Map<String, dynamic>> infoCategories = [
      {'title': 'Qu\'est-ce que la tuberculose ?', 'icon': Icons.help_outline, 'route': '/info/what_is_tb'},
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
          return ListTile(
            leading: Icon(category['icon'] as IconData? ?? Icons.info_outline),
            title: Text(category['title'] as String? ?? 'Information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement navigation to detail screens based on category['route']
              print('Tapped on ${category['title']}');
              // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => InfoDetailScreen(topic: category['title'])));
            },
          );
        },
      ),
    );
  }
}

// Placeholder for detail screen - can be expanded later
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

