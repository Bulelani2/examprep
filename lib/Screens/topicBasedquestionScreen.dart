import 'package:final_exam_prep/data/Json/accountingjson.dart';
import 'package:final_exam_prep/data/Json/mathemathisjson.dart';
import 'package:final_exam_prep/data/Json/physicsjson.dart';
import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:final_exam_prep/data/score_manager/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_exam_prep/data/Json/lifesciencesjson.dart';

class TopicBasedQuestionsScreen extends StatefulWidget {
  final String topic;

  TopicBasedQuestionsScreen({
    required this.topic,
  });

  @override
  _TopicBasedQuestionsScreenState createState() =>
      _TopicBasedQuestionsScreenState();
}

class _TopicBasedQuestionsScreenState extends State<TopicBasedQuestionsScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  bool answered = false;
  String? userAnswer;
  int correctAnswers = 0;
  String feedbackMessage = "";
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    loadQuestions();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void loadQuestions() {
    Map<String, List<Map<String, dynamic>>> topicData = {
      // Life Sciences
      'Meiosis': meiosis,
      'Reproduction in Vertebrates': reproduction_in_vertebrates,
      'Human Reproduction': human_reproduction,
      'Responding to the Environment (Humans)':
          responding_to_the_environment_humans,
      'Human Endocrine System': human_endocrine_system,
      'Homeostasis in Humans': homeostasis_in_humans,
      'Responding to the Environment (Plants)':
          responding_to_the_environment_plants,
      'Human Impact on Environment': human_impact_on_environment,

      // Mathematics
      'Algebra': algebra,
      'Sequences and Series': sequences_and_series,
      'Finance, Growth and Decay': finance_growth_decay,
      'Functions and Graphs': functions_and_graphs,
      'Equations and Inequalities': equationsAndInequalities,
      'Calculus': calculus,
      'Probability': probability,
      'Geometry': geometry,
      'Analytical Geometry': analytical_geometry,
      'Statistics': statistics,
      'Trigonometry': trigonometry,

      // Physical Sciences
      "Newton's Laws": newtons_laws,
      'Work, Energy, and Power': work_energy_power,
      'Acids and Bases': acids_bases,
      'Momentum and Impulse': momentum_impulse,
      'Electric Circuits': electric_circuits,
      'Matter and Materials': matter_materials,
      'Chemical Reactions': chemical_reactions,
      'Thermodynamics': thermodynamics,
      'Waves, Sound, and Light': waves_sound_light,

      //Accounting
      'Financial Statements': financial_statements,
      'Managerial Accounting': managerial_accounting,
      'Cost Accounting': cost_accounting,
      'Bank Reconciliation': bank_reconciliation,
      'Taxation': taxation,
      'Budgeting': budgeting,
      'Internal Auditing & Control': internal_auditing,
      'Business Transactions': business_transactions,
      'Accounting Principles': accounting_principles,
      'Financial Reporting & Evaluation': financial_reporting_evaluation,
    };

    if (topicData.containsKey(widget.topic) &&
        topicData[widget.topic]!.isNotEmpty) {
      setState(() {
        questions = List<Map<String, dynamic>>.from(
            topicData[widget.topic]![0][widget.topic]['questions']);
      });
    }
  }

  void checkAnswer(String selectedAnswer) {
    var correctAnswer = questions[currentQuestionIndex]['answer'];

    setState(() {
      userAnswer = selectedAnswer;
      answered = true;

      if (selectedAnswer == correctAnswer) {
        feedbackMessage = "✅ Correct!";
        correctAnswers++;
      } else {
        feedbackMessage = "❌ Incorrect! The correct answer is: $correctAnswer";
        _animateButton();
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        answered = false;
        userAnswer = null;
        feedbackMessage = "";
      } else {
        showCompletionDialog();
      }
    });
  }

  void showCompletionDialog() async {
    await ScoreManager()
        .updateScore(widget.topic, correctAnswers, questions.length);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title:
            Text("Quiz Completed!", style: TextStyle(color: AppColors.primary)),
        content:
            Text("You got $correctAnswers out of ${questions.length} correct."),
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
            child: Text("Restart", style: TextStyle(color: AppColors.blue)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Exit", style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  void _animateButton() {
    _animationController.forward().then((value) {
      _animationController.reverse();
    });

    setState(() {});
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  Color _getButtonColor(String option) {
    if (answered) {
      return option == userAnswer
          ? (option == questions[currentQuestionIndex]['answer']
              ? AppColors.green
              : AppColors.red)
          : AppColors.blue;
    } else {
      return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.topic,
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.primary,
        ),
        body: Center(
          child: Text(
            "No questions available for this topic.",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic,
            style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight)),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Question ${currentQuestionIndex + 1} of ${questions.length}",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              questions[currentQuestionIndex]['question'],
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...List.generate(
              (questions[currentQuestionIndex]['options'] as List).length,
              (index) {
                String option =
                    questions[currentQuestionIndex]['options'][index];
                Color buttonColor = _getButtonColor(option);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: answered ? null : () => checkAnswer(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(2, 4),
                              blurRadius: 5)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Center(
                          child: Text(
                            option,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            if (answered)
              Text(
                feedbackMessage,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            if (answered)
              ElevatedButton(
                onPressed: nextQuestion,
                child: Text(currentQuestionIndex < questions.length - 1
                    ? "Next Question"
                    : "Finish"),
              ),
          ],
        ),
      ),
    );
  }
}
