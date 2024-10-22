import 'package:care_connect/UI/add_appointment_reminder.dart';
import 'package:care_connect/UI/appbar.dart';
import 'package:flutter/material.dart';
import 'package:care_connect/DB/database_helper.dart';

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

                // Return a Card widget for each appointment
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display appointment name
                        Text(
                          appointment['name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        // Display appointment location
                        Text('Location: ${appointment['location']}'),
                        // Display appointment date
                        Text('Date: ${appointment['date']}'),
                        // Display appointment time
                        Text('Time: ${appointment['time']}'),
                      ],
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