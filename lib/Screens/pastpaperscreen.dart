// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:final_exam_prep/data/appcolour/app_colours.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PastPapersScreen extends StatefulWidget {
//   final String subject;

//   PastPapersScreen({Key? key, required this.subject}) : super(key: key);

//   @override
//   _PastPapersScreenState createState() => _PastPapersScreenState();
// }

// class _PastPapersScreenState extends State<PastPapersScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   final List<int> years = [2023, 2022, 2021, 2020];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           '${widget.subject} Past Papers',
//           style: GoogleFonts.poppins(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: AppColors.textLight),
//         ),
//         backgroundColor: AppColors.primary,
//         bottom: TabBar(
//           unselectedLabelColor: AppColors.textLight,
//           controller: _tabController,
//           labelColor: AppColors.textLight,
//           indicatorColor: AppColors.secondary,
//           tabs: [
//             Tab(text: "Paper 1"),
//             Tab(text: "Paper 2"),
//           ],
//         ),
//       ),
//       backgroundColor: AppColors.background,
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildPastPaperList("Paper 1"),
//           _buildPastPaperList("Paper 2"),
//         ],
//       ),
//     );
//   }

//   Widget _buildPastPaperList(String paperType) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ListView.builder(
//         itemCount: years.length,
//         itemBuilder: (context, index) {
//           int year = years[index];
//           return Card(
//             color: AppColors.cardBackground,
//             elevation: 3,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             child: ExpansionTile(
//               iconColor: AppColors.primary,
//               collapsedIconColor: AppColors.primary,
//               title: Text(
//                 '$year - $paperType',
//                 style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.text),
//               ),
//               children: [
//                 ListTile(
//                   title: Text(
//                     "${widget.subject} - $paperType",
//                     style: GoogleFonts.poppins(
//                         fontSize: 16, color: AppColors.text),
//                   ),
//                   trailing: IconButton(
//                     icon: Icon(Icons.download, color: AppColors.blue),
//                     onPressed: () {
//                       _downloadPaper(year, paperType);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _downloadPaper(int year, String paperType) async {
//     try {
//       // Remove leading/trailing spaces in subject name
//       String formattedSubject = widget.subject.trim().replaceAll(' ', '');
//       String fileName =
//           "$formattedSubject$paperType.pdf"; // No space before Paper 1
//       String encodedFileName = Uri.encodeComponent(fileName); // Proper encoding
//       String supabasePath = "$year/$encodedFileName";

//       final supabase = Supabase.instance.client;
//       print("supabasePath: $supabasePath"); // Debugging
//       final downloadUrl =
//           supabase.storage.from("past_papers").getPublicUrl(supabasePath);

//       print("Generated URL: $downloadUrl"); // Debugging

//       Uri url = Uri.parse(downloadUrl);
//       if (await canLaunchUrl(url)) {
//         await launchUrl(url, mode: LaunchMode.externalApplication);
//       } else {
//         throw "Could not launch $downloadUrl";
//       }
//     } catch (e) {
//       print("Error: $e"); // Debugging
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Paper not available. Try another year."),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_exam_prep/data/appcolour/app_colours.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PastPapersScreen extends StatefulWidget {
  final String subject;

  PastPapersScreen({Key? key, required this.subject}) : super(key: key);

  @override
  _PastPapersScreenState createState() => _PastPapersScreenState();
}

class _PastPapersScreenState extends State<PastPapersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<int> years = [2023, 2022, 2021, 2020];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.subject} Past Papers',
          style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight),
        ),
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          unselectedLabelColor: AppColors.textLight,
          controller: _tabController,
          labelColor: AppColors.textLight,
          indicatorColor: AppColors.secondary,
          tabs: [
            Tab(text: "Paper 1"),
            Tab(text: "Paper 2"),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPastPaperList("Paper 1"),
          _buildPastPaperList("Paper 2"),
        ],
      ),
    );
  }

  Widget _buildPastPaperList(String paperType) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: years.length,
        itemBuilder: (context, index) {
          int year = years[index];
          return Card(
            color: AppColors.cardBackground,
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ExpansionTile(
              iconColor: AppColors.primary,
              collapsedIconColor: AppColors.primary,
              title: Text(
                '$year - $paperType',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text),
              ),
              children: [
                ListTile(
                  title: Text(
                    "${widget.subject} - $paperType",
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: AppColors.text),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.file_download, color: AppColors.blue),
                        onPressed: () {
                          _downloadFile(year, paperType, false);
                        },
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.description, color: AppColors.secondary),
                        onPressed: () {
                          _downloadFile(year, paperType, true);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _downloadFile(int year, String paperType, bool isMemo) async {
    try {
      // Ensure subject name is trimmed properly
      String formattedSubject = widget.subject.trim();

      // Correctly format the file name
      String fileName = isMemo
          ? "$formattedSubject$paperType Memo.pdf" // Memo file
          : "$formattedSubject$paperType.pdf"; // Past paper file

      String supabasePath = "$year/$fileName";
      Uri.encodeFull(supabasePath); // Encode full path

      final supabase = Supabase.instance.client;
      print("Supabase Path: $supabasePath"); // Debugging

      // Get the public URL
      final downloadUrl =
          supabase.storage.from("past_papers").getPublicUrl(supabasePath);
      print("Generated URL: $downloadUrl"); // Debugging

      Uri url = Uri.parse(downloadUrl);

      // ✅ Check if the file actually exists using an HTTP HEAD request
      final exists = await _checkIfFileExists(downloadUrl);

      if (!exists) {
        _showErrorDialog(
            isMemo ? "Memo not available." : "Paper not available.");
        return;
      }

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw "Could not launch $downloadUrl";
      }
    } catch (e) {
      print("Error: $e"); // Debugging
      _showErrorDialog(isMemo ? "Memo not available." : "Paper not available.");
    }
  }

// ✅ Helper function to check if file exists using HTTP HEAD request
  Future<bool> _checkIfFileExists(String url) async {
    try {
      final response = await http.head(Uri.parse(url));

      if (response.statusCode == 200) {
        return true; // File exists
      } else if (response.statusCode == 404) {
        print("File not found: $url");
        return false;
      } else {
        print("Unexpected response: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("File check error: $e");
      return false;
    }
  }

// ✅ Show alert dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Error",
  //             style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
  //         content: Text(message, style: GoogleFonts.poppins()),
  //         actions: [
  //           TextButton(
  //             child: Text("OK", style: GoogleFonts.poppins(color: Colors.blue)),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
