import 'package:clockwisehq/attendance/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clockwisehq/global/global.dart' as global;
import '../provider/provider.dart';
import '../timetable/activity.dart';
import 'dart:developer';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  late DateTime currentDate;
  List<Activity> activities = [];
  List<AttendanceEntry> entries = [];
  bool showOptions = false;
  bool firstIteration = true;
  static final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  void createAttendance() {
    activities = Provider.of<MainProvider>(context, listen: false)
        .activityList
        .where((activity) =>
            currentDate.isAfter(activity.startDate) &&
                currentDate.isBefore(activity.endDate) ||
            currentDate.isAtSameMomentAs(activity.startDate) ||
            currentDate.isAtSameMomentAs(activity.endDate))
        .toList();
    for (Activity activity in activities) {
      if (activity.title != 'none') {
        activity.timeOfDayMap.forEach((key, value) {
          if (key == daysOfWeek[currentDate.weekday - 1]) {
            String title = activity.title;
            for (var time in value) {
              entries.add(AttendanceEntry(
                  time: time,
                  date: currentDate,
                  activity: Activity(
                      activity.title,
                      activity.location,
                      activity.instructor,
                      {
                        key: [time]
                      },
                      activity.type,
                      activity.startDate,
                      activity.endDate),
                  attendance: false));
            }
          }
        });
      }
    }
  }

  Future<void> _saveAttendance() async {
    if (entries.isNotEmpty) {
      await AttendanceFile().saveAttendance(entries);
      final attendance = await AttendanceFile().readAttendance();
      Provider.of<MainProvider>(context, listen: false)
          .updateAttendanceEntries(attendance);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currentDate = DateTime.utc(2023, 6, 16);
      createAttendance();
    });
  }

  void toggleOptions() {
    setState(() {
      showOptions = !showOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    bool darkMode = provider.isDarkMode;

    if (darkMode == true) {
      global.aColor = Colors.white;
      global.bColor = Colors.black87;
    } else {
      global.bColor = Colors.white;
      global.aColor = Colors.black87;
    }

    return Scaffold(
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
          onPressed: () {
            _saveAttendance();
            showMessage('Attendance saved',
                'Date: ${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}');
          },
          child: const Text('Save'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        color: global.bColor,
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${daysOfWeek[currentDate.weekday - 1]} : ${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: global.aColor,
                  ),
                ),
                Text(
                  'Attendance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: global.aColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            // Add some spacing between the text and the list
            Expanded(
              child: ListView.builder(
                shrinkWrap: true, // Wrap the ListView.builder with a SizedBox
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final activity = entries[index].activity;
                  final isAttended = entries[index].attendance ?? false;
                  final time = entries[index].time;
                  String nextHour = ((time.hour + 1) % 24).toString();

                  return ListTile(
                    title: Text(
                      activity.title[0].toUpperCase() +
                          activity.title.substring(1),
                      style: TextStyle(
                        color: global.aColor,
                      ),
                    ),
                    subtitle: Text(
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} - ${nextHour.padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ',
                      style: TextStyle(color: global.cColor),
                    ),
                    trailing: Theme(
                      data: ThemeData(
                        unselectedWidgetColor: global.aColor,
                      ),
                      child: Checkbox(
                        checkColor: global.bColor,
                        activeColor: global.aColor,
                        value: isAttended,
                        onChanged: (value) {
                          setState(() {
                            entries[index].attendance = value ?? false;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showMessage(String message, String title) {
    AlertDialog inputFail = AlertDialog(
      backgroundColor: global.bColor,
      title: Text(
        title,
        style: TextStyle(color: global.aColor),
      ),
      content: Text(message, style: TextStyle(color: global.aColor)),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(global.aColor)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(color: global.bColor),
            )),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return inputFail;
      },
    );
  }
}
