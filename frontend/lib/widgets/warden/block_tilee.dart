import 'package:flutter/material.dart';

class BlockTile extends StatelessWidget {
  final String name;
  final int inCount;
  final int outCount;
  final bool isOverallCount;

  const BlockTile({
    super.key,

    required this.name,
    required this.inCount,
    required this.outCount,
    this.isOverallCount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isOverallCount
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          crossAxisAlignment: isOverallCount
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isOverallCount ? 20 : 16,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: isOverallCount
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.arrow_downward_outlined,
                  color: Colors.green,
                ),
                // const SizedBox(width: 4.0),
                Text(
                  '${inCount - outCount} ',
                  style: TextStyle(
                    fontSize: isOverallCount ? 20 : 16,
                  ),
                ),
                const SizedBox(

                  width: 8
                ),
                const Icon(
                  Icons.arrow_upward_sharp,
                  color: Colors.red,
                ),
                // const SizedBox(width: 4.0),
                Text(
                  '$outCount',
                  style: TextStyle(
                    fontSize: isOverallCount ? 20 : 16,
                  ),
                ),
                const SizedBox(
                  width: 8
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
