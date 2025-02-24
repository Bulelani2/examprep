import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultipleChoiceScreen extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(String) checkAnswer;
  final bool answered;
  final String? userAnswer;
  final int questionNumber;
  final int totalQuestions;
  final int correctAnswers;
  final VoidCallback onQuizComplete;

  const MultipleChoiceScreen({
    Key? key,
    required this.question,
    required this.checkAnswer,
    required this.answered,
    required this.userAnswer,
    required this.questionNumber,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.onQuizComplete,
  }) : super(key: key);

  @override
  _MultipleChoiceScreenState createState() => _MultipleChoiceScreenState();
}

class _MultipleChoiceScreenState extends State<MultipleChoiceScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;
  bool _isShaking = false;

  @override
  void initState() {
    super.initState();

    // Fade Animation Controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Shake Animation Controller
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.03, 0), // Small left-right shake effect
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _animateButton() {
    if (widget.answered && widget.userAnswer != widget.question['answer']) {
      _shakeController.forward().then((_) => _shakeController.reverse());
      setState(() {
        _isShaking = true;
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          _isShaking = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Question Number Display
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Question ${widget.questionNumber} of ${widget.totalQuestions}",
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text),
            ),
          ),

          // Question Text
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
            child: Text(
              widget.question['question'] ?? 'No question available',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Answer Options
          ...List.generate(
            (widget.question['options'] as List).length,
            (index) {
              String option = widget.question['options'][index];
              Color buttonColor = _getButtonColor(option);

              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: widget.answered
                      ? null
                      : () {
                          widget.checkAnswer(option);
                          _animateButton();
                          if (widget.questionNumber == widget.totalQuestions) {
                            setState(() {});
                          }
                        },
                  child: AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset:
                            _isShaking ? _shakeAnimation.value : Offset.zero,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
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
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getButtonColor(String option) {
    if (widget.answered) {
      return option == widget.userAnswer
          ? (option == widget.question['answer']
              ? AppColors.green
              : AppColors.red)
          : AppColors.blue;
    } else {
      return AppColors.blue;
    }
  }
}
