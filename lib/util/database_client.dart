import 'dart:io';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/todo_item.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String tableName = "todoTbl";
  final String columnId = "id";
  final String columnItemName = "itemName";
  final String columnDueDate = "dueDate";
  final String columnDetails = "details";
  final String columnIsComplete = "isComplete";

  static Database _db;

  Future<Database> get db async {
   if (_db != null){
     return _db;
   }
   _db = await initDb();
   return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    print("database dir is ${documentDirectory.path}");
    String path = join(documentDirectory.path, "todo_list_db.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, $columnItemName TEXT, $columnDueDate TEXT, $columnDetails TEXT, $columnIsComplete NUMERIC)"
    );
    print("Table is created");
  }

  //Insertion
  Future<int> saveItem(TodoItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", item.toMap());
    print(res.toString());

    return res;
  }

  //Get
  Future<List> getItems({@required bool isComplete}) async {
    assert (isComplete != null);
    var whereArg = isComplete == true ? 1 : 0;
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE $columnIsComplete = $whereArg ORDER BY $columnItemName ASC");

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
      "SELECT COUNT(*) FROM $tableName"
    ));
  }

  Future<TodoItem> getItem(int id) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return new TodoItem.fromMap(result.first);
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateItem(TodoItem item) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", item.toMap(), where: "$columnId = ?", whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
