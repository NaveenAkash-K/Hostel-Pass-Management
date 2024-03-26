import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/pages/common/bug_report_page.dart';
import 'package:hostel_pass_management/pages/rt/announcement_page.dart';
import 'package:hostel_pass_management/pages/rt/block_students_page.dart';
import 'package:hostel_pass_management/pages/rt/pass_logs_page.dart';
import 'package:hostel_pass_management/pages/rt/rt_page.dart';
import 'package:hostel_pass_management/providers/block_students_provider.dart';
import 'package:hostel_pass_management/pages/rt/rt_profile_page.dart';

class RtDrawer extends ConsumerStatefulWidget {
  const RtDrawer({super.key});

  @override
  ConsumerState<RtDrawer> createState() => _RtDrawerState();
}

class _RtDrawerState extends ConsumerState<RtDrawer> {
  @override
  Widget build(BuildContext context) {
    final students = ref.watch(blockStudentProvider);

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
                  builder: (context) => const RtPage(),
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
                  builder: (context) => BlockStudentsPage(
                    students: students,
                  ),
                ),
              );
            },
            leading: const Icon(Icons.apartment_rounded),
            title: const Text("Block Students"),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PassLogsPage(),
                ),
              );
            },
            leading: const Icon(Icons.receipt_long_rounded),
            title: const Text("Pass Logs"),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnnouncementPage(),
                ),
              );
            },
            leading: const Icon(Icons.notifications_rounded),
            title: const Text("Announcements"),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RtProfilePage(),
                ),
              );
            },
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         // builder: (context) => const RulesPage(),
          //         builder: (context) => Guidelo,
          //       ),
          //     );
          //   },
          //   title: const Text("Rules and Regulations"),
          //   leading: const Icon(Icons.rule),
          // ),
          // const Spacer(),
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
          //         builder: (context) => const DeveloperPage(),
          //       ),
          //     );
          //   },
          //   title: const Text("About us"),
          //   leading: const Icon(Icons.developer_mode),
          // ),
          // ListTile(
          //   onTap: () async {
          //     await prefs!.clear();
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const LoginPage(),
          //       ),
          //     );
          //   },
          //   title: const Text("Logout"),
          //   leading: const Icon(Icons.logout_rounded),
          // )
        ],
      ),
    );
  }
}
