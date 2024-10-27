import 'package:flutter/material.dart';
import 'package:care_connect/DB/database_helper.dart';
import 'package:care_connect/UI/appbar.dart';

class PastAlarm extends StatefulWidget {
  @override
  _PastAlarmState createState() => _PastAlarmState();
}

class _PastAlarmState extends State<PastAlarm> {
  late Future<List<Map<String, dynamic>>> _alarms;

  @override
  void initState() {
    super.initState();
    _alarms = _fetchAlarms();
  }

  Future<List<Map<String, dynamic>>> _fetchAlarms() async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.getAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar( title: 'Past Alarms'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _alarms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No past alarms found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final alarm = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(alarm['title']),
                    subtitle: Text('Time: ${alarm['time']}\nDate: ${alarm['date']}'),
                    trailing: Icon(
                      alarm['manuallyTurnedOff'] == 1 ? Icons.check : Icons.timer_off,
                      color: alarm['manuallyTurnedOff'] == 1 ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}