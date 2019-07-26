import 'package:flutter/material.dart';
import 'package:akses_app/models/portuser.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:convert';
import 'package:akses_app/resources/db_provider.dart';
import 'package:akses_app/screens/portuser_inout_page.dart';
import 'package:akses_app/utils/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PortuserListView extends StatefulWidget {
  @override
  _PortuserListViewState createState() => _PortuserListViewState();
}

class _PortuserListViewState extends State<PortuserListView> {
  List<Portuser> portuserList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (portuserList == null) {
      portuserList = List<Portuser>();
//      updatePortuserListFromLocalJson();
//      updatePortuserListFromDb();
      updatePortuserListFromDbActive();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Portuser List'),
      ),
      body: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int position) {
            return ListTile(
              leading: loadImage(this.portuserList[position]),
              title: Text(this.portuserList[position].name),
              subtitle: Text(this.portuserList[position].company),
              trailing: Helpers.inOutIcon(
                  clockType: this.portuserList[position].inOutStatus),
              onTap: () {
                print(portuserList[position].id);
                // Todo: navigate to detail page when tab
                navigateToPortuserInOutPage(portuserList[position]);
              },
            );
          }),
    );
  }

  loadImage(Portuser user) {
      return ClipOval(
        child: CachedNetworkImage(
          width: 40.0,
          height: 40.0,
          imageUrl: 'https://picsum.photos/2509?image=' + user.id.toString(),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.person),
          fit: BoxFit.cover,
        ),
      );      
      
//      return CachedNetworkImage(
//        imageUrl: 'https://picsum.photos/2509?image=' + user.id.toString(),
//        placeholder: (context, url) => new CircularProgressIndicator(),
//        errorWidget: (context, url, error) => new Icon(Icons.person),
//      );

  }

  Future<String> loadJson() async {
    print('loading...');
    String json = await rootBundle.loadString('assets/data.json');
    print(json);
    return json;
  }

  void updatePortuserListFromLocalJson() async {
    var parsedJson = jsonDecode(await loadJson());

    for (int i = 0; i < parsedJson.length; i++) {
      portuserList.add(Portuser.fromJson(parsedJson[i]));
    }

    setState(() {
      this.count = portuserList.length;
      this.portuserList = portuserList;
    });
  }

  void updatePortuserListFromDb() async {
    DbProvider dbProvider = DbProvider.instance;

    List<Map<String, dynamic>> userList = await dbProvider.getPortuserMapList();
    for (int i = 0; i < userList.length; i++) {
      portuserList.add(Portuser.fromDb(userList[i]));
    }

    setState(() {
      this.count = portuserList.length;
      this.portuserList = portuserList;
    });
  }

  void updatePortuserListFromDbActive() async {
    DbProvider dbProvider = DbProvider.instance;

    List<Map<String, dynamic>> userList = await dbProvider.getPortuserMapListActive();
    for (int i = 0; i < userList.length; i++) {
      portuserList.add(Portuser.fromDbWithActive(userList[i]));
    }

    setState(() {
      this.count = portuserList.length;
      this.portuserList = portuserList;
    });
  }

  void navigateToPortuserInOutPage(Portuser portuser) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PortuserInOutPage(
        portuser: portuser,
      );
    }));
  }
}
