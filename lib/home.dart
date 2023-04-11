import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    void _scrollToNext() {
      _scrollController.animateTo(
        _scrollController.offset + 300,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }

    void _scrollToPrev() {
      _scrollController.animateTo(
        _scrollController.offset - 300,
        duration: Duration(milliseconds: 200),
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
                accountName: Text('John Doe'),
                accountEmail: Text('johndoe@email.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.grey[600],
                  child: Text(
                    'JD',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to home page
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Manage timetable'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to schedule page
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Attendance Records'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to attendance records page
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings page
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
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
            elevation: 5.0,
            title: Row(
              children: [
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
                icon: Icon(Icons.notifications_none_sharp, size: 30.0),
                onPressed: () {
                  // Show list of notifications
                  showNotifications(context);
                },
              ),
              Padding(
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
                  ))
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 260,
                      width: 320,
                      child: TableCalendar(
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color:
                                  Colors.indigoAccent.shade200.withAlpha(200),
                              shape: BoxShape.circle,
                            ),
                          ),
                          shouldFillViewport: true,
                          focusedDay: DateTime.now(),
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 10, 16)),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: Container(
                        width: 320,
                        child: Card(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.grey[600]!),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 2, top: 8),
                                child: Center(
                                  child: Text(
                                    'Upcoming Class/Event',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(thickness: 1.0),
                              Expanded(
                                child: ListView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: [
                                    Container(
                                      width: 300,
                                      child: ListTile(
                                        leading: Icon(Icons.calendar_today),
                                        title: Text('Maths 214'),
                                        subtitle: Text('8:00 AM - 9:00 AM'),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      child: ListTile(
                                        leading: Icon(Icons.calendar_today),
                                        title: Text('Com Sci 344'),
                                        subtitle: Text('10:00 AM - 11:00 AM'),
                                      ),
                                    ),
                                    Container(
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
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      _scrollToPrev();
                                    },
                                  ),
                                  SizedBox(width: 50,),
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      _scrollToNext();
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                        },
                        child: Text('View Timetable'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigoAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ), // Text color
                        ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                        },
                        child: Text('Manage Timetable and Events'),
                      ),
                    ),
                    SizedBox(
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
                        child: Text('Attendance Marking and Records'),
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
                        child: Text('Settings'),
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
          title: Text('Notifications'),
          content: Container(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notification ${index + 1}'),
                  subtitle: Text('This is a notification'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
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
