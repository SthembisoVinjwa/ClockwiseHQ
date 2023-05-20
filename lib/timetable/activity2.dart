import 'dart:convert';
import 'package:clockwisehq/file2.dart';
import 'package:flutter/material.dart';

import '../file_handling.dart';

class Activity2 {
  late String title;
  String location = '';
  String instructor = '';
  late Map<String, List<TimeOfDay>> timeOfDayMap;
  late String type;
  late DateTime startDate;
  late DateTime endDate;

  Activity2(this.title, this.location, this.instructor, this.timeOfDayMap,
      this.type, this.startDate, this.endDate);

  @override
  String toString() {
    return 'Activity2(title: $title, location: $location, instructor: $instructor, timeOfDayMap: $timeOfDayMap, type: $type, startDate: $startDate, endDate: $endDate)';
  }

  factory Activity2.fromJson(Map<String, dynamic> json) {
    return Activity2(
      json['title'],
      json['location'],
      json['instructor'],
      Map<String, List<TimeOfDay>>.from(json['timeOfDayMap'].map((key, value) {
        return MapEntry(
            key,
            (value as List<dynamic>).map((time) {
              final timeParts = time.split(':');
              return TimeOfDay(
                hour: int.parse(timeParts[0]),
                minute: int.parse(timeParts[1]),
              );
            }).toList());
      })),
      json['type'],
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': location,
      'instructor': instructor,
      'timeOfDayMap': timeOfDayMap.map((key, value) {
        return MapEntry(key, value.map(_formatTimeOfDay).toList());
      }),
      'type': type,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString();
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

void save(List<Activity2> acts) async {
  await TimetableFile2().saveActivities(acts);
}

Future<List<Activity2>> read() async {
  List<Activity2> acts = await TimetableFile2().readActivitiesFromJsonFile();
  return acts;
}

void main() {
  final List<Activity2> activities = [
    Activity2(
      'class1',
      'home',
      'Mr',
      {'Mon': [TimeOfDay(hour: 7, minute: 30)]},
      'class',
      DateTime(2023, 4, 1),
      DateTime(2023, 8, 1),
    ),
    Activity2(
      'class1',
      'home',
      'Mr',
      {
        'Mon': [TimeOfDay(hour: 7, minute: 30)],
        'Wed': [TimeOfDay(hour: 10, minute: 30)]
      },
      'class',
      DateTime(2023, 4, 1),
      DateTime(2023, 8, 1),
    ),
  ];

  //save(activities);

  //read().then((value) => print(value.last.title));
}
