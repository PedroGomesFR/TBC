import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:mytuberculose_app/data/models/quiz_model.dart';
// TODO: Import AppLocalizations when needed

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  List<int?> _selectedAnswers = []; // Store index of selected answer for each question
  int? _highScore;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _resetQuizState();
  }

  void _resetQuizState() {
    _selectedAnswers = List<int?>.filled(quizQuestions.length, null);
    _currentQuestionIndex = 0;
    _score = 0;
    _quizCompleted = false;
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('quizHighScore');
    });
  }

  Future<void> _saveScoreAndMaybeUpdateHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    // Save current score (optional, could just save high score)
    // await prefs.setInt('lastQuizScore', _score);

    // Update high score if current score is better
    if (_highScore == null || _score > _highScore!) {
      await prefs.setInt('quizHighScore', _score);
      setState(() {
        _highScore = _score;
      });
      print('New high score saved: $_score');
    } else {
      print('Score saved: $_score (High score: $_highScore)');
    }
  }

  void _answerQuestion(int selectedOptionIndex) {
    if (_quizCompleted) return; // Don't process if quiz is done

    setState(() {
      _selectedAnswers[_currentQuestionIndex] = selectedOptionIndex;
      // Basic scoring: +1 if the selected option is marked as correct.
      // Needs refinement for questions with multiple correct answers.
      if (quizQuestions[_currentQuestionIndex].options[selectedOptionIndex].isCorrect) {
         // Check if *all* correct answers are selected and *no* incorrect ones are for multi-answer questions.
         // For simplicity now, just check if *this* selected one is correct.
         bool isMultiAnswer = quizQuestions[_currentQuestionIndex].options.where((o) => o.isCorrect).length > 1;
         if (!isMultiAnswer) {
            _score++;
         } else {
            // Basic handling for multi-answer: give point only if this specific one is correct.
            // A better approach would track all selections for the question.
            _score++; // Needs better logic for multi-select scoring
         }
      }

      // Move to the next question or finish the quiz
      if (_currentQuestionIndex < quizQuestions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _quizCompleted = true;
        _saveScoreAndMaybeUpdateHighScore(); // Save score when quiz finishes
        print('Quiz completed! Score: $_score / ${quizQuestions.length}');
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _resetQuizState();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Localize titles and buttons
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Tuberculose'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _quizCompleted
          ? _buildResultScreen(context)
          : _buildQuestionScreen(context),
    );
  }

  Widget _buildQuestionScreen(BuildContext context) {
    if (quizQuestions.isEmpty) {
      return const Center(child: Text('Aucune question de quiz chargée.'));
    }
    if (_currentQuestionIndex >= quizQuestions.length) {
       return const Center(child: Text('Erreur : Index de question invalide.')); // Should not happen
    }

    final question = quizQuestions[_currentQuestionIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Question ${_currentQuestionIndex + 1}/${quizQuestions.length}',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            question.questionText,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          ...question.options.asMap().entries.map((entry) {
            int idx = entry.key;
            QuizOption option = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // TODO: Add visual feedback for selected answer if needed before moving next
                ),
                onPressed: () => _answerQuestion(idx),
                child: Text(option.optionText, textAlign: TextAlign.center),
              ),
            );
          }).toList(),
          // TODO: Add explanation display after answering?
        ],
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Quiz Terminé !',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Votre score : $_score / ${quizQuestions.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (_highScore != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Meilleur score : $_highScore / ${quizQuestions.length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 30),
            // TODO: Add review answers button?
            ElevatedButton(
              onPressed: _resetQuiz,
              child: const Text('Recommencer le Quiz'),
            ),
            // TODO: Button to go back or close
          ],
        ),
      ),
    );
  }
}

