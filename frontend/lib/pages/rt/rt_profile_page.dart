import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/logout_tile.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RtProfilePage extends StatefulWidget {
  const RtProfilePage({Key? key}) : super(key: key);

  @override
  State<RtProfilePage> createState() => _RtProfilePageState();
}

class _RtProfilePageState extends State<RtProfilePage> {
  String? profileBuffer;
  List<dynamic>? temporaryBlock;
  List<Map<String, dynamic>> switchedRts = [];
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  late int _selectedValue;
  late int excludedBlock;
  late List<DropdownMenuItem<int>> items;

  @override
  void initState() {
    super.initState();
    fetchProfilePic();
    fetchSwitchedRts();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    excludedBlock = prefs!.getInt("permanentBlock")!;
    _selectedValue = excludedBlock == 1 ? 2 : 1;
    items = List.generate(
      8,
      (int index) {
        int value = index + 1;
        if (value != prefs!.getInt("permanentBlock")) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('Block $value'),
          );
        }
        return null;
      },
    ).where((item) => item != null).toList().cast<DropdownMenuItem<int>>();
    setState(() {});
  }

  void fetchProfilePic() async {
    try {
      var response = await http.get(
        Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/profile/fetch"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      setState(() {
        profileBuffer = responseData["profileBuffer"];
        temporaryBlock = responseData["temporaryBlock"];
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    }
  }

  void fetchSwitchedRts() async {
    try {
      var response = await http.get(
        Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/rt/block/getSwitchedRts"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );
      var responseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        throw responseData["message"];
      }
      List<Map<String, dynamic>> switchedRtsData =
          (responseData as List).map((item) {
        return {
          "rtName": item["rtName"],
          "permanentBlock": item["permanentBlock"].toString(),
        };
      }).toList();
      setState(() {
        switchedRts = switchedRtsData;
      });
    } catch (err) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    }
  }

  void _submit() {
    TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                "Type \"SWITCH\" to delete",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            content: TextField(
              controller: confirmController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: confirmController.text == "SWITCH"
                    ? () async {
                        try {
                          await http.post(
                            Uri.parse(
                              "${dotenv.env["BACKEND_BASE_API"]}/rt/block/switchRt",
                            ),
                            headers: {
                              "Content-Type": "application/json",
                              "Authorization": prefs!.getString("jwtToken")!,
                            },
                            body: jsonEncode({"blockNo": _selectedValue}),
                          );
                        } catch (err) {
                          if (!mounted) {
                            return;
                          }
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Something went wrong"),
                            ),
                          );
                        }
                        fetchSwitchedRts();
                        Navigator.of(context).pop();
                      }
                    : null,
                child: const Text("Switch"),
              ),
            ],
          );
        });
      },
    );
  }

  void _revert() {
    TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  "Type \"REVERT\" to delete",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              content: TextField(
                controller: confirmController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: confirmController.text == "REVERT"
                      ? () async {
                          try {
                            await http.post(
                              Uri.parse(
                                "${dotenv.env["BACKEND_BASE_API"]}/rt/block/revertSwitchRt",
                              ),
                              headers: {
                                "Content-Type": "application/json",
                                "Authorization": prefs!.getString("jwtToken")!,
                              },
                            );
                          } catch (err) {
                            if (!mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Something went wrong"),
                              ),
                            );
                          }
                          fetchSwitchedRts();
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text("Revert"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      drawer: const RtDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    clipBehavior: Clip.hardEdge,
                    padding: const EdgeInsets.all(15),
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
                              child: profileBuffer == null
                                  ? const Icon(
                                      Icons.person_rounded,
                                      size: 30,
                                    )
                                  : Image.memory(
                                      base64Decode(profileBuffer!),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prefs!.getString("username")!,
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                  style: textTheme.bodyLarge!.copyWith(
                                    color:
                                        const Color.fromARGB(255, 25, 32, 42),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Block ${prefs!.getInt("permanentBlock")}",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color:
                                        const Color.fromARGB(255, 96, 102, 110),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'PERSONAL INFORMATION',
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 30, 75, 130),
                    ),
                  ),
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
                          // iconData: Icons.mail_rounded,
                          // iconData: Ionicons.mail,
                          iconData: const FaIcon(
                            FontAwesomeIcons.solidEnvelope,
                            size: 20,
                          ),
                          attribute: "Email",
                          value: prefs!.getString(("email"))!,
                        ),
                        const Divider(height: 0),
                        ProfileItem(
                          // iconData: Ionicons.call,
                          // iconData: Icons.call,
                          iconData: const FaIcon(
                            FontAwesomeIcons.phone,
                            size: 20,
                          ),

                          attribute: "Phone No",
                          value: prefs!.getString(("phNo"))!,
                        ),
                        const Divider(height: 0),
                        ProfileItem(
                          // iconData: Icons.apartment_rounded,
                          iconData: const FaIcon(
                            FontAwesomeIcons.solidBuilding,
                            size: 20,
                          ),
                          attribute: "Temporary Blocks Assigned",
                          value: temporaryBlock == null
                              ? "Loading..."
                              : temporaryBlock!.isEmpty
                                  ? "None"
                                  : temporaryBlock!.join(", "),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'SWITCH RT',
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 30, 75, 130),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 15),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Switch to :",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 0),
                              child: DropdownButton<int>(
                                value: _selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedValue = value!;
                                  });
                                },
                                items: items,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.arrow_drop_down),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                                dropdownColor: Colors.white,
                                elevation: 8,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _revert,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                              child: const Text('Revert'),
                            ),
                            const SizedBox(width: 15),
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              child: const Text('Switch'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Switched RTs:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // SizedBox(height: 10),
                        switchedRts.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: switchedRts.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                        "${index + 1}. RT Name: ${switchedRts[index]['rtName']}"),
                                    subtitle: Text(
                                        "Block: ${switchedRts[index]['permanentBlock']}"),
                                  );
                                },
                              )
                            : const Padding(
                                padding: EdgeInsets.only(top: 12.0),
                                child: Text(
                                  "No Rts Incharge for your block",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: LogoutTile(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
