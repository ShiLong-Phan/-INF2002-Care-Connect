import 'package:care_connect/UI/appbar.dart';
import 'package:flutter/material.dart';

class AppointmentDetails extends StatelessWidget {
  const AppointmentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the list
    final List<Map<String, String>> appointments = [
      {'name': 'Doctor Smith', 'location': 'Clinic A', 'date': '2023-10-01', 'time': '10:00 AM'},
      {'name': 'Dentist John', 'location': 'Dental Care', 'date': '2023-10-05', 'time': '02:00 PM'},
      {'name': 'Therapist Jane', 'location': 'Wellness Center', 'date': '2023-10-10', 'time': '11:00 AM'},
    ];

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
                          appointment['name']!,
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
                      onPressed: () {
                        // Navigate to add appointment screen
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