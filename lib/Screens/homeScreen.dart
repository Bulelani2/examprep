import 'package:final_exam_prep/Screens/subjectScreen.dart';
import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary, // ✅ Uses primary color
        title: Text(
          'Exam Prep',
          style: TextStyle(color: AppColors.textLight),
        ),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCategoryCard(
              context, 'Mathematics', Icons.calculate, AppColors.blue),
          _buildCategoryCard(
              context, 'Physical Sciences', Icons.science, AppColors.green),
          _buildCategoryCard(
              context, 'Life Sciences', Icons.biotech, AppColors.red),
          _buildCategoryCard(
              context, 'Accounting', Icons.attach_money, AppColors.orange),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String title, IconData icon, Color color) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubjectScreen(title: title)),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: AppColors.textLight),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
