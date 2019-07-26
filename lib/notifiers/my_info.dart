import 'package:flutter/foundation.dart';
import 'package:akses_app/models/portuser.dart';

class MyInfo with ChangeNotifier {

  int _portuserCount = 0;
  int _vehicleCount = 0;

  int get vehicleCount => _vehicleCount;

  set vehicleCount(int value) {
    _vehicleCount = value;
    notifyListeners();
  }

  String _lastScannedValue;
  List<Portuser> _plist;

  int get portuserCount => _portuserCount;
  String get lastScannedValue => _lastScannedValue;
  List<Portuser> get plist => _plist;

  set portuserCount(int value) {
    _portuserCount = value;
    notifyListeners();
  }

  set lastScannedValue(String value) {
    _lastScannedValue = value;
    notifyListeners();
  }

  set plist(List<Portuser> value) {
    _plist = value;
    if(value != null) {
      portuserCount = value.length;
    }
    notifyListeners();
  }
}