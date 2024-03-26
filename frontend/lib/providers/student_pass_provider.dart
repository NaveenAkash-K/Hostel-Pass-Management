import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentPassNotifier extends StateNotifier<List<Pass>> {
  StudentPassNotifier() : super([]);
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  Future<void> loadPassFromDB() async {
    if (prefs!.getString("jwtToken") == null) {
      return;
    }

    try {
      var response = await http.get(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/getPass"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      List<Pass> passes = [];
      for (var pass in responseData["data"]) {
        passes.add(pass["status"] == "Used"
            ? Pass(
                passId: pass["passId"],
                studentId: pass["studentId"],
                gender: pass['gender'],
                qrId: pass["qrId"],
                status: pass["status"],
                destination: pass["destination"],
                type: pass["type"],
                isActive: pass["isActive"],
                reason: pass["reason"],
                expectedInDate:
                    "${DateTime.parse(pass['expectedIn']).day}-${DateTime.parse(pass['expectedIn']).month}-${DateTime.parse(pass['expectedIn']).year}",
                expectedInTime:
                    "${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedIn'])).hour}:${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedIn'])).minute} ${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedIn'])).period.name.toUpperCase()}",
                expectedOutDate:
                    "${DateTime.parse(pass['expectedOut']).day}-${DateTime.parse(pass['expectedOut']).month}-${DateTime.parse(pass['expectedOut']).year}",
                expectedOutTime:
                    "${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedOut'])).hour}:${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedOut'])).minute} ${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedOut'])).period.name.toUpperCase()}",
                actualInDate:
                    "${DateTime.parse(pass['entryScanAt']).day}-${DateTime.parse(pass['entryScanAt']).month}-${DateTime.parse(pass['entryScanAt']).year}",
                actualInTime:
                    "${TimeOfDay.fromDateTime(DateTime.parse(pass['entryScanAt'])).hour}:${TimeOfDay.fromDateTime(DateTime.parse(pass['entryScanAt'])).minute} ${TimeOfDay.fromDateTime(DateTime.parse(pass['entryScanAt'])).period.name.toUpperCase()}",
                actualOutDate:
                    "${DateTime.parse(pass['exitScanAt']).day}-${DateTime.parse(pass['exitScanAt']).month}-${DateTime.parse(pass['exitScanAt']).year}",
                actualOutTime:
                    "${TimeOfDay.fromDateTime(DateTime.parse(pass['exitScanAt'])).hour}:${TimeOfDay.fromDateTime(DateTime.parse(pass['exitScanAt'])).minute} ${TimeOfDay.fromDateTime(DateTime.parse(pass['exitScanAt'])).period.name.toUpperCase()}",
                showQr: DateTime.parse(pass['expectedOut'])
                        .add(const Duration(minutes: 60))
                        .isAfter(DateTime.now()) &&
                    DateTime.parse(pass['expectedOut'])
                        .subtract(const Duration(minutes: 60))
                        .isBefore(DateTime.now()),
                isSpecialPass: pass["isSpecialPass"],
                isLate: pass["isLate"],
              )
            : Pass(
                passId: pass["passId"],
                studentId: pass["studentId"],
                gender: pass['gender'],
                qrId: pass["qrId"],
                status: pass["status"],
                destination: pass["destination"],
                type: pass["type"],
                isActive: pass["isActive"],
                reason: pass["reason"],
                expectedInDate:
                    "${DateTime.parse(pass['expectedIn']).day}-${DateTime.parse(pass['expectedIn']).month}-${DateTime.parse(pass['expectedIn']).year}",
                expectedInTime:
                    "${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedIn'])).hour}:${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedIn'])).minute} ${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedIn'])).period.name.toUpperCase()}",
                expectedOutDate:
                    "${DateTime.parse(pass['expectedOut']).day}-${DateTime.parse(pass['expectedOut']).month}-${DateTime.parse(pass['expectedOut']).year}",
                expectedOutTime:
                    "${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedOut'])).hour}:${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedOut'])).minute} ${TimeOfDay.fromDateTime(DateTime.parse(pass['expectedOut'])).period.name.toUpperCase()}",
                showQr: pass["status"] == "In use"
                    ? true
                    : DateTime.parse(pass['expectedOut'])
                            .add(const Duration(minutes: 60))
                            .isAfter(DateTime.now()) &&
                        DateTime.parse(pass['expectedOut'])
                            .subtract(const Duration(minutes: 60))
                            .isBefore(DateTime.now()),
                isSpecialPass: pass["isSpecialPass"],
              ));
      }
      state = passes;
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<void> addPass({
    required String destination,
    required String type,
    required String reason,
    required DateTime inDate,
    required TimeOfDay inTime,
    required DateTime outDate,
    required TimeOfDay outTime,
    required bool isSpecialPass,
  }) async {
    dynamic responseData;
    try {
      var response = await http.post(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/newPass"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
        body: jsonEncode(
          {
            "studentId": prefs!.getString("studentId"),
            "destination": destination,
            "type": type,
            "reason": reason,
            "outDateTime": DateTime.parse(
                    "${outDate.year}-${outDate.month.toString().padLeft(2, '0')}-${outDate.day.toString().padLeft(2, '0')} ${outTime.hour.toString().padLeft(2, '0')}:${outTime.minute.toString().padLeft(2, '0')}:00")
                .toIso8601String(),
            "inDateTime": DateTime.parse(
                    "${inDate.year}-${inDate.month.toString().padLeft(2, '0')}-${inDate.day.toString().padLeft(2, '0')} ${inTime.hour.toString().padLeft(2, '0')}:${inTime.minute.toString().padLeft(2, '0')}:00")
                .toIso8601String(),
            "isSpecialPass": isSpecialPass,
          },
        ),
      );
      responseData = jsonDecode(response.body);

      state = [
        ...state,
        Pass(
          passId: responseData["passId"],
          studentId: prefs!.getString("studentId")!,
          qrId: responseData["qrId"],
          status: responseData["status"],
          destination: responseData["destination"],
          type: responseData["type"],
          gender: responseData['gender'],
          isActive: responseData["isActive"],
          reason: responseData["reason"],
          expectedInDate: "${inDate.day}-${inDate.month}-${inDate.year}",
          expectedInTime:
              "${inTime.hourOfPeriod}:${inTime.minute} ${inTime.period.name}",
          expectedOutDate: "${outDate.day}-${outDate.month}-${outDate.year}",
          expectedOutTime:
              "${outTime.hour}:${outTime.minute} ${outTime.period.name}",
          isSpecialPass: responseData["isSpecialPass"],
        )
      ];
    } catch (e) {
      throw responseData["message"];
    }
  }

  Future<void> deletePass(String passId) async {
    try {
      await http.delete(
          Uri.parse(
              "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/deletePass/$passId"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": prefs!.getString("jwtToken")!
          });
      state = state.where((pass) => pass.passId != passId).toList();
    } catch (err) {
      throw "Something went wrong";
    }
  }

  Pass? getActivePass() {
    final activePass = state.where((pass) => pass.isActive).toList();
    if (activePass.isEmpty) {
      return null;
    }
    return activePass[0];
  }
}

final studentPassProvider =
    StateNotifierProvider<StudentPassNotifier, List<Pass>>(
  (ref) => StudentPassNotifier(),
);
