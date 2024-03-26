import 'package:flutter/material.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/widgets/rt/pass_request_item.dart';

class WardenPassLogPage extends StatelessWidget {
  const WardenPassLogPage(
      {super.key, required this.passes, required this.blockNo});
  final List<PassRequest> passes;
  final int blockNo;

  @override
  Widget build(BuildContext context) {
    final filteredpasses =
        passes.where((pass) => pass.blockNo == blockNo).toList();
    return Scaffold(
      body: ListView.builder(
        itemCount: filteredpasses.length,
        itemBuilder: (context, index) {
          return PassRequestItem(
            pass: filteredpasses[index],
            passRequest: false,
          );
        },
      ),
    );
  }
}
