import 'dart:async';
import 'package:care_connect/UI/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:care_connect/DB/database_helper.dart'; // Import your database helper
import 'package:permission_handler/permission_handler.dart'; // Import permission handler
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await _requestNotificationPermission(); // Request notification permission
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const LandingPage(),
    );
  }
}

// Function to request notification permission
Future<void> _requestNotificationPermission() async {
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
}

// Function to add an alarm entry to the database
Future<void> addAlarmEntry(
    AlarmSettings alarmSettings, bool manuallyTurnedOff) async {
  final dbHelper = DatabaseHelper();
  final DateFormat timeFormat =
      DateFormat('hh:mm a'); // 12-hour format with AM/PM
  final alarmEntry = {
    'id': alarmSettings.id,
    'title': alarmSettings.notificationSettings.title,
    'type': 'alarm',
    // Assuming type is 'alarm' for this example
    'time': timeFormat.format(alarmSettings.dateTime),
    // Format time to 12-hour clock
    'date': alarmSettings.dateTime.toIso8601String().split('T')[0],
    // Extract date part
    'manuallyTurnedOff': manuallyTurnedOff ? true : false,
    // Store as integer (1 for true, 0 for false)
  };
  await dbHelper.insertAlarmEntry(alarmEntry);
  print('Alarm entry added: $alarmEntry'); // Debugging statement
}


