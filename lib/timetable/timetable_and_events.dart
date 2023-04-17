import 'package:clockwisehq/timetable/weekly.dart';
import 'package:flutter/material.dart';

class ManageTimetable extends StatefulWidget {
  const ManageTimetable({Key? key}) : super(key: key);

  @override
  State<ManageTimetable> createState() => _ManageTimetableState();
}

class _ManageTimetableState extends State<ManageTimetable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          elevation: 1.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            "Manage Timetable and Events",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
      body: const WeekTimetable(),
    );
  }
}
