import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/warden/block_details_page.dart';
import 'package:hostel_pass_management/providers/hostel_students_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';

class BlockTile extends StatefulWidget {
  const BlockTile({
    super.key,
    required this.blockName,
    required this.inCount,
    required this.outCount,
  });
  final String blockName;
  final int inCount;
  final int outCount;

  @override
  State<BlockTile> createState() => _BlockTileState();
}

class _BlockTileState extends State<BlockTile> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.blockName,
              style: textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 222, 242, 230),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 135, 207, 163),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Present",
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          (widget.inCount - widget.outCount).toString(),
                          style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 246, 232, 232),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 187, 68, 68),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Away",
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.outCount.toString(),
                          style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}