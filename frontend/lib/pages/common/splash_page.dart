import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/pages/common/login_page.dart';
import 'package:hostel_pass_management/pages/rt/rt_page.dart';
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

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});
  @override
  ConsumerState<SplashPage> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends ConsumerState<SplashPage> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  void tokenCheck() async {
    try {
      if (prefs!.getString("jwtToken") != null) {
        if (prefs!.getString("role") == "student") {
          await ref.read(studentPassProvider.notifier).loadPassFromDB();
          await ref
              .read(studentAnnouncementNotifier.notifier)
              .loadAnnouncementsFromDB();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => StudentPage(),
            ),
          );
        } else if (prefs!.getString("role") == "rt") {
          await ref
              .read(blockStudentProvider.notifier)
              .loadBlockStudentsFromDB();
          await ref
              .read(rtAnnouncementNotifier.notifier)
              .loadAnnouncementsFromDB();
          await ref.read(rtPassProvider.notifier).loadPassRequestsFromDB();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // builder: (context) => RtPage(),
              builder: (context) => RtPage(),
            ),
          );
        } else if (prefs!.getString("role") == "warden") {
          await ref
              .read(hostelStudentProvider.notifier)
              .loadHostelStudentsFromDB();
          await ref.read(specialPassProvider.notifier).getSpecailPassesFromDB();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => StatsPage(),
              // builder: (context) => WardenPage(),
            ),
          );
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
            builder: (context) => LoginPage(),
          ),
        );
      });
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    tokenCheck();
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
                    'App Version 1.0.0',
                    style: textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 135, 135, 135)),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
