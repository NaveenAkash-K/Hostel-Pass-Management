import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WardenPassRequestsNotifier extends StateNotifier<List<PassRequest>> {
  WardenPassRequestsNotifier() : super([]);
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  Future<void> getSpecailPassesFromDB() async {
    if (prefs!.getString("jwtToken") == null) {
      return;
    }
    try {
      var response = await http.get(
          Uri.parse(
              "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/getPass"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": prefs!.getString("jwtToken")!
          });
      var responseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        throw responseData["message"];
      }
      List<PassRequest> specialPasses = [];
      for (var pass in responseData) {
        specialPasses.add(PassRequest(
            passId: pass["passId"],
            qrId: pass["qrId"],
            studentId: pass["studentId"],
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
            isSpecialPass: pass["isSpecialPass"],
            studentName: pass["studentName"],
            dept: pass["dept"],
            fatherPhNo: pass["fatherPhNo"],
            motherPhNo: pass["motherPhNo"],
            phNo: pass["phNo"],
            roomNo: pass["roomNo"],
            year: pass["year"],
            blockNo: pass["blockNo"],
            approvedBy: pass["approvedBy"],
            confirmedWith: pass["confirmedWith"]));
      }
      state = specialPasses;
    } catch (err) {
      throw "Something went wrong";
    }
  }

  Future<void> approvePassRequest(String passId, String confirmedWith) async {
    if (prefs?.getString == null) {
      return;
    }
    try {
      var response = await http.post(
          Uri.parse(
              "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/approvePass"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": prefs!.getString("jwtToken")!,
          },
          body: jsonEncode({
            "passId": passId,
            "wardenName": prefs!.getString("username"),
            "confirmedWith": confirmedWith
          }));
      var reponseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        return reponseData["message"];
      }
      int passIndex = state.indexWhere((pass) => pass.passId == passId);
      if (passIndex != -1) {
        PassRequest updatedPass = PassRequest(
          passId: state[passIndex].passId,
          qrId: state[passIndex].qrId,
          studentId: state[passIndex].studentId,
          status: 'Approved',
          approvedBy: prefs!.getString("username")!,
          confirmedWith: confirmedWith,
          destination: state[passIndex].destination,
          type: state[passIndex].type,
          isActive: state[passIndex].isActive,
          reason: state[passIndex].reason,
          expectedInDate: state[passIndex].expectedInDate,
          expectedInTime: state[passIndex].expectedInTime,
          expectedOutDate: state[passIndex].expectedOutDate,
          expectedOutTime: state[passIndex].expectedOutTime,
          isSpecialPass: state[passIndex].isSpecialPass,
          studentName: state[passIndex].studentName,
          dept: state[passIndex].dept,
          fatherPhNo: state[passIndex].fatherPhNo,
          motherPhNo: state[passIndex].motherPhNo,
          phNo: state[passIndex].phNo,
          roomNo: state[passIndex].roomNo,
          blockNo: state[passIndex].blockNo,
          year: state[passIndex].year,
        );
        state[passIndex] = updatedPass;
      }
      state = [...state];
    } catch (err) {
      throw "Something went wrong";
    }
  }

  Future<void> rejectPassRequest(String passId) async {
    if (prefs?.getString == null) {
      return;
    }
    try {
      var response = await http.post(
          Uri.parse(
              "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/rejectPass"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": prefs!.getString("jwtToken")!,
          },
          body: jsonEncode({
            "passId": passId,
            "wardenName": prefs!.getString("username"),
          }));
      var reponseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        return reponseData["message"];
      }
      int passIndex = state.indexWhere((pass) => pass.passId == passId);
      if (passIndex != -1) {
        PassRequest updatedPass = PassRequest(
          passId: state[passIndex].passId,
          qrId: state[passIndex].qrId,
          studentId: state[passIndex].studentId,
          status: 'Rejected',
          approvedBy: prefs!.getString("username")!,
          confirmedWith: 'None',
          destination: state[passIndex].destination,
          type: state[passIndex].type,
          isActive: false,
          reason: state[passIndex].reason,
          expectedInDate: state[passIndex].expectedInDate,
          expectedInTime: state[passIndex].expectedInTime,
          expectedOutDate: state[passIndex].expectedOutDate,
          expectedOutTime: state[passIndex].expectedOutTime,
          isSpecialPass: state[passIndex].isSpecialPass,
          studentName: state[passIndex].studentName,
          dept: state[passIndex].dept,
          fatherPhNo: state[passIndex].fatherPhNo,
          motherPhNo: state[passIndex].motherPhNo,
          phNo: state[passIndex].phNo,
          roomNo: state[passIndex].roomNo,
          blockNo: state[passIndex].blockNo,
          year: state[passIndex].year,
        );
        state[passIndex] = updatedPass;
      }
      state = [...state];
    } catch (err) {
      throw "Something went wrong";
    }
  }
}

final specialPassProvider =
    StateNotifierProvider<WardenPassRequestsNotifier, List<PassRequest>>(
        (ref) => WardenPassRequestsNotifier());
