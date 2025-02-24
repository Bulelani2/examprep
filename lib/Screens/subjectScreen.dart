import 'package:final_exam_prep/Screens/examtipsscreen.dart';
import 'package:final_exam_prep/Screens/pastpaperscreen.dart';
import 'package:final_exam_prep/Screens/studyAnalysisScreen.dart';
import 'package:final_exam_prep/Screens/topicBasedScreen.dart';
import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectScreen extends StatelessWidget {
  final String title;

  SubjectScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: AppColors.primary, // ✅ Using Theme Color
      ),
      backgroundColor: AppColors.background, // ✅ Set Background Color
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOptionTile(
                context, 'Past Papers', Icons.folder, AppColors.blue),
            _buildOptionTile(
                context, 'Topic-Based Questions', Icons.list, AppColors.green),
            _buildOptionTile(
                context, 'Exam Writing Tips', Icons.star, AppColors.orange),
            _buildOptionTile(
                context, 'Study Analysis', Icons.analytics, AppColors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
      BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 5,
      color: AppColors.cardBackground, // ✅ Consistent Card Background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.text, // ✅ Consistent Text Color
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: AppColors.text),
        onTap: () {
          if (title == 'Exam Writing Tips') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExamWritingTipsScreen(
                  subject: this.title,
                ),
              ),
            );
          } else if (title == 'Study Analysis') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudyAnalysisScreen(),
              ),
            );
          } else if (title == 'Topic-Based Questions') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopicBasedScreen(subject: this.title),
              ),
            );
          } else if (title == 'Past Papers') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PastPapersScreen(
                  subject: this.title,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
