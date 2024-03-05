import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BugReportPage extends StatefulWidget {
  const BugReportPage({super.key});

  @override
  State<BugReportPage> createState() => BugReportPageState();
}

class BugReportPageState extends State<BugReportPage> {
  double starRating = 0;
  final TextEditingController reportController = TextEditingController();
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    var drawer;
    if (prefs!.getString("role") == "student") {
      drawer = StudentDrawer();
    } else if (prefs!.getString("role") == "rt") {
      drawer = RtDrawer();
    } else if (prefs!.getString("role") == "warden") {
      drawer = WardenDrawer();
    }
    Future<void> submitFeedback() async {
      if (reportController.text.isEmpty) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter  your feedback."),
          ),
        );
        return;
      }
      if (starRating == 0) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please rate the app."),
          ),
        );
        return;
      }
      try {
        var response = await http.post(
          Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/bugReport/newReport"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": prefs!.getString("jwtToken")!,
          },
          body: jsonEncode({
            "report": reportController.text,
            // "rating": starRating,
          }),
        );

        var responseData = jsonDecode(response.body);

        if (response.statusCode >= 400) {
          throw responseData["message"];
        }

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData["message"],
            ),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bug Report"),
      ),
      drawer: drawer,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SvgPicture.asset(
                  "assets/images/bug_report.svg",
                  width: MediaQuery.of(context).size.width - 100,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Encountered a bug 🐞? Help us enhance the app experience.",
                style: textTheme.titleMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: reportController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Bug Report",
                  border: OutlineInputBorder(),
                ),
              ),
              // const SizedBox(height: 20),
              // RatingBar.builder(
              //   initialRating: 0,
              //   minRating: 1,
              //   direction: Axis.horizontal,
              //   glow: true,
              //   glowColor: Colors.amber,
              //   allowHalfRating: true,
              //   itemCount: 5,
              //   itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
              //   itemBuilder: (context, _) => const Icon(
              //     Icons.star_rounded,
              //     color: Colors.amber,
              //   ),
              //   onRatingUpdate: (rating) {
              //     setState(() {
              //       starRating = rating;
              //     });
              //   },
              // ),
              const SizedBox(height: 30),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: submitFeedback,
                child: Ink(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: MediaQuery.of(context).size.width - 200,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Report",
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
