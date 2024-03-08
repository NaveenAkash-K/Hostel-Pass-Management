import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassRequestPage extends ConsumerStatefulWidget {
  const PassRequestPage(
      {required this.pass, required this.passRequest, super.key});

  final PassRequest pass;
  final bool passRequest;
  @override
  ConsumerState<PassRequestPage> createState() {
    return _PassRequestPageState();
  }
}

class _PassRequestPageState extends ConsumerState<PassRequestPage> {
  @override
  var selectedParent = null;
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    bool warden = false;
    if (prefs!.getString("role") == "warden") {
      warden = true;
    }
    if (prefs.getString("role") == "rt") {
      warden = false;
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
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Father'),
                      value: 'father',
                      groupValue: selectedParent,
                      onChanged: (value) {
                        setState(() {
                          selectedParent = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Mother'),
                      value: 'mother',
                      groupValue: selectedParent,
                      onChanged: (value) {
                        setState(() {
                          selectedParent = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
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
                        onPressed: warden
                            ? () async {
                                ref
                                    .read(specialPassProvider.notifier)
                                    .rejectPassRequest(widget.pass.passId);
                                Navigator.of(context).pop();
                              }
                            : () async {
                                ref
                                    .read(rtPassProvider.notifier)
                                    .rejectPassRequest(widget.pass.passId);
                                Navigator.of(context).pop();
                              },
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
                        onPressed: warden
                            ? () async {
                                if (selectedParent != null) {
                                  ref
                                      .read(specialPassProvider.notifier)
                                      .approvePassRequest(
                                          widget.pass.passId, selectedParent!);
                                  Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .clearMaterialBanners();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Please select a parent.'),
                                  ));
                                }
                              }
                            : () async {
                                if (selectedParent != null) {
                                  ref
                                      .read(rtPassProvider.notifier)
                                      .approvePassRequest(
                                          widget.pass.passId, selectedParent!);
                                  Navigator.of(context).pop();
                                } else {
                                  // Handle case where no parent is selected
                                  ScaffoldMessenger.of(context)
                                      .clearMaterialBanners();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Please select a parent.'),
                                  ));
                                }
                              },
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
