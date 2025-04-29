import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
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
  // Store selected indices for the current question. Use Set for multi-choice.
  Set<int> _selectedOptionIndices = {}; 
  int? _highScore;
  // Store user's answers for review later (optional)
  // Map<int, Set<int>> _userAnswers = {}; 

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _resetQuizState();
  }

  void _resetQuizState() {
    _currentQuestionIndex = 0;
    _score = 0;
    _quizCompleted = false;
    _selectedOptionIndices = {};
    // _userAnswers = {};
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('quizHighScore');
    });
  }

  Future<void> _saveScoreAndMaybeUpdateHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (_highScore == null || _score > _highScore!) {
      await prefs.setInt('quizHighScore', _score);
      setState(() {
        _highScore = _score;
      });
    } else {
    }
  }

  void _handleOptionSelection(int optionIndex, bool isMultiChoice) {
    setState(() {
      if (isMultiChoice) {
        if (_selectedOptionIndices.contains(optionIndex)) {
          _selectedOptionIndices.remove(optionIndex);
        } else {
          _selectedOptionIndices.add(optionIndex);
        }
      } else {
        // Single choice: clear previous and set new selection
        _selectedOptionIndices = {optionIndex};
        // For single choice, we can proceed immediately or wait for a next button
        // Let's add a next button for consistency
      }
    });
  }

  void _submitAnswer() {
    if (_quizCompleted) return;

    final question = quizQuestions[_currentQuestionIndex];
    final correctIndices = question.options
        .asMap()
        .entries
        .where((entry) => entry.value.isCorrect)
        .map((entry) => entry.key)
        .toSet();

    bool isAnswerCorrect = false;
    if (correctIndices.length == _selectedOptionIndices.length &&
        correctIndices.containsAll(_selectedOptionIndices)) {
      isAnswerCorrect = true;
    }

    if (isAnswerCorrect) {
      _score++;
    }

    // Store user answer for review (optional)
    // _userAnswers[_currentQuestionIndex] = Set.from(_selectedOptionIndices);

    // Move to the next question or finish the quiz
    setState(() {
       _selectedOptionIndices = {}; // Clear selection for next question
      if (_currentQuestionIndex < quizQuestions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _quizCompleted = true;
        _saveScoreAndMaybeUpdateHighScore();
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
      return const Center(child: Text('Erreur : Index de question invalide.'));
    }

    final question = quizQuestions[_currentQuestionIndex];
    final bool isMultiChoice = question.options.where((o) => o.isCorrect).length > 1;

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
          const SizedBox(height: 10),
          if (isMultiChoice)
            Text(
              '(Plusieurs réponses possibles)',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 20),
          Text(
            question.questionText,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          // Use CheckboxListTile for multi-choice, RadioListTile for single-choice
          ...question.options.asMap().entries.map((entry) {
            int idx = entry.key;
            QuizOption option = entry.value;
            return isMultiChoice
                ? CheckboxListTile(
                    title: Text(option.optionText),
                    value: _selectedOptionIndices.contains(idx),
                    onChanged: (bool? value) {
                      _handleOptionSelection(idx, true);
                    },
                  )
                : RadioListTile<int>(
                    title: Text(option.optionText),
                    value: idx,
                    groupValue: _selectedOptionIndices.isNotEmpty ? _selectedOptionIndices.first : null,
                    onChanged: (int? value) {
                       if (value != null) {
                         _handleOptionSelection(value, false);
                       }
                    },
                  );
          }).toList(),
          const SizedBox(height: 30),
          ElevatedButton(
            // Disable button if no option is selected
            onPressed: _selectedOptionIndices.isNotEmpty ? _submitAnswer : null, 
            child: Text(_currentQuestionIndex < quizQuestions.length - 1 ? 'Suivant' : 'Terminer'),
          ),
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
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate back or to another screen
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Retour'),
            )
          ],
        ),
      ),
    );
  }
}

