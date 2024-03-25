import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostel_pass_management/pages/common/login_page.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LogoutTile extends StatelessWidget {
  LogoutTile({super.key});
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  @override
  Widget build(BuildContext context) {
    void logout() async {
      HapticFeedback.heavyImpact();
      await prefs!.clear();
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }

    // ignore: unused_local_variable
    TextTheme textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          showDragHandle: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Logout?",
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Are you sure you want to logout from the app?",
                    style: textTheme.titleMedium!.copyWith(
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: logout,
                    child: Ink(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: colorScheme.error,
                      ),
                      child: Center(
                        child: Text(
                          "Logout",
                          style: textTheme.titleMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Ink(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.black,
                        ),
                        // color: colorScheme.error,
                      ),
                      child: Center(
                        child: Text(
                          "Go Back",
                          style: textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Ink(
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          border: Border.all(
            color: colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        // margin: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            "Logout",
            style: textTheme.titleMedium!.copyWith(
              color: colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }
}
