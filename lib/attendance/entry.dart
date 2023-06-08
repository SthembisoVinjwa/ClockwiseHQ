import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../timetable/activity.dart';

class AttendanceEntry {
  TimeOfDay time;
  DateTime date;
  Activity activity;
  bool attendance;

  AttendanceEntry({
    required this.time,
    required this.date,
    required this.activity,
    required this.attendance,
  });

  Map<String, dynamic> toJson() {
    return {
      'time': {'hour': time.hour, 'minute': time.minute},
      'date': date.toIso8601String(),
      'activity': activity.toJson(),
      'attendance': attendance,
    };
  }

  factory AttendanceEntry.fromJson(Map<String, dynamic> json) {
    return AttendanceEntry(
      time:
          TimeOfDay(hour: json['time']['hour'], minute: json['time']['minute']),
      date: DateTime.parse(json['date'] as String),
      activity: Activity.fromJson(json['activity'] as Map<String, dynamic>),
      attendance: json['attendance'] as bool,
    );
  }

  @override
  String toString() {
    return 'AttendanceEntry(time: $time, date: $date, activity: ${activity.title}, attendance: $attendance)';
  }
}

class AttendanceFile {
  Future<void> saveAttendance(List<AttendanceEntry> attendanceEntries) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/attendance.json';
    final file = File(filePath);

    var existingAttendanceEntries = await readAttendance();

    List<AttendanceEntry> notDuplicate = [];

    for (final ae in attendanceEntries) {
      bool isDuplicate = false;

      for (final ex in existingAttendanceEntries) {
        if (ex.date == ae.date && ex.time == ae.time && ex.activity.title == ae.activity.title) {
          isDuplicate = true;
          break;
        }
      }

      if (!isDuplicate) {
        notDuplicate.add(ae);
      }
    }

    final updatedAttendanceEntries = [...existingAttendanceEntries, ...notDuplicate];

    final jsonString = jsonEncode(updatedAttendanceEntries.map((entry) => entry.toJson()).toList());

    await file.writeAsString(jsonString, mode: FileMode.writeOnly);
  }

  void clear() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/attendance.json';
    final empty = File(filePath).openWrite();
    empty.write("");
  }

  Future<List<AttendanceEntry>> readAttendance() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/attendance.json';
    final file = File(filePath);

    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) {
        final jsonList = jsonDecode(content) as List<dynamic>;
        final attendanceEntries =
            jsonList.map((json) => AttendanceEntry.fromJson(json)).toList();
        return attendanceEntries;
      }
    }

    return [];
  }
}
