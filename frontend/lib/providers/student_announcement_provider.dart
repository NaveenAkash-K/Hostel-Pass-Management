import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/announcement_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentAnnouncementNotifier extends StateNotifier<List<Announcement>> {
  StudentAnnouncementNotifier() : super([]);
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  Future<void> loadAnnouncementsFromDB() async {
    if (prefs?.getString("jwtToken") == null) {
      return;
    }
    try {
      var response = await http.get(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/student/block/getAnnouncement/${prefs!.getInt('blockNo')}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );
      var responseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        throw responseData["message"];
      }
      List<Announcement> announcements = [];
      for (var announcement in responseData) {
        announcements.add(Announcement(
            announcementId: announcement["_id"],
            rtId: announcement["rtId"],
            title: announcement["title"],
            isRead: announcement['isRead'],
            isBoysHostelRt: announcement['isBoysHostelRt'],
            message: announcement["message"],
            blockNo: announcement["blockNo"]));
      }
      state = announcements;
    } catch (err) {
      throw "student announcement error";
    }
  }

  Future<void> markAnnouncementAsRead(String id) async {
    try {
      final response = await http.post(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/block/readAnnouncement"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
        body: jsonEncode({
          'id': id,
        }),
      );
      var responseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        return responseData["message"];
      }
      final index =
          state.indexWhere((announcement) => announcement.announcementId == id);
      if (index != -1) {
        Announcement updatedAnnoucement = Announcement(
            rtId: state[index].rtId,
            title: state[index].title,
            message: state[index].message,
            isBoysHostelRt: state[index].isBoysHostelRt,
            blockNo: state[index].blockNo,
            announcementId: state[index].announcementId,
            isRead: true);
        state[index] = updatedAnnoucement;
      }
      state = [...state];
    } catch (e) {
      throw 'Something went wrong';
    }
  }
}

final studentAnnouncementNotifier =
    StateNotifierProvider<StudentAnnouncementNotifier, List<Announcement>>(
  (ref) => StudentAnnouncementNotifier(),
);
