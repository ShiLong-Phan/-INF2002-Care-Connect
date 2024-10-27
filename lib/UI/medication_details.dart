import 'package:care_connect/UI/add_medication_reminder.dart';
import 'package:care_connect/UI/appbar.dart';
import 'package:flutter/material.dart';
import 'package:care_connect/DB/database_helper.dart';

class MedicationDetails extends StatefulWidget {
  const MedicationDetails({super.key});

  @override
  _MedicationDetailsState createState() => _MedicationDetailsState();
}

class _MedicationDetailsState extends State<MedicationDetails> {
  List<Map<String, dynamic>> medications = [];

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    final data = await DatabaseHelper().getReminders();
    setState(() {
      medications = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Medication Details'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final medication = medications[index];

                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMedicationReminder(reminder: medication),
                      ),
                    );

                    if (result == true) {
                      _loadMedications();
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
                            medication['name'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text('Dosage: ${medication['dosage']}'),
                          Text('Interval: ${medication['interval']}'),
                          Text(
                            'Description: ${medication['description']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddMedicationReminder(),
                          ),
                        );

                        if (result == true) {
                          _loadMedications();
                        }
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}