import 'package:flutter/material.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeveloperPage extends StatelessWidget {
  DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    var drawer;
    if (prefs!.getString("role") == "student") {
      drawer = StudentDrawer();
    } else if (prefs.getString("role") == "rt") {
      drawer = RtDrawer();
    } else if (prefs.getString("role") == "warden") {
      drawer = WardenDrawer();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("About us"),
      ),
    );
  }
}
