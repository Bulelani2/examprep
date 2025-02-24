import 'package:final_exam_prep/data/Json/questionpaers.dart';
import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:flutter/material.dart';

class TerminologyScreen extends StatefulWidget {
  final VoidCallback onQuizComplete;

  const TerminologyScreen({Key? key, required this.onQuizComplete})
      : super(key: key);

  @override
  _TerminologyScreenState createState() => _TerminologyScreenState();
}

class _TerminologyScreenState extends State<TerminologyScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  TextEditingController answerController = TextEditingController();
  int correctAnswers = 0;
  bool showFeedback = false;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  void loadQuestions() {
    setState(() {
      questions = List<Map<String, dynamic>>.from(
          terminology[0]['terminology']['questions']);
    });
  }

  void checkAnswer() {
    setState(() {
      showFeedback = true;
      if (answerController.text.trim().toLowerCase() ==
          questions[currentIndex]['answer'].toLowerCase()) {
        correctAnswers++;
      }
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showFeedback = false;
        if (currentIndex < questions.length - 1) {
          currentIndex++;
          answerController.clear();
        } else {
          widget.onQuizComplete();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Card(
        color: AppColors.cardBackground,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Question ${currentIndex + 1} of ${questions.length}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text),
              ),
              const SizedBox(height: 15),
              Text(
                questions[currentIndex]['description'],
                style: TextStyle(fontSize: 16, color: AppColors.text),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: answerController,
                decoration: InputDecoration(
                  labelText: "Your Answer",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: AppColors.background,
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textLight,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: checkAnswer,
                child: const Text("Submit Answer"),
              ),
              if (showFeedback)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    answerController.text.trim().toLowerCase() ==
                            questions[currentIndex]['answer'].toLowerCase()
                        ? "✅ Correct!"
                        : "❌ Incorrect. Answer: ${questions[currentIndex]['answer']}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: answerController.text.trim().toLowerCase() ==
                              questions[currentIndex]['answer'].toLowerCase()
                          ? AppColors.green
                          : AppColors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
