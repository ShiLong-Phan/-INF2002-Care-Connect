import 'dart:async';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:intl/intl.dart';
import '../DB/database_helper.dart';

class RingScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const RingScreen({Key? key, required this.alarmSettings}) : super(key: key);

  @override
  _RingScreenState createState() => _RingScreenState();
}

class _RingScreenState extends State<RingScreen> {
  final DateFormat timeFormat = DateFormat('hh:mm a'); // 12-hour format with AM/PM
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoStopTimer();
  }

  void _startAutoStopTimer() {
    _timer = Timer(const Duration(seconds: 15), () async {
      addAlarmEntry(widget.alarmSettings, false);
      await Alarm.stop(widget.alarmSettings.id);
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Ringing'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Alarm Time: ${timeFormat.format(widget.alarmSettings.dateTime)}\n${widget.alarmSettings.dateTime.toIso8601String().split('T')[0]}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Title: ${widget.alarmSettings.notificationSettings.title}',
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Message: ${widget.alarmSettings.notificationSettings.body}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  _timer?.cancel();
                  addAlarmEntry(widget.alarmSettings, true);
                  await Alarm.stop(widget.alarmSettings.id);
                  Navigator.of(context).pop();
                },
                child: const Text('Stop Alarm'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> addAlarmEntry(AlarmSettings alarmSettings, bool manuallyTurnedOff) async {
  final dbHelper = DatabaseHelper();
  final DateFormat timeFormat = DateFormat('hh:mm a'); // 12-hour format with AM/PM
  final alarmEntry = {
    'id': alarmSettings.id,
    'title': alarmSettings.notificationSettings.title,
    'type': 'alarm', // Assuming type is 'alarm' for this example
    'time': timeFormat.format(alarmSettings.dateTime), // Format time to 12-hour clock
    'date': alarmSettings.dateTime.toIso8601String().split('T')[0], // Extract date part
    'manuallyTurnedOff': manuallyTurnedOff ? 1 : 0, // Store as integer (1 for true, 0 for false)
  };
  await dbHelper.insertAlarmEntry(alarmEntry);
  print('Alarm entry added: $alarmEntry'); // Debugging statement
}