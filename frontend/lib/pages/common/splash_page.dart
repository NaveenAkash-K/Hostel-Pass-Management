import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/pages/common/login_page.dart';
import 'package:hostel_pass_management/pages/common/maintenance.dart';
import 'package:hostel_pass_management/pages/common/update_page.dart';
import 'package:hostel_pass_management/pages/rt/rt_page.dart';
import 'package:hostel_pass_management/pages/security/security_page.dart';
import 'package:hostel_pass_management/pages/student/student_page.dart';
import 'package:hostel_pass_management/pages/warden/hostel_stats.dart';
import 'package:hostel_pass_management/providers/rt_announcement_provider.dart';
import 'package:hostel_pass_management/providers/block_students_provider.dart';
import 'package:hostel_pass_management/providers/hostel_students_provider.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/providers/student_announcement_provider.dart';
import 'package:hostel_pass_management/providers/student_pass_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends ConsumerState<SplashPage> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  Future<void> miscellaneous() async {
    // return;
    try {
      var response = await http.get(
        Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/miscellaneous"),
      );
      var responseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        throw responseData["message"];
      }
      if (responseData["maintenance"] == "true") {
        if (!mounted) {
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MaintenancePage(),
          ),
        );
        return;
      } else if (responseData["version"] != dotenv.env["VERSION"]) {
        if (!mounted) {
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const UpdatePage(),
          ),
        );
        return;
      }
      tokenCheck();
    } catch (err) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Internet connection error"),
        ),
      );
    }
  }

  void tokenCheck() async {
    try {
      print(prefs!.getString("jwtToken"));
      print(prefs!.getString("role"));
      if (prefs!.getString("jwtToken") != null) {
        if (prefs!.getString("role") == "student") {
          await ref.read(studentPassProvider.notifier).loadPassFromDB();
          await ref
              .read(studentAnnouncementNotifier.notifier)
              .loadAnnouncementsFromDB();
          if (!mounted) {
            return;
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const StudentPage(),
            ),
          );
          return;
        } else if (prefs!.getString("role") == "rt") {
          await ref
              .read(blockStudentProvider.notifier)
              .loadBlockStudentsFromDB();
          await ref
              .read(rtAnnouncementNotifier.notifier)
              .loadAnnouncementsFromDB();
          await ref.read(rtPassProvider.notifier).loadPassRequestsFromDB();
          if (!mounted) {
            return;
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // builder: (context) => RtPage(),
              builder: (context) => const RtPage(),
            ),
          );
          return;
        } else if (prefs!.getString("role") == "warden") {
          await ref
              .read(hostelStudentProvider.notifier)
              .loadHostelStudentsFromDB();
          await ref.read(specialPassProvider.notifier).getSpecailPassesFromDB();
          if (!mounted) {
            return;
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => StatsPage(),
              // builder: (context) => WardenPage(),
            ),
          );
          return;
        } else if (prefs!.getString("role") == "faculty") {
          await ref
              .read(hostelStudentProvider.notifier)
              .loadHostelStudentsFromDB();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => StatsPage(),
              // builder: (context) => WardenPage(),
            ),
          );
          return;
        } else if (prefs!.getString("role") == "security") {
          print("Hehe");
          await ref.read(specialPassProvider.notifier).getSpecailPassesFromDB();
          await ref
              .read(hostelStudentProvider.notifier)
              .loadHostelStudentsFromDB();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const SecurityPage(),
            ),
          );
          return;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      return;
    }

    if (prefs!.getString("jwtToken") == null) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      });
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    miscellaneous();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    LottieBuilder.asset(
                      'assets/animations/splash_loading.json',
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  Text(
                    'Made by Subash & Naveen Akash',
                    style: textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 135, 135, 135)),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
