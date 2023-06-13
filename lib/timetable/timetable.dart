import 'package:clockwisehq/file.dart';
import 'package:clockwisehq/provider/provider.dart';
import 'package:clockwisehq/timetable/add.dart';
import 'package:clockwisehq/timetable/arrowText.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'activity.dart';
import 'package:clockwisehq/global/global.dart' as global;

class Timetable extends StatefulWidget {
  const Timetable({Key? key}) : super(key: key);

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  String? _dropdownValue;
  bool set = false;
  late List<Activity> myActivities;
  bool _isLoadingActivities = false;
  List<DropdownMenuItem<String>> items = const [
    DropdownMenuItem(
      value: 'Weekly',
      child: Text('Weekly'),
    ),
    DropdownMenuItem(
      value: 'Daily',
      child: Text('Daily'),
    ),
  ];

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

  String _currentText = daysOfWeek[DateTime.now().weekday - 1];

  void _updateText(String newText) {
    setState(() {
      _currentText = newText;
    });
  }

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  void _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-7872743903266632/8320653540',
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          print(error);
        }),
        request: const AdRequest());

    _bannerAd.load();
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

    if (set == false) {
      _dropdownValue = 'Weekly';
      set = true;
    }
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
            // Code for navigating to create/manage timetable screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTask()),
            );
          },
          child: const Text('Add Class/Event'),
        ),
      ),
      body: Column(
        children: [
          if (_isAdLoaded)
            Expanded(
              child: SizedBox(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(
                  ad: _bannerAd,
                ),
              ),
            ),
          Container(
            color: global.bColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      underline: const SizedBox(),
                      alignment: Alignment.center,
                      hint: Text(
                        'Timeframe',
                        style: TextStyle(color: global.aColor),
                      ),
                      items: items,
                      iconEnabledColor: global.aColor,
                      dropdownColor: global.bColor,
                      style: TextStyle(
                          color: global.aColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      value: _dropdownValue,
                      onChanged: (String? value) {
                        if (value is String) {
                          setState(() {
                            _dropdownValue = value;
                          });
                        }
                      },
                    ),
                    _dropdownValue != 'Weekly'
                        ? SizedBox(
                            height: 60,
                            width: 200,
                            child: ArrowTextWidget(
                              texts: const [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun'
                              ],
                              onUpdateText: _updateText,
                              index: DateTime.now().weekday - 1,
                              textColor: global.aColor,
                            ),
                          )
                        : const SizedBox(
                            height: 60,
                          ),
                    const SizedBox(
                      width: 30,
                    ),
                    if (_dropdownValue == 'Weekly')
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: global.aColor,
                          backgroundColor: darkMode
                              ? Colors.black87.withOpacity(0.25)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: global.aColor),
                            borderRadius: BorderRadius.circular(15),
                          ), // Text color
                        ),
                        onPressed: () {
                          try {
                            setState(() {
                              TimetableFile().clearFile();
                              provider.updateActivityList([
                                Activity(
                                  'none',
                                  'none',
                                  'none',
                                  {'mon': [TimeOfDay(hour: 0, minute: 0)]},
                                  'class',
                                  DateTime.utc(2010, 10, 16),
                                  DateTime.utc(2011, 10, 16),
                                )
                              ]);
                            });
                            showMessage(
                                'Timetable has been deleted.', 'Deletion');
                          } catch (e) {
                            showMessage('Could not delete timetable',
                                'Something went wrong');
                          }
                        },
                        child: const Text('Delete Timetable'),
                      ),
                  ],
                ),
                if (_isLoadingActivities)
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Center(
                          child: CircularProgressIndicator(
                        color: global.aColor,
                      )),
                    ],
                  )
                else if (myActivities.isNotEmpty)
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey),
                    ),
                    elevation: 1,
                    child: Container(
                      color: global.bColor,
                      height: 585,
                      width: _dropdownValue == 'Weekly'
                          ? MediaQuery.of(context).size.width - 15
                          : MediaQuery.of(context).size.width - 50,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: _dropdownValue == 'Weekly'
                              ? buildWeeklyTable()
                              : buildDailyTimetable(),
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 605,
                    child: Center(
                        child: Text(
                      'No timetable data found',
                      style: TextStyle(fontSize: 18, color: global.aColor),
                    )),
                  )
              ],
            ),
          ),
          if (!_isAdLoaded)
            Expanded(
              child: Container(
                color: global.bColor,
              ),
            )
        ],
      ),
    );
  }

  Widget buildWeeklyTable() {
    final now = DateTime.now();
    int weekDay = now.weekday;
    DateTime monday = now.subtract(Duration(days: weekDay - 1));
    DateTime sunday = now.add(Duration(days: 7 - weekDay));
    List<Activity> activeActivities = myActivities
        .where((activity) =>
            activity.type == 'Class' &&
                now.isAfter(activity.startDate) &&
                now.isBefore(activity.endDate) ||
            now.isAtSameMomentAs(activity.startDate) ||
            now.isAtSameMomentAs(activity.endDate))
        .toList();

    final events = myActivities.where((activity) =>
        activity.type == 'Event' &&
        (activity.startDate.isAtSameMomentAs(monday) ||
            activity.startDate.isAtSameMomentAs(monday) ||
            (activity.startDate.isAfter(monday) &&
                activity.startDate.isBefore(sunday))));

    for (final event in events) {
      activeActivities.add(event);
    }

    List<Activity> toDisplay = [];

    for (Activity activity in activeActivities) {
      activity.timeOfDayMap.forEach((key, value) {
        for (final day in daysOfWeek) {
          if (key == day) {
            String title = activity.title;
            for (var time in value) {
              toDisplay.add(Activity(
                  activity.title,
                  activity.location,
                  activity.instructor,
                  {
                    day: [time]
                  },
                  activity.type,
                  activity.startDate,
                  activity.endDate));
            }
          }
        }
      });
    }

    return DataTable(
      border: TableBorder.all(color: Colors.grey),
      columns: [
        const DataColumn(label: Text('')),
        ...daysOfWeek.map((day) => DataColumn(
                label: Text(
              day,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: global.aColor),
            ))),
      ],
      rows: [
        for (final time in timesOfDay)
          DataRow(cells: [
            DataCell(Text(
              time.format(context),
              style: TextStyle(color: global.aColor),
            )),
            for (final day in daysOfWeek)
              DataCell(InkWell(
                onTap: () {
                  final matchingActivity = toDisplay.firstWhere(
                    (activity) =>
                        activity.timeOfDayMap.containsKey(day) &&
                        activity.timeOfDayMap[day]!.contains(time),
                    orElse: () => Activity(
                      '',
                      '',
                      '',
                      {},
                      '',
                      DateTime.utc(2000, 10, 16),
                      DateTime.utc(2090, 10, 16),
                    ),
                  );
                  showActivityDialog(
                    matchingActivity,
                    day,
                    time,
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 55,
                  child: Text(
                    maxLines: 3,
                    style: TextStyle(fontSize: 12, color: global.aColor),
                    overflow: TextOverflow.ellipsis,
                    capitalize(
                      toDisplay
                          .where((activity) =>
                              activity.timeOfDayMap.containsKey(day) &&
                              activity.timeOfDayMap[day]!.contains(time))
                          .map((activity) => activity.title)
                          .join('\n'),
                    ),
                  ),
                ),
              )),
          ]),
      ],
    );
  }

  int getWeekNumber(DateTime dateTime) {
    DateTime firstDayOfYear = DateTime(dateTime.year, 1, 1);
    int differenceInDays = dateTime.difference(firstDayOfYear).inDays;
    int weekNumber = (differenceInDays ~/ 7) + 1;
    return weekNumber;
  }

  DateTime getDateFromWeekAndDay(int week, int day) {
    DateTime firstDayOfYear = DateTime(DateTime.now().year, 1, 1);
    int daysToAdd = week * 7 + (day - firstDayOfYear.weekday + 1);
    return firstDayOfYear.add(Duration(days: daysToAdd));
  }

  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();

    return "$day/$month/$year";
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

  showActivityDialog(Activity activity, String day, TimeOfDay time) {
    int dayIndex = daysOfWeek.indexOf(day);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: global.bColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  activity.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: global.aColor),
                ),
                SizedBox(height: 10.0),
                Text('Location: ${activity.location}',
                    style: TextStyle(color: global.aColor)),
                Text('Instructor: ${activity.instructor}',
                    style: TextStyle(color: global.aColor)),
                Text(
                    'Date: ${formatDate(getDateFromWeekAndDay(getWeekNumber(DateTime.now()), dayIndex))}',
                    style: TextStyle(color: global.aColor)),
                Text('Time: ${time.format(context)}',
                    style: TextStyle(color: global.aColor)),
                // Add more information fields as needed
                SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String capitalize(String title) {
    if (title.isNotEmpty) {
      return (title[0].toUpperCase() + title.substring(1));
    } else {
      return '';
    }
  }

  Widget buildDailyTimetable() {
    final now = DateTime.now();
    int weekDay = now.weekday;
    DateTime monday = now.subtract(Duration(days: weekDay - 1));
    DateTime sunday = now.add(Duration(days: 7 - weekDay));
    List<Activity> activeActivities = myActivities
        .where((activity) =>
            activity.type == 'Class' &&
                now.isAfter(activity.startDate) &&
                now.isBefore(activity.endDate) ||
            now.isAtSameMomentAs(activity.startDate) ||
            now.isAtSameMomentAs(activity.endDate))
        .toList();

    final events = myActivities.where((activity) =>
        activity.type == 'Event' &&
        (activity.startDate.isAtSameMomentAs(monday) ||
            activity.startDate.isAtSameMomentAs(monday) ||
            (activity.startDate.isAfter(monday) &&
                activity.startDate.isBefore(sunday))));

    for (final event in events) {
      activeActivities.add(event);
    }

    List<Activity> toDisplay = [];

    for (Activity activity in activeActivities) {
      activity.timeOfDayMap.forEach((key, value) {
        for (final day in daysOfWeek) {
          if (key == day) {
            String title = activity.title;
            for (var time in value) {
              toDisplay.add(Activity(
                  activity.title,
                  activity.location,
                  activity.instructor,
                  {
                    day: [time]
                  },
                  activity.type,
                  activity.startDate,
                  activity.endDate));
            }
          }
        }
      });
    }

    final currentDay = [_currentText];

    return DataTable(
      border: TableBorder.all(color: Colors.grey),
      columns: const [
        DataColumn(label: Text('')),
        DataColumn(label: Text('')),
      ],
      rows: [
        for (final time in timesOfDay)
          DataRow(cells: [
            DataCell(Text(
              time.format(context),
              style: TextStyle(color: global.aColor),
            )),
            for (final day in currentDay)
              DataCell(Container(
                width: MediaQuery.of(context).size.width - 189,
                alignment: Alignment.center,
                child: Text(
                  maxLines: 3,
                  style: TextStyle(fontSize: 14, color: global.aColor),
                  overflow: TextOverflow.ellipsis,
                  capitalize(toDisplay
                      .where((activity) =>
                          activity.timeOfDayMap.containsKey(day) &&
                          activity.timeOfDayMap[day]!.contains(time))
                      .map((activity) => activity.title)
                      .join('\n')),
                ),
              )),
          ]),
      ],
    );
  }
}
