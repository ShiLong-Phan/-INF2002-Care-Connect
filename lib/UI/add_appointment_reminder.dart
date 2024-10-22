import 'package:care_connect/UI/appbar.dart';
import 'package:flutter/material.dart';

import 'package:care_connect/DB/database_helper.dart';

class AddAppointmentReminder extends StatefulWidget {
  const AddAppointmentReminder({super.key});

  @override
  _AddAppointmentReminderState createState() => _AddAppointmentReminderState();
}

class _AddAppointmentReminderState extends State<AddAppointmentReminder> {
  // Controllers to handle text input for name, location, date, and time
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  // Function to show the date picker dialog and set the selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  // Function to show the time picker dialog and set the selected time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom app bar with the title 'Appointment Details'
      appBar: CustomAppBar(title: 'Appointment Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Row for name input field with label on the left
            Row(
              children: [
                const Text('Name: '),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter name',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Row for location input field with label on the left
            Row(
              children: [
                const Text('Location: '),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'E.g. 123 Tom Road',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Row for date input field with label on the left and date picker
            Row(
              children: [
                const Text('Date: '),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Select date',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Row for time input field with label on the left and time picker
            Row(
              children: [
                const Text('Time: '),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: timeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Select time HH:MM',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Save Appointment button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 75),
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                onPressed: () async {
                  // Collect the form data
                  final String name = nameController.text;
                  final String location = locationController.text;
                  final String date = dateController.text;
                  final String time = timeController.text;

                  // Save the data to the database
                  await DatabaseHelper().insertAppointment({
                    'name': name,
                    'location': location,
                    'date': date,
                    'time': time,
                  });

                  // Navigate back to the previous screen
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Save Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}