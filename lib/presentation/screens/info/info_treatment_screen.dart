import 'package:flutter/material.dart';
// TODO: Import AppLocalizations

class InfoTreatmentScreen extends StatelessWidget {
  const InfoTreatmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Localize content
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traitement de la Tuberculose'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Principes du Traitement',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Le traitement de la tuberculose active repose sur une combinaison d\'antibiotiques spécifiques (antituberculeux) prise pendant plusieurs mois. Il est crucial de suivre le traitement complet, même si l\'on se sent mieux, pour guérir complètement et éviter le développement de résistances aux médicaments.\n\n'
              'Le traitement standard comporte généralement deux phases :'
            ),
            SizedBox(height: 12),
            Text(
              '1. Phase Initiale (Intensive) :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              '• Durée : Généralement 2 mois.\n'
              '• Objectif : Tuer rapidement la majorité des bactéries pour réduire la contagiosité et les symptômes.\n'
              '• Médicaments : Association de 4 antibiotiques : Isoniazide (INH), Rifampicine (RIF), Pyrazinamide (PZA), et Ethambutol (EMB).'
            ),
            SizedBox(height: 12),
            Text(
              '2. Phase de Continuation :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              '• Durée : Généralement 4 mois (peut être plus long dans certains cas).\n'
              '• Objectif : Éliminer les bactéries restantes et prévenir les rechutes.\n'
              '• Médicaments : Association de 2 antibiotiques : Isoniazide (INH) et Rifampicine (RIF).'
            ),
            SizedBox(height: 16),
            Text(
              'Importance de l\'Observance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'L\'observance (prendre ses médicaments régulièrement et sans interruption) est la clé du succès du traitement. L\'oubli fréquent des prises ou l\'arrêt prématuré du traitement peut entraîner :\n'
              '• L\'échec du traitement\n'
              '• Les rechutes\n'
              '• Le développement de tuberculose résistante aux médicaments (TB-MR ou TB-UR), beaucoup plus difficile et longue à traiter.'
            ),
             SizedBox(height: 16),
            Text(
              'Effets Secondaires',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Les médicaments antituberculeux peuvent provoquer des effets secondaires. Il est important de signaler rapidement tout symptôme inhabituel à son médecin (ex: nausées, vomissements, jaunisse, troubles de la vision, éruptions cutanées, fourmillements). La plupart des effets secondaires sont gérables.'
            ),
            SizedBox(height: 16),
            Text(
              'Traitement de l\'Infection Latente (ITL)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Les personnes atteintes d\'ITL peuvent recevoir un traitement préventif (généralement un ou deux médicaments pendant 3 à 9 mois) pour réduire le risque de développer une tuberculose active.'
            ),
            // TODO: Add more details if needed (e.g., Directly Observed Therapy - DOT)
          ],
        ),
      ),
    );
  }
}

