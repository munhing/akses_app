import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Helpers {

  static inOutIcon({int clockType}) {
    double iconSize = 30.0;
    if (clockType == 1) {
      return Icon(
        Icons.input,
        color: Colors.green,
        size: iconSize,
      );
    }

    return Icon(
      Icons.launch,
      color: Colors.redAccent,
      size: iconSize,
    );
  }

}
