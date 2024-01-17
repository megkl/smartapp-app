import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String TABLE_NAME = 'level';

  final String ID = 'id';
  final String CAT_ID = 'cat_id';
  final String SUB_CAT_ID = 'sub_cat_id';
  final String LEVEL_NO = "level_no";

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();

    return _db!;
  }

  Future<Database> initDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "quiz_level.db");

    // Check if the database exists
    var exists = await databaseExists(path);
    if (!exists) {
      // print("database***Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "quiz_level.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("database***Opening existing database");
    }
    // open the database
    var db = await openDatabase(path, readOnly: false);

    return db;
  }

  /*
     * insert level no
     */
  insertLevel(int catId, int subCatId, int levelNo) async {
    var dbClient = await db;
    print("db***insert**$catId***$subCatId**$levelNo");
    String query =
        "INSERT INTO $TABLE_NAME ($CAT_ID ,$SUB_CAT_ID ,  $LEVEL_NO  ) VALUES( $catId , $subCatId ,$levelNo)";
    dbClient.execute(query);
  }

  /*
     *with this method we check if categoryId & subCategoryId is already exist or not in our database
     */
  Future<bool> isExist(int catId, int subCatId) async {
    var dbClient = await db;

    List<Map<String, dynamic>> records = await dbClient.rawQuery(
        "SELECT * FROM $TABLE_NAME  WHERE ( $CAT_ID  = $catId AND $SUB_CAT_ID = $subCatId )",
        null);

    bool exist = (records.length > 0);

    print("db***exist**$catId***$subCatId");
    print("---isExit  $exist");
    return exist;
  }

  /*
     * get level
     */
  Future<int> GetLevelById(int catId, int subCatId) async {
    int level = 1;
    var dbClient = await db;
    String selectQuery =
        "SELECT  * FROM  $TABLE_NAME WHERE ( $CAT_ID =  $catId AND $SUB_CAT_ID =$subCatId )";

    List<Map<String, dynamic>> data = await dbClient.rawQuery(selectQuery);

    for (int i = 0; i < data.length; i++) {
      level = int.parse(data[i]["level_no"]);
    }
    print("db***get**$catId***$subCatId**$level");
    return level;
  }

  /*
     * Update lavel
     */
  Future<void> UpdateLevel(int catId, int subCatId, int levelNo) async {
    var dbClient = await db;

    print("db***update**$catId***$subCatId**$levelNo");

    dbClient.rawQuery(
        "update $TABLE_NAME set level_no=$levelNo where ( $CAT_ID =$catId and $SUB_CAT_ID =$subCatId)");
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
