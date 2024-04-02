import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/widgets/rt/pass_request_item.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class WardenPassRequestPage extends ConsumerStatefulWidget {
  const WardenPassRequestPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _WardenPassRequestPageState();
  }
}

class _WardenPassRequestPageState extends ConsumerState<WardenPassRequestPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    final passRequests = ref.watch(specialPassProvider);
    final List<PassRequest> pendingPasses =
        passRequests.where((pass) => pass.status == 'Pending').toList();

    return Scaffold(
      drawer: const WardenDrawer(),
      appBar: AppBar(
        title: const Text('Pass Requests'),
        centerTitle: true,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          await ref.read(specialPassProvider.notifier).getSpecailPassesFromDB();
          _refreshController.refreshCompleted();
        },
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Boys'),
                  Tab(text: 'Girls'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPasses(pendingPasses, 'M'),
                    _buildPasses(pendingPasses, 'F'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasses(List<PassRequest> passes, String gender) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final filteredPasses = passes
        .where((pass) => pass.gender == gender && pass.isSpecialPass)
        .toList();

    if (filteredPasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset(
              "assets/images/no-pass.svg",
              width: 300,
            ),
            const SizedBox(height: 10),
            Text(
              "No pass requests detected.\nSit back and Enjoy",
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
            const Spacer(),
            const Spacer()
          ],
        ),
      );
    } else {
      return Column(
        children: filteredPasses
            .map((pass) => PassRequestItem(
                  pass: pass,
                  passRequest: true,
                ))
            .toList(),
      );
    }
  }
}
