import 'package:care_connect/UI/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:care_connect/DB/database_helper.dart';
import 'package:alarm/alarm.dart';

class AddMedicationReminder extends StatefulWidget {
  final Map<String, dynamic>? reminder;

  const AddMedicationReminder({super.key, this.reminder});

  @override
  _AddMedicationReminderState createState() => _AddMedicationReminderState();
}

class _AddMedicationReminderState extends State<AddMedicationReminder> {
  File? _image;
  TimeOfDay? _selectedTime;

  late TextEditingController nameController;
  late TextEditingController dosageController;
  late TextEditingController intervalController;
  late TextEditingController descriptionController;
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.reminder?['name'] ?? '');
    dosageController = TextEditingController(text: widget.reminder?['dosage'] ?? '');
    intervalController = TextEditingController(text: widget.reminder?['interval'] ?? '');
    descriptionController = TextEditingController(text: widget.reminder?['description'] ?? '');
    timeController = TextEditingController(text: widget.reminder?['time'] ?? '');
    if (widget.reminder?['image'] != null) {
      _image = File(widget.reminder!['image']);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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

  Future<void> _deleteReminder() async {
    if (widget.reminder != null) {
      await DatabaseHelper().deleteReminder(widget.reminder!['id']);
      await Alarm.stop(widget.reminder!['id']);
      Navigator.pop(context, true);
    }
  }

  Future<void> _updateReminder() async {
    final String medicationName = nameController.text;
    final String dosage = dosageController.text;
    final String interval = intervalController.text;
    final String description = descriptionController.text;
    final String time = timeController.text;
    final String imagePath = _image?.path ?? '';

    final reminderData = {
      'name': medicationName,
      'dosage': dosage,
      'interval': interval,
      'description': description,
      'time': time,
      'image': imagePath,
    };

    String body = 'Type: Medication\nDosage: $dosage\nInterval: $interval\nDescription: $description';
    String formattedTime = convertTo24HourFormat(time);
    String formattedDate = DateTime.now().toString().split(' ')[0] + "T" + formattedTime + ":00";
    DateTime setDateTime = DateTime.parse(formattedDate);

    if (widget.reminder != null) {
      reminderData['id'] = widget.reminder!['id'].toString();
      await DatabaseHelper().updateReminder(reminderData);
      await Alarm.stop(widget.reminder!['id']);
      await Alarm.set(alarmSettings: AlarmSettings(
        id: widget.reminder!['id'],
        dateTime: setDateTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        volume: 0.8,
        fadeDuration: 3.0,
        notificationSettings: NotificationSettings(
            icon: 'mipmap/ic_launcher',
            title: medicationName,
            body: body,
            stopButton: ('Stop Alarm')
        ),
      ));
    } else {
      final id = await DatabaseHelper().insertReminder(reminderData);
      await Alarm.set(alarmSettings: AlarmSettings(
        id: id,
        dateTime: setDateTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        volume: 0.8,
        fadeDuration: 3.0,
        notificationSettings: NotificationSettings(
            icon: 'mipmap/ic_launcher',
            title: medicationName,
            body: body,
            stopButton: ('Stop Alarm')
        ),
      ));
    }

    Navigator.pop(context, true);
  }

  Future<void> _showConfirmationDialog(String action) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text('Are you sure you want to $action this reminder?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                if (action == 'delete') {
                  _deleteReminder();
                } else {
                  _updateReminder();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Medication Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 60),
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  onPressed: () => _showConfirmationDialog(widget.reminder != null ? 'update' : 'set'),
                  child: Text(
                    widget.reminder != null ? 'Update Medication' : 'Set Medication',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (widget.reminder != null)
                  const SizedBox(width: 10), // Add space between buttons
                if (widget.reminder != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(140, 60),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    onPressed: () => _showConfirmationDialog('delete'),
                    child: const Text(
                      'Delete Medication',
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
    );
  }
}

String convertTo24HourFormat(String time12h) {
  final RegExp timeRegExp = RegExp(r'(\d+):(\d+) (\w+)');
  final Match? match = timeRegExp.firstMatch(time12h);

  if (match != null) {
    int hour = int.parse(match.group(1)!);
    final int minute = int.parse(match.group(2)!);
    final String period = match.group(3)!.toUpperCase();

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  throw FormatException('Invalid time format');
}

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