import 'dart:convert';
import 'dart:io';
import 'package:clockwisehq/timetable/activity2.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TimetableFile2 {
  Future<void> saveActivities(List<Activity2> activities) async {
    // Get the application directory
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/activities.json';

    try {
      // Open the file for writing
      final file = File(filePath).openWrite();

      // Write the activities to the file
      file.write(activities.map((e) => jsonEncode(e.toJson())));

      // Close the file
      await file.close();
    } catch (e) {
      // Handle errors
      print('Error saving activities: $e');
    }
  }

  void clearFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/activities.json';
      final empty = File(filePath).openWrite();
      empty.write("");
    } catch(e) {
      print(e.toString());
    }
  }

  Future<List<Activity2>> readActivitiesFromJsonFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/activities.json';
      final File jsonFile = File(filePath);
      final String jsonData = await jsonFile.readAsString();
      String withSB = jsonData.replaceFirst('(', '[');
      withSB = withSB.replaceFirst(')', ']');
      final List<dynamic> jsonList = json.decode(withSB);
      final List<Activity2> activities = jsonList
          .map((e) => Activity2.fromJson(e as Map<String, dynamic>))
          .toList();
      return activities;
    } catch (e) {
      final List<Activity2> none = [
        Activity2(
          'none',
          'none',
          'none',
          {'mon': [TimeOfDay(hour: 0, minute: 0)]},
          'class',
          DateTime.utc(2010, 10, 16),
          DateTime.utc(2011, 10, 16),
        )
      ];
      return none;
    }
  }
}

