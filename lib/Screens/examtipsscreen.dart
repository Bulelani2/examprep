import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_exam_prep/data/appcolour/app_colours.dart';

class ExamWritingTipsScreen extends StatelessWidget {
  final String subject;

  ExamWritingTipsScreen({required this.subject});

  final List<Map<String, dynamic>> examTips = [
    {
      'subject': 'Life Sciences',
      'studyTips': [
        'Summarize key concepts in your own words.',
        'Use diagrams and flowcharts to understand processes.',
        'Revise past papers and practice essay questions.',
        'Use past question papers to practice, preferably from four years ago.',
        'Understand the structure of the exam paper and identify commonly repeated questions.',
        'Check for keywords in definitions to ensure accurate answers.',
        'Start practicing at the beginning of the year, dedicating 30 minutes to 1 hour per day.',
        'Practice each section weekly and repeat it until confident in answering exam questions.',
        'Create a study schedule and stick to it.',
        'Ensure you get enough sleep before the exam to retain information better.'
      ],
      'answeringTechniques': [
        'Use key biological terms correctly in your answers.',
        'For MCQs, eliminate incorrect options before choosing.',
        'In essay questions, structure your response logically with an introduction, body, and conclusion.'
      ],
      'examDayTips': [
        'Read all questions carefully before answering.',
        'Manage time wisely – do not spend too long on one question.',
        'Highlight keywords in questions to focus your answers.'
      ]
    },
    {
      'subject': 'Mathematics',
      'studyTips': [
        'Practice solving past exam questions under timed conditions.',
        'Understand the formulas instead of memorizing them.',
        'Break down complex problems into smaller steps.',
        'Use past question papers to practice, preferably from four years ago.',
        'Understand the structure of the exam paper and identify commonly repeated questions.',
        'Check for keywords in definitions to ensure accurate answers.',
        'Start practicing at the beginning of the year, dedicating 30 minutes to 1 hour per day.',
        'Practice each section weekly and repeat it until confident in answering exam questions.',
        'Create a study schedule and stick to it.',
        'Ensure you get enough sleep before the exam to retain information better.'
      ],
      'answeringTechniques': [
        'Show all steps in your calculations for full marks.',
        'Double-check answers, especially for sign errors.',
        'Use substitution to verify solutions in equations.'
      ],
      'examDayTips': [
        'Start with the questions you find easiest to gain confidence.',
        'Leave time at the end to review answers.',
        'Use scrap paper for rough calculations to stay organized.'
      ]
    },
    {
      'subject': 'Accounting',
      'studyTips': [
        'Understand the principles behind debits and credits.',
        'Practice financial statements frequently.',
        'Use color coding for different account types in notes.',
        'Use past question papers to practice, preferably from four years ago.',
        'Understand the structure of the exam paper and identify commonly repeated questions.',
        'Check for keywords in definitions to ensure accurate answers.',
        'Start practicing at the beginning of the year, dedicating 30 minutes to 1 hour per day.',
        'Practice each section weekly and repeat it until confident in answering exam questions.',
        'Create a study schedule and stick to it.',
        'Ensure you get enough sleep before the exam to retain information better.'
      ],
      'answeringTechniques': [
        'Ensure debits and credits balance before moving on.',
        'Label all calculations and financial statements clearly.',
        'Explain reasoning in theoretical questions.'
      ],
      'examDayTips': [
        'Check calculations at least twice before finalizing answers.',
        'Keep your answers neat to avoid confusion.',
        'Use time wisely – don’t get stuck on a single adjustment.'
      ]
    },
    {
      'subject': 'Physical Sciences',
      'studyTips': [
        'Practice applying formulas instead of memorizing them.',
        'Understand concepts through real-life examples.',
        'Solve past papers and analyze trends in question types.',
        'Use past question papers to practice, preferably from four years ago.',
        'Understand the structure of the exam paper and identify commonly repeated questions.',
        'Check for keywords in definitions to ensure accurate answers.',
        'Start practicing at the beginning of the year, dedicating 30 minutes to 1 hour per day.',
        'Practice each section weekly and repeat it until confident in answering exam questions.',
        'Create a study schedule and stick to it.',
        'Ensure you get enough sleep before the exam to retain information better.'
      ],
      'answeringTechniques': [
        'Write given data, formula, and substitutions before solving.',
        'Use SI units – marks get deducted for missing units.',
        'Explain each step clearly in essay-type questions.'
      ],
      'examDayTips': [
        'Draw diagrams for physics problems when needed.',
        'Use a calculator efficiently – avoid unnecessary steps.',
        'Review your work, especially for rounding errors.'
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    // Find the selected subject’s tips
    final selectedTips = examTips.firstWhere(
      (element) => element['subject'] == subject,
      orElse: () =>
          {'studyTips': [], 'answeringTechniques': [], 'examDayTips': []},
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$subject Exam Tips',
          style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight),
        ),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSection("📚 Study Tips", selectedTips['studyTips']),
            buildSection("✏️ How to Answer Questions",
                selectedTips['answeringTechniques']),
            buildSection("⏳ Exam Day Tips", selectedTips['examDayTips']),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, List<String>? tips) {
    if (tips == null || tips.isEmpty) return SizedBox.shrink();

    return Card(
      color: AppColors.cardBackground,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Column(
              children: tips.map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.green, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: AppColors.text),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
