import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/logout_tile.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WardenProfilePage extends StatefulWidget {
  const WardenProfilePage({Key? key}) : super(key: key);

  @override
  State<WardenProfilePage> createState() => _WardenProfilePageState();
}

class _WardenProfilePageState extends State<WardenProfilePage> {
  String? profileBuffer;
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

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
      });
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    }
  }

  @override
  void initState() {
    fetchProfilePic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      drawer: const WardenDrawer(),
      body: Container(
        // height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
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
                              color: const Color.fromARGB(255, 25, 32, 42),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Warden",
                            style: textTheme.bodyMedium!.copyWith(
                              color: const Color.fromARGB(255, 96, 102, 110),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PERSONAL INFORMATION',
                    style: textTheme.bodyLarge!.copyWith(
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
                          iconData: const FaIcon(
                            FontAwesomeIcons.solidEnvelope,
                            size: 20,
                          ),
                          attribute: "Email",
                          value: prefs!.getString(("email"))!,
                        ),
                        const Divider(height: 0),
                        ProfileItem(
                          iconData: const FaIcon(
                            FontAwesomeIcons.phone,
                            size: 20,
                          ),
                          attribute: "Phone No",
                          value: prefs!.getString(("phNo"))!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: LogoutTile(),
            ),
          ],
        ),
      ),
    );
  }
}
