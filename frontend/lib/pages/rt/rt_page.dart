import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/providers/block_students_provider.dart';
import 'package:hostel_pass_management/providers/rt_announcement_provider.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/rt/pass_request_item.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RtPage extends ConsumerStatefulWidget {
  const RtPage({super.key, this.warden});
  final bool? warden;

  @override
  ConsumerState<RtPage> createState() => _RtPageState();
}

class _RtPageState extends ConsumerState<RtPage> {
  @override
  Widget build(BuildContext context) {
    final passRequests;
    var studentPasses;
    List<PassRequest> pendingPasses;
    var students = [];
    int studentsCount = 0;
    int passesCount = 0;
    var drawer;
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    if (prefs!.getString("role") == "student") {
      drawer = StudentDrawer();
    } else if (prefs.getString("role") == "rt") {
      drawer = RtDrawer();
    }
    if (prefs.getString("role") == "warden") {
      drawer = WardenDrawer();
    }
    if (prefs.getString("role") == "rt") {
      passRequests = ref.watch(rtPassProvider);
      students = ref.watch(blockStudentProvider);

      if (prefs.getBool('isBoysHostelRt')!) {
        students.where((student) => student.gender == 'M').forEach((student) {
          studentsCount++;
        });

        students.where((student) => student.gender == 'M').forEach((student) {
          studentPasses = passRequests.where((pass) =>
              pass.studentId == student.studentId && pass.status == "In use");
          studentPasses.forEach((pass) {
            passesCount++;
          });
        });
      } else {
        students.where((student) => student.gender == 'F').forEach((student) {
          studentsCount++;
        });

        students.where((student) => student.gender == 'F').forEach((student) {
          studentPasses = passRequests.where((pass) =>
              pass.studentId == student.studentId && pass.status == "In use");
          studentPasses.forEach((pass) {
            passesCount++;
          });
        });
      }
      // students.forEach((student) {
      //   studentsCount++;
      // });
      // students.forEach((student) {
      //   studentPasses = passRequests.where((pass) =>
      //       pass.studentId == student.studentId && pass.status == "In use");
      //   studentPasses.forEach((pass) {
      //     passesCount++;
      //   });
      // });
      if (prefs.getBool('isBoysHostelRt')!) {
        pendingPasses = passRequests
            .where((pass) =>
                pass.status == 'Pending' &&
                pass.gender == 'M' &&
                pass.isSpecialPass == false)
            .toList();
      } else {
        pendingPasses = passRequests
            .where((pass) => pass.status == 'Pending' && pass.gender == 'F')
            .toList();
      }
      print("stduents $studentsCount");
      print("pases $passesCount");
    } else {
      passRequests = ref.watch(specialPassProvider);
      pendingPasses =
          passRequests.where((pass) => pass.status == 'Pending').toList();
    }
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text('Pass Requests'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // DropdownButton<int>(
          //   value: 0,
          //   onChanged: (int? value) {
          //     setState(() {
          //       // _selectedValue = value!;
          //     });
          //   },
          //   items: List<DropdownMenuItem<int>>.generate(5, (int index) {
          //     if (index == 1) {
          //       index++;
          //     }
          //     return DropdownMenuItem<int>(
          //       value: index,
          //       child: Text(index == 0 ? "None" : 'Block ${index}'),
          //     );
          //   }),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Visibility(
                  visible: studentsCount != 0,
                  child: Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_walk, color: Colors.green),
                          SizedBox(width: 10),
                          Text(
                            "Students\nOutside: $passesCount",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Visibility(
                  visible: studentsCount != 0,
                  child: Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home,
                              color: Theme.of(context).colorScheme.primary),
                          SizedBox(width: 10),
                          Text(
                            "Students\nInside: ${studentsCount - passesCount}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (pendingPasses.length == 0)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SvgPicture.asset(
                      "assets/images/no-pass.svg",
                      width: 300,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No pass requests detected.\nSit back and Enjoy",
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium,
                    ),
                    Spacer(),
                    Spacer()
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return PassRequestItem(
                    pass: pendingPasses[index],
                    passRequest: true,
                  );
                },
                itemCount: pendingPasses.length,
              ),
            ),
        ],
      ),
    );
  }
}
