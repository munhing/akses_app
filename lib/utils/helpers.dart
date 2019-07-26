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

  static Future<String> checkAsset(String path) async {
    String assetPath;
    print(await rootBundle.loadString(path));
    try {
      assetPath = await rootBundle.loadString(path);
      print(assetPath);
    } catch (e) {
      assetPath = null;
    }
    return assetPath;
  }
}
