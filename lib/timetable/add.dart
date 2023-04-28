import 'package:clockwisehq/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

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
  String? _dropdownValue;
  bool set = false;
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

  List<MultiSelectItem<String>> daysOfWeek = [
    MultiSelectItem('Mon', 'Mon'),
    MultiSelectItem('Tue', 'Tue'),
    MultiSelectItem('Wed', 'Wed'),
    MultiSelectItem('Thu', 'Thu'),
    MultiSelectItem('Fri', 'Fri'),
    MultiSelectItem('Sat', 'Sat'),
    MultiSelectItem('Sun', 'Sun'),
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

  List<MultiSelectItem<String>> times = timesOfDay
      .map((e) => MultiSelectItem('${e.hour}:00', '${e.hour}:00'))
      .toList();

  List<String> selectedDays = [];
  List<String> selectedTimes = [];

  @override
  Widget build(BuildContext context) {
    if (set == false) {
      _dropdownValue = 'Class';
      set = true;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          elevation: 1.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            "Add Class/Event",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(5.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Title',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 70,
                  child: MyTextField(
                    controller: titleController,
                    obscureText: false,
                    hintText: 'Class/event title',
                    validateField: (String? password) {
                      if (password!.length < 6) {
                        return 'Password length must be greater than 6';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Type',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  height: 45,
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        filled: true,
                        fillColor: Colors.white),
                    items: items,
                    iconEnabledColor: Colors.indigoAccent,
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
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
                const SizedBox(height: 22),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Venue',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 70,
                  child: MyTextField(
                    controller: locationController,
                    obscureText: false,
                    hintText: 'Venue/location name',
                    validateField: (String? password) {
                      if (password!.length < 6) {
                        return 'Password length must be greater than 6';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Instructor',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 70,
                  child: MyTextField(
                    controller: instructorController,
                    obscureText: false,
                    hintText: 'Instructor/teacher name',
                    validateField: (String? password) {
                      if (password!.length < 6) {
                        return 'Password length must be greater than 6';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        _dropdownValue == 'Class' ? 'Start Date' : 'Date',
                        style: const TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (_dropdownValue == 'Class')
                      const Padding(
                        padding: EdgeInsets.only(left: 107),
                        child: Text(
                          'End Date',
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
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
                                lastDate: DateTime.utc(2090, 10, 16));
                            if (selectedDate != null) {
                              setState(() {
                                startDateController.text =
                                    DateFormat('yyyy-mm-dd')
                                        .format(selectedDate);
                              });
                            }
                          },
                          cursorColor: Colors.indigoAccent,
                          style: const TextStyle(color: Colors.black),
                          controller: startDateController,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(color: Colors.indigoAccent),
                            contentPadding: EdgeInsets.all(5),
                            icon: Icon(Icons.calendar_today_sharp),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            hintText: 'yyyy-mm-dd',
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
                          validator: (String? date) {
                            if (date!.isEmpty) {
                              return 'Date is empty';
                            } else {
                              if (!RegExp(r'^\d{4}-\d{2}-\d{2}$')
                                  .hasMatch(date)) {
                                return 'Incorrect date';
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
                                  lastDate: DateTime.utc(2090, 10, 16));
                              if (selectedDate != null) {
                                setState(() {
                                  endDateController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedDate);
                                });
                              }
                            },
                            cursorColor: Colors.indigoAccent,
                            style: const TextStyle(color: Colors.black),
                            controller: endDateController,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(color: Colors.indigoAccent),
                              contentPadding: EdgeInsets.all(5),
                              icon: Icon(Icons.calendar_today_sharp),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              hintText: 'yyyy-MM-dd',
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
                            validator: (String? date) {
                              if (date!.isEmpty) {
                                return 'Date is empty';
                              } else {
                                if (!RegExp(r'^\d{4}-\d{2}-\d{2}$')
                                    .hasMatch(date)) {
                                  return 'Incorrect date';
                                }
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                if (_dropdownValue == 'Class')
                  const SizedBox(height: 32),
                if (_dropdownValue == 'Event')
                  const SizedBox(height: 16),
                if (_dropdownValue == 'Class')
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 13),
                    child: MultiSelectBottomSheetField(
                      selectedColor: Colors.indigoAccent.withOpacity(0.4),
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
                      buttonText: const Text("Days of the week",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      title: const Text(
                        "Days",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      items: daysOfWeek,
                      onConfirm: (values) {
                        selectedDays = values.map((e) => e.toString()).toList();
                      },
                      chipDisplay: MultiSelectChipDisplay.none(),
                    ),
                  ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: MultiSelectBottomSheetField(
                    selectedColor: Colors.indigoAccent.withOpacity(0.4),
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
                    buttonText: const Text("Times",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                    title: const Text(
                      "Times",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    items: times,
                    onConfirm: (values) {
                      selectedTimes = values.map((e) => e.toString()).toList();
                    },
                    chipDisplay: MultiSelectChipDisplay.none(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                  width: 100,
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {}
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
