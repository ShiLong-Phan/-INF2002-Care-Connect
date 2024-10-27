import 'dart:async';
import 'dart:math';
import 'package:care_connect/UI/appointment_details.dart';
import 'package:care_connect/UI/medication_details.dart';
import 'package:care_connect/UI/past_alarms.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import '../DB/database_helper.dart';
import 'package:alarm/alarm.dart';
import 'package:care_connect/UI/ring_screen.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<AlarmSettings> alarms = [];
  static StreamSubscription<AlarmSettings>? ringSubscription;
  static StreamSubscription<int>? updateSubscription;

  @override
  void initState() {
    super.initState();
    loadAlarms();
    ringSubscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
    updateSubscription ??= Alarm.updateStream.stream.listen((_) {
      loadAlarms();
    });
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => RingScreen(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Care\nConnect',
                    style: TextStyle(fontSize: 58),
                    textAlign: TextAlign.center),
              ],
            ),
            SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    MedicationDetailButton(),
                    SizedBox(height: 28),
                    AppointmentDetailButton(),
                    SizedBox(height: 28),
                    PastActivityButton(),
                    SizedBox(height: 28),
                    TestAlarmButton(), // New button to test the alarm
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationDetailButton extends StatelessWidget implements PreferredSizeWidget {
  const MedicationDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 75),
        backgroundColor: Colors.indigo,
        padding: const EdgeInsets.all(0),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MedicationDetails()),
        );
      },
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(FontAwesome5.pills, color: Colors.white),
        SizedBox(width: 15),
        CustomButtonText(title: 'Medications')
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppointmentDetailButton extends StatelessWidget implements PreferredSizeWidget {
  const AppointmentDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 75),
        backgroundColor: Colors.indigo,
        padding: const EdgeInsets.all(0),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AppointmentDetails()),
        );
      },
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(FontAwesome5.hospital, color: Colors.white),
        SizedBox(width: 15),
        CustomButtonText(title: 'Appointments')
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PastActivityButton extends StatelessWidget implements PreferredSizeWidget {
  const PastActivityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 75),
        backgroundColor: Colors.indigo,
        padding: const EdgeInsets.all(0),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PastAlarm()),
        );
      },
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(FontAwesome5.clock, color: Colors.white),
        SizedBox(width: 15),
        CustomButtonText(title: 'Past Activities')
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TestAlarmButton extends StatelessWidget implements PreferredSizeWidget {
  const TestAlarmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 75),
        backgroundColor: Colors.indigo,
        padding: const EdgeInsets.all(0),
      ),
      onPressed: () {
        // Schedule a test alarm
        final randomId = Random().nextInt(1000) + 1000;
        scheduleAlarm(randomId, DateTime.now().add(const Duration(seconds: 5)), 'This is a test alarm');
      },
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(FontAwesome5.bell, color: Colors.white),
        SizedBox(width: 15),
        CustomButtonText(title: 'Test Alarm')
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomButtonText extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomButtonText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, color: Colors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Function to schedule alarms
void scheduleAlarms() async {
  final dbHelper = DatabaseHelper();

  // Fetch reminders
  final reminders = await dbHelper.getReminders();
  for (var reminder in reminders) {
    final id = reminder['id'];
    final name = reminder['name'];
    final dosage = reminder['dosage'];
    final time = reminder['time'];
    final scheduledTime = DateTime.parse(time); // Assuming time is stored in ISO 8601 format
    final body = 'Reminder: $name, Dosage: $dosage';

    scheduleAlarm(id, scheduledTime, body);
  }

  // Fetch appointments
  final appointments = await dbHelper.getAppointments();
  for (var appointment in appointments) {
    final id = appointment['id'];
    final name = appointment['name'];
    final location = appointment['location'];
    final date = appointment['date'];
    final time = appointment['time'];
    final note = appointment['note'];
    final scheduledTime = DateTime.parse('$date $time'); // Assuming date and time are stored separately
    final body = 'Appointment: $name, Location: $location, Note: $note';

    scheduleAlarm(id, scheduledTime, body);
  }
}

void scheduleAlarm(int id, DateTime scheduledTime, String body) {
  final alarmSettings = AlarmSettings(
    id: id,
    dateTime: scheduledTime,
    assetAudioPath: 'assets/alarm.mp3', // Ensure you have an audio file at this path
    loopAudio: true,
    vibrate: true,
    volume: 0.8,
    fadeDuration: 3.0,
    warningNotificationOnKill: Platform.isIOS,
    androidFullScreenIntent: true,
    notificationSettings: NotificationSettings(
      icon: 'mipmap/ic_launcher',
      title: 'Alarm',
      body: body,
      stopButton: ('Stop') ,
    ),
  );

  Alarm.set(alarmSettings: alarmSettings);
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
    'manuallyTurnedOff': manuallyTurnedOff ? true : false, // Store as integer (1 for true, 0 for false)
  };
  await dbHelper.insertAlarmEntry(alarmEntry);
  print('Alarm entry added: $alarmEntry'); // Debugging statement
}