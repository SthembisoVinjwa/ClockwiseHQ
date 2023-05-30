import 'package:clockwisehq/screens/settingDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clockwisehq/global/global.dart' as global;
import '../attendance/attendance.dart';
import '../provider/provider.dart';

class AttendanceMarking extends StatelessWidget {
  const AttendanceMarking({Key? key}) : super(key: key);

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
              "Attendance Marking",
              style: TextStyle(fontSize: 18.0, color: global.aColor),
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
      body: const Attendance(),
    );
  }
}
