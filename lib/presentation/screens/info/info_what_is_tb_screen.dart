import 'package:flutter/material.dart';
// TODO: Import AppLocalizations

class InfoWhatIsTbScreen extends StatelessWidget {
  const InfoWhatIsTbScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Localize content
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qu\"est-ce que la tuberculose ?'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Définition',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'La tuberculose est une maladie infectieuse causée par une bactérie appelée Mycobacterium tuberculosis. Elle affecte le plus souvent les poumons (tuberculose pulmonaire), mais peut également toucher d\"autres parties du corps comme les reins, la colonne vertébrale et le cerveau (tuberculose extra-pulmonaire).'
            ),
            SizedBox(height: 16),
            Text(
              'Tuberculose Latente vs. Tuberculose Active',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Il existe deux états liés à la tuberculose : l\"infection tuberculeuse latente (ITL) et la tuberculose maladie (ou active).\n\n'
              '• Infection Tuberculeuse Latente (ITL) : Les personnes atteintes d\"ITL ont la bactérie dans leur corps, mais leur système immunitaire l\"empêche de se multiplier et de provoquer des symptômes. Elles ne sont pas malades et ne peuvent pas transmettre la bactérie. Cependant, elles peuvent développer une tuberculose active plus tard si leur système immunitaire s\"affaiblit.\n\n'
              '• Tuberculose Active : Les bactéries se multiplient et provoquent des symptômes. Les personnes atteintes de tuberculose pulmonaire active sont contagieuses et peuvent transmettre la maladie à d\"autres.'
            ),
            // TODO: Add more sections (History, Global Impact, etc.)
          ],
        ),
      ),
    );
  }
}

