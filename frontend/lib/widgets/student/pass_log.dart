import 'package:flutter/material.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:intl/intl.dart';

class PassLog extends StatelessWidget {
  const PassLog({
    required this.passlog,
    super.key,
  });

  final List<Pass> passlog;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Text(
              "Pass Log",
              style: textTheme.titleLarge,
            ),
          ),
          const Divider(
            height: 0,
          ),
          if (passlog.isEmpty)
            Expanded(
              child: const Center(
                child: Text("Empty Log"),
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: passlog.map((pass) {
                    return Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  pass.destination,
                                  style: textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                // Container(
                                //   padding: EdgeInsets.all(3),
                                //   decoration: BoxDecoration(
                                //     color: Colors.amber,
                                //     shape: BoxShape.circle,
                                //   ),
                                //   child: Icon(
                                //     Icons.star_rounded,
                                //     color: Colors.white,
                                //   ),
                                // ),
                                if (pass.isSpecialPass)
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                  ),
                                SizedBox(width: 5),
                                Text(
                                  "Gatepass",
                                  style: textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      pass.actualOutDate!,
                                      style: textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(pass.actualOutTime!)
                                  ],
                                ),
                                Spacer(),
                                // Container(
                                //   padding: EdgeInsets.all(3),
                                //   decoration: BoxDecoration(
                                //     color: Color.fromARGB(255, 119, 119, 119),
                                //     shape: BoxShape.circle,
                                //   ),
                                //   child: Icon(
                                //     Icons.compare_arrows_rounded,
                                //     color: Colors.white,
                                //     size: 30,
                                //   ),
                                // ),
                                Icon(
                                  Icons.compare_arrows_rounded,
                                  // color: Colors.white,
                                  size: 30,
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      pass.actualInDate!,
                                      style: textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(pass.actualInTime!)
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
