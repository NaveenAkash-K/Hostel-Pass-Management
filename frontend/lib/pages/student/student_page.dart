import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/announcement_model.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/pages/student/new_pass_page.dart';
import 'package:hostel_pass_management/providers/student_announcement_provider.dart';
import 'package:hostel_pass_management/providers/student_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/student/active_passes.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/student/pass_log.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentPage extends ConsumerStatefulWidget {
  const StudentPage({super.key});

  @override
  ConsumerState<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends ConsumerState<StudentPage> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  List<Announcement>? announcement;
  int unreadAnnouncements = 0;

  // Future<void> _markAnnouncementAsRead(String id) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/block/readAnnouncement"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": prefs!.getString("jwtToken")!,
  //       },
  //       body: jsonEncode({
  //         'id': id,
  //       }),
  //     );
  //     var responseData = jsonDecode(response.body);
  //     if (response.statusCode > 399) {
  //       return responseData["message"];
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     throw 'Something went wrong';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final List<Pass> passes = ref.watch(studentPassProvider);
    final List<Announcement> annoucement =
        ref.watch(studentAnnouncementNotifier);
    final List<Pass> usedPasses = passes
        .where(
          (pass) => pass.status == "Used",
        )
        .toList();
    final activePass = ref.read(studentPassProvider.notifier).getActivePass();
    if (prefs!.getString('gender') == 'M') {
      announcement = ref
          .read(studentAnnouncementNotifier)
          .where((announcement) => announcement.isBoysHostelRt)
          .toList();
      unreadAnnouncements = announcement!
          .where((announcement) => announcement.isRead == false)
          .toList()
          .length;
    } else {
      announcement = ref
          .read(studentAnnouncementNotifier)
          .where((announcement) => !announcement.isBoysHostelRt)
          .toList();
    }

    Widget _buildTickIcon(Announcement announcement) {
      if (!announcement.isRead) {
        return IconButton(
          icon: Icon(Icons.check, color: Colors.green),
          onPressed: () async {
            await ref
                .read(studentAnnouncementNotifier.notifier)
                .markAnnouncementAsRead(announcement.announcementId);
            Navigator.of(context).pop();
          },
        );
      } else {
        return SizedBox();
      }
    }

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {
                  showModalBottomSheet(
                    scrollControlDisabledMaxHeightRatio: 0.6,
                    context: context,
                    builder: (context) {
                      return announcement!.isNotEmpty
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Announcements",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (announcement != null &&
                                          announcement!.isNotEmpty) ...[
                                        ListTile(
                                          trailing: !annoucement[0].isRead
                                              ? _buildTickIcon(announcement![0])
                                              : null,
                                          // tileColor: announcement![0].isRead
                                          //     ? Colors.transparent
                                          //     : Colors.blue[50],
                                          title: Text(
                                            "1. ${announcement![0].title}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          subtitle: Text(
                                            announcement![0].message,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          onTap: () async {
                                            if (!announcement![0].isRead) {
                                              await ref
                                                  .read(
                                                      studentAnnouncementNotifier
                                                          .notifier)
                                                  .markAnnouncementAsRead(
                                                      announcement![0]
                                                          .announcementId);
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                        if (announcement!.length > 1) ...[
                                          const Divider(),
                                          ListTile(
                                            trailing: !announcement![1].isRead
                                                ? _buildTickIcon(
                                                    announcement![1])
                                                : null,
                                            // tileColor: announcement![1].isRead
                                            //     ? Colors.transparent
                                            //     : Colors.blue[50],
                                            title: Text(
                                              "2. ${announcement![1].title}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            subtitle: Text(
                                              announcement![1].message,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            onTap: () async {
                                              if (!announcement![1].isRead) {
                                                await ref
                                                    .read(
                                                        studentAnnouncementNotifier
                                                            .notifier)
                                                    .markAnnouncementAsRead(
                                                        announcement![1]
                                                            .announcementId);
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                          const Divider(),
                                        ],
                                      ] else ...[
                                        const Text(
                                          "No announcements",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: const Align(
                                alignment: Alignment.topLeft,
                                child: Center(
                                  child: Text("No announcements"),
                                ),
                              ),
                            ); // Return empty SizedBox if there's no announcement
                    },
                  );
                },
              ),
              if (unreadAnnouncements != 0)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadAnnouncements.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: Hero(
        tag: "newpass",
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
          child: InkWell(
            onTap: activePass == null
                ? () {
                    HapticFeedback.selectionClick();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewPassPage(),
                      ),
                    );
                  }
                : () {
                    HapticFeedback.selectionClick();
                    showModalBottomSheet(
                      scrollControlDisabledMaxHeightRatio: 0.65,
                      context: context,
                      builder: (context) {
                        return QrBottomSheet();
                      },
                    );
                  },
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              width: 130,
              height: 60,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      activePass == null ? Icons.add : Icons.qr_code_rounded,
                      size: 25,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    Text(activePass == null ? "New Pass" : "Show QR")
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      drawer: const StudentDrawer(),
      body: Column(
        children: [
          ActivePasses(
            pass: activePass,
          ),
          Expanded(
            child: PassLog(
              passlog: usedPasses,
            ),
          ),
        ],
      ),
    );
  }
}

class QrBottomSheet extends ConsumerStatefulWidget {
  QrBottomSheet({super.key});

  @override
  ConsumerState<QrBottomSheet> createState() => _QrBottomSheetState();
}

class _QrBottomSheetState extends ConsumerState<QrBottomSheet> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Pass activePass = ref.read(studentPassProvider.notifier).getActivePass()!;

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: colorScheme.background,
            ),
            child: Column(
              children: [
                Text(
                  "Scan QR at Entrance",
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.width * .85,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorScheme.primaryContainer,
                  ),
                  child: activePass.status == "Approved" ||
                          activePass.status == "In use"
                      ? activePass.showQr!
                          ? QrImageView(
                              data: activePass.qrId,
                              semanticsLabel: "skuf",
                            )
                          : const Center(
                              child: Text(
                                "QR will be generated 1hour before leaving time",
                                textAlign: TextAlign.center,
                              ),
                            )
                      : const Center(
                          child: Text("Pass not yet approved"),
                        ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "QR will be expired 1hour after specified leaving time",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
