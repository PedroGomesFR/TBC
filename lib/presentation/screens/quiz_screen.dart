import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize selected answers list
    _selectedAnswers = List<int?>.filled(quizQuestions.length, null);
  }

  void _answerQuestion(int selectedOptionIndex) {
    if (_quizCompleted) return; // Don't process if quiz is done

    setState(() {
      _selectedAnswers[_currentQuestionIndex] = selectedOptionIndex;
      // Check if the selected option is correct
      // Note: This assumes only one correct answer per question for scoring.
      // The model supports multiple correct answers, but scoring logic needs adjustment if needed.
      if (quizQuestions[_currentQuestionIndex].options[selectedOptionIndex].isCorrect) {
        // Simple scoring: +1 for correct. Needs refinement if multiple answers are correct.
        // Check if this question was already answered correctly in a previous attempt (if allowing re-tries)
        // For now, just increment score if the selected one is marked as correct.
        // A more robust check would verify if *all* correct options are selected and *no* incorrect ones are.
        _score++; // Basic scoring, needs refinement for multiple correct answers
      }

      // Move to the next question or finish the quiz
      if (_currentQuestionIndex < quizQuestions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _quizCompleted = true;
        // TODO: Save score locally (Task 3.4.3)
        print('Quiz completed! Score: $_score / ${quizQuestions.length}');
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _selectedAnswers = List<int?>.filled(quizQuestions.length, null);
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

