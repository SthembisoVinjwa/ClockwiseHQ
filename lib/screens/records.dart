import 'package:flutter/material.dart';

class AttendanceRecords extends StatefulWidget {
  const AttendanceRecords({Key? key}) : super(key: key);

  @override
  State<AttendanceRecords> createState() => _AttendanceRecordsState();
}

class _AttendanceRecordsState extends State<AttendanceRecords> {
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
            "Attendance Records",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}