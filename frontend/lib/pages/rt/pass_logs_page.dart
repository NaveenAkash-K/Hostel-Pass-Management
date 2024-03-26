import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/pass_request_item.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassLogsPage extends ConsumerStatefulWidget {
  const PassLogsPage(
      {Key? key, this.inUsePasses, this.usedPasses, this.blockNo})
      : super(key: key);
  final List<PassRequest>? inUsePasses;
  final List<PassRequest>? usedPasses;
  final int? blockNo;
  @override
  ConsumerState<PassLogsPage> createState() => _PassLogsPageState();
}

class _PassLogsPageState extends ConsumerState<PassLogsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var drawer;
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    if (prefs!.getString("role") == "student") {
      drawer = const StudentDrawer();
    } else if (prefs.getString("role") == "rt") {
      drawer = const RtDrawer();
    }
    if (prefs.getString("role") == "warden") {
      drawer = const WardenDrawer();
    }
    final passRequests;
    List<PassRequest> inUsePasses = [];
    List<PassRequest> usedPasses = [];
    if (prefs.getString("role") == "warden" &&
        widget.inUsePasses != null &&
        widget.usedPasses != null) {
      inUsePasses = widget.inUsePasses!
          .where((pass) => pass.blockNo == widget.blockNo)
          .toList();
      usedPasses = widget.usedPasses!
          .where((pass) => pass.blockNo == widget.blockNo)
          .toList();
    } else if (prefs.getString("role") == "rt") {
      passRequests = ref.watch(rtPassProvider);
      if (prefs.getBool('isBoysHostelRt')!) {
        inUsePasses = passRequests
            .where((pass) => pass.status == 'In use' && pass.gender == 'M')
            .toList();
        usedPasses = passRequests
            .where((pass) => pass.status == 'Used' && pass.gender == 'M')
            .toList();
      } else {
        inUsePasses = passRequests
            .where((pass) => pass.status == 'In use' && pass.gender == 'F')
            .toList();
        usedPasses = passRequests
            .where((pass) => pass.status == 'Used' && pass.gender == 'F')
            .toList();
      }
    }

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text('Pass Logs'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'In Use'),
            Tab(text: 'Used'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: inUsePasses.length,
            itemBuilder: (context, index) {
              return PassRequestItem(
                pass: inUsePasses[index],
                passRequest: false,
              );
            },
          ),
          ListView.builder(
            itemCount: usedPasses.length,
            itemBuilder: (context, index) {
              return PassRequestItem(
                pass: usedPasses[index],
                passRequest: false,
              );
            },
          ),
        ],
      ),
    );
  }
}
