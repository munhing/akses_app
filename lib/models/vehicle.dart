import 'package:flutter/foundation.dart';
import 'company.dart';

class Vehicle {
  final String uuid;
  final String plateNo;
  final Company company;

  Vehicle({
    @required this.uuid,
    @required this.plateNo,
    this.company
  });

  factory Vehicle.fromJson(Map<String, dynamic> parsedJson){
    return Vehicle(
        uuid: parsedJson['uuid'],
        plateNo: parsedJson['plate_no'],
        company: Company.fromJson(parsedJson['company'])
    );
  }
}