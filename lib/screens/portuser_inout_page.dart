import 'package:flutter/material.dart';
import 'package:akses_app/models/portuser.dart';
import 'package:akses_app/resources/db_provider.dart';
import 'package:intl/intl.dart';
import 'package:akses_app/utils/helpers.dart';

class PortuserInOutPage extends StatefulWidget {
  PortuserInOutPage({Key key, this.portuser}) : super(key: key);

  final Portuser portuser;

  @override
  _PortuserInOutPageState createState() => _PortuserInOutPageState();
}

class _PortuserInOutPageState extends State<PortuserInOutPage> {

  List<Map<String, dynamic>> userInOutList;
  int count;

  @override
  Widget build(BuildContext context) {

    if(userInOutList == null) {
      userInOutList = List<Map<String, dynamic>>();
      updateUserInOutList();
    }

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.portuser.name),
        ),
        body: userInOut(),
      );
    }

  userInOut() {
    return ListView.builder(
        itemCount: userInOutList.length,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            elevation: 3.0,
            margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
            child: ListTile(

              leading: Helpers.inOutIcon(clockType: userInOutList[position]['clock_type']),
              title: Text(DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(userInOutList[position]['clock_time']))),
              subtitle: Text(DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(userInOutList[position]['clock_time']))),

            ),
          );
        });
  }

  void updateUserInOutList() async {

    DbProvider dbProvider = DbProvider.instance;

    List<Map<String, dynamic>> userInOutMapList = await dbProvider.getPortuserInOutMapList(widget.portuser.id);

    setState(() {
      this.count = userInOutMapList.length;
      this.userInOutList = userInOutMapList;
    });
  }
}
