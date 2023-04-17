import 'package:flutter/material.dart';

class ManageTimetables extends StatefulWidget {
  const ManageTimetables({Key? key}) : super(key: key);

  @override
  State<ManageTimetables> createState() => _ManageTimetablesState();
}

class _ManageTimetablesState extends State<ManageTimetables> {
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
            "Manage and Share",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
