import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:chilemergencias/src/controllers/SymbolController.dart';
import 'package:chilemergencias/src/models/BomberosModel.dart';
import 'package:chilemergencias/src/models/CarabinerosModel.dart';
import 'package:chilemergencias/src/models/UrgenciasModel.dart';
import 'package:chilemergencias/src/providers/Provider.dart';
import 'package:chilemergencias/utils/utils.dart';

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
  dynamic closestInformation;

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
          children: <Widget>[mapWithStreaming(), _goToClosest()],
        ),
        floatingActionButton: _centerGpsCamera());
  }

  Column _goToClosest() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        Container(
          child: _getClosestButtons(),
          height: 90.0,
          width: 250.0,
          decoration: ShapeDecoration(
              shape: StadiumBorder(), color: Color.fromRGBO(80, 154, 195, 0.5)),
        ),
      ],
    );
  }

  FloatingActionButton _centerGpsCamera() {
    return FloatingActionButton(
      onPressed: () async {
        await _mapController.moveCamera(CameraUpdate.newLatLng(_myPosition));
      },
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
          _addMarkers("Bomberos");
          _addMarkers("Carabineros");
          _allData = snapshot.data;
          _areMarkersDrawed = true;
          return Container();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<Symbol> _addSymbol(String iconImage, LatLng latLng) async {
    return _mapController.addSymbol(
      SymbolOptions(geometry: latLng, iconImage: iconImage),
    );
  }

  void _addMarkers(String institution) async {
    switch (institution) {
      case "Urgencias":
        if (_symbolController.urgenciasSymbols.length == 0) {
          for (UrgenciasModel item in provider.urgencias)
            _symbolController.urgenciasSymbols.add(await _addSymbol(
                "hospital-15", LatLng(item.latitude, item.longitude)));
        }
        break;
      case "Bomberos":
        if (_symbolController.bomberosSymbols.length == 0) {
          for (BomberosModel item in provider.bomberos) {
            _symbolController.bomberosSymbols.add(await _addSymbol(
                "fire-station-15", LatLng(item.latitude, item.longitude)));
          }
        }
        break;
      case "Carabineros":
        if (_symbolController.carabinerosSymbols.length == 0) {
          for (CarabinerosModel item in provider.carabineros)
            _symbolController.carabinerosSymbols.add(await _addSymbol(
                "police-15", LatLng(item.latitude, item.longitude)));
        }
        break;
      default:
        throw new Exception("Opción inválida");
        break;
    }
  }

  //TODO: Refactorizar codigo para que sea mas corto.
  Widget _getClosestButtons() {
    TextStyle textStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        fontStyle: FontStyle.italic);

    FloatingActionButton closestUrgencias   = _createClosestButton("assets/Urgencias_Chile.png");
    FloatingActionButton closestBomberos    = _createClosestButton("assets/Bomberos_Chile.png");
    FloatingActionButton closestCarabineros = _createClosestButton("assets/Carabineros_Chile.png");

    return Column(
      children: <Widget>[
        Text(
          "Ir a mas cercano",
          style: textStyle,
        ),
        Row(
          children: <Widget>[
            closestUrgencias,
            SizedBox(
              width: 10.0,
            ),
            closestBomberos,
            SizedBox(
              width: 10.0,
            ),
            closestCarabineros
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )
      ],
    );
  }

  FloatingActionButton _createClosestButton(String assetImage) {
    String institutionName = _getInstitutionNameByAssetImage(assetImage);
    return FloatingActionButton(
      child: Image(
        image: AssetImage(assetImage),
        height: 45.0,
        width: 45.0,
      ),
      onPressed: () {
            _goToClosestInstitution(institutionName);
      },
      backgroundColor: Colors.white,
    );
  }

  _goToClosestInstitution(String institutionName) {
    switch (institutionName) {
      case "Urgen":
        _goToClosestUrgencias();
        break;
      case "Bombe":
        _goToClosestBombero();
        break;
      default:
        _goToClosestCarabineros();
        break;
    }
  }

  void _goToClosestCarabineros() {
    int idElementIndex = 0;
    int distanceIndex = 1;
    closestInformation = getClosestCarabineroId();
    if (closestInformation != null) {
      String closestId = closestInformation[idElementIndex];
      CarabinerosModel closestCarabinero = _allData[closestId];
      double zoom = setZoomLevel(num.parse(closestInformation[distanceIndex]));
      _mapController.moveCamera(CameraUpdate.newLatLngZoom(
          LatLng(closestCarabinero.latitude, closestCarabinero.longitude),
          zoom));
    }
  }

  void _goToClosestUrgencias() {
    int idElementIndex = 0;
    int distanceIndex = 1;
    closestInformation = getClosestUrgenciaId();
    if (closestInformation != null) {
      String closestId = closestInformation[idElementIndex];
      UrgenciasModel closestUrgencia = _allData[closestId];
      double zoom = setZoomLevel(num.parse(closestInformation[distanceIndex]));
      _mapController.moveCamera(CameraUpdate.newLatLngZoom(
          LatLng(closestUrgencia.latitude, closestUrgencia.longitude), zoom));
    }
  }

  void _goToClosestBombero() {
    int idElementIndex = 0;
    int distanceIndex = 1;
    closestInformation = getClosestBomberoId();
    if (closestInformation != null) {
      String closestId = getClosestBomberoId()[idElementIndex];
      BomberosModel closestBombero = _allData[closestId];
      double zoom = setZoomLevel(num.parse(closestInformation[distanceIndex]));
      _mapController.moveCamera(CameraUpdate.newLatLngZoom(
          LatLng(closestBombero.latitude, closestBombero.longitude), zoom));
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  getClosestBomberoId() {
    final latlong.Distance distance = new latlong.Distance();
    latlong.LatLng mypos =
        latlong.LatLng(_myPosition.latitude, _myPosition.longitude);
    num minorDistance;
    int closestId;

    for (int i = 0; i < provider.bomberos.length; i++) {
      latlong.LatLng objectPosition = latlong.LatLng(
          provider.bomberos[i].latitude, provider.bomberos[i].longitude);
      num distanceBetween = distance.distance(mypos, objectPosition);

      if (minorDistance == null || distanceBetween < minorDistance) {
        minorDistance = distanceBetween;
        closestId = i;
      }
    }
    return (closestId != null)
        ? [closestId.toString() + "_Bombe", minorDistance.toString()]
        : null;
  }

  getClosestUrgenciaId() {
    final latlong.Distance distance = new latlong.Distance();
    latlong.LatLng mypos =
        latlong.LatLng(_myPosition.latitude, _myPosition.longitude);
    num minorDistance;
    int closestId;

    for (int i = 0; i < provider.urgencias.length; i++) {
      latlong.LatLng objectPosition = latlong.LatLng(
          provider.urgencias[i].latitude, provider.urgencias[i].longitude);
      num distanceBetween = distance.distance(mypos, objectPosition);

      if (minorDistance == null || distanceBetween < minorDistance) {
        minorDistance = distanceBetween;
        closestId = i;
      }
    }
    return (closestId != null)
        ? [closestId.toString() + "_Urgen", minorDistance.toString()]
        : null;
  }

  getClosestCarabineroId() {
    final latlong.Distance distance = new latlong.Distance();
    latlong.LatLng mypos =
        latlong.LatLng(_myPosition.latitude, _myPosition.longitude);
    num minorDistance;
    int closestId;

    for (int i = 0; i < provider.carabineros.length; i++) {
      latlong.LatLng objectPosition = latlong.LatLng(
          provider.carabineros[i].latitude, provider.carabineros[i].longitude);
      num distanceBetween = distance.distance(mypos, objectPosition);

      if (minorDistance == null || distanceBetween < minorDistance) {
        minorDistance = distanceBetween;
        closestId = i;
      }
    }

    return (closestId != null)
        ? [closestId.toString() + "_Carab", minorDistance.toString()]
        : null;
  }

  String _getInstitutionNameByAssetImage(String assetImage) {
    String value;
    switch (assetImage) {
      case "assets/Urgencias_Chile.png":
        value = "Urgen";
        break;
      case "assets/Bomberos_Chile.png":
        value = "Bombe";
        break;
      default:
        value = "Carab";
        break;
    }
    return value;
  }
}
