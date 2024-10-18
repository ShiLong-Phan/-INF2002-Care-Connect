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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Medication Reminder'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medication Name input field
            const Row(
              children: [
                Text('Medication\nName: '),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter medication name',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Dosage input field
            const Row(
              children: [
                Text('Dosage: '),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
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
                //Time Input field
                const Text('Time: '),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer(
                      child: TextField(
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [TimeTextInputFormatter()],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter interval in HH:MM max 24:00',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Description input field
            const Row(
              children: [
                Text('Description: '),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Example: For Stomachache',
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
                  minimumSize: const Size(200, 50),
                  backgroundColor: Colors.indigo,
                ),
                onPressed: () {
                  // Handle the button press
                },
                child: const Text(
                  'Set Medication',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
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
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length == 1 && int.tryParse(text) != null && int.parse(text) > 2) {
      return oldValue;
    } else if (text.length == 2 && int.tryParse(text) != null && int.parse(text) > 24) {
      return oldValue;
    } else if (text.length == 3 && text[2] != ':') {
      return TextEditingValue(
        text: '${text.substring(0, 2)}:${text.substring(2)}',
        selection: const TextSelection.collapsed(offset: 4),
      );
    } else if (text.length == 4 && int.tryParse(text.substring(3)) != null && int.parse(text.substring(3)) > 5) {
      return oldValue;
    } else if (text.length > 5) {
      return oldValue;
    }
    return newValue;
  }
}