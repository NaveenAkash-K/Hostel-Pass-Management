import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/pages/common/bug_report_page.dart';
import 'package:hostel_pass_management/pages/common/login_page.dart';
import 'package:hostel_pass_management/pages/warden/hostel_stats.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacultyDrawer extends ConsumerStatefulWidget {
  const FacultyDrawer({super.key});

  @override
  ConsumerState<FacultyDrawer> createState() => _FacultyDrawerState();
}

class _FacultyDrawerState extends ConsumerState<FacultyDrawer> {
  @override
  Widget build(BuildContext context) {
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
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
                  builder: (context) => const StatsPage(),
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
                  builder: (context) => const BugReportPage(),
                ),
              );
            },
            title: const Text("Bug Report"),
            leading: const Icon(Icons.bug_report_rounded),
          ),
          ListTile(
            onTap: () async {
              await prefs!.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            leading: const Icon(Icons.logout_rounded),
            title: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
