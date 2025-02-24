import 'package:final_exam_prep/Screens/homeScreen.dart';
import 'package:final_exam_prep/data/Json/questionpaers.dart';
import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'multiple_choice_screen.dart';
import 'matching_screen.dart';
import 'terminology_screen.dart';

class QuizScreen extends StatefulWidget {
  final String subject;
  final String difficulty;

  const QuizScreen({Key? key, required this.subject, required this.difficulty})
      : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  String? userAnswer;
  String? feedbackMessage;
  bool answered = false;
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() {
    List<Map<String, dynamic>> loadedQuestions = [];

    if (widget.difficulty == 'easy') {
      if (multiple_choice.isNotEmpty &&
          multiple_choice[0]['multiple_choice']['questions'] != null) {
        loadedQuestions = List<Map<String, dynamic>>.from(
            multiple_choice[0]['multiple_choice']['questions']);
      }
    } else if (widget.difficulty == 'medium') {
      if (matching.isNotEmpty && matching[0]['matching']['pairs'] != null) {
        loadedQuestions = List<Map<String, dynamic>>.from(
          matching[0]['matching']['pairs'].entries.map((entry) {
            return {
              'question':
                  entry.value['definition'] ?? 'No definition available',
              'answer': entry.value['answer'] ?? 'No answer available'
            };
          }).toList(),
        );
      }
    } else if (widget.difficulty == 'hard') {
      if (terminology.isNotEmpty &&
          terminology[0]['terminology'] != null &&
          terminology[0]['terminology']['questions'] != null &&
          terminology[0]['terminology']['questions'] is List) {
        loadedQuestions = List<Map<String, dynamic>>.from(
          (terminology[0]['terminology']['questions'] as List).map((question) {
            return {
              'question': question['description'] ?? 'No description available',
              'answer': question['answer'] ?? 'No answer available',
            };
          }),
        );
      }
    }

    setState(() {
      questions = loadedQuestions;
    });
  }

  void checkAnswer(String selectedAnswer) {
    var correctAnswer = questions[currentQuestionIndex]['answer'];

    setState(() {
      userAnswer = selectedAnswer;
      answered = true;

      if (selectedAnswer == correctAnswer) {
        feedbackMessage = "✅ Correct!";
      } else {
        feedbackMessage = "❌ Incorrect! The correct answer is: $correctAnswer";
      }
    });
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title:
            Text("Quiz Completed!", style: TextStyle(color: AppColors.primary)),
        content: Text(
          "You got $correctAnswers out of ${questions.length} correct.",
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                currentQuestionIndex = 0;
                correctAnswers = 0;
                answered = false;
                userAnswer = null;
                feedbackMessage = "";
              });
            },
            child:
                Text("Restart", style: TextStyle(color: AppColors.secondary)),
          ),
        ],
      ),
    );
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        userAnswer = null;
        feedbackMessage = null;
        answered = false;
      });
    } else {
      showCompletionDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title:
              const Text('Quiz', style: TextStyle(color: AppColors.textLight)),
          backgroundColor: AppColors.primary,
        ),
        body: const Center(
          child: Text("Loading questions... Please wait.",
              style: TextStyle(color: AppColors.text)),
        ),
      );
    }

    var question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz', style: TextStyle(color: AppColors.textLight)),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            if (widget.difficulty == 'easy' && question.containsKey('options'))
              MultipleChoiceScreen(
                question: question,
                checkAnswer: (selectedAnswer) {
                  setState(() {
                    if (selectedAnswer == question['answer']) {
                      correctAnswers++; // ✅ Correctly track only once
                    }
                    checkAnswer(selectedAnswer);
                  });
                },
                answered: answered,
                userAnswer: userAnswer,
                questionNumber: currentQuestionIndex + 1,
                totalQuestions: questions.length,
                correctAnswers: correctAnswers,
                onQuizComplete: () {
                  Navigator.pop(context);
                },
              )
            else if (widget.difficulty == 'medium')
              MatchingScreen(
                questions: questions,
                onAnswerSelected: (index, value) {
                  setState(() {
                    userAnswer = value;
                  });
                },
              )
            else
              TerminologyScreen(
                onQuizComplete: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
            if (feedbackMessage != null)
              Text(
                feedbackMessage!,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text),
              ),
            if (answered)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary),
                onPressed: nextQuestion,
                child: currentQuestionIndex < questions.length - 1
                    ? Text("Next Question",
                        style: TextStyle(color: AppColors.textLight))
                    : Text("Finish",
                        style: TextStyle(color: AppColors.textLight)),
              ),
          ],
        ),
      ),
    );
  }
}
