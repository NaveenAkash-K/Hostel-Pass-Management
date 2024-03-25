import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/warden/block_details_page.dart';
import 'package:hostel_pass_management/providers/hostel_students_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/widgets/warden/block_tile.dart';
import 'package:hostel_pass_management/widgets/warden/block_tilee.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  @override
  Widget build(BuildContext context) {
    final students = ref.watch(hostelStudentProvider);
    final passes = ref.watch(specialPassProvider);

    // Filter students and passes based on gender
    final maleStudents =
        students.where((student) => student.gender == 'M').toList();
    final femaleStudents =
        students.where((student) => student.gender == 'F').toList();

    // final maleInUsePasses = passes
    //     .where((pass) => maleStudents.any((student) =>
    //         student.studentId == pass.studentId && pass.status == "In use"))
    // .toList();
    final maleInUsePasses =
        passes.where((pass) => pass.gender == 'M' && pass.status == 'In use');
    final femaleInUsePasses = passes
        .where((pass) => femaleStudents.any((student) =>
            student.studentId == pass.studentId && pass.status == "In use"))
        .toList();
    final malePasses = passes
        .where((pass) =>
            maleStudents.any((student) => student.studentId == pass.studentId))
        .toList();
    final femalePasses = passes
        .where((pass) => femaleStudents
            .any((student) => student.studentId == pass.studentId))
        .toList();

    List<int> maleBlockCounts = List.filled(8, 0);
    List<int> femaleBlockCounts = List.filled(3, 0);
    List<int> malePassCount = List.filled(8, 0);
    List<int> femalePassCount = List.filled(3, 0);

    for (var student in maleStudents) {
      maleBlockCounts[student.blockNo - 1]++;
    }

    for (var student in femaleStudents) {
      femaleBlockCounts[student.blockNo - 1]++;
    }

    for (var pass in maleInUsePasses) {
      malePassCount[pass.blockNo - 1]++;
    }

    for (var pass in femaleInUsePasses) {
      femalePassCount[pass.blockNo - 1]++;
    }

    List<Widget> maleBlockTiles = [];
    List<Widget> femaleBlockTiles = [];

    final NO_OF_MALE_BLOCKS = maleBlockCounts.length;
    final NO_OF_FEMALE_BLOCKS = femaleBlockCounts.length;

    for (int i = 0; i < NO_OF_MALE_BLOCKS; i++) {

      maleBlockTiles.add(
        GestureDetector(
          onTap: () {
            _navigateToBlockDetails(context, i + 1, maleStudents, malePasses);
          },
          child: BlockTile(
            name: "Block ${i + 1}",

            inCount: maleBlockCounts[i],
            outCount: malePassCount[i],
          ),
        ),
      );
    }
    for (int i = 0; i < NO_OF_FEMALE_BLOCKS; i++) {
      femaleBlockTiles.add(
        GestureDetector(
          onTap: () {
            _navigateToBlockDetails(
                context, i + 1, femaleStudents, femalePasses);
          },
          child: BlockTile(
            name: "Block ${i + 1}",
            inCount: femaleBlockCounts[i],
            outCount: femalePassCount[i],
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
        drawer: const WardenDrawer(),
        body: TabBarView(
          children: [
            ListView(
              children: [
                BlockTile(
                  isOverallCount: true,
                  name: "Overall Count",

                  inCount: maleStudents.length,
                  outCount: maleInUsePasses.length,
                ),
                buildRows(maleBlockTiles),
              ],
            ),
            ListView(
              children: [
                BlockTile(
                  isOverallCount: true,
                  name: "Overall Count",

                  inCount: femaleStudents.length,
                  outCount: femaleInUsePasses.length,
                ),
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
    List<PassRequest> passes,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlockDetailPage(
          blockNo: blockNo,
          students:
              students.where((student) => student.blockNo == blockNo).toList(),
          inUsePasses: passes
              .where(
                  (pass) => pass.blockNo == blockNo && pass.status == 'In use')
              .toList(),
          usedPasses: passes
              .where((pass) => pass.blockNo == blockNo && pass.status == 'Used')
              .toList(),
        ),
      ),
    );
  }
}
