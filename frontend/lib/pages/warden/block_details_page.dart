import 'package:flutter/material.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/rt/block_students_page.dart';
import 'package:hostel_pass_management/pages/warden/warden_pass_logs_page.dart';

class BlockDetailPage extends StatefulWidget {
  const BlockDetailPage(
      {super.key,
      required this.students,
      required this.inUsePasses,
      required this.usedPasses,
      required this.blockNo});
  final List<BlockStudent> students;
  final List<PassRequest> inUsePasses;
  final List<PassRequest> usedPasses;
  final int blockNo;
  @override
  State<BlockDetailPage> createState() {
    return _BlockDetailPageState();
  }
}

class _BlockDetailPageState extends State<BlockDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Block Detail'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'In use'),
            Tab(text: 'Used'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlockStudentsPage(
            students: widget.students,
          ),
          WardenPassLogPage(
              passes: widget.inUsePasses, blockNo: widget.blockNo),
          WardenPassLogPage(
            blockNo: widget.blockNo,
            passes: widget.usedPasses,
          ),
        ],
      ),
    );
  }
}

// class InUsePasses extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() {
//     return _InUsePassState();
//   }
// }

// class _InUsePassState extends ConsumerState<InUsePasses> {
//   @override
//   Widget build(BuildContext context) {
    
//   }
// }
