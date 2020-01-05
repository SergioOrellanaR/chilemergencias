import 'dart:async';
import 'dart:ffi';

import 'package:chilemergencias/src/controllers/SymbolController.dart';
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
  bool _areMarkersDrawed = false;
  SymbolController _symbolController;
  LatLng _myPosition;
  MapboxMapController _mapController;
  MapboxMap _mapBoxMap;
  Map<String, dynamic> _allData;
  
  Color _showFilterUrgenciasButtonColor   = Colors.white54;
  Color _showFilterBomberosButtonColor    = Colors.white54;
  Color _showFilterCarabinerosButtonColor = Colors.white54;


  @override
  void initState() {
    super.initState();
    _myPosition = new LatLng(0, 0);
    _createMapBoxMap();
    _symbolController = new SymbolController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text("Hi")),
        body: Stack(
          children: <Widget>[mapWithStreaming(),
                            _filterButtons()],
        ),
        floatingActionButton: _centerGpsCamera());
  }

  FloatingActionButton _centerGpsCamera() {
    return FloatingActionButton(
      onPressed: checkInformation,
      //   onPressed: () async {
      //   await _mapController.moveCamera(CameraUpdate.newLatLng(_myPosition));
      // },
      child: Icon(Icons.gps_fixed),
    );
  }

  //Despues descubri que el mismo MapBoxMap me permite centrar la ubicación XD
  mapWithStreaming() {
    var location = new Location();
    return StreamBuilder(
      stream: location.onLocationChanged(),
      builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
        if (snapshot.hasData) {
          Widget widget = Container();
          _myPosition = LatLng(snapshot.data.latitude, snapshot.data.longitude);

          if (_mapController != null && _areMarkersDrawed == false) {
            widget = drawInstitutionsOnMap();
            _areMarkersDrawed = checkMarkersInitialized();
          }

          return Stack(
            children: <Widget>[_mapBoxMap, widget],
          );
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
        zoomGesturesEnabled: true);
  }

  //TODO: Controlar que map controller no sea null mientras se tenga data.
  Widget drawInstitutionsOnMap() {
    return FutureBuilder(
      future: provider.allDataToMap(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
          //TODO: verificar que future no esté dando problemas por asignación a variable simple.
          _addMarkers("Urgencias");
          _symbolController.showUrgencias = true;
          _addMarkers("Bomberos");
          _symbolController.showBomberos = true;
          _addMarkers("Carabineros");
          _symbolController.showCarabineros = true;

          return Container();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _addCircle(CarabinerosModel item) {
    _mapController.addCircle(
      CircleOptions(
        geometry: LatLng(item.latitude, item.longitude),
        circleColor: "#FF0000",
      ),
    );
  }

  Future<Symbol> _addSymbol(String iconImage, LatLng latLng) async {
    return _mapController.addSymbol(
      SymbolOptions(geometry: latLng, iconImage: iconImage),
    );
  }

  Future<void> _removeSymbol(Symbol symbol) async {
    return _mapController.removeSymbol(symbol);
  }

  void _addMarkers(String institution) async {
    switch (institution) {
      case "Urgencias":
          for (UrgenciasModel item in provider.urgencias)
            _symbolController.urgenciasSymbols.add(await _addSymbol(
                "hospital-15", LatLng(item.latitude, item.longitude)));
        break;
      case "Bomberos":
        if(_symbolController.bomberosSymbols.length == 0)
        {
          for (BomberosModel item in provider.bomberos)
          {
            _symbolController.bomberosSymbols.add(await _addSymbol(
                "fire-station-15", LatLng(item.latitude, item.longitude)));
          }
        }
        break;
      case "Carabineros":
          for (CarabinerosModel item in provider.carabineros)
            _symbolController.carabinerosSymbols.add(await _addSymbol(
                "police-15", LatLng(item.latitude, item.longitude)));
        break;
      default:
        throw new Exception("Opción inválida");
        break;
    }
  }

  //TODO: Agregar verificación
  void _deleteMarkers(String institution) async {
    switch (institution) {
      case "Urgencias":
          for (Symbol item in _symbolController.urgenciasSymbols)
            await _removeSymbol(item);
        break;
      case "Bomberos":
          List<String> symbolIds = new List<String>();
          for (Symbol item in _symbolController.bomberosSymbols)
          {
            symbolIds.add(item.id);
          }
          await _mapController.customClearSymbols(symbolIds);
          _symbolController.bomberosSymbols = new List<Symbol>();
            
        break;
      case "Carabineros":
          for (Symbol item in _symbolController.carabinerosSymbols)
            await _removeSymbol(item);
        break;
      default:
        throw new Exception("Opción inválida");
        break;
    }
  }

  bool checkMarkersInitialized() {
    if (_symbolController.showBomberos == true &&
        _symbolController.showUrgencias &&
        _symbolController.showCarabineros) {
      return true;
    } else {
      return false;
    }
  }

  Widget _filterButtons()
  {
    FloatingActionButton filterUrgencias = new FloatingActionButton(
      child: Image(image: AssetImage("assets/urgencias_Chile.png"), height: 45.0, width: 45.0,),
      onPressed: (){
        
      },
      backgroundColor: _showFilterUrgenciasButtonColor,
    );

    FloatingActionButton filterBomberos = new FloatingActionButton(
      child: Image(image: AssetImage("assets/Bomberos_Chile.png"),),
      onPressed: (){
        setState(() {
          _symbolController.showBomberos = !_symbolController.showBomberos; 
          (_symbolController.showBomberos) ? _showFilterBomberosButtonColor = Colors.white54 : _showFilterBomberosButtonColor = Colors.grey;
          (_symbolController.showBomberos) ? _addMarkers("Bomberos") : _deleteMarkers("Bomberos");
        });
      },
      backgroundColor: _showFilterBomberosButtonColor
    );

    FloatingActionButton filterCarabineros = new FloatingActionButton(
      child: Image(image: AssetImage("assets/carabineros_Chile.png"),),
      onPressed: (){},
      backgroundColor: _showFilterCarabinerosButtonColor
    );

    return Column(
      children: <Widget>[
        filterUrgencias,
        SizedBox(
          height: 10.0,
        ),
        filterBomberos,
        SizedBox(
          height: 10.0,
        ),
        filterCarabineros
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  checkInformation() {
    _areMarkersDrawed;
    _symbolController;
    _myPosition;
    _mapController;
    _mapBoxMap;
    _allData;
    return Container();
  }
}
