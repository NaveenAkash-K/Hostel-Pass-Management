import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/common/developer_page.dart';
import 'package:hostel_pass_management/pages/common/bug_report_page.dart';
import 'package:hostel_pass_management/pages/common/login_page.dart';
import 'package:hostel_pass_management/pages/student/student_profile_page.dart';
import 'package:hostel_pass_management/pages/rt/block_students_page.dart';
import 'package:hostel_pass_management/pages/rt/pass_logs_page.dart';
import 'package:hostel_pass_management/pages/rt/rt_page.dart';
import 'package:hostel_pass_management/pages/student/student_page.dart';
import 'package:hostel_pass_management/pages/student/rules_page.dart';
import 'package:hostel_pass_management/pages/warden/block_details_page.dart';
import 'package:hostel_pass_management/pages/warden/hostel_stats.dart';
import 'package:hostel_pass_management/pages/warden/warden_pass_logs_page.dart';
import 'package:hostel_pass_management/pages/warden/warden_pass_request_page.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/pages/warden/warden_profile_page.dart';
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
    final passRequests = ref.watch(specialPassProvider);
    final List<PassRequest> pendingPasses =
        passRequests.where((pass) => pass.status == 'Pending').toList();
    final pendingpassesLength = pendingPasses.length;
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
                  builder: (context) => StatsPage(),
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
            title: Text("Bug Report"),
            leading: Icon(Icons.bug_report_rounded),
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
