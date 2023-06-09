import 'package:clockwisehq/components/addedItemList.dart';
import 'package:clockwisehq/components/textfield.dart';
import 'package:clockwisehq/file.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import '../components/dayTimePicker.dart';
import '../provider/provider.dart';
import '../screens/settingDialog.dart';
import 'activity.dart';
import 'package:clockwisehq/global/global.dart' as global;

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final instructorController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  Activity activity = Activity('', '', '', {}, '', DateTime.utc(2000, 10, 16),
      DateTime.utc(2090, 10, 16));
  String _dropdownValue = 'Class';
  String _dayValue = 'Mon';
  bool timeError = false;
  bool dayError = false;
  List<String> addedDays = [];
  double kVertSpacing = 15;
  List<DropdownMenuItem<String>> items = const [
    DropdownMenuItem(
      value: 'Class',
      child: Text('Class'),
    ),
    DropdownMenuItem(
      value: 'Event',
      child: Text('Event'),
    ),
  ];

  List<DropdownMenuItem<String>> days = const [
    DropdownMenuItem(
      value: 'Mon',
      child: Text('Mon'),
    ),
    DropdownMenuItem(
      value: 'Tue',
      child: Text('Tue'),
    ),
    DropdownMenuItem(
      value: 'Wed',
      child: Text('Wed'),
    ),
    DropdownMenuItem(
      value: 'Thu',
      child: Text('Thu'),
    ),
    DropdownMenuItem(
      value: 'Fri',
      child: Text('Fri'),
    ),
    DropdownMenuItem(
      value: 'Sat',
      child: Text('Sat'),
    ),
    DropdownMenuItem(
      value: 'Sun',
      child: Text('Sun'),
    ),
  ];

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

  static final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<MultiSelectItem<String>> times = timesOfDay
      .map((e) => MultiSelectItem('${e.hour}:00', '${e.hour}:00'))
      .toList();
  List<String> selectedTimes = [];

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
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
            backgroundColor: global.bColor,
            elevation: 1.0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: global.aColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              "Add Class/Event",
              style: TextStyle(
                fontSize: 18.0,
                color: global.aColor,
              ),
            ),
            actions: [
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
                      return const SettingsDialog();
                    },
                  );
                },
              )
            ]),
      ),
      body: Container(
          padding: const EdgeInsets.all(5.0),
          color: global.bColor,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 12),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Title',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: global.aColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kVertSpacing),
                Container(
                  height: 70,
                  child: MyTextField(
                    textColor: global.aColor,
                    controller: titleController,
                    obscureText: false,
                    hintText: 'Class/event title',
                    validateField: (String? title) {
                      if (title!.isEmpty) {
                        return 'Title is empty';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                //SizedBox(height: kVertSpacing),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Type',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: global.aColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kVertSpacing),
                Container(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  height: 45,
                  child: DropdownButtonFormField(
                    dropdownColor: global.bColor,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    items: items,
                    iconEnabledColor: global.aColor,
                    style: TextStyle(color: global.aColor, fontSize: 16.0),
                    value: _dropdownValue,
                    onChanged: (String? value) {
                      if (value is String) {
                        setState(() {
                          _dropdownValue = value;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: kVertSpacing),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Venue',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: global.aColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kVertSpacing),
                MyTextField(
                  textColor: global.aColor,
                  controller: locationController,
                  obscureText: false,
                  hintText: 'Venue/location name',
                  validateField: (String? venue) {},
                ),
                SizedBox(height: kVertSpacing),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        'Instructor',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: global.aColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kVertSpacing),
                MyTextField(
                  textColor: global.aColor,
                  controller: instructorController,
                  obscureText: false,
                  hintText: 'Instructor/teacher name',
                  validateField: (String? password) {},
                ),
                SizedBox(height: kVertSpacing),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        _dropdownValue == 'Class' ? 'Start Date' : 'Date',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: global.aColor),
                      ),
                    ),
                    if (_dropdownValue == 'Class')
                      Padding(
                        padding: const EdgeInsets.only(left: 107),
                        child: Text(
                          'End Date',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: global.aColor),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: kVertSpacing),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: SizedBox(
                        width: 160,
                        height: 45,
                        child: TextFormField(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.utc(2010, 10, 16),
                              lastDate: DateTime.utc(2090, 10, 16),
                              builder: (BuildContext context, Widget? child) {
                                if (provider.isDarkMode) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      primaryColor: global.aColor,
                                      accentColor: global.aColor,
                                      colorScheme: ColorScheme.dark(
                                          primary: global.aColor),
                                      buttonTheme: const ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary),
                                    ),
                                    child: child!,
                                  );
                                } else {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor: global.aColor,
                                      accentColor: global.aColor,
                                      colorScheme: ColorScheme.light(
                                          primary: global.aColor),
                                      buttonTheme: const ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary),
                                    ),
                                    child: child!,
                                  );
                                }
                              },
                            );
                            if (selectedDate != null) {
                              setState(() {
                                startDateController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(selectedDate);
                              });
                            }
                          },
                          cursorColor: global.aColor,
                          style: TextStyle(color: global.aColor),
                          controller: startDateController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            icon: Icon(Icons.calendar_today_sharp,
                                color: global.aColor),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            hintText: 'yyyy-mm-dd',
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: (String? date) {
                            if (date!.isEmpty) {
                              return 'Date is empty';
                            } else {
                              if (!RegExp(r'^\d{4}-\d{2}-\d{2}$')
                                  .hasMatch(date)) {
                                return 'Invalid date';
                              }
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    if (_dropdownValue == 'Class')
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: SizedBox(
                          width: 160,
                          height: 45,
                          child: TextFormField(
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.utc(2010, 10, 16),
                                lastDate: DateTime.utc(2090, 10, 16),
                                builder: (BuildContext context, Widget? child) {
                                  if (provider.isDarkMode) {
                                    return Theme(
                                      data: ThemeData.dark().copyWith(
                                        primaryColor: global.aColor,
                                        accentColor: global.aColor,
                                        colorScheme: ColorScheme.dark(
                                            primary: global.aColor),
                                        buttonTheme: const ButtonThemeData(
                                            textTheme: ButtonTextTheme.primary),
                                      ),
                                      child: child!,
                                    );
                                  } else {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        primaryColor: global.aColor,
                                        accentColor: global.aColor,
                                        colorScheme: ColorScheme.light(
                                            primary: global.aColor),
                                        buttonTheme: const ButtonThemeData(
                                            textTheme: ButtonTextTheme.primary),
                                      ),
                                      child: child!,
                                    );
                                  }
                                },
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  endDateController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedDate);
                                });
                              }
                            },
                            cursorColor: global.aColor,
                            style: TextStyle(color: global.aColor),
                            controller: endDateController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(5),
                              icon: Icon(Icons.calendar_today_sharp,
                                  color: global.aColor),
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              hintText: 'yyyy-mm-dd',
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            validator: (String? date) {
                              if (date!.isEmpty) {
                                return 'Date is empty';
                              } else {
                                if (!RegExp(r'^\d{4}-\d{2}-\d{2}$')
                                    .hasMatch(date)) {
                                  return 'Invalid date';
                                }
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: kVertSpacing),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Day and Time(s)',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: global.aColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kVertSpacing),
                Row(
                  children: [
                    if (_dropdownValue != 'Event')
                      Container(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        height: 45,
                        width: 167,
                        child: DropdownButtonFormField(
                          dropdownColor: global.bColor,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          items: days,
                          iconEnabledColor: global.aColor,
                          style:
                              TextStyle(color: global.aColor, fontSize: 16.0),
                          value: _dayValue,
                          onChanged: (String? value) {
                            if (value is String) {
                              setState(() {
                                _dayValue = value;
                              });
                            }
                          },
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: _dropdownValue == 'Class' ? 3 : 15, right: 17),
                      child: MultiSelectBottomSheetField(
                        buttonIcon: Icon(
                          Icons.arrow_drop_down,
                          color: global.aColor,
                        ),
                        /*validator: (List<dynamic>? value) {
                          if (value!.isEmpty) {
                            setState(() {
                              timeError = true;
                            });
                            return 'Select atleast one time';
                          } else {
                            setState(() {
                              timeError = false;
                            });
                            return null;
                          }
                        },*/
                        selectedColor: Colors.black87.withOpacity(0.70),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        initialChildSize: 0.4,
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        buttonText: Text("Time(s)",
                            style:
                                TextStyle(fontSize: 16, color: global.aColor)),
                        title: const Text(
                          "Time(s)",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        items: times,
                        onConfirm: (values) {
                          selectedTimes =
                              values.map((e) => e.toString()).toList();
                        },
                        chipDisplay: MultiSelectChipDisplay.none(),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: global.aColor,
                            backgroundColor: global.bColor.withOpacity(0.0001),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(color: global.cColor, width: 1.5),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 0 // Text color
                            ),
                        onPressed: () {
                          // Code for navigating to create/manage timetable screen
                          if (addedDays.length < 7 &&
                              selectedTimes.isNotEmpty) {
                            setState(() {
                              addedDays.add(_dayValue);
                              activity.timeOfDayMap[_dayValue] =
                                  selectedTimes.map((timeString) {
                                DateTime dateTime =
                                    DateFormat('HH:mm').parse(timeString);
                                return TimeOfDay.fromDateTime(dateTime);
                              }).toList();
                            });
                          }

                          if (selectedTimes.isEmpty) {
                            showMessage(
                                'Please select time(s) for $_dropdownValue',
                                'Select time');
                          }
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(
                              color: global.aColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                /*if (timeError == true)
                  const SizedBox(
                    height: 5,
                  ),
                if (timeError == false)
                  const SizedBox(
                    height: 22,
                  ),*/
                SizedBox(height: 10),
                SizedBox(
                  height: 55,
                  width: MediaQuery.of(context).size.width - 37,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      AddedItemList(
                          itemTitles: addedDays,
                          timeOfDayMap: activity.timeOfDayMap),
                    ],
                  ),
                ),
                SizedBox(
                  height: kVertSpacing,
                ),
                SizedBox(
                  height: 40,
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: global.aColor,
                      backgroundColor: darkMode
                          ? global.bColor.withOpacity(0.25)
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: global.aColor),
                        borderRadius: BorderRadius.circular(15),
                      ), // Text color
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_dropdownValue == 'Class') {
                          activity.title = titleController.text;
                          activity.location = locationController.text;
                          activity.instructor = instructorController.text;
                          activity.type = _dropdownValue!;
                          activity.startDate =
                              DateTime.parse(startDateController.text);
                          activity.endDate =
                              DateTime.parse(endDateController.text);
                          List<Activity> activities = provider.activityList;
                          activities.add(activity);
                          activity = Activity('', '', '', {}, '', DateTime.utc(2000, 10, 16),
                              DateTime.utc(2090, 10, 16));
                          await TimetableFile().saveActivities(activities);
                          provider.updateActivityList(activities);
                          showMessage('$_dropdownValue was successfully added',
                              'Added $_dropdownValue');
                        } else {
                          activity.title = titleController.text;
                          activity.location = locationController.text;
                          activity.instructor = instructorController.text;
                          activity.type = _dropdownValue!;
                          activity.startDate =
                              DateTime.parse(startDateController.text);
                          activity.endDate =
                              DateTime.parse(startDateController.text);
                          activity.timeOfDayMap =
                              replaceKeysInTimeOfDayMap(activity);
                          List<Activity> activities = provider.activityList;
                          activities.add(activity);
                          activity = Activity('', '', '', {}, '', DateTime.utc(2000, 10, 16),
                              DateTime.utc(2090, 10, 16));
                          await TimetableFile().saveActivities(activities);
                          provider.updateActivityList(activities);
                          showMessage('$_dropdownValue was successfully added',
                              'Added $_dropdownValue');
                        }
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 16, color: global.aColor),
                    ),
                  ),
                ),
              ],
            ),
          )),
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

  Map<String, List<TimeOfDay>> replaceKeysInTimeOfDayMap(Activity activity) {
    Map<String, List<TimeOfDay>> newTimeOfDayMap = {};

    activity.timeOfDayMap.forEach((key, value) {
      String newKey =
          daysOfWeek[DateTime.parse(startDateController.text).weekday - 1];
      newTimeOfDayMap[newKey] = value;
    });

    return newTimeOfDayMap;
  }
}
