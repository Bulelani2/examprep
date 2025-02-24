import 'package:final_exam_prep/data/Json/subjecttopicjson.dart';
import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:final_exam_prep/data/score_manager/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class StudyAnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, double> topicScores = ScoreManager().getAllScores();
    // Function to get the subject based on the topic
    String getSubjectForTopic(String topic) {
      for (var subject in sortedSubjectTopics.keys) {
        for (var paper in sortedSubjectTopics[subject]!.values) {
          if (paper.contains(topic)) {
            return subject; // Return subject name if the topic is found
          }
        }
      }
      return "Unknown Subject"; // Fallback if topic isn't found
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Study Analysis",
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Performance by Topic",
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text),
              ),
              const SizedBox(height: 20),
              // Bar Chart for performance visualization
              if (topicScores.isNotEmpty)
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "${value.toInt()}%", // Show percentage on the Y-axis
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: AppColors.text),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize:
                                MediaQuery.of(context).size.width < 600
                                    ? MediaQuery.of(context).size.width *
                                        0.2 // Mobile (Number 1)
                                    : 50, // Web (Number 2)
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 &&
                                  index < topicScores.keys.length) {
                                String topic =
                                    topicScores.keys.elementAt(index);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: MediaQuery.of(context).size.width < 600
                                      ? RotatedBox(
                                          quarterTurns: 3, // Rotate for mobile
                                          child: Text(
                                            topic,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: AppColors.text,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Text(
                                          topic, // Normal for web
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: AppColors.text,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      barGroups: topicScores.entries.map((entry) {
                        return BarChartGroupData(
                          x: topicScores.keys.toList().indexOf(entry.key),
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              color: entry.value > 50
                                  ? AppColors.green
                                  : AppColors.red,
                              width: 15,
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                )
              else
                Center(
                  child: Text(
                    "No data available. Complete some quizzes first!",
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: AppColors.text),
                  ),
                ),

              const SizedBox(height: 20),

              // Weak Areas and Recommendations
              Text(
                "Weak Topics to Focus On",
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.red),
              ),
              const SizedBox(height: 10),
              if (topicScores.isNotEmpty)
                ...topicScores.entries
                    .where((entry) => entry.value < 50) // Filter weak topics
                    .map((entry) {
                  String subject =
                      getSubjectForTopic(entry.key); // Get subject dynamically

                  return ListTile(
                    leading: Icon(Icons.warning, color: AppColors.orange),
                    title: Text(entry.key,
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: AppColors.text)),
                    subtitle: Text(
                        "Score: ${entry.value.toStringAsFixed(1)}% - Needs Improvement",
                        style: TextStyle(color: AppColors.text)),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        subject,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blue),
                      ),
                    ),
                  );
                }).toList()
              else
                Center(
                  child: Text(
                    "No weak areas detected yet!",
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: AppColors.text),
                  ),
                ),

              const SizedBox(height: 20),

              // Suggested Study Plan Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to Topic-Based Questions for weak areas
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Practice Weak Topics",
                    style: TextStyle(color: AppColors.textLight)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
