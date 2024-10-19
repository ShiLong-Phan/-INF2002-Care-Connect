import 'package:care_connect/UI/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddMedicationReminder extends StatefulWidget {
  const AddMedicationReminder({super.key});

  @override
  _AddMedicationReminderState createState() => _AddMedicationReminderState();
}

class _AddMedicationReminderState extends State<AddMedicationReminder> {
  File? _image; // Variable to store the selected image
  TimeOfDay? _selectedTime; // Variable to store the selected time

  // Controllers to handle text input for medication name, dosage, interval, description, and time
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController intervalController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to show the time picker dialog and set the selected time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        timeController.text = _selectedTime!.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'New Medication Reminder'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medication Name input field
            Row(
              children: [
                const Text('Medication\nName: '),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter medication name',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Dosage input field
            Row(
              children: [
                const Text('Dosage: '),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: dosageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'e.g. 100mg, 1 tablet, 50ml',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Time input field with time picker
            Row(
              children: [
                const Text('Start Time: '),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: timeController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: _selectedTime != null
                              ? _selectedTime!.format(context)
                              : 'Enter time in HH:MM',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Interval input field with custom formatter
            Row(
              children: [
                const Text('Interval: '),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: intervalController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [TimeTextInputFormatter()],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'HH:MM max 24:00',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Description input field
            Row(
              children: [
                const Text('Description: '),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'For Gastric',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Image picker
            Row(
              children: [
                const Text('Image: '),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _image == null
                          ? const Center(child: Text('Tap to select image'))
                          : Image.file(_image!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Set Medication button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 75),
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                onPressed: () {
                  // Handle the button press
                  // Collect the form data
                  final String medicationName = nameController.text;
                  final String dosage = dosageController.text;
                  final String interval = intervalController.text;
                  final String description = descriptionController.text;
                  final String time = timeController.text;

                  // Print the collected data
                  print('Medication Name: $medicationName');
                  print('Dosage: $dosage');
                  print('Interval: $interval');
                  print('Description: $description');
                  print('Time: $time');
                  print('Image: ${_image?.path ?? 'No image selected'}');

                  Navigator.pop(context);
                },
                child: const Text(
                  'Set Medication',
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

// Custom input formatter for time in HH:MM format
class TimeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length == 1 && int.tryParse(text) != null && int.parse(text) > 2) {
      return oldValue;
    } else if (text.length == 2 &&
        int.tryParse(text) != null &&
        int.parse(text) > 24) {
      return oldValue;
    } else if (text.length == 3 && text[2] != ':') {
      return TextEditingValue(
        text: '${text.substring(0, 2)}:${text.substring(2)}',
        selection: const TextSelection.collapsed(offset: 4),
      );
    } else if (text.length == 4 &&
        int.tryParse(text.substring(3)) != null &&
        int.parse(text.substring(3)) > 5) {
      return oldValue;
    } else if (text.length > 5) {
      return oldValue;
    }
    return newValue;
  }
}