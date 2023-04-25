import 'package:clockwisehq/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    if (set == false) {
      _dropdownValue = 'Class';
      set = true;
    }
    return Scaffold(
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
        padding: EdgeInsets.all(5.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    const Text('Title', style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 12),
                MyTextField(
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
                const SizedBox(height: 12),
                Row(
                  children: const [
                    SizedBox(width: 15,),
                    Text('Type', style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  height: 60,
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        filled: true,
                        fillColor: Colors.white),
                    items: items,
                    iconEnabledColor: Colors.indigoAccent,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0
                    ),
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    const Text('Venue', style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 12),
                MyTextField(
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    const Text('Instructor', style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 12),
                MyTextField(
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    const Text('Start Date', style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),),
                    SizedBox(width: 102,),
                    const Text('End Date', style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    Container(
                      width: 160,
                      child: TextFormField(
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.utc(2010, 10, 16),
                              lastDate: DateTime.utc(2090, 10, 16));
                          if (selectedDate != null) {
                            setState(() {
                              startDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                            });
                          }
                        },
                        cursorColor: Colors.indigoAccent,
                        style: TextStyle(color: Colors.grey),
                        controller: startDateController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today_sharp),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          hintText: 'yyyy-MM-dd',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey,
                                width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(
                                10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey,
                                width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(
                                10.0)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey,
                                width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(
                                10.0)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey,
                                width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(
                                10.0)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 25,),
                    Container(
                      width: 160,
                      child: TextFormField(
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.utc(2010, 10, 16),
                              lastDate: DateTime.utc(2090, 10, 16));
                          if (selectedDate != null) {
                            setState(() {
                              endDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                            });
                          }
                        },
                        cursorColor: Colors.indigoAccent,
                        style: TextStyle(color: Colors.grey),
                        controller: endDateController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today_sharp),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          hintText: 'yyyy-MM-dd',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey,
                                width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(
                                10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey,
                                width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(
                                10.0)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey,
                                width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(
                                10.0)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey,
                                width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(
                                10.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                /*ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {

                    }
                  },
                  child: Text('Register'),
                ),*/
              ],
            )
        ),
      ),
    );
  }
}
