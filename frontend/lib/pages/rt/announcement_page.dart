import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_pass_management/models/announcement_model.dart';
import 'package:hostel_pass_management/providers/rt_announcement_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/toast.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementPage extends ConsumerStatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AnnouncementPage> createState() {
    return _AnnouncementPageState();
  }
}

class _AnnouncementPageState extends ConsumerState<AnnouncementPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = false;
  List<Announcement>? announcements;
  late FToast toast;

  @override
  Widget build(BuildContext context) {
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    announcements = ref.watch(rtAnnouncementNotifier);
    toast = FToast();
    toast.init(context);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    if (prefs!.getBool('isBoysHostelRt')!) {
      announcements = ref
          .watch(rtAnnouncementNotifier)
          .where((announcement) => announcement.isBoysHostelRt)
          .toList();
    } else {
      announcements = ref
          .watch(rtAnnouncementNotifier)
          .where((announcement) => !announcement.isBoysHostelRt)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements"),
        centerTitle: true,
      ),
      drawer: const RtDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: "Message",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the message';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: isLoading || announcements!.length >= 2
                        ? null
                        : _submitForm,
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
                      child: isLoading
                          ? Column(
                              children: [
                                CircularProgressIndicator(
                                  color: colorScheme.background,
                                ),
                              ],
                            )
                          : Text(
                              "Make Announcement",
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
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Current Announcement(s)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: announcements!.length,
                itemBuilder: (context, index) {
                  final announcement = announcements![index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          announcement.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(announcement.message),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await ref
                                .read(rtAnnouncementNotifier.notifier)
                                .deleteAnnouncement(
                                  announcementId: announcement.announcementId,
                                );
                            toast.removeQueuedCustomToasts();
                            toast.showToast(
                                child: ToastMsg(
                                    text: "Announcement Deleted",
                                    bgColor: Theme.of(context)
                                        .colorScheme
                                        .errorContainer));

                            setState(() {
                              isLoading = false;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String title = _titleController.text;
    final String message = _messageController.text;

    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 70));

    setState(() {
      isLoading = true;
    });

    try {
      await ref.read(rtAnnouncementNotifier.notifier).makeAnnouncement(
            title: title,
            message: message,
          );
      if (!mounted) {
        return;
      }
      _titleController.clear();
      _messageController.clear();
      toast.removeQueuedCustomToasts();
      toast.showToast(
        child: const ToastMsg(
          text: "Announcement Made",
          bgColor: Colors.greenAccent,
          icondata: Icons.check_rounded,
        ),
        gravity: ToastGravity.BOTTOM,
      );
      // Fluttertoast.showToast(
      //     msg: "Annoucement made",
      //     fontSize: 18,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: Colors.black,
      //     textColor: Colors.white);
      // ScaffoldMessenger.of(context).clearSnackBars();
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Announcement Made")));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
