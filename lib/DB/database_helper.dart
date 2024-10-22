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
          'CREATE TABLE reminders(id INTEGER PRIMARY KEY, name TEXT, dosage TEXT, interval TEXT, description TEXT, time TEXT, image TEXT)',
        );
        db.execute(
          'CREATE TABLE appointments(id INTEGER PRIMARY KEY, name TEXT, location TEXT, date TEXT, time TEXT)',
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
}