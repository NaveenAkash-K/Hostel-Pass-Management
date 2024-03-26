import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/pages/student/student_profile_page.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockStudentsPage extends ConsumerStatefulWidget {
  const BlockStudentsPage({this.students, this.blockNo, super.key});
  final List<BlockStudent>? students;
  final int? blockNo;

  @override
  ConsumerState<BlockStudentsPage> createState() => _BlockStudentsPageState();
}

class _BlockStudentsPageState extends ConsumerState<BlockStudentsPage> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  final TextEditingController _searchController = TextEditingController();
  List<BlockStudent> _filteredStudents = [];
  List<BlockStudent> blockStudents = [];
  var drawer;
  var appbar;

  @override
  void initState() {
    super.initState();
    if (prefs!.getString('role') == "rt") {
      blockStudents = widget.students!;
      if (prefs!.getBool('isBoysHostelRt')!) {
        blockStudents =
            blockStudents.where((student) => student.gender == 'M').toList();
      } else {
        blockStudents =
            blockStudents.where((student) => student.gender == 'F').toList();
      }
      _filteredStudents = blockStudents;
      drawer = const RtDrawer();
      appbar = AppBar(
        title: const Text('Block Students'),
        centerTitle: true,
      );
    } else {
      blockStudents = widget.students!;
      _filteredStudents = blockStudents;
      drawer = null;
      appbar = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: drawer,
      appBar: appbar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: 'Search by student name...',
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(137, 26, 26, 26),
                  ),
                  suffixIcon: _searchController.text.trim() == ""
                      ? const Icon(
                          Icons.search_rounded,
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              _searchController.text = "";
                              _filteredStudents = blockStudents;
                            });
                          },
                          child: const Icon(Icons.cancel_outlined))),
              style: const TextStyle(color: Colors.black),
              onChanged: _filterStudents,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStudents.isNotEmpty
                  ? _filteredStudents.length
                  : blockStudents.length,
              itemBuilder: (BuildContext context, int index) {
                if (_filteredStudents.isEmpty) return null;
                // final student = blockStudents[index];
                final student = _searchController.text.trim() == ""
                    ? blockStudents[index]
                    : _filteredStudents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentProfilePage(studentData: student),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Row(
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
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.username,
                                      style: textTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text("Room No: ${student.roomNo}")
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(
                                  student.dept,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          height: 1, // Adjust the height as needed
                          thickness: 1, // Adjust the thickness as needed
                          color: Color.fromARGB(255, 219, 219, 219),
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

  void _filterStudents(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredStudents = blockStudents;
      });
    } else {
      setState(() {
        _filteredStudents = blockStudents
            .where((student) =>
                student.username.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }
}
