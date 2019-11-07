import 'package:flutter/material.dart';
import 'package:akses_app/models/portuser.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:akses_app/providers/portusers.dart';

class PortuserListView extends StatefulWidget {
  @override
  _PortuserListViewState createState() => _PortuserListViewState();
}

class _PortuserListViewState extends State<PortuserListView> {
  List<Portuser> portuserList;
  int portuserCount = 0;

  @override
  Widget build(BuildContext context) {

    final portusersProvider = Provider.of<Portusers>(context);
    portuserList = Provider.of<Portusers>(context).items;
    portuserCount = Provider.of<Portusers>(context).items.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Portuser List'),
      ),
      body: ListView.builder(
          itemCount: portuserCount,
          itemBuilder: (BuildContext context, int position) {
            return ListTile(
              leading: loadPhoto(this.portuserList[position].photo.urlThumb),
              title: Text(this.portuserList[position].name),
              subtitle: Text(this.portuserList[position].company.name),
            );
          }),
    );
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
//        Provider.of<Portusers>(context).fetchActivePortusers();
    });
    super.initState();
  }

  loadPhoto(String url) {

    return ClipOval(
      child: CachedNetworkImage(
        width: 40.0,
        height: 40.0,
        imageUrl: 'http://llpm.dlinkddns.com:8084' + url,
        errorWidget: (context, url, error) => Icon(Icons.person),
        fit: BoxFit.cover,
      ),
    );
  }
}
