import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'notifiers/my_info.dart';
import 'screens/scan_user_page.dart';

Future main() async {
  // prevent app from rotating
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => MyInfo(),
        ),
      ],
      child: MaterialApp(
        title: 'Akses',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: MyHomePage(title: 'AKSES.'),
//        home: ScanUserPage(scanData: '1'),
      ),
    );
  }
}
