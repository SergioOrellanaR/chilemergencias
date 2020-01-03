import 'dart:async';

import 'package:chilemergencias/src/models/BomberosModel.dart';
import 'package:chilemergencias/src/models/CarabinerosModel.dart';
import 'package:chilemergencias/src/models/UrgenciasModel.dart';
import 'package:chilemergencias/src/providers/Provider.dart';
import 'package:chilemergencias/utils/private.dart' as privateInfo;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
//https://stackoverflow.com/questions/54910211/errorflutter-lib-ui-ui-dart-state-cc148-unhandled-exception/57087364

class _HomePageState extends State<HomePage> {
  LatLng _myPosition;
  MapboxMapController _mapController;
  MapboxMap _mapBoxMap;
  Map<String, dynamic> _allData;
  List<Symbol> _markers = new List();

  @override
  void initState() {
    super.initState();
    _myPosition = new LatLng(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Hi")),
      body: Stack(children: <Widget>[
        mapWithStreaming(),
        drawInstitutionsOnMap()
      ],
        
        
      ),
      floatingActionButton: _centerGpsCamera()      
    );
  }

  FloatingActionButton _centerGpsCamera() {
    return FloatingActionButton(onPressed: () async {
      await _mapController.moveCamera(CameraUpdate.newLatLng(_myPosition));
    });
  }

  //Despues descubri que el mismo MapBoxMap me permite centrar la ubicación XD
  mapWithStreaming() {
    var location = new Location();
    return StreamBuilder(
      stream: location.onLocationChanged(),
      builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
        if (snapshot.hasData) {
          _myPosition = LatLng(snapshot.data.latitude, snapshot.data.longitude);
          if (_mapBoxMap == null) {
            _createMapBoxMap();
          }
          return _mapBoxMap;
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _createMapBoxMap() {
    _mapBoxMap = MapboxMap(
      initialCameraPosition: CameraPosition(target: _myPosition, zoom: 10),
      myLocationEnabled: true,
      onMapCreated: (controller) {
        _mapController = controller;
      },
      compassEnabled: true,
      //minMaxZoomPreference: MinMaxZoomPreference(),
      //onCameraTrackingDismissed: (){print("Salimos del foco perrito");},
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: true,
      zoomGesturesEnabled: true
    );
  }

  //TODO: Controlar que map controller no sea null mientras se tenga data.
  Widget drawInstitutionsOnMap()
  {
    return FutureBuilder(
      future: provider.allDataToMap(),
      builder: (BuildContext context, AsyncSnapshot<Map<String,dynamic>> snapshot) {
        if (snapshot.hasData && _mapController != null)
        {
          for (BomberosModel item in provider.bomberos) {
            _addSymbol(item);
          }

          for (CarabinerosModel item in provider.carabineros) {
            _addCircle(item);
          }


          return Container();

          // snapshot.data.forEach((k,v)
          // {
          //   _mapController.addSymbol(SymbolOptions(
          //     provider.
          //   ));

          // }
          // );

        }
        else
        {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }

  void _addSymbol(BomberosModel item) {
    try
    {
      _mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(item.latitude,item.longitude),
        iconImage: 'assets/custom-icon.png'
        // iconImage: "airport-15"
      ),
    );
    }
    catch (e)
    {
      print(e.toString());
    }
  }

  void _addCircle(CarabinerosModel item)
  {
    _mapController.addCircle(
      CircleOptions(
        geometry: LatLng(item.latitude,item.longitude),
        circleColor: "#FF0000",
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
