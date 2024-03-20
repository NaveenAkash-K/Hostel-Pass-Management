import 'package:flutter/material.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/pages/student/student_profile_page.dart';

class BlockStudentsPage extends StatefulWidget {
  const BlockStudentsPage({Key? key, this.students, this.blockNo})
      : super(key: key);
  final List<BlockStudent>? students;
  final int? blockNo;

  @override
  _BlockStudentsPageState createState() => _BlockStudentsPageState();
}

class _BlockStudentsPageState extends State<BlockStudentsPage> {
  TextEditingController _searchController = TextEditingController();
  List<BlockStudent>? _filteredStudents;

  @override
  void initState() {
    super.initState();
    _filteredStudents = widget.students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                  hintText: 'Search by student name...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Color.fromARGB(137, 26, 26, 26),
                  ),
                  suffixIcon: Icon(
                    Icons.search_rounded,
                  )),
              style: const TextStyle(color: Colors.black),
              onChanged: _filterStudents,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStudents!.length,
              itemBuilder: (BuildContext context, int index) {
                final student = _filteredStudents![index];
                return ListTile(
                  title: Text(student.username),
                  subtitle: Text('Room No: ${student.roomNo}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudentProfilePage(
                          studentData: student,
                        ),
                      ),
                    );
                  },
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
        _filteredStudents = widget.students;
      });
    } else {
      setState(() {
        _filteredStudents = widget.students!
            .where((student) =>
                student.username.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }
}
