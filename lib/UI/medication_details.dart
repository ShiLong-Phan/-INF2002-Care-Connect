import 'package:care_connect/UI/appbar.dart';
import 'package:care_connect/UI/add_medication_reminder.dart';
import 'package:flutter/material.dart';

class MedicationDetails extends StatelessWidget {
  const MedicationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the list
    final List<Map<String, String>> medications = [
      {'name': 'Aspirin', 'dosage': '100mg', 'interval': '8 hours'},
      {'name': 'Ibuprofen', 'dosage': '200mg', 'interval': '12 hours'},
      {'name': 'Paracetamol', 'dosage': '500mg', 'interval': '6 hours'},
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
                return ListTile(
                  title: Text(medication['name']!),
                  subtitle: Text(
                      'Dosage: ${medication['dosage']} - Interval: ${medication['interval']}'),
                  onTap: () {
                    // Handle the tap event here
                    print('Tapped on ${medication['name']}');
                  },
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
