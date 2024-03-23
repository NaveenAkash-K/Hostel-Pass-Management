import 'package:flutter/material.dart';
import 'package:hostel_pass_management/pages/common/developer_page.dart';
import 'package:hostel_pass_management/pages/common/bug_report_page.dart';
import 'package:hostel_pass_management/pages/common/login_page.dart';
import 'package:hostel_pass_management/pages/student/student_faq_page.dart';
import 'package:hostel_pass_management/pages/student/student_page.dart';
import 'package:hostel_pass_management/pages/student/rules_page.dart';
import 'package:hostel_pass_management/pages/student/student_profile_page.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/logout_tile.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPreferences? prefs = SharedPreferencesManager.preferences;

    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: 200,
                    ),
                    Text(
                      "Hostel Pass Manager",
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 29, 79, 158),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentPage(),
                ),
              );
            },
            leading: Icon(Icons.home_filled),
            title: Text("Home"),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentProfilePage(),
                ),
              );
            },
            leading: Icon(Icons.person),
            title: Text("Profile"),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentFaqPage(),
                ),
              );
            },
            title: Text("Guidelines"),
            leading: Icon(Icons.rule),
          ),
          // Spacer(),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BugReportPage(),
                ),
              );
            },
            title: Text("Bug Report"),
            leading: Icon(Icons.bug_report_rounded),
          ),
          Spacer(),
          Text(
            'Made with ❤️ by Subash & Naveen',
            textAlign: TextAlign.center,
            style: textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 135, 135, 135),
            ),
          ),
          SizedBox(height: 12),
          // ListTile(
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => DeveloperPage(),
          //       ),
          //     );
          //   },
          //   title: Text("About us"),
          //   leading: Icon(Icons.developer_mode),
          // ),
          // ListTile(
          //   onTap: () async {
          //     await prefs!.clear();
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => LoginPage(),
          //       ),
          //     );
          //   },
          //   title: Text("Logout"),
          //   leading: Icon(Icons.logout_rounded),
          // )
        ],
      ),
    );
  }
}
