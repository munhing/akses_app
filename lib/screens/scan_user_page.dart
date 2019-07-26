import 'package:flutter/material.dart';
import 'package:akses_app/resources/db_provider.dart';
import 'package:akses_app/models/portuser.dart';

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
//    portuser = fetchPortuser(id: scanData);
//    portuser.then((value) {
//      print(value.name);
//    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Access"),
      ),
      body: FutureBuilder(
          future: fetchPortuserWithActive(id: widget.scanData),
          builder: (context, snapshot) {
//            if(snapshot.connectionState == ConnectionState.done) {
            print(snapshot);
            if (snapshot.data == null) {
              return Text("Error");
            }
//            return Text("Hello");
            return userProfile(snapshot.data);

//            return Container(child: Text(snapshot.data.company));
          }),
    );
  }

  Widget userProfile(user) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 50.0,
            // Todo: Load user's photo
            child: Icon(
              Icons.perm_contact_calendar,
              size: 70.0,
            ),
          ),
          Text(
            user.name,
            style: TextStyle(fontSize: 50.0),
          ),
          Text(
            user.company,
            style: TextStyle(fontSize: 20.0),
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
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                inOutButton(user),
              ],
            ),
          ),
//          SizedBox(height: 10.0,),
          FlatButton(
            child: Icon(
              Icons.cancel,
              size: 80.0,
              color: Colors.red,
            ),
//              shape: CircleBorder(),
//              color: Colors.red,
//              textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          )
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

    if (user.inOutStatus == 1) {
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
          Future<int> clockingId =
              clockingWithActive(portuser: user, clockingType: clockingType);
          clockingId.then((onValue) {
            print(onValue);
          });
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

  Future<int> clocking({Portuser portuser, int clockingType}) async {
    DbProvider dbProvider = DbProvider.instance;

    int clockingId = await dbProvider.clocking(
        portuser: portuser, clockingType: clockingType);

    return clockingId;
  }

  Future<int> clockingWithActive({Portuser portuser, int clockingType}) async {
    DbProvider dbProvider = DbProvider.instance;

    int clockingId = await dbProvider.clockingWithActive(
        portuser: portuser, clockingType: clockingType);

    return clockingId;
  }

  Future<Portuser> fetchPortuser({String id}) async {
    DbProvider dbProvider = DbProvider.instance;
    Portuser puser;
    puser = await dbProvider.getPortuser(int.parse(id));
    return puser;
  }

  Future<Portuser> fetchPortuserWithActive({String id}) async {
    DbProvider dbProvider = DbProvider.instance;
    Portuser puser;
    puser = await dbProvider.getPortuserWithActive(int.parse(id));
    return puser;
  }
}
