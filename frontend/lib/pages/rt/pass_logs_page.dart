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
  const PassLogsPage({Key? key}) : super(key: key);

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
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    var drawer;
    if (prefs!.getString("role") == "student") {
      drawer = StudentDrawer();
    } else if (prefs.getString("role") == "rt") {
      drawer = RtDrawer();
    } else if (prefs.getString("role") == "warden") {
      drawer = WardenDrawer();
    }
    final passRequests = ref.watch(rtPassProvider);
    List<PassRequest> inUsePasses =
        passRequests.where((pass) => pass.status == 'In use').toList();
    List<PassRequest> usedPasses =
        passRequests.where((pass) => pass.status == 'Used').toList();

    return Scaffold(
      drawer: const RtDrawer(),
      appBar: AppBar(
        title: const Text('SVCE Hostel'),
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
