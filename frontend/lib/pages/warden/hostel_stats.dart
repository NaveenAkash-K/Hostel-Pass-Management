import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/warden/block_details_page.dart';
import 'package:hostel_pass_management/providers/hostel_students_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/widgets/warden/block_tile.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';

class StatsPage extends ConsumerStatefulWidget {
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
    List<int> femaleBlockCounts = List.filled(8, 0);
    List<int> malePassCount = List.filled(8, 0);
    List<int> femalePassCount = List.filled(8, 0);

    maleStudents.forEach((student) {
      maleBlockCounts[student.blockNo - 1]++;
    });

    femaleStudents.forEach((student) {
      femaleBlockCounts[student.blockNo - 1]++;
    });

    maleInUsePasses.forEach((pass) {
      malePassCount[pass.blockNo - 1]++;
    });

    femaleInUsePasses.forEach((pass) {
      femalePassCount[pass.blockNo - 1]++;
    });

    print(maleBlockCounts);
    print(malePassCount);

    List<Widget> maleBlockTiles = [];
    List<Widget> femaleBlockTiles = [];
    final NO_OF_BLOCKS = maleBlockCounts.length;

    for (int i = 0; i < NO_OF_BLOCKS; i++) {
      maleBlockTiles.add(
        GestureDetector(
          onTap: () {
            _navigateToBlockDetails(context, i + 1, maleStudents, malePasses);
          },
          child: BlockTile(
            blockName: "Block ${i + 1}",
            inCount: maleBlockCounts[i],
            outCount: malePassCount[i],
          ),
        ),
      );

      femaleBlockTiles.add(
        GestureDetector(
          onTap: () {
            _navigateToBlockDetails(
                context, i + 1, femaleStudents, femalePasses);
          },
          child: BlockTile(
            blockName: "Block ${i + 1}",
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
          title: const Text('Stats and Blocks'),
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
                ...maleBlockTiles,
                BlockTile(
                  blockName: "Overall Count",
                  inCount: maleStudents.length,
                  outCount: maleInUsePasses.length,
                )
              ],
            ),
            ListView(
              children: [
                ...femaleBlockTiles,
                BlockTile(
                  blockName: "Overall Count",
                  inCount: femaleStudents.length,
                  outCount: femaleInUsePasses.length,
                )
              ],
            ),
          ],
        ),
      ),
    );
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
