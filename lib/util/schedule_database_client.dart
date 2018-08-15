import 'dart:io';
import 'dart:async';

import 'package:synchronized/synchronized.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/class.dart';
import 'package:path_provider/path_provider.dart';

class ScheduleDatabaseHelper {
  static final ScheduleDatabaseHelper _instance = ScheduleDatabaseHelper.internal();
  factory ScheduleDatabaseHelper() => _instance;

  final String tableName = "scheduleTbl";
  final String columnId = "id";
  final String columnClassNo = "classNo";
  final String columnWeekDay = "weekDay";
  final String columnStartTime = "startTime";
  final String columnEndTime = "endTime";
  final String columnName = "name";
  final String columnLocation = "location";
  final String columnTeacher = "teacher";


  static Database _db;
  final _lock = Lock();

  Future<Database> get db async {
    if (_db == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (_db == null) {
          _db = await initDb();
        }
      });
    }
    return _db;
  }

  ScheduleDatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    print("database dir is ${documentDirectory.path}");
    String path = join(documentDirectory.path, "schedule_db.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY,
        $columnClassNo INTEGER,
        $columnWeekDay INTEGER,
        $columnStartTime TEXT,
        $columnEndTime TEXT,
        $columnName TEXT,
        $columnLocation TEXT,
        $columnTeacher TEXT
      )'''
    );
    print("Table is created");
  }

  //Get
  Future<List> getClasses({@required int weekDay}) async {
    assert (weekDay != null);
    var whereArg = weekDay;
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE $columnWeekDay = $whereArg ORDER BY $columnClassNo ASC");
    return result.toList();
  }

  //Insertion
  Future<int> addClass(Class _class) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", _class.toMap());
    print(res.toString());
    return res;
  }

  Future<Class> getClass(int id) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return Class.fromMap(result.first);
  }

  Future<int> updateClass(Class _class) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", _class.toMap(), where: "$columnId = ?", whereArgs: [_class.id]);
  }

  Future<int> deleteClass(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
      "SELECT COUNT(*) FROM $tableName"
    ));
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}