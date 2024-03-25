import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

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
            const Spacer(),
            Center(
              child: SvgPicture.asset(
                "assets/images/maintenance.svg",
                width: MediaQuery.of(context).size.width - 100,
              ),
            ),
            const Spacer(),
            Text(
              "App is under maintenance. Please try again in few minutes.",
              style: textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
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
