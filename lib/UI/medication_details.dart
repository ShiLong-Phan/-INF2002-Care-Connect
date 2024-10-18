import 'package:care_connect/UI/appbar.dart';
import 'package:care_connect/UI/add_medication_reminder.dart';
import 'package:flutter/material.dart';

class MedicationDetails extends StatelessWidget {
  const MedicationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the list
    final List<Map<String, String>> medications = [
      {
        'name': 'Aspirin',
        'dosage': '100mg',
        'interval': '8 hours',
        'usage': 'Used to reduce pain, fever, or inflammation.'
      },
      {
        'name': 'Ibuprofen',
        'dosage': '200mg',
        'interval': '12 hours',
        'usage': 'Used to relieve pain from various conditions such as headache, dental pain, menstrual cramps, muscle aches, or arthritis.'
      },
      {
        'name': 'Paracetamol',
        'dosage': '500mg',
        'interval': '6 hours',
        'usage': 'Used to treat mild to moderate pain and reduce fever.'
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(title: 'Medication Details'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final medication = medications[index];

                // Return a Card widget for each medication
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display medication name
                        Text(
                          medication['name']!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        // Display medication dosage
                        Text('Dosage: ${medication['dosage']}'),
                        // Display medication interval
                        Text('Interval: ${medication['interval']}'),
                        // Display medication usage/description with truncation
                        Text(
                          'Usage: ${medication['usage']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                        // Navigate to add medication reminder screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddMedicationReminder()),
                        );
                      },
                      child: const Text(
                        'Add Medication Reminder',
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