import 'package:flutter/material.dart';
import 'package:akses_app/models/portuser.dart';
import 'package:provider/provider.dart';
import 'package:akses_app/providers/portusers.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Todo: query user id from db
// Todo: add check in/out timestamp to inout table

class ScanUserPage extends StatefulWidget {
  ScanUserPage({Key key, this.scanData}) : super(key: key);

  final String scanData;

  @override
  _ScanUserPageState createState() => _ScanUserPageState();
}

class _ScanUserPageState extends State<ScanUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)),
          ),
          FutureBuilder(
              future: scanner(scanData: widget.scanData),
              builder: (context, snapshot) {
//            if(snapshot.connectionState == ConnectionState.done) {
                print(snapshot);
                if (snapshot.data == null) {
//
                  return errorPage();
                }
//            return Text("Hello");
                return userProfile(snapshot.data);

//            return Container(child: Text(snapshot.data.company));
              }),
        ],
      ),

//      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  Widget errorPage() {

    return AlertDialog(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text('Not Found!'),
      content: Text('This person or vehicle is not registered in the system!'),

      actions: <Widget>[
        FlatButton(
          onPressed: () {
            return Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),

      ],
    );
  }

  Widget userProfile(user) {
    final double screenWidth = MediaQuery.of(context).size.width;

//    final String company = 'This is a very long company name'; // 32
//    final String company = 'ABCDEF 1234567 medium names12'; // 29
//    final String company = 'ABCDEF 1234 medium name'; // 23
//    final String company = 'ABCDEF medium name'; // 18
//    final String company = 'ABC medium name'; // 15
//    final String company = 'Short name';  // 10
//    final String company = 'Company';  // 10
//    final String company = 'name';  // 4
//    final String company = Provider.of<MyInfo>(context)
//        .clist
//        .where((c) => c.id == user.id)
//        .first
//        .name;

    return SafeArea(
      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 30.0,
                color: Colors.white,
              ),
//              shape: CircleBorder(),
//              color: Colors.red,
//              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          CircleAvatar(
//            radius: 70.0,
            radius: screenWidth / 5,
            // Todo: Load user's photo
            child: CachedNetworkImage(
              width: 200.0,
              height: 200.0,
              imageUrl: 'http://llpm.dlinkddns.com:8084' + user.photo.url,
              errorWidget: (context, url, error) => Icon(Icons.person),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: sizedName(user.name, screenWidth),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                user.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            width: sizedCompany(user.company.name, screenWidth),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                user.company.name,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
              ),
            ),
          ),
          Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: ListTile(
              title: Text(
                widget.scanData,
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: <Widget>[
                inOutButton(user),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget inOutButton(Portuser user) {
    Color buttonColor;
    Color buttonTextColor;
    String buttonText;
    IconData buttonIcon;
    String debugText;
    int clockingType;

    print(user.uuid);

    if (user.active == 1) {
      buttonColor = Colors.redAccent.shade700;
      buttonTextColor = Colors.white;
      buttonText = 'Check Out';
      buttonIcon = Icons.launch;
      debugText = 'Clocking Out!';
      clockingType = 0;
    } else {
      buttonColor = Colors.lightGreenAccent;
      buttonTextColor = Colors.black;
      buttonText = 'Check In';
      buttonIcon = Icons.input;
      debugText = 'Clocking In!';
      clockingType = 1;
    }

    return Expanded(
      child: FlatButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: buttonColor,
        padding: EdgeInsets.all(25.0),
        onPressed: () {
          print(debugText);
          Provider.of<Portusers>(context).clocking(user);
          Navigator.pop(context);
        },
        child: Column(
          children: <Widget>[
            Icon(
              buttonIcon,
              size: 60.0,
              color: buttonTextColor,
            ),
            Text(
              buttonText,
              style: TextStyle(fontSize: 20.0, color: buttonTextColor),
            )
          ],
        ),
      ),
    );
  }

//  Future<int> clocking({Portuser portuser, int clockingType}) async {
//    DbProvider dbProvider = DbProvider.instance;
//
//    int clockingId = await dbProvider.clocking(
//        portuser: portuser, clockingType: clockingType);
//
//    return clockingId;
//  }
//
//  Future<int> clockingWithActive({Portuser portuser, int clockingType}) async {
//    DbProvider dbProvider = DbProvider.instance;
//
//    int clockingId = await dbProvider.clockingWithActive(
//        portuser: portuser, clockingType: clockingType);
//
//    Provider.of<MyInfo>(context).initializeActivePortusersList();
//
//    return clockingId;
//  }

  Future<dynamic> scanner({String scanData}) async {
//    DbProvider dbProvider = DbProvider.instance;
    Map<String, dynamic> scanDataMap = Map<String, dynamic>();
    Portuser puser;

    // Todo: Determine portuser or vehicle by identifying the type
    // type=1:Portuser, Type=2:[Vehicle], Type=3:[Visitor]

    List split1 = scanData.split('&');
    split1.forEach((value) {
      List split2 = value.split('=');
      print(split2[1]);
      scanDataMap[split2[0]] = split2[1];
    });

    print('heloool ' + scanDataMap['type']);

    if (int.parse(scanDataMap['type']) == 1) {
      print('Portuser');
      // Portuser
      puser = await Provider.of<Portusers>(context).getScanPortuser(scanData);
      return puser;
    }

    if (scanDataMap['type'] == 2) {
      // Vehicle
    }

    return null;
  }

  double sizedName(String name, double screenWidth) {
    double percentage = 0.6;

    if (name.length < 8) percentage = 0.5;
    if (name.length > 10) percentage = 0.7;
    if (name.length > 15) percentage = 0.85;

    return screenWidth * percentage;
  }

  double sizedCompany(String company, double screenWidth) {
    double percentage = 0.15;

    if (company.length > 5) percentage = 0.25;
    if (company.length > 10) percentage = 0.35;
    if (company.length > 15) percentage = 0.45;
    if (company.length > 20) percentage = 0.55;
    if (company.length > 25) percentage = 0.65;
    if (company.length > 30) percentage = 0.75;

    return screenWidth * percentage;
  }
}
