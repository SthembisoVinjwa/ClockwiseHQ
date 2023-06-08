import 'dart:convert';
import 'package:clockwisehq/file.dart';
import 'package:flutter/material.dart';

class Activity {
  String title = '';
  String location = '';
  String instructor = '';
  late Map<String, List<TimeOfDay>> timeOfDayMap;
  String type = '';
  late DateTime startDate;
  late DateTime endDate;

  Activity(this.title, this.location, this.instructor, this.timeOfDayMap,
      this.type, this.startDate, this.endDate);

  @override
  String toString() {
    return 'Activity2(title: $title, location: $location, instructor: $instructor, timeOfDayMap: $timeOfDayMap, type: $type, startDate: $startDate, endDate: $endDate)';
  }

  bool isDuplicateOf(Activity other) {
    return title == other.title && location == other.location && instructor == other.instructor;
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
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

void save(List<Activity> acts) async {
  await TimetableFile().saveActivities(acts);
}

Future<List<Activity>> read() async {
  List<Activity> acts = await TimetableFile().readActivitiesFromJsonFile();
  return acts;
}

void main() {
  final List<Activity> activities = [
    Activity(
      'class1',
      'home',
      'Mr',
      {'Mon': [TimeOfDay(hour: 7, minute: 30)]},
      'class',
      DateTime(2023, 4, 1),
      DateTime(2023, 8, 1),
    ),
    Activity(
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

  // Save and read the activities as before
  // save(activities);
  // read().then((value) => print(value.last.title));
}
