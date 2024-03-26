// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/logout_tile.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key, this.studentData});
  final BlockStudent? studentData;

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  String? profileBuffer;
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  late BlockStudent student;

  void fetchProfilePic() async {
    try {
      var response;
      if (widget.studentData == null) {
        response = await http.get(
          Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/profile/fetch"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": prefs!.getString("jwtToken")!,
          },
        );
      } else {
        response = await http.get(
          Uri.parse(
              "${dotenv.env["BACKEND_BASE_API"]}/profile/studentProfile/${widget.studentData!.studentId}"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": prefs!.getString("jwtToken")!,
          },
        );
      }

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
    if (widget.studentData == null) {
      student = BlockStudent(
          studentId: prefs!.getString("studentId")!,
          uid: prefs!.getString("uid")!,
          username: prefs!.getString("username")!,
          gender: prefs!.getString("gender")!,
          email: prefs!.getString("email")!,
          regNo: prefs!.getString("regNo")!,
          phNo: prefs!.getString("phNo")!,
          fatherName: prefs!.getString("fatherName")!,
          fatherPhNo: prefs!.getString("fatherPhNo")!,
          motherName: prefs!.getString("motherName")!,
          motherPhNo: prefs!.getString("motherPhNo")!,
          dept: prefs!.getString("dept")!,
          year: prefs!.getInt("year")!,
          blockNo: prefs!.getInt("blockNo")!,
          roomNo: prefs!.getInt("roomNo")!,
          section: prefs!.getString("section")!);
    } else {
      student = BlockStudent(
          studentId: widget.studentData!.studentId,
          uid: widget.studentData!.uid,
          username: widget.studentData!.username,
          gender: widget.studentData!.gender,
          email: widget.studentData!.email,
          regNo: widget.studentData!.regNo,
          phNo: widget.studentData!.phNo,
          fatherName: widget.studentData!.fatherName,
          fatherPhNo: widget.studentData!.fatherPhNo,
          motherName: widget.studentData!.motherName,
          motherPhNo: widget.studentData!.motherPhNo,
          dept: widget.studentData!.dept,
          year: widget.studentData!.year,
          blockNo: widget.studentData!.blockNo,
          roomNo: widget.studentData!.roomNo,
          section: widget.studentData!.section);
    }

    // ignore: unused_local_variable
    TextTheme textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    // print(prefs!.getString("profileBuffer"));

    return Scaffold(
      body: Scaffold(
        backgroundColor: const Color(0xf5f4fa),
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 153, 0, 255),
          // foregroundColor: Colors.white,
          title: const Text(
            "Profile",
          ),
          // centerTitle: true,
        ),
        drawer: widget.studentData == null ? const StudentDrawer() : null,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                // prefs!.getString("username")!,
                                // "Naveen Naveen Naveen Naveen Naveen",
                                student.username,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: textTheme.bodyLarge!.copyWith(
                                  color: const Color.fromARGB(255, 25, 32, 42),
                                  // color: Color.fromARGB(255, 112, 106, 106),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              student.regNo,
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
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACADEMIC INFORMATION',
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        // color: colorScheme.primary,
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
                              FontAwesomeIcons.graduationCap,
                              size: 20,
                            ),
                            attribute: "Year",
                            value: student.year.toString(),
                          ),
                          const Divider(height: 0),
                          ProfileItem(
                            iconData: const FaIcon(
                              FontAwesomeIcons.solidBuilding,
                              size: 20,
                            ),
                            attribute: "Department",
                            value: student.dept,
                          ),
                          const Divider(height: 0),
                          ProfileItem(
                            iconData: const FaIcon(
                              FontAwesomeIcons.school,
                              size: 20,
                            ),
                            attribute: "Section",
                            value: student.section,
                          ),
                          const Divider(height: 0),
                          ProfileItem(
                            iconData: const FaIcon(
                              FontAwesomeIcons.solidAddressCard,
                              size: 20,
                            ),
                            attribute: "Admission Number",
                            value: student.studentId,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
                            value: student.email,
                          ),
                          const Divider(height: 0),
                          ProfileItem(
                            iconData: const FaIcon(
                              FontAwesomeIcons.phone,
                              size: 20,
                            ),
                            attribute: "Phone No",
                            value: student.phNo,
                          ),
                          const Divider(height: 0),
                          ProfileItem(
                            iconData: const FaIcon(
                              FontAwesomeIcons.peopleRoof,
                              size: 20,
                            ),
                            attribute: "Father's / Mother's Name",
                            value:
                                "${student.fatherName} / ${student.motherName}",
                          ),
                          // const Divider(height: 0),
                          // ProfileItem(
                          //   attribute: "Mother's Name",
                          //   value: student.motherName,
                          // ),
                          const Divider(height: 0),

                          ProfileItem(
                            iconData: const FaIcon(
                              FontAwesomeIcons.phone,
                              size: 20,
                            ),
                            attribute: "Father's / Mother's Phone No",
                            value:
                                "${student.fatherPhNo}  /  ${student.motherPhNo}",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'HOSTEL INFORMATION',
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 30, 75, 130),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
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
                            attribute: "Block No",
                            iconData: const FaIcon(
                              FontAwesomeIcons.solidBuilding,
                              size: 20,
                            ),
                            value: student.blockNo.toString(),
                          ),
                          const Divider(height: 0),
                          ProfileItem(
                            iconData: const FaIcon(
                              FontAwesomeIcons.doorOpen,
                              size: 20,
                            ),
                            attribute: "Room No",
                            value: student.roomNo.toString(),
                          ),
                        ],
                      ),
                    ),
                    if (widget.studentData == null) const SizedBox(height: 15),
                    if (widget.studentData == null) LogoutTile(),
                    const SizedBox(height: 20),
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
