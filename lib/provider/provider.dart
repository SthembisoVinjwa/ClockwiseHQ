import 'package:flutter/foundation.dart';

import '../file.dart';
import '../timetable/activity.dart';

class MainProvider with ChangeNotifier {
  List<Activity> _activityList = [];
  bool _darkMode = true;
  Map<Activity, bool> _attendanceMap = {};

  List<Activity> get activityList => _activityList;
  bool get isDarkMode => _darkMode;
  Map<Activity, bool> get attendance => _attendanceMap;

  void updateActivityList(List<Activity> newActivityList) {
    _activityList = newActivityList;
    notifyListeners();
  }

  void updateAttendanceMap(Map<Activity, bool> attendanceList) {
    _attendanceMap = attendanceList;
    notifyListeners();
  }

  void updateMode(bool mode) {
    _darkMode = mode;
    notifyListeners();
  }
}
