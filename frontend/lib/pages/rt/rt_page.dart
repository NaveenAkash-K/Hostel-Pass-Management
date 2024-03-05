import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/rt/pass_request_item.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RtPage extends ConsumerStatefulWidget {
  const RtPage({super.key, this.warden});
  final bool? warden;

  @override
  ConsumerState<RtPage> createState() => _RtPageState();
}

class _RtPageState extends ConsumerState<RtPage> {
  @override
  Widget build(BuildContext context) {
    var drawer;
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    if (prefs!.getString("role") == "student") {
      drawer = StudentDrawer();
    } else if (prefs.getString("role") == "rt") {
      drawer = RtDrawer();
    } else if (prefs.getString("role") == "warden") {
      drawer = WardenDrawer();
    }
    final passRequests;
    List<PassRequest> pendingPasses;
    if (prefs.getString("role") == "rt") {
      passRequests = ref.watch(rtPassProvider);
      pendingPasses = passRequests
          .where(
              (pass) => pass.status == 'Pending' && pass.isSpecialPass == false)
          .toList();
    } else {
      passRequests = ref.watch(specialPassProvider);
      pendingPasses = passRequests
          .where(
              (pass) => pass.status == 'Pending' && pass.isSpecialPass == true)
          .toList();
    }

    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text('SVCE Hostel'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
            child: Text(
              "Pass Requests",
              style: textTheme.titleLarge,
            ),
          ),
          if (pendingPasses.length == 0)
            const Expanded(
              child: Center(
                child: Text("No pass requests. Enjoy!!"),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return PassRequestItem(
                    pass: pendingPasses[index],
                    passRequest: true,
                  );
                },
                itemCount: pendingPasses.length,
              ),
            ),
        ],
      ),
    );
  }
}
