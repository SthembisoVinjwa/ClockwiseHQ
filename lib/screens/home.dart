import 'package:clockwisehq/screens/marking_and_records.dart';
import 'package:clockwisehq/screens/timetable_and_events.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;

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

    return Scaffold(
        backgroundColor: const Color(0xfffdffff),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: const Text('John Doe'),
                accountEmail: const Text('johndoe@email.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.grey[600],
                  child: const Text(
                    'JD',
                    style: TextStyle(color: Colors.white),
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
                title: const Text('Manage timetable'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to schedule page
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
                leading: const Icon(Icons.help),
                title: const Text('Help'),
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
                icon: const Icon(Icons.notifications_none_sharp, size: 30.0),
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
                      child: StatefulBuilder(
                        builder: (context, setState) => TableCalendar(
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarStyle: const CalendarStyle(
                            cellMargin: EdgeInsets.all(4),
                          ),
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          shouldFillViewport: true,
                          availableGestures: AvailableGestures.all,
                          headerStyle: const HeaderStyle(
                              formatButtonVisible: false, titleCentered: true),
                          focusedDay: _focusedDay,
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 10, 16),
                        ),
                      )
                    ),
                    const SizedBox(height: 5),
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
                              const Padding(
                                padding: EdgeInsets.only(bottom: 2, top: 8),
                                child: Center(
                                  child: Text(
                                    'Classes and Events',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(thickness: 1.0),
                              Expanded(
                                child: ListView(
                                  controller: scrollController,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: const [
                                    SizedBox(
                                      width: 300,
                                      child: ListTile(
                                        leading: Icon(Icons.calendar_today),
                                        title: Text('Maths 214'),
                                        subtitle: Text('8:00 AM - 9:00 AM'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: ListTile(
                                        leading: Icon(Icons.calendar_today),
                                        title: Text('Com Sci 344'),
                                        subtitle: Text('10:00 AM - 11:00 AM'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: ListTile(
                                        leading: Icon(Icons.calendar_today),
                                        title: Text('Com Sci 244 Prac'),
                                        subtitle: Text('12:00 AM - 11:00 AM'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () {
                                      scrollToPrev();
                                    },
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigoAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                        },
                        child: const Text('View Timetable'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigoAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ManageTimetable()),
                          );
                        },
                        child: const Text('Manage Timetable and Events'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigoAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MarkingRecords()),
                          );
                        },
                        child: const Text('Attendance Records and Marking'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigoAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                        },
                        child: const Text('Settings'),
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
