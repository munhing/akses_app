import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:akses_app/models/portuser.dart';

class DbProvider {
  static final _databaseName = "akses.db";

  static final _databaseVersion = 10;

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
              uuid TEXT UNIQUE,
              name TEXT,
              company_id INTEGER,
              expires_on INTEGER,
              created_at INTEGER,
              updated_at INTEGER
            )
          """);
    await db.execute("""
            CREATE TABLE portusers_inout
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              portuser_uuid TEXT,
              clock_type INTEGER,
              clock_time INTEGER
            )
          """);
    await db.execute("""
            CREATE TABLE portusers_active
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              portuser_uuid TEXT UNIQUE
            )
          """);
    await db.execute("""
            CREATE TABLE vehicles
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              uuid TEXT UNIQUE,
              plate_no TEXT,
              company_id INTEGER,
              expires_on INTEGER,
              created_at INTEGER,
              updated_at INTEGER
            )
          """);
    await db.execute("""
            CREATE TABLE vehicles_inout
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              vehicle_uuid TEXT,
              clock_type INTEGER,
              clock_time INTEGER
            )
          """);
    await db.execute("""
            CREATE TABLE vehicles_active
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              vehicle_uuid TEXT UNIQUE
            )
          """);
    await db.execute("""
            CREATE TABLE companies
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              created_at INTEGER,
              updated_at INTEGER
            )
          """);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {

    await db.execute("""
            DROP TABLE IF EXISTS portusers
          """);

    await db.execute("""
            CREATE TABLE portusers
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              uuid TEXT UNIQUE,
              name TEXT,
              company_id INTEGER,
              expires_on INTEGER,
              created_at INTEGER,
              updated_at INTEGER
            )
          """);

    await db.execute("""
            DROP TABLE IF EXISTS portusers_inout
          """);

    await db.execute("""
            CREATE TABLE portusers_inout
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              portuser_uuid TEXT,
              clock_type INTEGER,
              clock_time INTEGER
            )
          """);

    await db.execute("""
            DROP TABLE IF EXISTS portusers_active
          """);

    await db.execute("""
            CREATE TABLE portusers_active
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              portuser_uuid TEXT UNIQUE
            )
          """);

    await db.execute("""
            DROP TABLE IF EXISTS vehicles
          """);

    await db.execute("""
            CREATE TABLE vehicles
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              uuid TEXT UNIQUE,
              plate_no TEXT,
              company_id INTEGER,
              expires_on INTEGER,
              created_at INTEGER,
              updated_at INTEGER
            )
          """);

    await db.execute("""
            DROP TABLE IF EXISTS vehicles_inout
          """);

    await db.execute("""
            CREATE TABLE vehicles_inout
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              vehicle_uuid TEXT,
              clock_type INTEGER,
              clock_time INTEGER
            )
          """);

    await db.execute("""
            DROP TABLE IF EXISTS vehicles_active
          """);

    await db.execute("""
            CREATE TABLE vehicles_active
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              vehicle_uuid TEXT UNIQUE
            )
          """);

    await db.execute("""
            DROP TABLE IF EXISTS companies
          """);

    await db.execute("""
            CREATE TABLE companies
            (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              created_at INTEGER,
              updated_at INTEGER
            )
          """);

    await db.execute("""
            DROP TABLE IF EXISTS test_blob
          """);
  }

  Future<int> insert(Portuser portuser) async {
    Database db = await database;

    int id = await db.insert("Portusers", portuser.toMap());
    return id;
  }

  Future<int> insertUuid(String uuidStr) async {
    Database db = await database;
    print(uuidStr);

    int id = await db
        .rawInsert('insert into test_uuid (uuid) values (?)', [uuidStr]);

    return id;
//    return null;
  }

  Future<List<Map<String, dynamic>>> getPortuserMapList() async {
    Database db = await database;
    final maps = await db.query('portusers');

    return maps;
  }

  Future<List<Map<String, dynamic>>> getPortusersTableList() async {
    Database db = await database;
    final maps = await db.query('portusers');

    return maps;
  }

  Future<List<Map<String, dynamic>>> getPortusersInOutTableList() async {
    Database db = await database;
    final maps = await db.query('portusers_inout');

    return maps;
  }

  Future<List<Map<String, dynamic>>> getPortusersActiveTableList() async {
    Database db = await database;
    final maps = await db.query('portusers_active');

    return maps;
  }

  Future<List<Map<String, dynamic>>> getCompaniesTableList() async {
    Database db = await database;
    final maps = await db.query('companies');

    return maps;
  }

  Future<List<Map<String, dynamic>>> getPortuserMapListActive() async {
    Database db = await database;
    final maps = await db.rawQuery(
//        'select p.*, count(a.portuser_id) as active from portusers p left join active_portusers a on p.id = a.portuser_id'
        'select p.*, (select count(a.portuser_id) from active_portusers a where a.portuser_id = p.id ) as active from portusers p');

    return maps;
  }

  Future<List<Map<String, dynamic>>> getPortuserInOutMapList(
      String portuserUuid) async {
    Database db = await database;
    final maps = await db
        .query('portusers_inout', where: 'portuser_uuid = ?', whereArgs: [portuserUuid]);

    print(maps);
    return maps;
  }

  Future<Portuser> getPortuser(String uuid) async {
    Database db = await database;
//    final maps = await db.query('portusers', where: 'uuid = ?', whereArgs: [uuid]);
    final maps = await db.rawQuery('select p.*, (select count(a.portuser_uuid) from portusers_active a where a.portuser_uuid = ? ) as inout_status from portusers p where p.uuid = ?',
        [uuid, uuid]);

//print('getPortuser method: uuid=$uuid');
    if (maps.length > 0) {
//      print(maps.first);
      return Portuser.fromDb(maps.first);
    }

    return null;
  }

  Future<Portuser> getPortuserWithActive(int id) async {
    Database db = await database;
    final maps = await db.rawQuery(
        'select p.*, (select count(a.portuser_id) from active_portusers a where a.portuser_id = ? ) as active from portusers p where p.id = ?',
        [id, id]);

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
    final maps = await db.rawQuery(
        'SELECT p.uuid, p.name, p.company_id from portusers_active a left outer join portusers p on a.portuser_uuid = p.uuid');

    if (maps.length > 0) {
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

  Future<dynamic> clockingWithActive(
      {Portuser portuser, int clockingType}) async {
    portuser.inOutStatus = clockingType;

    Database db = await database;
    var result;

    // insert inout transaction for historical purpose
    int id = await db.insert(
        "portusers_inout", portuser.toClockingMap(clockingType: clockingType));

    if (clockingType == 1) {
      // if clocking type is 1 [clocking in], then insert into the active_portusers table
      result =
          await db.insert('portusers_active', portuser.toActiveClockingMap());
    } else {
      // if clocking type is 0 [clocking out], then delete from the active_portusers table
      result = await db.delete('portusers_active',
          where: 'portuser_uuid = ?', whereArgs: [portuser.uuid]);
    }

    return result;
  }

  void truncateTable(String tablename) async {
    Database db = await database;
    await db.delete(tablename);
  }

  Future<int> insertMockPortuserList(Portuser portuser) async {
    Database db = await database;

    int id = await db.rawInsert('insert into portusers (id, uuid, name, company_id, expires_on, created_at, updated_at) values (?,?,?,?,?,?,?)', [portuser.id, portuser.uuid, portuser.name, portuser.companyId, portuser.expiresOn, portuser.createdAt,portuser.updatedAt]);
    return id;
  }

  Future<int> insertMockPortuserInOutList(var map) async {
    Database db = await database;
    print(map['portuser_uuid']);

    int id = await db.rawInsert('insert into portusers_inout (portuser_uuid, clock_type, clock_time) values (?,?,?)', [map['portuser_uuid'], map['clock_type'], map['clock_time']]);
    return id;
//    return null;
  }

  Future<int> insertMockPortuserActiveList(var map) async {
    Database db = await database;
    print(map['portuser_uuid']);

    int id = await db.rawInsert('insert into portusers_active (portuser_uuid) values (?)', [map['portuser_uuid']]);
    return id;
//    return null;
  }

  Future<int> insertMockCompaniesList(var map) async {
    Database db = await database;
    print(map['name']);

    int id = await db.rawInsert('insert into companies (id, name, created_at, updated_at) values (?,?,?,?)', [map['id'],map['name'],map['created_at'],map['updated_at']]);
    return id;
//    return null;
  }
}
