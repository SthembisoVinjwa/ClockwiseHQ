import 'dart:convert';
import 'dart:io';
import 'package:clockwisehq/timetable/activity.dart';
import 'package:flutter/material.dart';
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
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/activities.json';
      //final empty = File(filePath).openWrite();
      //empty.write("");
      final File jsonFile = File(filePath);
      final String jsonData = await jsonFile.readAsString();
      String withSB = jsonData.replaceFirst('(', '[');
      withSB = withSB.replaceFirst(')', ']');
      final List<dynamic> jsonList = json.decode(withSB);
      final List<Activity> activities = jsonList.map((e) =>
          Activity.fromJson(e)).toList();
      return activities;
    } catch (e) {
      List<Activity> none = [Activity('none', 'none', 'none', [const TimeOfDay(hour: 0, minute: 0)], ['mon'], 'class', DateTime.utc(2010, 10, 16), DateTime.utc(2011, 10, 16))];
      return none;
    }
  }
}