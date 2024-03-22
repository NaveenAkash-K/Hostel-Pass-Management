import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/pass_tile.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/common/toast.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassRequestPage extends ConsumerStatefulWidget {
  const PassRequestPage({
    required this.pass,
    required this.passRequest,
    super.key,
  });

  final PassRequest pass;
  final bool passRequest;
  @override
  ConsumerState<PassRequestPage> createState() {
    return _PassRequestPageState();
  }
}

class _PassRequestPageState extends ConsumerState<PassRequestPage> {
  late FToast toast;
  var selectedParent = null;
  void setSelectedParent(String? parent) {
    setState(() {
      selectedParent = parent;
    });
  }

  Widget build(BuildContext context) {
    toast = FToast();
    toast.init(context);
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
        title: Text(widget.passRequest ? "Pass Request" : "Pass Log"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: colorScheme.primaryContainer,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            height: 60,
                            width: 60,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 30,
                            )),
                        // const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                widget.pass.studentName,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: textTheme.bodyLarge!.copyWith(
                                  color: const Color.fromARGB(255, 25, 32, 42),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${widget.pass.roomNo} / ${widget.pass.dept}",
                              style: textTheme.bodyMedium!.copyWith(
                                color: const Color.fromARGB(255, 96, 102, 110),
                                // fontSize: 17,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              PassTile(
                title: "Pass Type / Destination",
                content: "${widget.pass.type} / ${widget.pass.destination}",
              ),
              PassTile(
                title: "Expected Leaving Date & Time",
                content:
                    "Date: ${widget.pass.expectedOutDate}  Time: ${widget.pass.expectedOutTime}",
              ),
              PassTile(
                title: "Expected Returning Date & Time",
                content:
                    "Date: ${widget.pass.expectedInDate}  Time: ${widget.pass.expectedInTime}",
              ),
              if (!widget.passRequest && widget.pass.status == "Used")
                PassTile(
                  title: "Actual Leaving Date & Time",
                  content:
                      "Date: ${widget.pass.actualOutDate}  Time: ${widget.pass.actualOutTime}",
                ),
              if (!widget.passRequest && widget.pass.status == "Used")
                PassTile(
                  title: "Actual Returning Date & Time",
                  content:
                      "Date: ${widget.pass.actualInDate}  Time: ${widget.pass.actualInTime}",
                ),
              Container(
                  width: double.infinity,
                  child:
                      PassTile(title: "Reason", content: widget.pass.reason)),
              Visibility(
                visible: !widget.passRequest,
                child: PassTile(
                    title: "Confirmed With",
                    content: widget.pass.confirmedWith),
              ),
              Visibility(
                visible: widget.passRequest,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 12),
                  child: Text(
                    "ConfirmedWith",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Visibility(
                visible: widget.passRequest,
                child: ContactTile(
                  title: "Father",
                  // number: "6369216597",
                  number: widget.pass.fatherPhNo,
                  isSelected: selectedParent == "Father",
                  onSelect: (selected) {
                    if (selected) {
                      setSelectedParent("Father");
                    } else {
                      setSelectedParent(null);
                    }
                  },
                ),
              ),
              Visibility(
                visible: widget.passRequest,
                child: ContactTile(
                  title: "Mother",
                  // number: "6369216597",
                  number: widget.pass.motherPhNo,
                  isSelected: selectedParent == "Mother",
                  onSelect: (selected) {
                    if (selected) {
                      setSelectedParent("Mother");
                    } else {
                      setSelectedParent(null);
                    }
                  },
                ),
              ),
              const SizedBox(height: 0),
              Visibility(
                visible: widget.passRequest,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
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
                                  toast.removeQueuedCustomToasts();

                                  toast.showToast(
                                      child: ToastMsg(
                                    text: "Pass Rejected",
                                    bgColor: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                  ));
                                }
                              : () async {
                                  ref
                                      .read(rtPassProvider.notifier)
                                      .rejectPassRequest(widget.pass.passId);
                                  Navigator.of(context).pop();
                                  toast.removeQueuedCustomToasts();

                                  toast.showToast(
                                      child: ToastMsg(
                                    text: "Pass Rejected",
                                    bgColor: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                  ));
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
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(4)),
                          ),
                          onPressed: warden
                              ? () async {
                                  if (selectedParent != null) {
                                    ref
                                        .read(
                                          specialPassProvider.notifier,
                                        )
                                        .approvePassRequest(
                                          widget.pass.passId,
                                          selectedParent!,
                                        );
                                    Navigator.of(context).pop();
                                    toast.removeQueuedCustomToasts();

                                    toast.showToast(
                                        child: const ToastMsg(
                                      text: "Pass Approved",
                                      bgColor: Colors.greenAccent,
                                      icondata: Icons.check,
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .clearMaterialBanners();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Please select a parent.'),
                                      ),
                                    );
                                  }
                                }
                              : () async {
                                  if (selectedParent != null) {
                                    ref
                                        .read(rtPassProvider.notifier)
                                        .approvePassRequest(
                                          widget.pass.passId,
                                          selectedParent!,
                                        );
                                    Navigator.of(context).pop();
                                    toast.removeQueuedCustomToasts();

                                    toast.showToast(
                                        child: const ToastMsg(
                                      text: "Pass Approved",
                                      bgColor: Colors.greenAccent,
                                      icondata: Icons.check,
                                    ));
                                  } else {
                                    // Handle case where no parent is selected
                                    ScaffoldMessenger.of(context)
                                        .clearMaterialBanners();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
