import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clockwisehq/global/global.dart' as global;
import '../attendance/entry.dart';
import '../export/pdfapi.dart';
import '../provider/provider.dart';
import '../screens/export.dart';
import '../timetable/activity.dart';
import 'dart:developer';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  List<Activity> activities = [];
  bool showOptions = false;
  bool firstIteration = true;
  List<AttendanceEntry> entries = [];
  static final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  Future<void> _readAttendance() async {
    if (entries.isEmpty) {
      final attendance = await AttendanceFile().readAttendance();
      Provider.of<MainProvider>(context, listen: false)
          .updateAttendanceEntries(attendance);
    }
  }

  @override
  void initState() {
    super.initState();
    _readAttendance();
  }

  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();

    return "$day/$month/$year";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);

    entries = provider.attendance;
    bool darkMode = provider.isDarkMode;

    if (darkMode == true) {
      global.aColor = Colors.white;
      global.bColor = Colors.black87;
    } else {
      global.bColor = Colors.white;
      global.aColor = Colors.black87;
    }

    return Scaffold(
      backgroundColor: global.bColor,
      floatingActionButton: SizedBox(
        width: 145,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: global.aColor,
            backgroundColor:
                darkMode ? Colors.black87.withOpacity(0.25) : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: global.aColor),
              borderRadius: BorderRadius.circular(15),
            ), // Text color
          ),
          onPressed: () async {
            final pdfFile =
                await PdfApi.exportAttendanceEntries(entries);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Export(
                        file: pdfFile,
                      )),
            );
          },
          child: const Text('Generate PDF'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: global.bColor.withOpacity(0),
        padding: const EdgeInsets.all(14.0),
        child: ListView.builder(
          shrinkWrap: true, // Wrap the ListView.builder with a SizedBox
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final activity = entries[index].activity;
            final isAttended = entries[index].attendance ?? false;

            final time = activity.timeOfDayMap.entries.first.value.first;
            String nextHour = ((time.hour + 1) % 24).toString();

            return ListTile(
              title: Text(
                activity.title[0].toUpperCase() + activity.title.substring(1),
                style: TextStyle(
                  color: global.aColor,
                ),
              ),
              subtitle: Text(
                '${formatDate(entries[index].date)} @ ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} - ${nextHour.padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: global.cColor),
              ),
              trailing: entries[index].attendance
                  ? Icon(
                      Icons.check,
                      color: global.aColor,
                    )
                  : Icon(Icons.close, color: global.aColor),
            );
          },
        ),
      ),
    );
  }
}
