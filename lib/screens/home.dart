import 'package:clockwisehq/provider/provider.dart';
import 'package:clockwisehq/screens/records.dart';
import 'package:clockwisehq/screens/marking.dart';
import 'package:clockwisehq/screens/settingDialog.dart';
import 'package:clockwisehq/screens/view.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../file_handling.dart';
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

  List<Widget> tasks(DateTime day) {
    List<Activity> activities = myActivities
        .where((activity) =>
            day.isAfter(activity.startDate) && day.isBefore(activity.endDate) ||
            day.isAtSameMomentAs(activity.startDate) ||
            day.isAtSameMomentAs(activity.endDate))
        .toList();

    for (int i = 0; i < activities.length; i++) {
      if (activities[i].daysOfWeek.contains("x")) {
        activities[i].daysOfWeek = [
          daysOfWeek[activities[i].startDate.weekday - 1]
        ];
      }
    }

    List<Widget> widgets = [];
    bool atleastOne = false;

    if (activities.isEmpty) {
      widgets.add(SizedBox(
        width: 300,
        child: ListTile(
          leading: Icon(
            Icons.free_cancellation_sharp,
            color: global.cColor,
          ),
          title: Text(
            "No classes/events",
            style: TextStyle(color: global.aColor),
          ),
        ),
      ));
    } else {
      for (final time in timesOfDay) {
        String title = activities
            .where((activity) =>
                activity.daysOfWeek.contains(daysOfWeek[day.weekday - 1]) &&
                activity.times.contains(time))
            .map((activity) => activity.title)
            .join('\n');
        if (title.isNotEmpty) {
          atleastOne = true;
          widgets.add(SizedBox(
            width: 300,
            child: ListTile(
              leading: Icon(
                Icons.calendar_today_sharp,
                size: 24,
                color: global.cColor,
              ),
              title: Text(
                title,
                style: TextStyle(color: global.aColor),
              ),
              subtitle: Text(
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} - ${(time.hour + 1).toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: global.aColor),
              ),
            ),
          ));
        }
      }
      if (atleastOne == false) {
        widgets.add(SizedBox(
          width: 300,
          child: ListTile(
            leading: Icon(
              Icons.free_cancellation_sharp,
              size: 27.0,
              color: global.cColor,
            ),
            title: Text(
              'No classes/events',
              style: TextStyle(color: global.aColor),
            ),
          ),
        ));
      }
    }
    return widgets;
  }

  Widget timetableForDay(DateTime day, context) {
    return ListView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: tasks(day),
    );
  }

  /*final List<Activity> activities = [
    Activity(
      'Maths 244',
      'Jan Mouton',
      'Dr. Gray',
      [const TimeOfDay(hour: 10, minute: 0)],
      ['Mon', 'Wed', 'Fri'],
      'class',
      DateTime(2023, 4, 1),
      DateTime(2023, 4, 30),
    ),
    Activity(
      'Com Sci 344',
      'Enginerring building room A303',
      'Willem Bester',
      [
        const TimeOfDay(hour: 9, minute: 0),
        const TimeOfDay(hour: 10, minute: 0),
        const TimeOfDay(hour: 14, minute: 0)
      ],
      ['Tue', 'Thu'],
      'class',
      DateTime(2023, 4, 1),
      DateTime(2023, 4, 30),
    ),
    Activity(
      'GIT 312',
      'Geology Building',
      'Dr. Stuurman',
      [
        const TimeOfDay(hour: 19, minute: 0),
        const TimeOfDay(hour: 20, minute: 0)
      ],
      ['Mon', 'Wed'],
      'class',
      DateTime(2023, 4, 1),
      DateTime(2023, 4, 30),
    ),
    Activity(
      'GTH 302',
      'Geology Building',
      'Dr. Stuurman',
      [
        const TimeOfDay(hour: 19, minute: 0),
      ],
      ['x'],
      'event',
      DateTime(2023, 4, 25),
      DateTime(2023, 4, 30),
    ),
  ];*/

  @override
  void initState() {
    super.initState();
    _readActivities();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    myActivities = provider.activityList;

    if (provider.isDarkMode == true) {
      global.aColor = Colors.white;
      global.bColor = Colors.black87;
    } else {
      global.bColor = Colors.white;
      global.aColor = Colors.black87;
    }

    return Scaffold(
        backgroundColor: global.bColor,
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
                        'ClockwiseHQ',
                        style: TextStyle(
                          color: global.bColor,
                          fontSize: 22.0,
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
                  "ClockwiseHQ",
                  style: TextStyle(
                    fontSize: 18.0,
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
                          color: global.bColor,
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
                                    : timetableForDay(_focusedDay, context),
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
                      height: 30,
                    ),
                    SizedBox(
                      width: 310,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: global.aColor,
                          backgroundColor: global.bColor,
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
                          backgroundColor: global.bColor,
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
                          backgroundColor: global.bColor,
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
                          backgroundColor: global.bColor,
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
