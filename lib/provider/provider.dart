import 'package:flutter/foundation.dart';

import '../file_handling.dart';
import '../timetable/activity.dart';

class MainProvider with ChangeNotifier {
  List<Activity> _activityList = [];
  bool _darkMode = false;

  List<Activity> get activityList => _activityList;
  bool get isDarkMode => _darkMode;

  void updateActivityList(List<Activity> newActivityList) {
    _activityList = newActivityList;
    notifyListeners();
  }

  void updateMode(bool mode) {
    _darkMode = mode;
    notifyListeners();
  }
}
