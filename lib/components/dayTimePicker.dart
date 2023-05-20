import 'package:flutter/material.dart';

class WeekdayTimePickerWidget extends StatefulWidget {
  final Map<String, TimeOfDay> timeOfDayMap;
  final void Function(String, TimeOfDay) onWeekdayTimeSelected;

  WeekdayTimePickerWidget({
    required this.timeOfDayMap,
    required this.onWeekdayTimeSelected,
  });

  @override
  _WeekdayTimePickerWidgetState createState() => _WeekdayTimePickerWidgetState();
}

class _WeekdayTimePickerWidgetState extends State<WeekdayTimePickerWidget> {
  String selectedWeekday = 'Mon';
  TimeOfDay? selectedTime;

  void _showTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
      widget.onWeekdayTimeSelected(selectedWeekday, pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: selectedWeekday,
          onChanged: (value) {
            setState(() {
              selectedWeekday = value!;
            });
          },
          items: widget.timeOfDayMap.keys.map((weekday) {
            return DropdownMenuItem<String>(
              value: weekday,
              child: Text(weekday),
            );
          }).toList(),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: _showTimePicker,
          child: Text(selectedTime != null ? selectedTime!.format(context) : 'Select Time'),
        ),
      ],
    );
  }
}


