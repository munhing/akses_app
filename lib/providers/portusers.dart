import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:akses_app/models/portuser.dart';
import 'package:http/http.dart' as http;

class Portusers with ChangeNotifier {
  List<Portuser> _items = [];
  int _count = 0;

  List<Portuser> get items {
    return [..._items];
  }

  int get count {
    return _items.length;
  }

  Future<void> fetchActivePortusers() async {
    const url = 'http://llpm.dlinkddns.com:8084/api/activeportusers';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List<dynamic>;
      final List<Portuser> loadedPortusers = [];
//      print(json.decode(response.body));


      extractedData.forEach((data) {

        print(data['portuser']);
        loadedPortusers.add(
            Portuser.fromJson(data['portuser'])
        );
      });

      _items = loadedPortusers;
      notifyListeners();
    } catch (err) {
      throw(err);
    }
  }

  Future<Portuser> getScanPortuser(String scanData) async {
    String url = 'http://llpm.dlinkddns.com:8084/api/scan?' + scanData;
    try {
      final response = await http.post(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      Portuser puser;

      print(json.decode(response.body));

      puser = Portuser.fromJson(extractedData);

      return puser;
    } catch (err) {
      throw(err);
    }
  }

  Future<void> clocking(Portuser puser) async {
    String param = "uuid=" + puser.uuid;
    String url = 'http://llpm.dlinkddns.com:8084/api/activeportusers?' + param;

    if(puser.active == 1) {
      // currently active. So need to clock out
      try {
        final response = await http.delete(url);
        print(json.decode(response.body));
      } catch (err) {
        throw(err);
      }
    }

    if (puser.active == 0) {
      // currently inactive. So need to clock in
      try {
        final response = await http.post(url);
        print(json.decode(response.body));
      } catch (err) {
        throw(err);
      }
    }

    // refresh the active portuser list
    fetchActivePortusers();
  }
}