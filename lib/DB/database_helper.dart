import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'care_connect.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE reminders(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dosage TEXT, interval TEXT, description TEXT, time TEXT, image TEXT)',
        );
        db.execute(
          'CREATE TABLE appointments(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, location TEXT, date TEXT, time TEXT, note TEXT)',
        );
        db.execute(
          'CREATE TABLE alarms(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, type TEXT, time TEXT, date TEXT, manuallyTurnedOff BOOLEAN)',
        );
      },
    );
  }

  Future<int> insertReminder(Map<String, dynamic> reminder) async {
    Database db = await database;
    return await db.insert('reminders', reminder);
  }

  Future<List<Map<String, dynamic>>> getReminders() async {
    Database db = await database;
    return await db.query('reminders');
  }

  Future<int> insertAppointment(Map<String, dynamic> appointment) async {
    Database db = await database;
    return await db.insert('appointments', appointment);
  }

  Future<List<Map<String, dynamic>>> getAppointments() async {
    Database db = await database;
    return await db.query('appointments');
  }

  Future<int> deleteReminder(int id) async {
    Database db = await database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAppointment(int id) async {
    Database db = await database;
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateReminder(Map<String, dynamic> reminder) async {
    Database db = await database;
    return await db.update(
      'reminders',
      reminder,
      where: 'id = ?',
      whereArgs: [reminder['id']],
    );
  }

  Future<int> updateAppointment(Map<String, dynamic> appointment) async {
    Database db = await database;
    return await db.update(
      'appointments',
      appointment,
      where: 'id = ?',
      whereArgs: [appointment['id']],
    );
  }

  Future<int> insertAlarmEntry(Map<String, dynamic> alarmEntry) async {
    Database db = await database;
    return await db.insert('alarms', alarmEntry);
  }

  Future<List<Map<String, dynamic>>> getAlarms() async {
    Database db = await database;
    return await db.query('alarms', orderBy: 'date DESC, time DESC');
  }

  Future<int> deleteAlarm(int id) async {
    Database db = await database;
    return await db.delete('alarms', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateAlarm(Map<String, dynamic> alarmEntry) async {
    Database db = await database;
    return await db.update(
      'alarms',
      alarmEntry,
      where: 'id = ?',
      whereArgs: [alarmEntry['id']],
    );
  }
}