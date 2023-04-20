import 'dart:convert';
import 'package:flutter/material.dart';

class Activity {
  late String title;
  String location = '';
  String instructor = '';
  late List<TimeOfDay> times;
  late List<String> daysOfWeek;
  late DateTime startDate;
  late DateTime endDate;

  Activity(this.title, this.location, this.instructor, this.times,
      this.daysOfWeek, this.startDate, this.endDate);

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      json['title'],
      json['location'],
      json['instructor'],
      List<TimeOfDay>.from(json['times'].map((time) {
        final timeParts = time.split(':');
        return TimeOfDay(
            hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      })),
      List<String>.from(json['daysOfWeek']),
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
    );
  }
}

class ActivityEncoder extends Converter<Activity, String> {
  final TimeOfDayFormat _timeOfDayFormatter = TimeOfDayFormat();

  @override
  String convert(Activity activity) {
    final Map<String, dynamic> json = <String, dynamic>{
      'title': activity.title,
      'location': activity.location,
      'instructor': activity.instructor,
      'times': activity.times
          .map((time) => _timeOfDayFormatter.format(time))
          .toList(),
      'daysOfWeek': activity.daysOfWeek,
      'startDate': activity.startDate.toIso8601String(),
      'endDate': activity.endDate.toIso8601String(),
    };
    return jsonEncode(json);
  }
}

class TimeOfDayFormat {
  String format(TimeOfDay timeOfDay) {
    String hour = timeOfDay.hour.toString();
    String minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

void main() {
  final List<Activity> activities = [
    Activity(
      'Maths 244',
      'Jan Mouton',
      'Dr. Gray',
      [const TimeOfDay(hour: 10, minute: 0)],
      ['Mon', 'Wed', 'Fri'],
      DateTime(2023, 4, 1),
      DateTime(2023, 4, 30),
    ),
    Activity(
      'Com Sci 344',
      'Enginerring building room A303',
      'Willem Bester',
      [
        const TimeOfDay(hour: 9, minute: 0),
        const TimeOfDay(hour: 10, minute: 0)
      ],
      ['Tue', 'Thu'],
      DateTime(2023, 4, 1),
      DateTime(2023, 4, 30),
    ),
    Activity(
      'GIT 312',
      'Geology Building',
      'Dr. Stuurman',
      [
        const TimeOfDay(hour: 19, minute: 0),
        const TimeOfDay(hour: 20, minute: 0)
      ],
      ['Mon', 'Wed'],
      DateTime(2023, 4, 1),
      DateTime(2023, 4, 30),
    ),
  ];

  final json = activities.map((e) => ActivityEncoder().convert(e)).toList();
  final List<Activity> myActivities =
      json.map((e) => Activity.fromJson(jsonDecode(e))).toList();

  print(myActivities);
}
