import 'package:flutter/material.dart';
// TODO: Import AppLocalizations

class InfoTransmissionPreventionScreen extends StatelessWidget {
  const InfoTransmissionPreventionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Localize content
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transmission et Prévention'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Comment se transmet la tuberculose ?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'La tuberculose se transmet principalement par voie aérienne. Lorsqu\'une personne atteinte de tuberculose pulmonaire active tousse, éternue, parle ou chante, elle projette de minuscules gouttelettes contenant la bactérie dans l\'air. Les personnes à proximité peuvent inhaler ces bactéries et être infectées.\n\n'
              'La tuberculose n\'est PAS transmise par :\n'
              '• Le partage d\'ustensiles de cuisine ou de verres\n'
              '• Le partage de nourriture ou de boissons\n'
              '• Le contact physique (serrer la main, étreindre)\n'
              '• Le partage de toilettes ou de literie'
            ),
            SizedBox(height: 16),
            Text(
              'Qui est à risque ?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Tout le monde peut contracter la tuberculose, mais certaines personnes sont plus à risque, notamment :\n'
              '• Les personnes ayant un système immunitaire affaibli (VIH, diabète, malnutrition, certains traitements médicaux)\n'
              '• Les contacts étroits de personnes atteintes de tuberculose active\n'
              '• Les personnes vivant dans des conditions de promiscuité ou insalubres\n'
              '• Les personnes originaires de pays où la tuberculose est fréquente\n'
              '• Les professionnels de la santé'
            ),
             SizedBox(height: 16),
            Text(
              'Comment prévenir la tuberculose ?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'La prévention repose sur plusieurs axes :\n'
              '• Traitement précoce des cas actifs : Identifier et traiter rapidement les personnes atteintes de tuberculose active pour stopper la transmission.\n'
              '• Traitement de l\'infection latente (ITL) : Traiter les personnes atteintes d\'ITL, en particulier celles à haut risque de développer une maladie active.\n'
              '• Vaccination (BCG) : Le vaccin BCG est principalement administré aux nourrissons dans les pays à forte prévalence pour prévenir les formes graves de tuberculose infantile. Son efficacité chez l\'adulte est limitée.\n'
              '• Mesures d\'hygiène respiratoire : Couvrir sa bouche et son nez en cas de toux ou d\'éternuement.\n'
              '• Ventilation des espaces clos : Assurer une bonne circulation de l\'air dans les lieux de vie et de travail.'
            ),
            // TODO: Add more details if needed
          ],
        ),
      ),
    );
  }
}

