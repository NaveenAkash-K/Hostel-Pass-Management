import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/rt/pass_request_item.dart';

class RtPage extends ConsumerStatefulWidget {
  const RtPage({super.key});

  @override
  ConsumerState<RtPage> createState() => _RtPageState();
}

class _RtPageState extends ConsumerState<RtPage> {
  @override
  Widget build(BuildContext context) {
    final passRequests = ref.watch(rtPassProvider);
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: RtDrawer(),
      appBar: AppBar(
        title: Text('SVCE Hostel'),
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
          if (passRequests.every((pass) => pass.status != "pending"))
            Expanded(
              child: Center(
                child: Text("No pass requests. Enjoy!!"),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (passRequests[index].status == "pending") {
                    return PassRequestItem(pass: passRequests[index]);
                  }
                },
                itemCount: passRequests.length,
              ),
            ),
        ],
      ),
    );
  }
}