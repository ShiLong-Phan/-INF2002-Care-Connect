import 'package:care_connect/UI/add_appointment_reminder.dart';
import 'package:care_connect/UI/appbar.dart';
import 'package:flutter/material.dart';
import 'package:care_connect/DB/database_helper.dart';
import 'package:alarm/alarm.dart'; // Import for AlarmSettings
import 'package:intl/intl.dart'; // Import for DateFormat

class AppointmentDetails extends StatefulWidget {
  const AppointmentDetails({super.key});

  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final data = await DatabaseHelper().getAppointments();
    setState(() {
      appointments = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Appointment Details'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];

                return GestureDetector(
                  onTap: () async {
                    // Navigate to add appointment screen with appointment data
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddAppointmentReminder(appointment: appointment),
                      ),
                    );

                    // If the result is true, refresh the appointments list
                    if (result == true) {
                      _loadAppointments();
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment['name'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text('Location: ${appointment['location']}'),
                          Text('Date: ${appointment['date']}'),
                          Text('Time: ${appointment['time']}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 75),
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      onPressed: () async {
                        // Navigate to add appointment screen and wait for the result
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddAppointmentReminder()),
                        );

                        // If the result is true, refresh the appointments list
                        if (result == true) {
                          _loadAppointments();
                        }
                      },
                      child: const Text(
                        'Add Appointment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Add some space from the bottom
              ],
            ),
          ),
        ],
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
    'manuallyTurnedOff': manuallyTurnedOff ? true : false, // Store as integer (1 for true, 0 for false)
  };
  await dbHelper.insertAlarmEntry(alarmEntry);
  print('Alarm entry added: $alarmEntry'); // Debugging statement
}