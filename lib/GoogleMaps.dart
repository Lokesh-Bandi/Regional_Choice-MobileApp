import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SimpleMap extends StatefulWidget {
  @override
  _SimpleMapState createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap> {
  static LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  GoogleMapController _controller;


  void initState(){
    super.initState();
   getPosition();
}

void getPosition() async{
  Position position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  setState(() {
    _kMapCenter=LatLng(position.latitude, position.longitude);
    _kInitialPosition =
        CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  });
}

  Future<void> _onMapCreated(GoogleMapController _cntlr)
  async{
    _controller = _cntlr;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller.setMapStyle(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Current Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: _kInitialPosition,
          onMapCreated: _onMapCreated,
        myLocationButtonEnabled:true,
        myLocationEnabled: true,
      ),
    );
  }
}
