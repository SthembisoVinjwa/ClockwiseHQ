import 'package:flutter/material.dart';

class Activity {
  late String title;
  String location = '';
  String instructor = '';
  late List<TimeOfDay> times;
  late List<String> daysOfWeek;
  late DateTime startDate;
  late DateTime endDate;

  Activity(this.title, this.location, this.instructor, this.times, this.daysOfWeek, this.startDate, this.endDate);
}