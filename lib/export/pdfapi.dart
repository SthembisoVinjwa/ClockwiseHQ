import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' as pwTable;
import 'package:permission_handler/permission_handler.dart';

import '../attendance/entry.dart';

class PdfApi {
  Future<String> saveToDownloads(File file) async {
    // Request permission
    final PermissionStatus status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Permission denied');
    }

    // Get the platform-specific downloads directory
    final directory = Platform.isAndroid
        ? Directory('/storage/emulated/0/Download/')
        : await getDownloadsDirectory();

    // Create a new file in the downloads directory
    final String fileName = 'Attendance_report.pdf';
    final String filePath = '${directory!.path}/$fileName';

    final File newFile = await file.copy(filePath);

    return newFile.path;
  }

  static Future<File> exportAttendanceEntries(List<AttendanceEntry> entries) async {
    final pdf = pw.Document();

    // Define table headers
    final headers = ['Date', 'Time', 'Class/Event', 'Attendance'];

    // Calculate the maximum number of rows per page
    final maxRowsPerPage = 25;

    // Split the entries into multiple pages
    final pagesCount = (entries.length / maxRowsPerPage).ceil();

    for (var pageIndex = 0; pageIndex < pagesCount; pageIndex++) {
      final startIndex = pageIndex * maxRowsPerPage;
      final endIndex = (pageIndex + 1) * maxRowsPerPage;

      // Ensure the endIndex is within the bounds of the entries list
      final pageEntries = entries.sublist(startIndex, endIndex.clamp(0, entries.length));

      // Create a list of rows for the table
      final tableRows = pageEntries.map((entry) {
        final time = entry.time;
        String nextHour = ((time.hour + 1) % 24).toString();
        return [
          formatDate(entry.date),
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} - ${nextHour.padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
          entry.activity.title,
          entry.attendance ? 'Present' : 'Absent',
        ];
      }).toList();

      // Create a table widget
      final table = pwTable.Table.fromTextArray(
        headers: headers,
        data: tableRows,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
        border: pw.TableBorder.all(width: 1, color: PdfColors.grey),
        headerHeight: 30,
        cellHeight: 25,
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerLeft,
          3: pw.Alignment.centerLeft,
        },
      );

      // Add the table to the PDF document
      pdf.addPage(pw.Page(build: (context) => pw.Center(child: table)));
    }

    // Save the PDF document to a file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/attendance_report.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();

    return "$day/$month/$year";
  }
}