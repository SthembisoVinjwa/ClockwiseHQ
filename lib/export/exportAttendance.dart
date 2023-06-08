import 'package:clockwisehq/export/pdfapi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:clockwisehq/global/global.dart' as global;

import '../provider/provider.dart';

class ExportAttendance extends StatefulWidget {
  final file;

  const ExportAttendance({Key? key, required this.file}) : super(key: key);

  @override
  State<ExportAttendance> createState() => _ExportAttendanceState();
}

class _ExportAttendanceState extends State<ExportAttendance> {
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

    return Container(
        color: global.bColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SfPdfViewer.file(widget.file),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
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
                    print('Saved: ${PdfApi.saveDocument(widget.file)}');
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ));
  }
}
