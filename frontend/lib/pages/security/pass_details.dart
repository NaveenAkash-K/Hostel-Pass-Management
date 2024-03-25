import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/security/security_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PassDetails extends StatefulWidget {
  const PassDetails({super.key, required this.qrData});
  final String qrData;

  @override
  State<PassDetails> createState() => _PassDetailsState();
}

class _PassDetailsState extends State<PassDetails> {
  String? profileBuffer;
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  bool isPassLoading = false;
  bool isButtonLoading = false;
  late var passData;

  void getPass() async {
    setState(() {
      isPassLoading = true;
    });
    try {
      var passResponse = await http.get(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/getDetails/${widget.qrData}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );

      passData = jsonDecode(passResponse.body);

      if (passResponse.statusCode > 399) {
        throw passData["message"];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

      Navigator.pop(context);

    } finally {
      setState(() {
        isPassLoading = false;
      });
    }
  }

  void confirmScan() async {
    setState(() {
      isButtonLoading = true;
    });
    try {
      dynamic response = await http.post(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/confirmScan/${widget.qrData}"),
        body: jsonEncode(
          {
            "scanAt": DateTime.now().toIso8601String(),
          },
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );

      dynamic responseData = jsonDecode(response.body);

      if (response.statusCode > 399) {
        throw responseData["message"];
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData["message"]),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    } finally {
      setState(() {
        isButtonLoading = false;
      });
    }
  }

  @override
  void initState() {
    getPass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    TextTheme textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    // print(prefs!.getString("profileBuffer"));

    return Scaffold(
      floatingActionButton: isPassLoading
          ? null
          : FloatingActionButton.extended(
              backgroundColor: passData["exitScanBy"] == null
                  ? colorScheme.errorContainer
                  : const Color.fromARGB(255, 179, 255, 181),
              onPressed: isButtonLoading ? null : confirmScan,
              label: isButtonLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      children: [
                        const Icon(Icons.check),
                        const SizedBox(width: 5),
                        Text(
                          passData["exitScanBy"] == null
                              ? "Confirm Exit"
                              : "Confirm Entry",
                        ),
                      ],
                    ),
            ),
      appBar: AppBar(
        title: const Text(
          "Student Pass",
        ),
      ),
      drawer: const SecurityDrawer(),
      body: isPassLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    clipBehavior: Clip.hardEdge,
                    padding: const EdgeInsets.all(30),
                    width: double.infinity,
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
                      color: passData["exitScanBy"] == null
                          ? colorScheme.errorContainer
                          : const Color.fromARGB(255, 179, 255, 181),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: profileBuffer == null
                              ? const Icon(
                                  Icons.person_rounded,
                                  size: 100,
                                )
                              : Image.memory(
                                  base64Decode(profileBuffer!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          passData["username"],
                          textAlign: TextAlign.center,
                          style: textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              ProfileItem(
                                attribute: "Room No",
                                value: passData["roomNo"].toString(),
                              ),
                              const Divider(height: 0),
                              ProfileItem(
                                attribute: "Pass Type",
                                value: passData["passType"],
                              ),
                              const Divider(height: 0),
                              ProfileItem(
                                attribute: "Leaving Time",
                                value: "${DateTime.parse(passData['leavingDateTime']).day}-${DateTime.parse(passData['leavingDateTime']).month}-${DateTime.parse(passData['leavingDateTime']).year} ${TimeOfDay.fromDateTime(DateTime.parse(passData['leavingDateTime'])).hourOfPeriod}:${TimeOfDay.fromDateTime(DateTime.parse(passData['leavingDateTime'])).minute} ${TimeOfDay.fromDateTime(DateTime.parse(passData['leavingDateTime'])).period.name}",
                              ),
                              const Divider(height: 0),
                              ProfileItem(
                                attribute: "Retruning Time",
                                value: "${DateTime.parse(passData['returningDateTime']).day}-${DateTime.parse(passData['returningDateTime']).month}-${DateTime.parse(passData['returningDateTime']).year} ${TimeOfDay.fromDateTime(DateTime.parse(passData['returningDateTime'])).hourOfPeriod}:${TimeOfDay.fromDateTime(DateTime.parse(passData['returningDateTime'])).minute} ${TimeOfDay.fromDateTime(DateTime.parse(passData['returningDateTime'])).period.name}",
                              ),
                              const Divider(height: 0),
                              ProfileItem(
                                attribute: "Approved by",
                                value: passData["approvedBy"],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
