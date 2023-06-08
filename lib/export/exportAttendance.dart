import 'package:flutter/material.dart';

class ExportAttendance extends StatefulWidget {
  const ExportAttendance({Key? key}) : super(key: key);

  @override
  State<ExportAttendance> createState() => _ExportAttendanceState();
}

class _ExportAttendanceState extends State<ExportAttendance> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
          child: Text('Generate PDF'),
          onPressed: () async {
            //
            //
          }),
    );
  }
}
