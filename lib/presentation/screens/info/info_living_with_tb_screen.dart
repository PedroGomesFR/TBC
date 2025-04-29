import 'package:flutter/material.dart';
// TODO: Import AppLocalizations

class InfoLivingWithTbScreen extends StatelessWidget {
  const InfoLivingWithTbScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Localize content
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vivre avec la Tuberculose'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Gestion du Traitement au Quotidien',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Vivre avec la tuberculose implique de gérer son traitement et de prendre soin de sa santé générale.\n\n'
              '• Observance : Prenez vos médicaments exactement comme prescrit par votre médecin, tous les jours, sans interruption. Utilisez des rappels (comme ceux de cette application) pour ne pas oublier.\n'
              '• Alimentation : Adoptez une alimentation saine et équilibrée pour renforcer votre système immunitaire. Mangez beaucoup de fruits, légumes, protéines et grains entiers.\n'
              '• Repos : Reposez-vous suffisamment. Le corps a besoin d\"énergie pour combattre l\"infection et se rétablir.\n'
              '• Éviter l\"alcool et le tabac : L\"alcool peut interagir avec les médicaments et surcharger le foie. Le tabac affaiblit les poumons et peut aggraver la maladie.\n'
              '• Suivi médical : Assistez à tous vos rendez-vous médicaux pour surveiller l\"efficacité du traitement et détecter d\"éventuels effets secondaires.'
            ),
            SizedBox(height: 16),
            Text(
              'Prévenir la Transmission (si contagieux)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Si vous avez une tuberculose pulmonaire active, il est important de prendre des précautions pour ne pas infecter votre entourage pendant les premières semaines de traitement :\n'
              '• Couvrez votre bouche et votre nez lorsque vous toussez ou éternuez.\n'
              '• Aérez bien les pièces où vous vivez.\n'
              '• Limitez les contacts étroits avec d\"autres personnes, en particulier les enfants et les personnes immunodéprimées.\n'
              '• Portez un masque chirurgical si votre médecin vous le recommande.\n\n'
              'Votre médecin vous indiquera quand vous n\"êtes plus contagieux (généralement après quelques semaines de traitement efficace).'
            ),
             SizedBox(height: 16),
            Text(
              'Soutien Psychologique et Social',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Le diagnostic de tuberculose peut être difficile à vivre. N\"hésitez pas à parler de vos inquiétudes à votre médecin, à votre famille ou à vos amis. Des groupes de soutien ou des associations de patients peuvent également apporter une aide précieuse.'
            ),
            // TODO: Add more details if needed
          ],
        ),
      ),
    );
  }
}

