import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
// TODO: Import AppLocalizations

class InfoResourcesScreen extends StatelessWidget {
  const InfoResourcesScreen({super.key});

  // Helper function to launch URL
  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Show error if URL can't be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d\"ouvrir le lien: $url')), // Localize
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Localize content and URLs
    // TODO: Get these links from a configurable source later (e.g., Supabase)
    final List<Map<String, String>> usefulLinks = [
      {
        'title': 'Organisation Mondiale de la Santé (OMS) - Tuberculose',
        'url': 'https://www.who.int/fr/news-room/fact-sheets/detail/tuberculosis'
      },
      {
        'title': 'Santé publique France - Tuberculose',
        'url': 'https://www.santepubliquefrance.fr/maladies-et-traumatismes/maladies-infectieuses-d-origine-bacterienne/tuberculose'
      },
      {
        'title': 'Ministère de la Santé et de la Prévention (France)',
        'url': 'https://sante.gouv.fr/soins-et-maladies/maladies/maladies-infectieuses/article/tuberculose'
      },
      // Add more relevant links
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ressources Utiles'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: usefulLinks.length,
        itemBuilder: (context, index) {
          final link = usefulLinks[index];
          return ListTile(
            leading: const Icon(Icons.link),
            title: Text(link['title']!),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _launchURL(context, link['url']!),
          );
        },
      ),
    );
  }
}

