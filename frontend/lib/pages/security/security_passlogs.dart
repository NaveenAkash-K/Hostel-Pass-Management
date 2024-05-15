import 'package:flutter/material.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/rt/block_students_page.dart';
import 'package:hostel_pass_management/pages/warden/warden_pass_logs_page.dart';

class SecurityPassLogs extends StatefulWidget {
  const SecurityPassLogs(
      {super.key,
      required this.students,
      required this.inUsePasses,
      required this.blockNo});
  final List<BlockStudent> students;
  final List<PassRequest> inUsePasses;
  final int blockNo;
  @override
  State<SecurityPassLogs> createState() {
    return _SecurityPassLogsState();
  }
}

class _SecurityPassLogsState extends State<SecurityPassLogs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In Use Passes'),
      ),
      body: WardenPassLogPage(
          passes: widget.inUsePasses, blockNo: widget.blockNo),
    );
  }
}
