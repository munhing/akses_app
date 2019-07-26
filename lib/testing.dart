import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:akses_app/models/portuser.dart';
import 'resources/db_provider.dart';

main() async {
  List<Portuser> plist = List<Portuser>();

  var dmap = await parseJsonFromAssets('assets/data.json');
  List json = jsonDecode(dmap);
  print('json decoded: $json');

  for (int i = 0; i < json.length; i++ ) {
//    print(json[i]);
    plist.add(Portuser.fromJson(json[i]));
  }
//  print(plist);

  plist.forEach((obj){
    print('name: ' + obj.name);
    print('company: ' + obj.company);

  });

  saveListToDb(plist);
}

Future<String> parseJsonFromAssets(String assetsPath) async {
  print('--- Print json from asset path: $assetsPath');
  var jsonStr = await rootBundle.loadString(assetsPath);
  print('json string: $jsonStr');
  return jsonStr;
}

saveListToDb(List<Portuser> plist) async {
  DbProvider dbProvider = DbProvider.instance;

  for (int i = 0; i < plist.length; i++) {
    try {
      int id = await dbProvider.insert(plist[i]);
      print('inserted row: $id');
    } catch (e) {
//      print('Id conflict. Unable to insert id: ' + plist[i].id.toString());
//      print(e);
    }
  }
}


