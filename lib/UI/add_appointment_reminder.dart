import 'package:care_connect/UI/appbar.dart';
import 'package:flutter/material.dart';
import 'package:care_connect/DB/database_helper.dart';
import 'package:alarm/alarm.dart';

class AddAppointmentReminder extends StatefulWidget {
  final Map<String, dynamic>? appointment;

  const AddAppointmentReminder({Key? key, this.appointment}) : super(key: key);

  @override
  _AddAppointmentReminderState createState() => _AddAppointmentReminderState();
}

class _AddAppointmentReminderState extends State<AddAppointmentReminder> {
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.appointment?['name'] ?? '');
    locationController = TextEditingController(text: widget.appointment?['location'] ?? '');
    dateController = TextEditingController(text: widget.appointment?['date'] ?? '');
    timeController = TextEditingController(text: widget.appointment?['time'] ?? '');
    noteController = TextEditingController(text: widget.appointment?['note'] ?? '');
  }

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

  Future<void> _deleteAppointment() async {
    if (widget.appointment != null) {
      await DatabaseHelper().deleteAppointment(widget.appointment!['id']);
      await Alarm.stop(widget.appointment!['id']);
      Navigator.pop(context, true);
    }
  }

  Future<void> _updateAppointment() async {
    final String name = nameController.text;
    final String location = locationController.text;
    final String date = dateController.text;
    final String time = timeController.text;
    final String note = noteController.text;

    final appointmentData = {
      'name': name,
      'location': location,
      'date': date,
      'time': time,
      'note': note,
    };
    String body = 'Type: Appointment\nLocation: $location\n Note: $note';
    String formattedTime = convertTo24HourFormat(time);
    String formattedDate = date + "T" + formattedTime + ":00";
    DateTime setDateTime = DateTime.parse(formattedDate);

    if (widget.appointment != null) {
      appointmentData['id'] = widget.appointment!['id'].toString();
      await DatabaseHelper().updateAppointment(appointmentData);
      //delete thn update
      await Alarm.stop(widget.appointment!['id']);
      await Alarm.set(alarmSettings: AlarmSettings(
        id: widget.appointment!['id'],
        dateTime: setDateTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        volume: 0.8,
        fadeDuration: 3.0,
        notificationSettings: NotificationSettings(
          icon: 'mipmap/ic_launcher',
          title: name,
          body: body,
          stopButton: ('Stop Alarm')
        ),
      ));
    } else {
      final id = await DatabaseHelper().insertAppointment(appointmentData);
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
            title: name,
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
          content: Text('Are you sure you want to $action this appointment?'),
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
                  _deleteAppointment();
                } else {
                  _updateAppointment();
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
      appBar: CustomAppBar(title: 'Appointment Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            Row(
              children: [
                const Text('Appointment Time: '),
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
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Note: '),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter note',
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
                  onPressed: () => _showConfirmationDialog(widget.appointment != null ? 'update' : 'set'),
                  child: Text(
                    widget.appointment != null ? 'Update\n Appointment' : 'Set Appointment',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (widget.appointment != null)
                  const SizedBox(width: 10), // Add space between buttons
                if (widget.appointment != null)
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
                      'Delete\nAppointment',
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