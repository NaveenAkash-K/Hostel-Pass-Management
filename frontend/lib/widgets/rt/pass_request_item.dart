import 'package:flutter/material.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/rt/pass_request_page.dart';

class PassRequestItem extends StatefulWidget {
  const PassRequestItem({
    required this.pass,
    required this.passRequest,
    Key? key,
  }) : super(key: key);

  final PassRequest pass;
  final bool passRequest;

  @override
  _PassRequestItemState createState() => _PassRequestItemState();
}

class _PassRequestItemState extends State<PassRequestItem> {
  // ignore: unused_field
  final TextEditingController _searchController = TextEditingController();
  // ignore: unused_field
  late List<PassRequest> _filteredPassRequests;

  @override
  void initState() {
    super.initState();
    _filteredPassRequests = [widget.pass];
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        //   child: TextField(
        //     controller: _searchController,
        //     decoration: const InputDecoration(
        //         hintText: 'Search by student name...',
        //         border: InputBorder.none,
        //         hintStyle: TextStyle(
        //           color: Color.fromARGB(137, 26, 26, 26),
        //         ),
        //         suffixIcon: Icon(
        //           Icons.search_rounded,
        //         )),
        //     style: const TextStyle(color: Colors.black),
        //     onChanged: _filterPassRequests,
        //   ),
        // ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PassRequestPage(
                  pass: widget.pass,
                  passRequest: widget.passRequest,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    widget.pass.studentName[0],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        widget.pass.studentName,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.pass.type),
                          if (widget.pass.status == "Used" &&
                              !widget.passRequest &&
                              widget.pass.isLate!)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "LATE",
                                style: textTheme.labelSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // void _filterPassRequests(String query) {
  //   if (query.isEmpty) {
  //     setState(() {
  //       _filteredPassRequests = [widget.pass];
  //     });
  //   } else {
  //     setState(() {
  //       _filteredPassRequests = [widget.pass]
  //           .where((passRequest) => passRequest.studentName
  //               .toLowerCase()
  //               .contains(query.toLowerCase()))
  //           .toList();
  //     });
  //   }
  // }
}
