// import 'package:final_exam_prep/Screens/topicBasedquestionScreen.dart';
// import 'package:final_exam_prep/data/Json/subjecttopicjson.dart';
// import 'package:final_exam_prep/data/appcolour/app_colours.dart';
// import 'package:final_exam_prep/data/score_manager/score_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TopicBasedScreen extends StatefulWidget {
//   final String subject;

//   TopicBasedScreen({Key? key, required this.subject}) : super(key: key);

//   @override
//   State<TopicBasedScreen> createState() => _TopicBasedScreenState();
// }

// class _TopicBasedScreenState extends State<TopicBasedScreen> {
//   @override
//   Widget build(BuildContext context) {
//     // Get topics for the selected subject
//     List<String> topics = subjectTopics[widget.subject] ?? [];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "${widget.subject} Topics",
//           style: GoogleFonts.poppins(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: AppColors.textLight),
//         ),
//         backgroundColor: AppColors.primary,
//       ),
//       backgroundColor: AppColors.background,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               "Choose a Topic",
//               style: GoogleFonts.poppins(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.text),
//             ),
//             const SizedBox(height: 20),

//             // Check if there are topics for the selected subject
//             if (topics.isEmpty)
//               Center(
//                 child: Text(
//                   "No topics available for this subject.",
//                   style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.red),
//                 ),
//               )
//             else
//               // Display Topics as Buttons with Scores
//               ...topics.map((topic) {
//                 double scorePercentage =
//                     ScoreManager().getScorePercentage(topic); // Get percentage

//                 return Card(
//                   elevation: 5,
//                   color: AppColors.cardBackground,
//                   child: ListTile(
//                     leading: Icon(Icons.book, color: AppColors.blue),
//                     title: Text(topic,
//                         style: GoogleFonts.poppins(
//                             fontSize: 18, color: AppColors.text)),
//                     subtitle: Text(
//                         "Score: ${scorePercentage.toStringAsFixed(1)}%",
//                         style: GoogleFonts.poppins(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.text)),
//                     trailing:
//                         Icon(Icons.arrow_forward_ios, color: AppColors.text),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => TopicBasedQuestionsScreen(
//                             topic: topic,
//                           ),
//                         ),
//                       ).then((_) {
//                         setState(
//                             () {}); // Refresh UI to show updated percentage
//                       });
//                     },
//                   ),
//                 );
//               }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:final_exam_prep/Screens/topicBasedquestionScreen.dart';
import 'package:final_exam_prep/data/Json/subjecttopicjson.dart';
import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:final_exam_prep/data/score_manager/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicBasedScreen extends StatefulWidget {
  final String subject;

  TopicBasedScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<TopicBasedScreen> createState() => _TopicBasedScreenState();
}

class _TopicBasedScreenState extends State<TopicBasedScreen> {
  @override
  Widget build(BuildContext context) {
    // Get topics for the selected subject, grouped into Paper 1 & Paper 2
    Map<String, List<String>>? subjectPapers =
        sortedSubjectTopics[widget.subject];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.subject} Topics",
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
        child: subjectPapers == null
            ? Center(
                child: Text(
                  "No topics available for this subject.",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.red),
                ),
              )
            : ListView(
                children: [
                  if (subjectPapers.containsKey("Paper 1")) ...[
                    Text(
                      "📘 Paper 1 Topics",
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text),
                    ),
                    const SizedBox(height: 10),
                    ..._buildTopicList(subjectPapers["Paper 1"]!),
                  ],
                  const SizedBox(height: 20),
                  if (subjectPapers.containsKey("Paper 2")) ...[
                    Text(
                      "📗 Paper 2 Topics",
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text),
                    ),
                    const SizedBox(height: 10),
                    ..._buildTopicList(subjectPapers["Paper 2"]!),
                  ],
                ],
              ),
      ),
    );
  }

  // Method to generate topic list UI
  List<Widget> _buildTopicList(List<String> topics) {
    return topics.map((topic) {
      double scorePercentage = ScoreManager().getScorePercentage(topic);

      return Card(
        elevation: 5,
        color: AppColors.cardBackground,
        child: ListTile(
          leading: Icon(Icons.book, color: AppColors.blue),
          title: Text(topic,
              style: GoogleFonts.poppins(fontSize: 18, color: AppColors.text)),
          subtitle: Text(
              "Score: ${(scorePercentage ?? 0.0).toDouble().toStringAsFixed(1)}%",
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text)),
          trailing: Icon(Icons.arrow_forward_ios, color: AppColors.text),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopicBasedQuestionsScreen(
                  topic: topic,
                ),
              ),
            ).then((_) {
              setState(() {}); // Refresh UI
            });
          },
        ),
      );
    }).toList();
  }
}
