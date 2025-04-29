import 'package:flutter/material.dart';
// TODO: Import AppLocalizations

class InfoSymptomsDiagnosisScreen extends StatelessWidget {
  const InfoSymptomsDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Localize content
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptômes et Diagnostic'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Symptômes de la Tuberculose Pulmonaire',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Les symptômes de la tuberculose pulmonaire active peuvent inclure :\n'
              '• Une toux persistante (plus de 2-3 semaines), parfois avec des crachats de sang\n'
              '• Douleurs thoraciques\n'
              '• Faiblesse ou fatigue\n'
              '• Perte de poids inexpliquée\n'
              '• Manque d\'appétit\n' // Corrected escape
              '• Frissons\n'
              '• Fièvre\n'
              '• Sueurs nocturnes\n\n'
              'Les symptômes de la tuberculose extra-pulmonaire dépendent de la partie du corps affectée.'
            ),
            SizedBox(height: 16),
            Text(
              'Diagnostic de la Tuberculose',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Le diagnostic de la tuberculose repose sur plusieurs examens :\n\n'
              '• Test Cutané à la Tuberculine (TCT) ou Test de Libération d\'Interféron Gamma (TLIG/IGRA) : Ces tests indiquent si une personne a été infectée par la bactérie, mais ne distinguent pas l\'infection latente de la maladie active.\n\n' // Corrected escape
              '• Radiographie Thoracique : Peut montrer des anomalies dans les poumons suggérant une tuberculose active, mais ne suffit pas seule au diagnostic.\n\n'
              '• Examen Bactériologique des Crachats (Expectorations) : C\'est l\'examen clé pour confirmer une tuberculose pulmonaire active. Il recherche la présence de Mycobacterium tuberculosis dans les échantillons de crachats, par microscopie (bacilloscopie) et/ou par culture (plus sensible mais plus long). Des tests moléculaires rapides (comme GeneXpert) peuvent aussi être utilisés pour détecter la bactérie et certaines résistances aux médicaments.\n\n' // Corrected escape
              '• Autres Prélèvements : Pour la tuberculose extra-pulmonaire, des échantillons d\'autres fluides corporels ou des biopsies des tissus affectés peuvent être nécessaires.' // Corrected escape
            ),
            // TODO: Add more details if needed
          ],
        ),
      ),
    );
  }
}

