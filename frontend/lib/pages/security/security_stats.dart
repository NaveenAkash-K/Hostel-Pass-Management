import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/security/security_passlogs.dart';
import 'package:hostel_pass_management/pages/warden/block_details_page.dart';
import 'package:hostel_pass_management/providers/hostel_students_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/faculty/faculty_drawer.dart';
import 'package:hostel_pass_management/widgets/security/security_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/block_tilee.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityStats extends ConsumerStatefulWidget {
  const SecurityStats({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SecurityStatsState();
  }
}

class _SecurityStatsState extends ConsumerState<SecurityStats> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  @override
  Widget build(BuildContext context) {
    final students = ref.watch(hostelStudentProvider);
    final passes = ref.watch(specialPassProvider);

    // Filter students and passes based on gender
    final maleStudents =
        students.where((student) => student.gender == 'M').toList();
    final femaleStudents =
        students.where((student) => student.gender == 'F').toList();

    final maleInUsePasses = passes
        .where((pass) => pass.gender == 'M' && pass.status == 'In use')
        .toList();
    final femaleInUsePasses = passes
        .where((pass) => pass.gender == 'F' && pass.status == 'In use')
        .toList();

    List<int> maleBlocksList =
        List.filled(int.parse(dotenv.env["NO_OF_BOYS_BLOCK"]!), 0);
    List<int> femaleBlocksList =
        List.filled(int.parse(dotenv.env["NO_OF_GIRLS_BLOCK"]!), 0);
    List<int> malePassesList =
        List.filled(int.parse(dotenv.env["NO_OF_BOYS_BLOCK"]!), 0);
    List<int> femalePassesList =
        List.filled(int.parse(dotenv.env["NO_OF_GIRLS_BLOCK"]!), 0);

    for (var student in maleStudents) {
      maleBlocksList[student.blockNo - 1]++;
    }

    for (var student in femaleStudents) {
      femaleBlocksList[student.blockNo - 1]++;
    }

    for (var pass in maleInUsePasses) {
      malePassesList[pass.blockNo - 1]++;
    }

    for (var pass in femaleInUsePasses) {
      femalePassesList[pass.blockNo - 1]++;
    }

    List<Widget> maleBlockTiles = [];
    List<Widget> femaleBlockTiles = [];

    final noOfMaleBlocks = maleBlocksList.length;
    final noOfFemaleBlocks = femaleBlocksList.length;

    for (int i = 0; i < noOfMaleBlocks; i++) {
      maleBlockTiles.add(
        GestureDetector(
          onTap: () {
            _navigateToBlockDetails(
                context, i + 1, maleStudents, maleInUsePasses);
          },
          child: BlockTile(
            name: "Block ${i + 1}",
            inCount: maleBlocksList[i],
            outCount: malePassesList[i],
          ),
        ),
      );
    }
    for (int i = 0; i < noOfFemaleBlocks; i++) {
      femaleBlockTiles.add(
        GestureDetector(
          onTap: () {
            _navigateToBlockDetails(
                context, i + 1, femaleStudents, femaleInUsePasses);
          },
          child: BlockTile(
            name: "Block ${i + 1}",
            inCount: femaleBlocksList[i],
            outCount: femalePassesList[i],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 244, 250),
        appBar: AppBar(
          title: const Text('Block Stats'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Boys Hostel'),
              Tab(text: 'Girls Hostel'),
            ],
          ),
        ),
        drawer: const SecurityDrawer(),
        body: TabBarView(
          children: [
            ListView(
              children: [
                buildRows(maleBlockTiles),
              ],
            ),
            ListView(
              children: [
                buildRows(femaleBlockTiles),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRows(List<Widget> blockTiles) {
    List<Widget> rows = [];
    int i = 0;
    while (i < blockTiles.length) {
      if (i == blockTiles.length - 1) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [blockTiles[i]],
        ));
      } else {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [blockTiles[i], blockTiles[i + 1]],
        ));
      }
      i += 2;
    }
    return Column(children: rows);
  }

  void _navigateToBlockDetails(
    BuildContext context,
    int blockNo,
    List<BlockStudent> students,
    List<PassRequest> inUsePasses,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SecurityPassLogs(
          blockNo: blockNo,
          students:
              students.where((student) => student.blockNo == blockNo).toList(),
          inUsePasses: inUsePasses
              .where(
                  (pass) => pass.blockNo == blockNo && pass.status == 'In use')
              .toList(),
        ),
      ),
    );
  }
}
