import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:final_exam_prep/Screens/homeScreen.dart';
import 'package:final_exam_prep/data/score_manager/score_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  await ScoreManager().loadScores(); // Load saved scores before app starts

  runApp(ExamPrepApp());
}

class ExamPrepApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exam Prep App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
