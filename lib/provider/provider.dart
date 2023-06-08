import 'package:clockwisehq/attendance/entry.dart';
import 'package:flutter/foundation.dart';

import '../file.dart';
import '../timetable/activity.dart';

class MainProvider with ChangeNotifier {
  List<Activity> _activityList = [];
  bool _darkMode = true;
  List<AttendanceEntry> _attendanceEntries = [];

  List<Activity> get activityList => _activityList;
  bool get isDarkMode => _darkMode;
  List<AttendanceEntry> get attendance => _attendanceEntries;

  void updateActivityList(List<Activity> newActivityList) {
    _activityList = newActivityList;
    notifyListeners();
  }

  void updateAttendanceEntries(List<AttendanceEntry> attendanceEntries) {
    _attendanceEntries = attendanceEntries;
    notifyListeners();
  }

  void updateMode(bool mode) {
    _darkMode = mode;
    notifyListeners();
  }
}
