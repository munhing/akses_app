import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:akses_app/screens/portuser_list.dart';
import 'package:akses_app/screens/scan_user_page.dart';
import 'package:akses_app/resources/db_provider.dart';
import 'package:provider/provider.dart';
import 'package:akses_app/notifiers/my_info.dart';
import 'package:akses_app/models/portuser.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = "QR Scanner";
  int totalActivePortusers;
  List<Portuser> portusers;

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });

      // Todo: Pass the QR data to the Portuser detail page
      // Todo: Navigate to the new page
      navigateToPortuserDetailPage(qrResult);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission is denied";
        });
      } else {
        setState(() {
          result = "Unknown error $e";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the exit button";
      });
    } catch (e) {
      setState(() {
        result = "Unknown error $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appInfo = Provider.of<MyInfo>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                elevation: 3.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(result),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print('People button was tab');
                        navigateToList();
                      },
                      child: Card(
                        elevation: 3.0,
                        margin: EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                appInfo.portuserCount.toString(),
                                style: TextStyle(fontSize: 80),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.people,
//                                    size: 100.0,
                                  ),
                                  Text('Port Users'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 3.0,
                      margin: EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              appInfo.vehicleCount.toString(),
                              style: TextStyle(fontSize: 80),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.directions_car,
//                                  size: 100.0,
                                ),
                                Text('Vehicles'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 80.0,
        height: 80.0,
        child: FloatingActionButton(
          onPressed: _scanQR,
          tooltip: 'Increment',
          child: Icon(
            Icons.camera,
            size: 50.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    if (portusers == null) {
      portusers = List<Portuser>();
      Future.delayed(Duration.zero).then((_) {
        Provider.of<MyInfo>(context).initializeActivePortusersList();
      });
    }
    super.initState();
  }

  void navigateToList() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PortuserListView();
    }));
  }

  void navigateToPortuserDetailPage(scanData) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ScanUserPage(scanData: scanData);
    }));
  }

  void initializeActivePortusersList() async {
    DbProvider dbProvider = DbProvider.instance;
    List<Map<String, dynamic>> maps = await dbProvider.getActivePortUsers();

    print(maps);
    if (maps != null) {
      for (int i = 0; i < maps.length; i++) {
        portusers.add(Portuser.fromDbDuringInitialization(maps[i]));
      }
    }
  }
}
