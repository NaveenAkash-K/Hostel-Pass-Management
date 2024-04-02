import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/common/bug_report_page.dart';
import 'package:hostel_pass_management/pages/warden/hostel_stats.dart';
import 'package:hostel_pass_management/pages/warden/warden_pass_request_page.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/pages/warden/warden_profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class WardenDrawer extends ConsumerStatefulWidget {
  const WardenDrawer({super.key});

  @override
  ConsumerState<WardenDrawer> createState() => _WardenDrawerState();
}

class _WardenDrawerState extends ConsumerState<WardenDrawer> {
  @override
  Widget build(BuildContext context) {
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
                  builder: (context) => const WardenPassRequestPage(),
                ),
              );
            },
            leading: const Icon(Icons.apartment_rounded),
            title: const Text("Pass Requests"),
            trailing: pendingpassesLength > 0
                ? Container(
                    alignment: Alignment.center,
                    width: 25,
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    child: Text(
                      pendingpassesLength.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : const SizedBox(),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => PassLogsPage(),
          //       ),
          //     );
          //   },
          //   leading: const Icon(Icons.receipt_long_rounded),
          //   title: const Text("Pass Logs"),
          // ),
          ListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WardenProfilePage(),
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
          //         builder: (context) => const RulesPage(),
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
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text("Mail us"),
            onTap: () async {
              String? encodeQueryParameters(Map<String, String> params) {
                return params.entries
                    .map((MapEntry<String, String> e) =>
                        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                    .join('&');
              }

              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: dotenv.env["MAIL_US"],
                query: encodeQueryParameters(<String, String>{
                  'subject': 'Query Title',
                  'body': 'Please post your queries here'
                }),
              );
              if (await canLaunchUrl(emailUri)) {
                launchUrl(emailUri);
              } else {
                throw Exception('Could not launch the email Uri');
              }
            },
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
