import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BlockStudentsNotifier extends StateNotifier<List<BlockStudent>> {
  BlockStudentsNotifier() : super([]);
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  Future<void> loadBlockStudentsFromDB() async {
    if (prefs!.getString("jwtToken") == null) {
      return;
    }

    try {
      var response = await http.get(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/block/getStudents"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      List<BlockStudent> blockStudents = [];
      for (var student in responseData) {
        blockStudents.add(
          BlockStudent(
              studentId: student['studentId'],
              uid: student['uid'],
              username: student['username'],
              gender: student['gender'],
              email: student['email'],
              blockNo: student['blockNo'],
              dept: student['dept'],
              fatherName: student['fatherName'],
              fatherPhNo: student['fatherPhNo'],
              motherName: student['motherName'],
              motherPhNo: student['motherPhNo'],
              phNo: student['phNo'],
              regNo: student['regNo'],
              section: student['section'],
              year: student['year'],
              roomNo: student['roomNo']),
        );
      }
      state = blockStudents;
    } catch (e) {
      throw "Something went wrong";
    }
  }
}

final blockStudentProvider =
    StateNotifierProvider<BlockStudentsNotifier, List<BlockStudent>>(
  (ref) => BlockStudentsNotifier(),
);
