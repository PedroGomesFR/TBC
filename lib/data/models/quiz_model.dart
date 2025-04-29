import 'package:flutter/material.dart';

class QuizQuestion {
  final String questionText;
  final List<QuizOption> options;
  final String? explanation; // Optional explanation for the correct answer

  QuizQuestion({
    required this.questionText,
    required this.options,
    this.explanation,
  });
}

class QuizOption {
  final String optionText;
  final bool isCorrect;

  QuizOption({required this.optionText, required this.isCorrect});
}

// Define the correct answers based on user input (0-based index: A=0, B=1, C=2, D=3)
const List<List<int>> correctAnswersList = [
  [1], // Q1: B
  [0, 2], // Q2: A, C
  [0, 1, 3], // Q3: A, B, D
  [1], // Q4: B
  [0], // Q5: A
  [0, 2], // Q6: A, C
  [2], // Q7: C
  [1], // Q8: B
  [0, 1, 2], // Q9: A, B, C
  [0, 1], // Q10: A, B
  [0], // Q11: A
  [0, 1, 2], // Q12: A, B, C
  [1], // Q13: B
  [1], // Q14: B
  [0, 1], // Q15: A, B
  [2], // Q16: C
  [1], // Q17: B
  [1], // Q18: B
  [1], // Q19: B
  [0, 1], // Q20: A, B
  [1], // Q21: B
  [2], // Q22: C
  [0, 2, 3], // Q23: A, C, D
  [1], // Q24: B
  [2], // Q25: C
  [1], // Q26: B
  [0], // Q27: A
  [2], // Q28: C
  [0, 1], // Q29: A, B
  [0], // Q30: A
  [2], // Q31: C
  [1], // Q32: B
  [1], // Q33: B
  [1], // Q34: B
  [2], // Q35: C
  [1], // Q36: B
  [1], // Q37: B
  [1], // Q38: B
  [2], // Q39: C
];

// Parse the raw quiz text and populate the questions list
List<QuizQuestion> parseQuizData(String rawData) {
  List<QuizQuestion> questions = [];
  List<String> lines = rawData.trim().split('\n\n'); // Split by double newline

  for (String block in lines) {
    List<String> parts = block.trim().split('\n');
    if (parts.length >= 2) {
      // Need at least a question and one option
      String questionText = parts[0].trim();
      List<QuizOption> options = [];
      int questionIndex = questions.length;

      if (questionIndex >= correctAnswersList.length) {
        // Handle error or default behavior if answers are missing
        continue; // Skip this question if no answer data
      }

      List<int> correctIndices = correctAnswersList[questionIndex];

      for (int i = 1; i < parts.length; i++) {
        String optionLine = parts[i].trim();
        // Basic check for option format (e.g., "A. Text")
        if (optionLine.isNotEmpty &&
            optionLine.length > 2 &&
            optionLine[1] == '.' &&
            optionLine[0].toUpperCase().codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
            optionLine[0].toUpperCase().codeUnitAt(0) <= 'Z'.codeUnitAt(0)) {
          String optionText = optionLine.substring(3).trim();
          int optionIndex = i - 1; // 0-based index (A=0, B=1, etc.)

          // Determine if this option is correct based on the provided list
          bool isCorrect = correctIndices.contains(optionIndex);

          options.add(QuizOption(optionText: optionText, isCorrect: isCorrect));
        }
      }
      if (options.isNotEmpty) {
        questions
            .add(QuizQuestion(questionText: questionText, options: options));
      }
    }
  }
  return questions;
}

// Raw data from the file (replace with actual file reading logic later)
const String rawQuizContent = """
Quelle bactérie est responsable de la tuberculose ?

A. Mycobacterium leprae

B. Mycobacterium tuberculosis

C. Streptococcus pneumoniae

D. Staphylococcus aureus

Laquelle des affirmations suivantes sur l’infection tuberculeuse latente (ITL) est vraie ?

A. Les bacilles sont vivants mais inactifs

B. La personne est contagieuse

C. Il n’y a pas de symptôme clinique

D. La radiographie pulmonaire est toujours anormale

Quels sont les principaux symptômes de la tuberculose pulmonaire ?

A. Toux persistante

B. Sueurs nocturnes

C. Éruption cutanée

D. Perte de poids

Comment se transmet principalement la tuberculose ?

A. Par contact cutané

B. Par voie aérienne (gouttelettes)

C. Par voie fécale-orale

D. Par piqûre d’insecte

Quelle forme de tuberculose est contagieuse ?

A. Pulmonaire

B. Rénale

C. Osseuse

D. Méningée

Quel examen est utilisé pour diagnostiquer une tuberculose pulmonaire ?

A. Radiographie thoracique

B. Échographie abdominale

C. Prélèvement respiratoire (expectorations)

D. IRM cérébrale

Durée minimale du traitement antibiotique curatif pour la tuberculose active ?

A. 1 mois

B. 3 mois

C. 6 mois

D. 12 mois

Le traitement préventif de l’ITL dure généralement :

A. 1 mois

B. 3 mois

C. 6 mois

D. 9 mois

Quels médicaments composent la phase initiale du traitement standard (2 mois) ?

A. Isoniazide

B. Rifampicine

C. Pyrazinamide

D. Amoxicilline

Après la phase initiale, quels antibiotiques sont poursuivis (4 mois) ?

A. Isoniazide

B. Rifampicine

C. Ethambutol

D. Pyrazinamide

Quel risque majeur survient en cas d’oubli répété de prises de traitement ?

A. Développement de souches résistantes

B. Infection fongique

C. Hyperglycémie

D. Anémie

Parmi ces effets secondaires, lesquels sont associés au traitement tuberculeux ?

A. Hépatite médicamenteuse

B. Troubles de la vision

C. Coloration rouge-orangée des urines

D. Hypercholestérolémie

Quel conseil d’utilisation est recommandé pour la plupart des antibiotiques antituberculeux ?

A. À prendre avec un repas riche en graisses

B. À jeun (2h avant ou 30 min après)

C. Toujours avant le coucher

D. Une heure après un effort physique

Quel médicament existe sous la forme combinée ‘Rifater’ ?

A. Isoniazide + Ethambutol

B. Isoniazide + Rifampicine + Pyrazinamide

C. Rifampicine + Ethambutol

D. Pyrazinamide + Ethambutol

Quels sont les dosages de RIMIFON disponibles ?

A. 50 mg

B. 150 mg

C. 300 mg

D. 500 mg

Laquelle de ces affirmations sur MyTuberculose est FAUSSE ?

A. Fonctionne en mode hors ligne

B. Propose un quiz éducatif

C. Permet la prise de rendez‐vous directement

D. Offre un espace pour les professionnels (optionnel)

Quel type de stockage local utilisera l’application ?

A. Realm

B. SQLite

C. Core Data

D. IndexedDB

Pour gérer les rappels, l’app intégrera :

A. Firebase Cloud Messaging

B. flutter_local_notifications

C. PushKit

D. OneSignal

Quel composant gère la multi‐localisation (i18n) sous Flutter ?

A. intl_provider

B. flutter_localizations

C. flutter_i18n

D. easy_localization

Dans le journal de suivi, quelles vues sont disponibles ?

A. Vue quotidienne

B. Vue hebdomadaire

C. Vue mensuelle

D. Vue annuelle

Quels patients peuvent choisir d’envoyer leur historique à leur médecin ?

A. Tous automatiquement

B. Ceux ayant saisi le code médecin

C. Ceux sans compte

D. Aucun

Quel mécanisme lie un patient à son médecin ?

A. Email d’invitation

B. Partage de QR code

C. Code unique généré

D. Appairage Bluetooth

Quelles informations facultatives un patient peut‐il renseigner à l’inscription ?

A. Numéro de téléphone

B. Profession

C. Email

D. Adresse

Combien de langues prioritaires l’app doit-elle supporter au lancement ?

A. 1

B. À définir avec le CLAT (au moins 3)

C. 5

D. 10

La section “Liens utiles” doit permettre :

A. L’édition en ligne

B. L’ajout par l’utilisateur

C. Le téléchargement pour accès hors ligne

D. L’envoi par email

Quel service backend est spécifié pour la base de données ?

A. Firebase

B. Supabase

C. AWS Amplify

D. Azure Mobile Apps

Quel est l’intérêt principal du mode hors ligne ?

A. Accès permanent aux données

B. Partage instantané avec le médecin

C. Accélération des requêtes réseau

D. Réduction de la taille de l’app

Le quiz “Vrai ou Faux” comporte combien de questions initialement ?

A. 10

B. 20

C. 40

D. 50

Qui reçoit l’alerte après 3–4 jours sans prise ?

A. Le patient

B. Le médecin référent

C. L’infirmier uniquement

D. L’équipe administrative

Quel framework Flutter gère la gestion d’état recommandée pour ce projet simple ?

A. Provider

B. Bloc

C. MobX

D. Redux

Dans la fiche médicament, quelle donnée n’est PAS requise ?

A. Photo du comprimé

B. Effets secondaires

C. Code-barres EAN

D. Posologie

Le stockage des vidéos éducatives doit se faire :

A. En streaming uniquement

B. Localement pour un accès hors ligne

C. Sur un CDN externe

D. Dans la galerie système

Quelle alerte signale un stock bas de médicament ?

A. Notification push

B. Alerte locale

C. Email automatique

D. SMS

Quel schéma de navigation est conseillé pour l’UI ?

A. Drawer + onglets

B. Barre de navigation inférieure (BottomNavigationBar)

C. Navigation par gestes

D. Menu contextuel

Pour assurer la confidentialité, on mettra en place :

A. Authentification OAuth2

B. Stockage non chiffré

C. Row Level Security (RLS) sur Supabase

D. Partage public des URL

Quelle méthode permet au patient de délier son médecin ?

A. Suppression du compte

B. Bouton “Dissocier le médecin” dans le profil

C. Nouvelle inscription

D. Reset de l’application

Quel type de notification doit fonctionner même si l’app est fermée ?

A. Notification in-app seulement

B. Notification en background

C. Alertes web push

D. Bannières système uniquement

Quel outil gratuit est prévu pour la conception des maquettes ?

A. Sketch

B. Figma (version gratuite)

C. Adobe XD (payant)

D. InVision

Combien d’heures de travail ont été estimées pour ce projet ?

A. 100h

B. 180h

C. 250h

D. 40h

Quel est le coût théorique du projet au tarif de 25 €/h ?

A. 2 500 €

B. 3 600 €

C. 4 500 €

D. 5 000 €
""";

// Populate the list using the parser
List<QuizQuestion> quizQuestions = parseQuizData(rawQuizContent);
