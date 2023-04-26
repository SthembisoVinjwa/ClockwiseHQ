import 'package:clockwisehq/timetable/timetable.dart';
import 'package:flutter/material.dart';

class ViewTimetable extends StatefulWidget {
  const ViewTimetable({Key? key}) : super(key: key);

  @override
  State<ViewTimetable> createState() => _ViewTimetableState();
}

class _ViewTimetableState extends State<ViewTimetable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          elevation: 1.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            "View Timetable",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
      body: const Timetable(),
    );
  }
}