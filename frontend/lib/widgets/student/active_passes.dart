import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/providers/student_pass_provider.dart';
import 'package:hostel_pass_management/widgets/common/toast.dart';
import 'package:hostel_pass_management/widgets/student/pass_item.dart';

class ActivePasses extends ConsumerStatefulWidget {
  const ActivePasses({
    super.key,
    required this.pass,
  });
  final Pass? pass;

  @override
  ConsumerState<ActivePasses> createState() => _ActivePassesState();
}

bool isDeletePassLoading = false;

class _ActivePassesState extends ConsumerState<ActivePasses> {
  late FToast toast;
  void deletePassConfirmation(BuildContext context) {
    // Create a TextEditingController to handle user input

    // Show the AlertDialog
    showDialog(
      context: context,
      builder: (context) {
        return DeletePassDialog(pass: widget.pass);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(15),
      // padding: EdgeInsets.all(20),
      width: double.infinity,
      // height: 175,
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Active Pass",
                  style: textTheme.titleLarge,
                ),
                IconButton(
                  onPressed:
                      widget.pass == null || widget.pass!.status == "In use"
                          ? null
                          : () {
                              deletePassConfirmation(context);
                            },
                  icon: Icon(
                    Icons.delete,
                    color: colorScheme.onErrorContainer,
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 0),
          Column(
            children: [
              if (widget.pass != null)
                PassItem(
                  inTime: widget.pass!.expectedInTime,
                  outTime: widget.pass!.expectedOutTime,
                  inDate: widget.pass!.expectedInDate,
                  outDate: widget.pass!.expectedOutDate,
                  type: widget.pass!.type,
                  status: widget.pass!.status,
                )
              else
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text("No Currently Active Passes"),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}

class DeletePassDialog extends ConsumerStatefulWidget {
  const DeletePassDialog({required this.pass, super.key});
  final Pass? pass;

  @override
  ConsumerState<DeletePassDialog> createState() => _DeletePassDialogState();
}

class _DeletePassDialogState extends ConsumerState<DeletePassDialog> {
  TextEditingController confirmController = TextEditingController();
  late FToast toast;
  Future<void> deletePass() async {
    try {
      if (widget.pass != null) {
        // Call the function in the provider to delete the pass
        HapticFeedback.selectionClick();
        setState(() {
          isDeletePassLoading = true;
        });
        await ref
            .read(studentPassProvider.notifier)
            .deletePass(widget.pass!.passId);
        setState(() {
          isDeletePassLoading = false;
        });
        toast.removeQueuedCustomToasts();
        toast.showToast(
          child: ToastMsg(
              icondata: Icons.check_circle_outline_rounded,
              text: "Pass Deleted",
              bgColor: Theme.of(context).colorScheme.errorContainer),
        );
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    toast = FToast();
    toast.init(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text(
        "Delete pass?",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Type \"DELETE\" to confirm",
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (val) {
              setState(() {});
            },
            controller: confirmController,
            decoration: InputDecoration(
              // hintText: "DELETE",
              contentPadding: const EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          // style: TextButton.styleFrom(
          //   backgroundColor: colorScheme.errorContainer,
          //   foregroundColor: colorScheme.error,
          // ),
          onPressed: isDeletePassLoading
              ? null
              : confirmController.text.trim() != "DELETE"
                  ? null
                  : () async {
                      await deletePass();
                      Navigator.of(context).pop();
                    },
          child: isDeletePassLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: colorScheme.error,
                  ),
                )
              : const Text("Delete"),
        ),
      ],
    );
  }
}
