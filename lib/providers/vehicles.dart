import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:akses_app/models/vehicle.dart';
import 'package:http/http.dart' as http;

class Vehicles with ChangeNotifier {
  List<Vehicle> _items = [];
  int _count = 0;

  List<Vehicle> get items {
    return [..._items];
  }

  int get count {
    return _items.length;
  }

  Future<void> fetchActiveVehicles() async {
    const url = 'http://llpm.dlinkddns.com:8084/api/activevehicles';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List<dynamic>;
      final List<Vehicle> loadedVehicles = [];
//      print(json.decode(response.body));


      extractedData.forEach((data) {

        print(data['vehicle']);
        loadedVehicles.add(
          Vehicle.fromJson(data['vehicle'])
        );
      });

      _items = loadedVehicles;
      notifyListeners();
    } catch (err) {
      throw(err);
    }
  }
}