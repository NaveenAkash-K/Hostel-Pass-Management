import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassRequestPage extends StatefulWidget {
  const PassRequestPage(
      {required this.pass, required this.passRequest, super.key});

  final PassRequest pass;
  final bool passRequest;
  @override
  State<PassRequestPage> createState() => _PassRequestPageState();
}

class _PassRequestPageState extends State<PassRequestPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    var drawer;
    if (prefs!.getString("role") == "student") {
      drawer = StudentDrawer();
    } else if (prefs.getString("role") == "rt") {
      drawer = RtDrawer();
    } else if (prefs.getString("role") == "warden") {
      drawer = WardenDrawer();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pass Request"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primaryContainer,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  widget.pass.studentName,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Text("Year: ${widget.pass.year}"),
              const SizedBox(height: 10),
              Text("Department: ${widget.pass.dept}"),
              const SizedBox(height: 10),
              Text("Room No: ${widget.pass.roomNo}"),
              const SizedBox(height: 10),
              Text("Phone No: ${widget.pass.phNo}"),
              const SizedBox(height: 10),
              Text("Pass type: ${widget.pass.type}"),
              const SizedBox(height: 10),
              Text("Destination: ${widget.pass.destination}"),
              const SizedBox(height: 10),
              Text(
                  "Leave on: ${widget.pass.expectedOutDate} ${widget.pass.expectedOutTime}"),
              const SizedBox(height: 10),
              Text(
                  "Return on: ${widget.pass.expectedInDate} ${widget.pass.expectedInTime}"),
              const SizedBox(height: 10),
              Text("Reason: ${widget.pass.reason}"),
              const SizedBox(height: 10),
              Visibility(
                visible: widget.passRequest,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 198, 198),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Deny",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 57, 43),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 179, 255, 181),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Approve",
                          style: TextStyle(
                            color: Color.fromARGB(255, 57, 139, 60),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
