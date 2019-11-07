import 'package:flutter/material.dart';
import 'package:akses_app/models/vehicle.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:akses_app/providers/vehicles.dart';

class VehicleListView extends StatefulWidget {
  @override
  _VehicleListViewState createState() => _VehicleListViewState();
}

class _VehicleListViewState extends State<VehicleListView> {
  List<Vehicle> vehicleList;
  int vehicleCount = 0;

  @override
  Widget build(BuildContext context) {

    final vehiclesProvider = Provider.of<Vehicles>(context);
    vehicleList = Provider.of<Vehicles>(context).items;
    vehicleCount = Provider.of<Vehicles>(context).items.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle List'),
      ),
      body: ListView.builder(
          itemCount: vehicleCount,
          itemBuilder: (BuildContext context, int position) {
            return ListTile(
              title: Text(this.vehicleList[position].plateNo),
              subtitle: Text(this.vehicleList[position].company.name),
            );
          }),
    );
  }

  @override
  void initState() {
      Future.delayed(Duration.zero).then((_) {
//        Provider.of<Vehicles>(context).fetchActiveVehicles();
      });
    super.initState();
  }
}
