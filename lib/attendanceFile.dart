import 'dart:convert';
import 'dart:io';

import 'package:clockwisehq/timetable/activity.dart';
import 'package:path_provider/path_provider.dart';

class AttendanceFile {
  Future<void> saveAttendance(Map<Activity, bool> attendanceMap) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/attendance.json';
    final file = File(filePath);

    final jsonMap = <String, bool>{};
    attendanceMap.forEach((activity, attended) {
      final activityJson = jsonEncode(activity.toJson());
      jsonMap[activityJson] = attended;
    });

    await file.writeAsString(jsonEncode(jsonMap), mode: FileMode.append);
  }

  void clearFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/attendance.json';
      final empty = File(filePath).openWrite();
      empty.write("");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<Activity, bool>> readAttendance() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/attendance.json';
    final file = File(filePath);

    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) {
        final jsonMap = jsonDecode(content) as Map<String, dynamic>;
        final attendanceMap = <Activity, bool>{};

        jsonMap.forEach((jsonKey, attended) {
          final activityJson = jsonDecode(jsonKey) as Map<String, dynamic>;
          final activity = Activity.fromJson(activityJson);
          attendanceMap[activity] = attended as bool;
        });

        return attendanceMap;
      }
    }

    return {};
  }
}
