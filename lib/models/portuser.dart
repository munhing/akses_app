import 'package:flutter/foundation.dart';

class Portuser {
  final int id;
  final String uuid;
  final String name;
  final int companyId;
  final int expiresOn;
  final int createdAt;
  final int updatedAt;
  int inOutStatus;

  Portuser.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        uuid = jsonMap['uuid'],
        name = jsonMap['name'],
        companyId = jsonMap['company_id'],
        expiresOn = jsonMap['expires_on'],
        createdAt = jsonMap['created_at'],
        updatedAt = jsonMap['updated_at'],
        inOutStatus = jsonMap['inOutStatus'];

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['uuid'] = uuid;
    map['name'] = name;
    map['company_id'] = companyId;
    map['expires_on'] = expiresOn;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['inout_status'] = inOutStatus;

    return map;
  }

  Map<String, dynamic> toClockingMap({int clockingType}) {
    var map = Map<String, dynamic>();
    map['portuser_uuid'] = uuid;
    map['clock_type'] = clockingType;
    map['clock_time'] = DateTime.now().millisecondsSinceEpoch;

    return map;
  }

  Map<String, dynamic> toActiveClockingMap({int clockingType}) {
    var map = Map<String, dynamic>();
    map['portuser_uuid'] = uuid;

    return map;
  }

//
  Portuser.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        uuid = parsedJson['uuid'],
        name = parsedJson['name'],
        companyId = parsedJson['company_id'],
        expiresOn = parsedJson['expires_on'],
        createdAt = parsedJson['created_at'],
        updatedAt = parsedJson['updated_at'],
        inOutStatus = parsedJson['inout_status'];

  Portuser.fromDbDuringInitialization(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        uuid = parsedJson['uuid'],
        name = parsedJson['name'],
        companyId = parsedJson['company_id'],
        expiresOn = parsedJson['expires_on'],
        createdAt = parsedJson['created_at'],
        updatedAt = parsedJson['updated_at'],
        inOutStatus = 1;

  Portuser.fromDbWithActive(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        uuid = parsedJson['uuid'],
        name = parsedJson['name'],
        companyId = parsedJson['company_id'],
        expiresOn = parsedJson['expires_on'],
        createdAt = parsedJson['created_at'],
        updatedAt = parsedJson['updated_at'],
        inOutStatus = parsedJson['active'];
}
