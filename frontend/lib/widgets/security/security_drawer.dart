import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hostel_pass_management/pages/common/login_page.dart';
import 'package:hostel_pass_management/pages/security/security_page.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityDrawer extends StatelessWidget {
  const SecurityDrawer({super.key});

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
                  builder: (context) => const SecurityPage(),
                ),
              );
            },
            leading: const Icon(Icons.home_filled),
            title: const Text("Home"),
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
