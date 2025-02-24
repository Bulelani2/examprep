import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DifficultySelectionScreen extends StatelessWidget {
  final Function(String) onSelectDifficulty;

  const DifficultySelectionScreen({Key? key, required this.onSelectDifficulty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Difficulty Level',
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Choose Your Difficulty Level',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              _buildDifficultyButton(
                  'Easy', AppColors.green, Icons.sentiment_satisfied),
              SizedBox(height: 25),
              _buildDifficultyButton(
                  'Medium', AppColors.orange, Icons.sentiment_neutral),
              SizedBox(height: 25),
              _buildDifficultyButton(
                  'Hard', AppColors.red, Icons.sentiment_dissatisfied),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.background,
    );
  }

  Widget _buildDifficultyButton(String level, Color color, IconData icon) {
    return ElevatedButton(
      onPressed: () => onSelectDifficulty(level.toLowerCase()),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: AppColors.textLight),
          SizedBox(width: 15),
          Text(
            level,
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}
