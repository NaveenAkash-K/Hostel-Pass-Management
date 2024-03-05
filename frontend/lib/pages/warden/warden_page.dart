import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/pages/rt/block_students_page.dart';
import 'package:hostel_pass_management/providers/hostel_students_provider.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WardenPage extends ConsumerStatefulWidget {
  const WardenPage({Key? key}) : super(key: key);

  @override
  ConsumerState<WardenPage> createState() => _WardenPageState();
}

class _WardenPageState extends ConsumerState<WardenPage> {
  @override
  Widget build(BuildContext context) {
    final hostelStudents = ref.watch(hostelStudentProvider);
    final blocks =
        List.generate(6, (index) => index + 1); // Generating 6 blocks
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    return Scaffold(
      drawer: WardenDrawer(),
      appBar: AppBar(
        title: const Text('Warden'),
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Displaying blocks in a ListView
          Expanded(
            child: ListView.builder(
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                final block = blocks[index];
                return ListTile(
                  title: Text('Block $block'),
                  onTap: () {
                    final filteredStudents = hostelStudents
                        .where((student) => student.blockNo == index + 1)
                        .toList();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlockStudentsPage(
                        students: filteredStudents,
                      ),
                    ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
