import 'package:flutter/foundation.dart';

import '../file2.dart';
import '../timetable/activity2.dart';

class MainProvider with ChangeNotifier {
  List<Activity2> _activityList = [];
  bool _darkMode = false;

  List<Activity2> get activityList => _activityList;
  bool get isDarkMode => _darkMode;

  void updateActivityList(List<Activity2> newActivityList) {
    _activityList = newActivityList;
    notifyListeners();
  }

  void updateMode(bool mode) {
    _darkMode = mode;
    notifyListeners();
  }
}
