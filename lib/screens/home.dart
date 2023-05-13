import 'package:clockwisehq/provider/provider.dart';
import 'package:clockwisehq/screens/records.dart';
import 'package:clockwisehq/screens/marking.dart';
import 'package:clockwisehq/screens/view.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../file_handling.dart';
import '../timetable/activity.dart';
import 'package:provider/provider.dart';

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
    Provider.of<ActivityProvider>(context, listen: false)
        .updateActivityList(acts);
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
        activities[i].daysOfWeek = [daysOfWeek[activities[i].startDate.weekday - 1]];
      }
    }

    List<Widget> widgets = [];
    bool atleastOne = false;

    if (activities.isEmpty) {
      widgets.add(const SizedBox(
        width: 300,
        child: ListTile(
          leading: Icon(Icons.free_cancellation_sharp),
          title: Text("No classs/events"),
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
              leading: const Icon(Icons.calendar_today_sharp, size: 24),
              title: Text(title),
              subtitle: Text(
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} - ${(time.hour + 1).toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              ),
            ),
          ));
        }
      }
      if (atleastOne == false) {
        widgets.add(const SizedBox(
          width: 300,
          child: ListTile(
            leading: Icon(Icons.free_cancellation_sharp, size: 27.0),
            title: Text('No classes/events'),
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
    final provider = Provider.of<ActivityProvider>(context);
    myActivities = provider.activityList;

    return Scaffold(
        backgroundColor: const Color(0xfffdffff),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: const [
                      Icon(Icons.access_time_filled_outlined, color: Colors.white),
                      Text(
                        'ClockwiseHQ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to home page
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('View timetable'),
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
                leading: const Icon(Icons.assignment),
                title: const Text('Attendance Records'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to attendance records page
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings page
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
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
            elevation: 1.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.access_time_filled_outlined),
                Text(
                  "ClockwiseHQ",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_sharp, size: 25.0),
                onPressed: () {
                  // Show list of notifications
                  showNotifications(context);
                },
              ),
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
                        calendarStyle: const CalendarStyle(
                          cellMargin: EdgeInsets.all(4),
                          selectedDecoration: ShapeDecoration(color: Colors.black,shape: CircleBorder()),
                          todayDecoration: ShapeDecoration(color: Colors.grey,shape: CircleBorder()),
                        ),
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        shouldFillViewport: true,
                        availableGestures: AvailableGestures.all,
                        headerStyle: const HeaderStyle(
                            formatButtonVisible: false, titleCentered: true),
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
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Colors.grey[600]!),
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(thickness: 1.0),
                              Expanded(
                                child: _isLoadingActivities
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      )
                                    : timetableForDay(_focusedDay, context),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios),
                                    onPressed: () {
                                      scrollToPrev();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios),
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
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30,),
                    SizedBox(
                      width: 310,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black),
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
                        child: const Text('View Timetable', style: TextStyle(color: Colors.black),),
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
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AttendanceMarking()),
                          );
                        },
                        child: const Text('Attendance Marking', style: TextStyle(color: Colors.black),),
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
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AttendanceRecords()),
                          );
                        },
                        child: const Text('Attendance Records', style: TextStyle(color: Colors.black),),
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
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                        },
                        child: const Text('Settings', style: TextStyle(color: Colors.black),),
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
          title: const Text('Notifications'),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text('Notification ${index + 1}'),
                  subtitle: const Text('This is a notification'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
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
