import 'package:flutter/material.dart';

class MarkingRecords extends StatefulWidget {
  const MarkingRecords({Key? key}) : super(key: key);

  @override
  State<MarkingRecords> createState() => _MarkingRecordsState();
}

class _MarkingRecordsState extends State<MarkingRecords> {
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
            "Attendance Records and Marking",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}