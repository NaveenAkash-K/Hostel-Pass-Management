import 'package:flutter/material.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RulesPage extends StatelessWidget {
  RulesPage({super.key});

  static const List<String> rules = [
    "Quiet Hours: Set specific hours during which noise levels should be kept to a minimum to ensure a peaceful environment for studying and rest.",
    "Visitation Policy: Define rules for visitors, including visiting hours, guest registration, and restrictions on overnight guests to maintain security and privacy.",
    "Cleanliness Standards: Emphasize the importance of cleanliness by establishing rules for personal and communal spaces. Outline responsibilities for cleaning common areas and personal living spaces.",
    "Security Measures: Encourage the use of security measures such as locking doors and windows to ensure the safety of all residents. Discourage sharing keys or access cards.",
    "Respect for Others: Promote a culture of respect by discouraging disruptive behavior, bullying, and any form of discrimination. Encourage open communication to address conflicts peacefully.",
    "Common Area Usage: Clearly outline guidelines for the use of common areas, such as the kitchen, laundry room, and recreation spaces. Establish a system for scheduling or sharing these spaces.",
    "Internet Usage: Set guidelines for responsible internet usage, including bandwidth limitations, restrictions on illegal downloads, and appropriate use of social media."
  ];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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
        title: Text("Rules and Regulations"),
      ),
      drawer: drawer(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(children: [
            for (var index = 0; index < rules.length; index++)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "$index. ${rules[index]}",
                  style: textTheme.bodyLarge!.copyWith(height: 2),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
