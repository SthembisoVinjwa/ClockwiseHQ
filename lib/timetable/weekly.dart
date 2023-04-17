import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'activity.dart';

class WeekTimetable extends StatefulWidget {
  const WeekTimetable({Key? key}) : super(key: key);

  @override
  State<WeekTimetable> createState() => _WeekTimetableState();
}

class _WeekTimetableState extends State<WeekTimetable> {
  final List<Activity> activities = [
    Activity(
      'Yoga class',
      'Yoga studio',
      'Jane Doe',
      [TimeOfDay(hour: 10, minute: 0)],
      ['Mon', 'Wed', 'Fri'],
      DateTime(2023, 4, 1),
      DateTime(2023, 4, 30),
    ),
    Activity(
      'Pilates class',
      'Fitness center',
      'John Smith',
      [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 10, minute: 0)],
      ['Tue', 'Thu'],
      DateTime(2023, 4, 1),
      DateTime(2023, 4, 30),
    ),
    Activity(
      'Dance class',
      'Dance studio',
      'Emily Brown',
      [TimeOfDay(hour: 19, minute: 0), TimeOfDay(hour: 20, minute: 0)],
      ['Mon', 'Wed'],
      DateTime(2023, 4, 1),
      DateTime(2023, 4, 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: buildDataTable(),
      ),
    );
  }

  Widget buildDataTable() {
    final now = DateTime.now();
    final activeActivities = activities.where((activity) =>
        now.isAfter(activity.startDate) && now.isBefore(activity.endDate));

    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final timesOfDay = [
      TimeOfDay(hour: 7, minute: 0),
      TimeOfDay(hour: 8, minute: 0),
      TimeOfDay(hour: 9, minute: 0),
      TimeOfDay(hour: 10, minute: 0),
      TimeOfDay(hour: 11, minute: 0),
      TimeOfDay(hour: 12, minute: 0),
      TimeOfDay(hour: 13, minute: 0),
      TimeOfDay(hour: 14, minute: 0),
      TimeOfDay(hour: 15, minute: 0),
      TimeOfDay(hour: 16, minute: 0),
      TimeOfDay(hour: 17, minute: 0),
      TimeOfDay(hour: 18, minute: 0),
      TimeOfDay(hour: 19, minute: 0),
      TimeOfDay(hour: 20, minute: 0),
      TimeOfDay(hour: 21, minute: 0),
      TimeOfDay(hour: 22, minute: 0),
    ];

    return DataTable(
      border: TableBorder.all(),
      columns: [
        DataColumn(label: Text('Time')),
        ...daysOfWeek.map((day) => DataColumn(label: Text(day))),
      ],
      rows: [
        for (final time in timesOfDay)
          DataRow(cells: [
            DataCell(Text(time.format(context))),
            for (final day in daysOfWeek)
              DataCell(Text(
                activeActivities
                    .where((activity) =>
                        activity.daysOfWeek.contains(day) &&
                        activity.times.contains(time))
                    .map((activity) => activity.title)
                    .join('\n'),
              )),
          ]),
      ],
    );
  }
}
