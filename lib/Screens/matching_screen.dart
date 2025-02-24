import 'dart:async';
import 'package:final_exam_prep/Screens/homeScreen.dart';
import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final Function(int, String) onAnswerSelected;

  const MatchingScreen({
    Key? key,
    required this.questions,
    required this.onAnswerSelected,
  }) : super(key: key);

  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  String? userAnswer;
  int correctAnswers = 0;
  int timeLeft = 10;
  late Timer _timer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    startTimer();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void startTimer() {
    timeLeft = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    _timer.cancel();
    if (userAnswer == null) return;

    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        userAnswer = null;
        startTimer();
        _fadeController.reset();
        _fadeController.forward();
      });
    } else {
      showCompletionDialog();
    }
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("🎉 Quiz Completed!", textAlign: TextAlign.center),
        content: Text(
          "You scored $correctAnswers out of ${widget.questions.length}!",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: const Text("Go Home",
                style: TextStyle(color: AppColors.textLight)),
          ),
        ],
      ),
    );
  }

  List<String> getShuffledAnswers() {
    List<String> answers = widget.questions
        .where((q) =>
            q['question'] != widget.questions[currentQuestionIndex]['question'])
        .map((q) => q['answer'] as String)
        .toList();
    answers.add(widget.questions[currentQuestionIndex]['answer']);
    answers.shuffle();
    return answers;
  }

  @override
  Widget build(BuildContext context) {
    var currentQuestion = widget.questions[currentQuestionIndex];
    double progress = (currentQuestionIndex + 1) / widget.questions.length;

    return Center(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.background,
                color: AppColors.blue,
                minHeight: 8,
              ),
              const SizedBox(height: 20),
              Text(
                "Question ${currentQuestionIndex + 1}: ${currentQuestion['question']}",
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: timeLeft / 10,
                      backgroundColor: AppColors.background,
                      color: AppColors.red,
                      strokeWidth: 6,
                    ),
                  ),
                  Text(
                    "$timeLeft",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.red),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: userAnswer,
                hint: const Text("Select an answer"),
                items: getShuffledAnswers().map((answer) {
                  return DropdownMenuItem<String>(
                    value: answer,
                    child: Text(answer,
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: AppColors.text)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    userAnswer = value!;
                    widget.onAnswerSelected(currentQuestionIndex, value);
                    if (value == currentQuestion['answer']) {
                      correctAnswers++;
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                onPressed: nextQuestion,
                child: Text(
                  currentQuestionIndex == widget.questions.length - 1
                      ? "Finish Quiz"
                      : "Next Question",
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: AppColors.textLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
