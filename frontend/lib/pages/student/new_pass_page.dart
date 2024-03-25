import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/providers/student_pass_provider.dart';

class NewPassPage extends ConsumerStatefulWidget {
  const NewPassPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NewPassPageState();
  }
}

class _NewPassPageState extends ConsumerState<NewPassPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  DateTime? inDate;
  TimeOfDay? inTime;
  DateTime? outDate;
  TimeOfDay? outTime;
  String? passType;
  bool isSpecialPass = false;
  bool isSubmitLoading = false;

  bool isTimeOfDayBefore(TimeOfDay first, TimeOfDay second) {
    if (first.hour < second.hour) {
      return true;
    } else if (first.hour == second.hour) {
      return first.minute < second.minute;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Pass"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Destination"),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: _destinationController,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    hintText: "Enter Destination",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the destination';
                    }
                    return null;
                  },
                ),
                const Text(
                  "Select Pass Type",
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              passType = 'GatePass';
                              if (inDate != null) {
                                inDate = null;
                              }
                              if (outDate != null) {
                                inDate = outDate;
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: passType == 'GatePass'
                                ? const Color.fromARGB(255, 1, 46, 76)
                                : Colors.grey[300],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (passType == 'GatePass')
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Color.fromARGB(255, 1, 46, 76),
                                      size: 16,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  'GatePass',
                                  style: TextStyle(
                                    color: passType == 'GatePass'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              passType = 'StayPass';
                              inDate = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: passType == 'StayPass'
                                  ? const Color.fromARGB(255, 1, 46, 76)
                                  : Colors.grey[300],
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              )),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (passType == 'StayPass')
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Color.fromARGB(255, 1, 46, 76),
                                      size: 16,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  'StayPass',
                                  style: TextStyle(
                                    color: passType == 'StayPass'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isSpecialPass = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: !isSpecialPass
                                ? const Color.fromARGB(255, 1, 46, 76)
                                : Colors.grey[300],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!isSpecialPass)
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Color.fromARGB(255, 1, 46, 76),
                                    size: 16,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Text(
                                'Normal Pass',
                                style: TextStyle(
                                  color: !isSpecialPass
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isSpecialPass = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isSpecialPass
                                  ? const Color.fromARGB(255, 1, 46, 76)
                                  : Colors.grey[300],
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isSpecialPass)
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Color.fromARGB(255, 1, 46, 76),
                                    size: 16,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Text(
                                'Special Pass',
                                style: TextStyle(
                                  color: isSpecialPass
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Leaving Time"),
                const SizedBox(height: 8),
                _buildDateTimePicker("Out", outDate, outTime),
                const SizedBox(height: 20),
                const Text("Returning Time"),
                const SizedBox(height: 8),
                _buildDateTimePicker("In", inDate, inTime),
                const SizedBox(height: 20),
                const Text("Reason"),
                const SizedBox(height: 4),
                TextField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Reason here...',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  onChanged: (text) {},
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: isSubmitLoading ? null : _submitForm,
                  child: Ink(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 1, 46, 76),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isSubmitLoading
                        ? Column(
                            children: [
                              CircularProgressIndicator(
                                color: colorScheme.background,
                              ),
                            ],
                          )
                        : Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime? date) {
    String buttonText = date != null ? _formatDate(date) : '$label Date';

    return TextButton.icon(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return Colors.transparent;
          },
        ),
      ),
      onPressed: label == "In" && passType == "GatePass"
          ? null
          : () async {
              if (passType == null) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select pass type first"),
                  ),
                );
                return;
              }
              DateTime? pickedDate;
              if (label == "Out") {
                pickedDate = await showDatePicker(
                  context: context,
                  initialDate: outDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2026),
                );
                inDate = null;
              } else {
                if (outDate == null) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select leaving date first"),
                    ),
                  );
                  return;
                }
                if (passType == "StayPass") {
                  pickedDate = await showDatePicker(
                    context: context,
                    initialDate: inDate ?? outDate!.add(const Duration(days: 1)),
                    firstDate: outDate!.add(const Duration(days: 1)),
                    lastDate: DateTime(2026),
                  );
                } else {
                  pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2026),
                  );
                }
              }

              if (pickedDate != null) {
                setState(() {
                  if (label == "Out") {
                    outDate = pickedDate;
                    if (passType == "GatePass") {
                      inDate = pickedDate;
                    }
                  } else {
                    inDate = pickedDate;
                    if (passType == "GatePass") {
                      outDate = pickedDate;
                    }
                  }
                });
              }
            },
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the icon and text horizontally
        children: [
          const Icon(
            Icons.calendar_month_outlined,
            color: Colors.black, // Set icon color
          ),
          const SizedBox(width: 8), // Add spacing between text and icon
          Text(
            buttonText,
            style: const TextStyle(color: Colors.black), // Set text color
          ),
        ],
      ),
      label: const SizedBox.shrink(), // No label text
    );
  }

  Widget _buildTimeButton(String label, TimeOfDay? time) {
    String buttonText = time != null ? _formatTime(time) : '$label Time';

    return TextButton.icon(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return Colors.transparent;
          },
        ),
      ),
      onPressed: () async {
        TimeOfDay? pickedTime;
        if (label == "In") {
          pickedTime = await showTimePicker(
            context: context,
            initialTime: inTime ?? TimeOfDay.now(),
          );
        } else {
          pickedTime = await showTimePicker(
            context: context,
            initialTime: outTime ?? TimeOfDay.now(),
          );
        }
        if (pickedTime != null) {
          setState(() {
            if (label == "In") {
              inTime = pickedTime;
            } else {
              outTime = pickedTime;
            }
          });
        }
      },
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the icon and text horizontally
        children: [
          const Icon(
            Icons.watch_later_outlined,
            color: Colors.black, // Set icon color
          ),
          const SizedBox(width: 8), // Add spacing between text and icon
          Text(
            buttonText,
            style: const TextStyle(color: Colors.black), // Set text color
          ),
        ],
      ),
      label: const SizedBox.shrink(), // No label text
    );
  }

  Widget _buildDateTimePicker(String label, DateTime? date, TimeOfDay? time) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50, // Adjust height as needed
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // Add border
                      ),
                      child: _buildDateButton(label, date),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50, // Adjust height as needed
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // Add border
                      ),
                      child: _buildTimeButton(label, time),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _submitForm() async {
    HapticFeedback.selectionClick();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    print(passType);
    if (passType == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Select the Pass type")));
      return;
    }
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter the reason")));
      return;
    }
    if (inDate != null &&
        inTime != null &&
        outDate != null &&
        outTime != null) {
      if (passType == 'StayPass' && (inDate!.isBefore(outDate!))) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('In date should be after out date')));
        return;
      }
      if (passType == "GatePass" &&
          (inDate == outDate && isTimeOfDayBefore(inTime!, outTime!))) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('In time can\'t be after out time')));
        return;
      }
      if (passType == "StayPass" &&
          (inDate!.isBefore(outDate!) || inDate == outDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'In date can\'t be before or equal to out date in special pass'),
          ),
        );
        return;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select all date and time fields.'),
        ),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    try {
      setState(() {
        isSubmitLoading = true;
      });
      await ref.read(studentPassProvider.notifier).addPass(
            destination: _destinationController.text,
            inDate: inDate!,
            inTime: inTime!,
            outDate: outDate!,
            outTime: outTime!,
            reason: _reasonController.text,
            type: passType!,
            isSpecialPass: isSpecialPass,
          );
      setState(() {
        isSubmitLoading = false;
      });
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
    } catch (error) {
      setState(() {
        isSubmitLoading = false;
      });
      if (!mounted) {
        return;
      }
      // Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 1));

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    } finally {
      HapticFeedback.heavyImpact();
    }
  }
}
