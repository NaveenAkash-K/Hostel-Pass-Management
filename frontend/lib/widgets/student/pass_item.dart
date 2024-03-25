import 'package:flutter/material.dart';

class PassItem extends StatefulWidget {
  final String inDate;
  final String outDate;
  final String outTime;
  final String inTime;
  final String type;
  final String status;
  final String? action;

  const PassItem({
    required this.inDate,
    required this.inTime,
    required this.outDate,
    required this.outTime,
    required this.type,
    required this.status,
    this.action,
  });

  @override
  State<PassItem> createState() => _PassItemState();
}

class _PassItemState extends State<PassItem> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    String statusText;
    Color statusColor;

    switch (widget.status) {
      case 'Pending':
        statusText = widget.status;
        statusColor = colorScheme.background;
        break;
      case 'Approved' || 'In use':
        statusText = widget.status;
        statusColor = const Color.fromARGB(255, 190, 255, 192);
        break;
      // case 'Rejected':
      //   statusText = 'Rejected';
      //   statusColor = colorScheme.errorContainer;
      //   break;
      // case 'Expired':
      //   statusText = 'EXPIRED';
      //   statusColor = const Color.fromARGB(255, 183, 183, 183);
      //   break;
      default:
        statusText = 'Unknown';
        statusColor = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: statusColor,
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Column(
            children: [
              Icon(Icons.post_add_sharp),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(statusText),
              Text("Out: ${widget.outDate} ${widget.outTime}"),
              Text("In: ${widget.inDate} ${widget.inTime}"),
              Text(widget.type),
            ],
          ),
          // const Spacer(),
          // actionWidget,
          // const SizedBox(width: 20),
        ],
      ),
    );
  }
}
