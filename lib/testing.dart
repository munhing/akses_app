//import 'dart:convert';
//import 'package:flutter/services.dart' show rootBundle;
//import 'package:akses_app/models/portuser.dart';
//import 'resources/db_provider.dart';
//
//main() async {
//
//  // ******** Save to DB **************
//  saveDataToDb();
//
//  // ******** Read from DB **************
////  getFromDb();
//}
//
//void saveDataToDb() async {
//  savePortusersTable();
//  savePortusersInOutTable();
//  savePortusersActiveTable();
//  saveCompaniesTable();
//}
//
//void savePortusersTable() async {
//  List<Portuser> plist = List<Portuser>();
//  var dmap = await parseJsonFromAssets('assets/portusers_table.json');
//  List json = jsonDecode(dmap);
//  for (int i = 0; i < json.length; i++ ) {
////    print(json[i]);
//    plist.add(Portuser.fromJson(json[i]));
//  }
////  print(plist);
//  saveListToDb(plist);
//}
//
//void savePortusersInOutTable() async {
//  var dmap = await parseJsonFromAssets('assets/portusers_inout_table.json');
//  List json = jsonDecode(dmap);
////  for (int i = 0; i < json.length; i++ ) {
////    print(json[i]);
////  }
//  savePortusersInOutToDb(json);
//
//}
//
//void savePortusersActiveTable() async {
//  var dmap = await parseJsonFromAssets('assets/portusers_active_table.json');
//  List json = jsonDecode(dmap);
////  for (int i = 0; i < json.length; i++ ) {
////    print(json[i]);
////  }
//  savePortusersActiveToDb(json);
//
//}
//
//void saveCompaniesTable() async {
//  var dmap = await parseJsonFromAssets('assets/companies_table.json');
//  List json = jsonDecode(dmap);
////  for (int i = 0; i < json.length; i++ ) {
////    print(json[i]);
////  }
//  saveCompaniesToDb(json);
//
//}
//
//
//
//
//Future<String> parseJsonFromAssets(String assetsPath) async {
//  print('--- Print json from asset path: $assetsPath');
//  var jsonStr = await rootBundle.loadString(assetsPath);
//  print('json string: $jsonStr');
//  return jsonStr;
//}
//
//savePortusersInOutToDb(List maps) async {
//  DbProvider dbProvider = DbProvider.instance;
//
//  for (int i = 0; i < maps.length; i++) {
//    try {
////      print(maps[i]);
//      int id = await dbProvider.insertMockPortuserInOutList(maps[i]);
//      print('inserted row: $id');
//    } catch (e) {
////      print('Id conflict. Unable to insert id: ' + plist[i].id.toString());
////      print(e);
//    }
//  }
//}
//
//savePortusersActiveToDb(List maps) async {
//  DbProvider dbProvider = DbProvider.instance;
//
//  for (int i = 0; i < maps.length; i++) {
//    try {
////      print(maps[i]);
//      int id = await dbProvider.insertMockPortuserActiveList(maps[i]);
//      print('inserted row: $id');
//    } catch (e) {
////      print('Id conflict. Unable to insert id: ' + plist[i].id.toString());
////      print(e);
//    }
//  }
//}
//
//saveCompaniesToDb(List maps) async {
//  DbProvider dbProvider = DbProvider.instance;
//
//  for (int i = 0; i < maps.length; i++) {
//    try {
////      print(maps[i]);
//      int id = await dbProvider.insertMockCompaniesList(maps[i]);
//      print('inserted row: $id');
//    } catch (e) {
////      print('Id conflict. Unable to insert id: ' + plist[i].id.toString());
////      print(e);
//    }
//  }
//}
//
//saveListToDb(List<Portuser> plist) async {
//  DbProvider dbProvider = DbProvider.instance;
//
//  for (int i = 0; i < plist.length; i++) {
//    try {
//      int id = await dbProvider.insertMockPortuserList(plist[i]);
//      print('inserted row: $id');
//    } catch (e) {
////      print('Id conflict. Unable to insert id: ' + plist[i].id.toString());
////      print(e);
//    }
//  }
//}
//
//saveUuidToDb(List uuidList) async {
////  print(uuidList);
//  DbProvider dbProvider = DbProvider.instance;
//
//  dbProvider.truncateTable('test_uuid');
//
//  for (int i = 0; i < uuidList.length; i++) {
//    try {
//      print('Inserting to db...');
//      int id = await dbProvider.insertUuid(uuidList[i]['uuid']);
//      print('inserted uuid: ' + uuidList[i]['uuid'] + ' with id: $id');
//    } catch (e) {
////      print('Id conflict. Unable to insert id: ' + plist[i].id.toString());
////      print(e);
//    }
//  }
//}
//
//void getFromDb() async {
//  DbProvider dbProvider = DbProvider.instance;
//
//
//    try {
//      print("hello");
//      var mapPortusers =  await dbProvider.getPortusersTableList();
//      var mapPortusersInOut =  await dbProvider.getPortusersInOutTableList();
//      var mapPortusersActive =  await dbProvider.getPortusersActiveTableList();
//      var mapCompanies =  await dbProvider.getCompaniesTableList();
////      print('inserted row: $id');
//    print(mapPortusers);
//    print(mapPortusersInOut);
//    print(mapPortusersActive);
//    print(mapCompanies);
//
//    } catch (e) {
////      print('Id conflict. Unable to insert id: ' + plist[i].id.toString());
////      print(e);
//    }
//
//    return null;
//
//}
//
