import 'package:bloddpressuretrackerapp/bloc/blood_pressure_model.dart';
import 'package:bloddpressuretrackerapp/consts/const.dart';
import 'package:bloddpressuretrackerapp/logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// repository for the save blood pressure entrys
class SaveBloodRepo {
  static Database? _database;

  /// get database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();

    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, 'blood_pressure.db'),
      onCreate: (db, _) {
        return db.execute(
          'CREATE TABLE entries(id INTEGER PRIMARY KEY AUTOINCREMENT, systolic INTEGER, diastolic INTEGER, pulse INTEGER, dateTime TEXT)',
        );
      },
      version: 1,
    );
  }

  /// insert entry
  Future<void> insertEntry(BloodPressureModel entry) async {
    logger.i('Inserting entry: ${entry.dateTime}');
    final db = await database;
    await db.insert(
      'entries',
      entry.toMap(),

    );
  }

  /// fetch entries by date
  Future<List<BloodPressureModel>> fetchEntriesByDate(DateTime date) async {
    final db = await database;
    final dateString = date.toIso8601String().substring(0, 10); // yyyy-MM-dd
    final maps = await db.query(
      'entries',
      where: "dateTime LIKE ?",
      whereArgs: ['$dateString%'],
      orderBy: 'dateTime ASC',
    );

    return List.generate(
      maps.length,
      (i) => BloodPressureModel.fromMap(maps[i]),
    );
  }

  /// fetch entries by week
  Future<List<BloodPressureModel>> fetchEntriesByWeek(
    DateTime startDate,
  ) async {
    final db = await database;
    final endDate = startDate.add(const Duration(days: 7));
    final startString = startDate.toIso8601String().substring(0, 10);
    final endString = endDate.toIso8601String().substring(0, 10);

    final maps = await db.query(
      'entries',
      where: "DATE(dateTime) >= ? AND DATE(dateTime) < ?",
      whereArgs: [startString, endString],
      orderBy: 'dateTime ASC',
    );

    return List.generate(
      maps.length,
      (i) => BloodPressureModel.fromMap(maps[i]),
    );
  }

  /// fetch entries by month
  Future<List<BloodPressureModel>> fetchEntriesByMonth(
    int year,
    int month,
  ) async {
    final db = await database;
    final startDate = DateTime(year, month,);
    final endDate = DateTime(year, month + one,);
    final startString = startDate.toIso8601String().substring(0, 10);
    final endString = endDate.toIso8601String().substring(0, 10);

    final maps = await db.query(
      'entries',
      where: "DATE(dateTime) >= ? AND DATE(dateTime) < ?",
      whereArgs: [startString, endString],
      orderBy: 'dateTime ASC',
    );

    return List.generate(
      maps.length,
      (i) => BloodPressureModel.fromMap(maps[i]),
    );
  }
}
