import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'notodo_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  var tableName = 'notodoTable';
  var columnId = 'id';
  var columnItemName = 'itemName';
  var columnPassword = 'dateCreated';

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnItemName TEXT, $columnPassword TEXT)');
  }

  //Insertion
  Future<int> saveItem(NoToDoItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert('$tableName', item.toMap());
    return res;
  }

  //GetUsers
  Future<List> getAllItems() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('SELECT * FROM $tableName  ORDER BY $columnItemName ASC');
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<NoToDoItem> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('SELECT * FROM $tableName WHERE $columnId = $id');
    if (result.length == 0) return null;
    return NoToDoItem.fromMap(result.first);
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;

    return await dbClient
        .delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateItem(NoToDoItem item) async {
    var dbClient = await db;
    return await dbClient.update(tableName, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
