import 'package:clockwisehq/file_handling.dart';
import 'package:clockwisehq/provider/provider.dart';
import 'package:clockwisehq/timetable/add.dart';
import 'package:clockwisehq/timetable/arrow_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'activity.dart';

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
    final provider = Provider.of<ActivityProvider>(context);
    myActivities = provider.activityList;

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
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                underline: const SizedBox(),
                alignment: Alignment.center,
                hint: const Text('Timeframe'),
                items: items,
                iconEnabledColor: Colors.black,
                style: const TextStyle(
                    color: Colors.black,
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
                      ),
                    )
                  : const SizedBox(
                      height: 60,
                    ),
            ],
          ),
          if (_isLoadingActivities)
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )),
              ],
            )
          else if (myActivities.isNotEmpty)
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
              ),
              elevation: 6,
              child: SizedBox(
                height: 605,
                width: MediaQuery.of(context).size.width-50,
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
            const SizedBox(
              height: 605,
              child: Center(
                  child: Text(
                'No timetable data found',
                style: TextStyle(fontSize: 18),
              )),
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
      event.daysOfWeek = [daysOfWeek[event.startDate.weekday - 1]];
      activeActivities.add(event);
    }

    return DataTable(
      border: TableBorder.all(color: Colors.grey),
      columns: [
        const DataColumn(label: Text('')),
        ...daysOfWeek.map((day) => DataColumn(
                label: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ))),
      ],
      rows: [
        for (final time in timesOfDay)
          DataRow(cells: [
            DataCell(Text(time.format(context))),
            for (final day in daysOfWeek)
              DataCell(Container(
                alignment: Alignment.center,
                width: 55,
                child: Text(
                  maxLines: 3,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  activeActivities
                      .where((activity) =>
                          activity.daysOfWeek.contains(day) &&
                          activity.times.contains(time))
                      .map((activity) => activity.title)
                      .join('\n'),
                ),
              )),
          ]),
      ],
    );
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
      event.daysOfWeek = [daysOfWeek[event.startDate.weekday - 1]];
      activeActivities.add(event);
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
            DataCell(Text(time.format(context))),
            for (final day in currentDay)
              DataCell(Container(
                width: MediaQuery.of(context).size.width-189,
                alignment: Alignment.center,
                child: Text(
                  maxLines: 3,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  activeActivities
                      .where((activity) =>
                          activity.daysOfWeek.contains(day) &&
                          activity.times.contains(time))
                      .map((activity) => activity.title)
                      .join('\n'),
                ),
              )),
          ]),
      ],
    );
  }
}
