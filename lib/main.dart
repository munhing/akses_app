import 'package:akses_app/providers/portusers.dart';
import 'package:akses_app/providers/vehicles.dart';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
          builder: (context) => Portusers(),
        ),
        ChangeNotifierProvider(
          builder: (context) => Vehicles(),
        ),
      ],
      child: MaterialApp(
        title: 'Akses',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: MyHomePage(title: 'AKSES.'),
//        home: ScanUserPage(scanData: 'type=1&uuid=88784c61-72f0-4034-85a8-354caa52bc7b'),
      ),
    );
  }
}
