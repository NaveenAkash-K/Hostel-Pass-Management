import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            // const Spacer(),
            Text(
              "Under Maintenance!",
              style: textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: SvgPicture.asset(
                "assets/images/maintenance.svg",
                width: MediaQuery.of(context).size.width - 100,
              ),
            ),
            const Spacer(),
            Text(
              "Please try again in few minutes",
              style: textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            TextButton.icon(
              onPressed: () async {
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
              icon: Icon(Icons.mail),
              label: Text("Mail us"),
            ),
            // SizedBox(height: 30),
            // InkWell(
            //   borderRadius: BorderRadius.circular(16),
            //   onTap: () {},
            //   child: Ink(
            //     // margin: EdgeInsets.all(20),
            //     decoration: BoxDecoration(
            //       color: colorScheme.primaryContainer,
            //       borderRadius: BorderRadius.circular(16),
            //     ),
            //     width: double.infinity,
            //     height: 60,
            //     child: Center(
            //       child: Text(
            //         "Update",
            //         style: textTheme.titleLarge!.copyWith(
            //           fontWeight: FontWeight.w500,
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ),
            // ),
            // Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
