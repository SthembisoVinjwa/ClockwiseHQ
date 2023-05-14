import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import 'package:clockwisehq/global/global.dart' as global;

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool allowNotifications = false;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: global.cColor,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      children: [
        ListTile(
          title: const Text('Dark mode'),
          trailing: Switch(
            activeTrackColor: Colors.grey,
            activeColor: Colors.black87,
            value: Provider.of<MainProvider>(context, listen: false).isDarkMode,
            onChanged: (bool value) {
              setState(() {
                Provider.of<MainProvider>(context, listen: false).updateMode(value);
              });
            },
          ),
        ),
        ListTile(
          title: Text('Allow notifications'),
          trailing: Switch(
            activeTrackColor: Colors.grey,
            activeColor: Colors.black87,
            value: allowNotifications,
            onChanged: (bool value) {
              setState(() {
                allowNotifications = value;
              });
            },
          ),
        ),
      ],
    );
  }
}