import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/pages/common/profile_page.dart';
import 'package:hostel_pass_management/providers/block_students_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockStudentsPage extends ConsumerStatefulWidget {
  const BlockStudentsPage({Key? key, this.students});
  final List<BlockStudent>? students;

  @override
  ConsumerState<BlockStudentsPage> createState() => _BlockStudentsPageState();
}

class _BlockStudentsPageState extends ConsumerState<BlockStudentsPage> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  @override
  Widget build(BuildContext context) {
    final blockStudents;
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    var drawer;
    if (prefs!.getString("role") == "student") {
      drawer = StudentDrawer();
    } else if (prefs.getString("role") == "rt") {
      drawer = RtDrawer();
    } else if (prefs.getString("role") == "warden") {
      drawer = WardenDrawer();
    }
    if (widget.students == null) {
      blockStudents = ref.watch(blockStudentProvider);
    } else {
      blockStudents = widget.students;
    }

    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text('Block Students'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: blockStudents.length,
              itemBuilder: (BuildContext context, int index) {
                final student = blockStudents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 24.0, top: 8, bottom: 8, left: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.primaryContainer,
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    student.username[0],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),

                              // child: Image.memory(
                              //   base64Decode(student.profileBuffer),
                              //   fit: BoxFit.cover,
                              // ),
                              // child: Text(
                              //   student.username[0],
                              //   style: textTheme.titleLarge!.copyWith(
                              //     fontWeight: FontWeight.w500,
                              //     color: colorScheme.onPrimaryContainer,
                              //   ),
                              // ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.username,
                                    style: textTheme.bodyLarge!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Text("Room No: ${student.roomNo}")
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              student.dept,
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          height: 1, // Adjust the height as needed
                          thickness: 1, // Adjust the thickness as needed
                          color: Color.fromARGB(
                              255, 219, 219, 219), // Adjust the color as needed
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
