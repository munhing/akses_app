import 'package:flutter/foundation.dart';

class Portuser {
  final int id;
  final String name;
  final String company;
  int inOutStatus;

  Portuser.fromJson(Map<String, dynamic> jsonMap)
    : id = jsonMap['id'],
      name = jsonMap['name'],
      company = jsonMap['company'],
      inOutStatus = jsonMap['inOutStatus'];

//  Portuser(this.id, this.name, this.company);
//
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['company'] = company;
    map['inout_status'] = inOutStatus;

    return map;
  }

  Map<String, dynamic> toClockingMap({int clockingType}) {
    var map = Map<String, dynamic>();
    map['portuser_id'] = id;
    map['clock_type'] = clockingType;
    map['clock_time'] = DateTime.now().millisecondsSinceEpoch;

    return map;
  }

  Map<String, dynamic> toActiveClockingMap({int clockingType}) {
    var map = Map<String, dynamic>();
    map['portuser_id'] = id;

    return map;
  }
//
  Portuser.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        company = parsedJson['company'],
        inOutStatus = parsedJson['inout_status'];

  Portuser.fromDbDuringInitialization(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        company = parsedJson['company'],
        inOutStatus = 1;

  Portuser.fromDbWithActive(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        company = parsedJson['company'],
        inOutStatus = parsedJson['active'];
}