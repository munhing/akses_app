import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:akses_app/models/portuser.dart';

class DbProvider {
  static final _databaseName = "akses.db";

  static final _databaseVersion = 4;

  DbProvider._privateConstructor();

  static final DbProvider instance = DbProvider._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // Todo: Change clock_type to INTEGER for smaller footprint

  Future _onCreate(Database db, int version) async {
    await db.execute("""
            CREATE TABLE portusers
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              company TEXT,
              inout_status INTEGER
            )
          """);
    await db.execute("""
            CREATE TABLE inout
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              portuser_id INTEGER,
              clock_type INTEGER,
              clock_time INTEGER
            )
          """);
    await db.execute("""
            CREATE TABLE active_portusers
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              portuser_id INTEGER
            )
          """);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
//    await db.execute("""
//            ALTER TABLE portusers ADD COLUMN inout_status INTEGER DEFAULT 0
//          """);
//    await db.execute("""
//            DROP TABLE IF EXISTS inout
//          """);
//    await db.execute("""
//            CREATE TABLE inout
//            (
//              id INTEGER PRIMARY KEY AUTOINCREMENT,
//              portuser_id INTEGER,
//              clock_type INTEGER,
//              clock_time INTEGER
//            )
//          """);
    await db.execute("""
            CREATE TABLE active_portusers
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              portuser_id INTEGER
            )
          """);
  }

  Future<int> insert(Portuser portuser) async {
    Database db = await database;

    int id = await db.insert("Portusers", portuser.toMap());
    return id;
  }

  Future<List<Map<String, dynamic>>> getPortuserMapList() async {
    Database db = await database;
    final maps = await db.query('portusers');

    return maps;
  }

  Future<List<Map<String, dynamic>>> getPortuserMapListActive() async {
    Database db = await database;
    final maps = await db.rawQuery(
//        'select p.*, count(a.portuser_id) as active from portusers p left join active_portusers a on p.id = a.portuser_id'
        'select p.*, (select count(a.portuser_id) from active_portusers a where a.portuser_id = p.id ) as active from portusers p'
    );

    return maps;
  }

  Future<List<Map<String, dynamic>>> getPortuserInOutMapList(
      int portuserId) async {
    Database db = await database;
    final maps = await db
        .query('inout', where: 'portuser_id = ?', whereArgs: [portuserId]);

    print(maps);
    return maps;
  }

  Future<Portuser> getPortuser(int id) async {
    Database db = await database;
    final maps = await db.query('portusers', where: 'id = ?', whereArgs: [id]);

    if (maps.length > 0) {
//      print(maps.first);
      return Portuser.fromDb(maps.first);
    }

    return null;
  }

  Future<Portuser> getPortuserWithActive(int id) async {
    Database db = await database;
    final maps =
        await db.rawQuery(
            'select p.*, (select count(a.portuser_id) from active_portusers a where a.portuser_id = ? ) as active from portusers p where p.id = ?', [id, id]
        );

    if (maps.length > 0) {
//      print(maps.first);
      return Portuser.fromDbWithActive(maps.first);
    }

    return null;
  }

  Future<List> queryAll() async {
    Database db = await database;
    List<Map> names = await db.rawQuery(
        'select Name.name, count(Date.date) from Name left join Date using(id) group by Name.name');
    if (names.length > 0) {
      return names;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getActivePortUsers() async {
    Database db = await database;

//    final maps = await db.rawQuery('SELECT p.id, p.name, p.company from active_portusers a inner join portusers p on a.portuser_id = p.id');
    final maps = await db.rawQuery('SELECT p.id, p.name, p.company from active_portusers a left outer join portusers p on a.portuser_id = p.id');

    if(maps.length > 0) {
      return maps;
    }
    return null;
  }

  Future<int> clocking({Portuser portuser, int clockingType}) async {
    portuser.inOutStatus = clockingType;

    Database db = await database;

    int id = await db.insert(
        "inout", portuser.toClockingMap(clockingType: clockingType));
    var result = await db.update('portusers', portuser.toMap(),
        where: 'id = ?', whereArgs: [portuser.id]);

    return result;
  }

  Future<dynamic> clockingWithActive({Portuser portuser, int clockingType}) async {
    portuser.inOutStatus = clockingType;

    Database db = await database;
    var result;

    // insert inout transaction for historical purpose
    int id = await db.insert(
        "inout", portuser.toClockingMap(clockingType: clockingType));

    if(clockingType == 1) {
    // if clocking type is 1 [clocking in], then insert into the active_portusers table
      result = await db.insert('active_portusers', portuser.toActiveClockingMap());
    } else {
    // if clocking type is 0 [clocking out], then delete from the active_portusers table
      result = await db.delete('active_portusers', where: 'portuser_id = ?', whereArgs: [portuser.id]);
    }

    return result;
  }
}
