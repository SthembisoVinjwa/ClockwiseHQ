import 'package:clockwisehq/provider/provider.dart';
import 'package:clockwisehq/screens/records.dart';
import 'package:clockwisehq/screens/marking.dart';
import 'package:clockwisehq/screens/settingDialog.dart';
import 'package:clockwisehq/screens/view.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../file.dart';
import '../timetable/activity.dart';
import 'package:provider/provider.dart';
import 'package:clockwisehq/global/global.dart' as global;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController scrollController = ScrollController();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Activity> myActivities = [];
  bool _isLoadingActivities = false;

  static final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const timesOfDay = [
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

  void scrollToNext() {
    scrollController.animateTo(
      scrollController.offset + 300,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void scrollToPrev() {
    scrollController.animateTo(
      scrollController.offset - 300,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _readActivities() async {
    setState(() {
      _isLoadingActivities = true;
    });
    List<Activity> acts = await TimetableFile().readActivitiesFromJsonFile();
    Provider.of<MainProvider>(context, listen: false).updateActivityList(acts);
    if (acts.length <= 1) {
      TimetableFile().clearFile();
    }
    setState(() {
      _isLoadingActivities = false;
    });
  }

  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();

    return "$day/$month/$year";
  }

  // Comparison function for sorting TimeOfDay values
  int _compareTimeOfDay(TimeOfDay a, TimeOfDay b) {
    if (a.hour < b.hour) {
      return -1;
    } else if (a.hour > b.hour) {
      return 1;
    } else {
      return a.minute.compareTo(b.minute);
    }
  }

  List<Widget> tasks(DateTime day, bool darkMode) {
    List<Activity> activities = myActivities
        .where((activity) =>
            day.isAfter(activity.startDate) && day.isBefore(activity.endDate) ||
            day.isAtSameMomentAs(activity.startDate) ||
            day.isAtSameMomentAs(activity.endDate))
        .toList();

    List<Widget> widgets = [];
    bool atLeastOne = false;

    if (activities.isEmpty) {
      widgets.add(
        SizedBox(
          width: 300,
          child: ListTile(
            leading: const Icon(
              Icons.free_cancellation_sharp,
              color: Colors.grey,
            ),
            title: Text(
              "No classes/events",
              style: TextStyle(color: global.aColor,),
            ),
          ),
        ),
      );
    } else {
      Map<TimeOfDay, String> entries = {};

      for (Activity activity in activities) {

        activity.timeOfDayMap.forEach((key, value) {
          if (key == daysOfWeek[day.weekday - 1]) {
            atLeastOne = true;
            String title = activity.title;
            for (var time in value) {
              entries.putIfAbsent(time, () => title);
            }
          }
        });
      }

      List<MapEntry<TimeOfDay, String>> sortedEntries = entries.entries.toList()
        ..sort((a, b) => _compareTimeOfDay(a.key, b.key));

      for (var entry in sortedEntries) {
        String nextHour = ((entry.key.hour + 1)%24).toString();
        String timeStr = '${entry.key.hour.toString().padLeft(2, '0')}:${entry.key.minute.toString().padLeft(2, '0')} - ${nextHour.padLeft(2, '0')}:${entry.key.minute.toString().padLeft(2, '0')}';
        widgets.add(
          SizedBox(
            width: 300,
            child: ListTile(
              leading: const Icon(
                Icons.calendar_today_sharp,
                size: 24,
                color: Colors.grey,
              ),
              title: Text(
                entry.value[0].toUpperCase() + entry.value.substring(1),
                style: TextStyle(color: global.aColor,),
              ),
              subtitle: Text(
                timeStr,
                style: TextStyle(color: global.aColor,),
              ),
            ),
          ),
        );
      }
      if (!atLeastOne) {
        widgets.add(
          SizedBox(
            width: 300,
            child: ListTile(
              leading: const Icon(
                Icons.free_cancellation_sharp,
                size: 27.0,
                color: Colors.grey,
              ),
              title: Text(
                'No classes/events',
                style: TextStyle(color: global.aColor,),
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  Widget timetableForDay(DateTime day, context, bool darkMode) {
    return ListView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: tasks(day, darkMode),
    );
  }

  @override
  void initState() {
    super.initState();
    _readActivities();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    myActivities = provider.activityList;
    bool darkMode = provider.isDarkMode;

    if (darkMode == true) {
      global.aColor = Colors.white;
      global.bColor = Colors.black87;
    } else {
      global.bColor = Colors.white;
      global.aColor = Colors.black87;
    }

    return Scaffold(
        drawer: Drawer(
          backgroundColor: global.bColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: global.aColor,
                ),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_outlined,
                        color: global.bColor,
                      ),
                      Text(
                        "  Timetable & Attendance",
                        style: TextStyle(
                          color: global.bColor,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: global.cColor,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                    color: global.aColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to home page
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.calendar_today,
                  color: global.cColor,
                ),
                title: Text(
                  'View timetable',
                  style: TextStyle(
                    color: global.aColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to schedule page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ViewTimetable()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.assignment,
                  color: global.cColor,
                ),
                title: Text(
                  'Attendance Records',
                  style: TextStyle(
                    color: global.aColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to attendance records page
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: global.cColor,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: global.aColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings page
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: global.cColor,
                ),
                title: Text(
                  'About',
                  style: TextStyle(
                    color: global.aColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to help page
                },
              ),
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: global.bColor,
            iconTheme: IconThemeData(color: global.aColor),
            elevation: 1.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_filled_outlined,
                  color: global.aColor,
                ),
                Text(
                  "  Timetable & Attendance",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: global.aColor,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.notifications_none_sharp,
                  size: 25.0,
                  color: global.aColor,
                ),
                onPressed: () {
                  // Show list of notifications
                  showNotifications(context);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 25.0,
                  color: global.aColor,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SettingsDialog();
                    },
                  );
                },
              )
              /*Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: const BorderSide(
                                        color: Color(0xfffdffff))))),
                    onPressed: () {
                      print('log In');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.person_sharp), // icon
                        Text('Log In'), // text
                      ],
                    ),
                  ))*/
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                color: global.bColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 260,
                      width: 320,
                      child: TableCalendar(
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        calendarStyle: CalendarStyle(
                          cellMargin: const EdgeInsets.all(4),
                          outsideTextStyle: TextStyle(
                            color: global.cColor,
                          ),
                          selectedDecoration: ShapeDecoration(
                              color: global.aColor,
                              shape: const CircleBorder()),
                          todayDecoration: ShapeDecoration(
                              color: global.cColor,
                              shape: const CircleBorder()),
                          selectedTextStyle: TextStyle(
                            color: global.bColor,
                          ),
                          todayTextStyle: TextStyle(
                            color: global.bColor,
                          ),
                          weekNumberTextStyle: TextStyle(color: global.aColor),
                          weekendTextStyle: TextStyle(color: global.aColor),
                          defaultTextStyle: TextStyle(color: global.aColor),
                        ),
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        shouldFillViewport: true,
                        availableGestures: AvailableGestures.all,
                        headerStyle: HeaderStyle(
                            titleTextStyle:
                                TextStyle(fontSize: 18, color: global.aColor),
                            leftChevronIcon: Icon(Icons.arrow_back_ios,
                                color: global.aColor),
                            rightChevronIcon: Icon(Icons.arrow_forward_ios,
                                color: global.aColor),
                            formatButtonVisible: false,
                            titleCentered: true),
                        focusedDay: _focusedDay,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2090, 10, 16),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: SizedBox(
                        width: 320,
                        child: Card(
                          color: darkMode ? Colors.black87.withOpacity(0) : Colors.white,
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: global.cColor,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 2, top: 8),
                                child: Center(
                                  child: Text(
                                    'Classes and Events: ${formatDate(_focusedDay)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: global.aColor,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1.0,
                                color: global.cColor,
                              ),
                              Expanded(
                                child: _isLoadingActivities
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: global.aColor,
                                        ),
                                      )
                                    : timetableForDay(_focusedDay, context, darkMode),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back_ios,
                                        color: global.aColor),
                                    onPressed: () {
                                      scrollToPrev();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: global.aColor,
                                    ),
                                    onPressed: () {
                                      scrollToNext();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: global.bColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 33,
                    ),
                    SizedBox(
                      width: 310,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: global.aColor,
                          backgroundColor: darkMode ? Colors.black87.withOpacity(0) : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: global.aColor),
                            borderRadius: BorderRadius.circular(15),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewTimetable()),
                          );
                        },
                        child: Text(
                          'View Timetable',
                          style: TextStyle(color: global.aColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 310,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: global.aColor,
                          backgroundColor: darkMode ? Colors.black87.withOpacity(0) : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: global.aColor),
                            borderRadius: BorderRadius.circular(15),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AttendanceMarking()),
                          );
                        },
                        child: Text(
                          'Attendance Marking',
                          style: TextStyle(color: global.aColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 310,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: global.aColor,
                          backgroundColor: darkMode ? Colors.black87.withOpacity(0) : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: global.aColor),
                            borderRadius: BorderRadius.circular(15),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AttendanceRecords()),
                          );
                        },
                        child: Text(
                          'Attendance Records',
                          style: TextStyle(color: global.aColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 310,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: global.aColor,
                          backgroundColor: darkMode ? Colors.black87.withOpacity(0) : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: global.aColor),
                            borderRadius: BorderRadius.circular(15),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                        },
                        child: Text(
                          'Settings',
                          style: TextStyle(color: global.aColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Notifications',
            style: TextStyle(fontSize: 18, color: global.aColor),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: global.cColor,
                  ),
                  title: Text(
                    'Notification ${index + 1}',
                    style: TextStyle(color: global.aColor),
                  ),
                  subtitle: Text('This is a notification',
                      style: TextStyle(color: global.cColor)),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: global.aColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
