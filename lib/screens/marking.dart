import 'package:flutter/material.dart';

class AttendanceMarking extends StatefulWidget {
  const AttendanceMarking({Key? key}) : super(key: key);

  @override
  State<AttendanceMarking> createState() => _AttendanceMarkingState();
}

class _AttendanceMarkingState extends State<AttendanceMarking> {
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
            "Attendance Marking",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
