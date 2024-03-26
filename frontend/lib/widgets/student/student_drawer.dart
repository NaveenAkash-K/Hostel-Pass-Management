import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hostel_pass_management/pages/common/bug_report_page.dart';
import 'package:hostel_pass_management/pages/student/student_faq_page.dart';
import 'package:hostel_pass_management/pages/student/student_page.dart';
import 'package:hostel_pass_management/pages/student/student_profile_page.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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

                    // Text(
                    //   "Hostel Pass Manager",
                    //   style: textTheme.titleMedium!.copyWith(
                    //     fontWeight: FontWeight.bold,
                    //     color: Color.fromARGB(255, 29, 79, 158),
                    //   ),
                    // ),
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
                  builder: (context) => const StudentPage(),
                ),
              );
            },
            leading: const Icon(Icons.home_filled),
            title: const Text("Home"),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentProfilePage(),
                ),
              );
            },
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentFaqPage(),
                ),
              );
            },
            title: const Text("Guidelines"),
            leading: const Icon(Icons.rule),
          ),
          // Spacer(),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BugReportPage(),
                ),
              );
            },
            title: const Text("Bug Report"),
            leading: const Icon(Icons.bug_report_rounded),
          ),
          const Spacer(),
          Text(
            'App version ${dotenv.env["VERSION"]}',
            textAlign: TextAlign.center,
            style: textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 135, 135, 135),
            ),
          ),
          const SizedBox(height: 12),
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
