import 'package:clockwisehq/screens/settingDialog.dart';
import 'package:clockwisehq/timetable/timetable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';
import 'package:clockwisehq/global/global.dart' as global;

class ViewTimetable extends StatefulWidget {
  const ViewTimetable({Key? key}) : super(key: key);

  @override
  State<ViewTimetable> createState() => _ViewTimetableState();
}

class _ViewTimetableState extends State<ViewTimetable> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);

    if (provider.isDarkMode == true) {
      global.aColor = Colors.white;
      global.bColor = Colors.black87;
    } else {
      global.bColor = Colors.white;
      global.aColor = Colors.black87;
    }

    return Scaffold(
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
              "View Timetable",
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
      body: const Timetable(),
    );
  }
}
