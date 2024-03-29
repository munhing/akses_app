//import 'package:flutter/foundation.dart';
//import 'package:akses_app/models/portuser.dart';
//import 'package:akses_app/resources/db_provider.dart';
//
//class MyInfo with ChangeNotifier {
//  int _portuserCount = 0;
//  int _vehicleCount = 0;
//
//  int get vehicleCount => _vehicleCount;
//
//  set vehicleCount(int value) {
//    _vehicleCount = value;
//    notifyListeners();
//  }
//
//  String _lastScannedValue;
//  List<Portuser> _plist;
//  List<Company> _clist;
//
//  List<Company> get clist => _clist;
//
//  set clist(List<Company> value) {
//    _clist = value;
//    notifyListeners();
//  }
//
//  int get portuserCount => _portuserCount;
//
//  String get lastScannedValue => _lastScannedValue;
//
//  List<Portuser> get plist => _plist;
//
//  set portuserCount(int value) {
//    _portuserCount = value;
//    notifyListeners();
//  }
//
//  set lastScannedValue(String value) {
//    _lastScannedValue = value;
//    notifyListeners();
//  }
//
//  set plist(List<Portuser> value) {
//    _plist = value;
//    if (value != null) {
//      portuserCount = value.length;
//    }
//    notifyListeners();
//  }
//
//  void initializeActivePortusersList() async {
//    DbProvider dbProvider = DbProvider.instance;
//    List<Portuser> portusers = List<Portuser>();
//    List<Map<String, dynamic>> maps = await dbProvider.getActivePortUsers();
//
//    if (_plist == null) {
//      _plist = List<Portuser>();
//    }
//
//    print(maps);
//    if (maps != null) {
//      for (int i = 0; i < maps.length; i++) {
//        portusers.add(Portuser.fromDbDuringInitialization(maps[i]));
//      }
//
//      plist = portusers;
//      plist.sort((a, b) => a.name.compareTo(b.name));
//    }
//  }
//
//  void initializeCompaniesList() async {
//    DbProvider dbProvider = DbProvider.instance;
//    List<Company> companies = List<Company>();
//    List<Map<String, dynamic>> maps = await dbProvider.getCompaniesTableList();
//
//    if (_clist == null) {
//      _clist = List<Company>();
//    }
//
//    print(maps);
//    if (maps != null) {
//      for (int i = 0; i < maps.length; i++) {
//        companies.add(Company.fromDb(maps[i]));
//      }
//
//      clist = companies;
//      clist.sort((a, b) => a.name.compareTo(b.name));
//    }
//  }
//}
