import 'dart:convert';
import 'dart:io';
import 'package:clockwisehq/timetable/activity.dart';
import 'package:path_provider/path_provider.dart';

class TimetableFile {
  Future<void> saveActivities(List<Activity> activities) async {
    // Get the application directory
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/activities.json';

    try {
      // Open the file for writing
      final file = File(filePath).openWrite();

      // Write the activities to the file
      file.write(activities.map((e) => ActivityEncoder().convert(e)));

      // Close the file
      await file.close();

    } catch (e) {
      // Handle errors
      print('Error saving activities: $e');
    }
  }

  Future<List<Activity>> readActivitiesFromJsonFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/activities.json';
    final File jsonFile = File(filePath);
    final String jsonData = await jsonFile.readAsString();
    String withSB = jsonData.replaceFirst('(', '[');
    withSB = withSB.replaceFirst(')', ']');
    print(withSB);
    final List<dynamic> jsonList = json.decode(withSB);
    final List<Activity> activities = jsonList.map((e) => Activity.fromJson(e)).toList();
    return activities;
  }
}