import 'package:flutter/foundation.dart';

import '../file_handling.dart';
import '../timetable/activity.dart';

class ActivityProvider with ChangeNotifier {
  List<Activity> _activityList = [];

  List<Activity> get activityList => _activityList;

  void updateActivityList(List<Activity> newActivityList) {
    _activityList = newActivityList;
    notifyListeners();
  }
}
