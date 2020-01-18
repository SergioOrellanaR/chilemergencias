import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:chilemergencias/src/models/Institution.dart';
import 'package:chilemergencias/src/providers/Provider.dart';
import 'package:chilemergencias/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
//https://stackoverflow.com/questions/54910211/errorflutter-lib-ui-ui-dart-state-cc148-unhandled-exception/57087364

class _HomePageState extends State<HomePage> {
  bool _areMarkersDrawed = false;
  LatLng _myPosition;
  MapboxMapController _mapController;
  MapboxMap _mapBoxMap;
  Map<String, dynamic> _allData;
  List<String> _closestThreeOfEachInstitutionId;
  dynamic closestInformation;

  @override
  void initState() {
    super.initState();
    _myPosition = new LatLng(0, 0);
    _createMapBoxMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text("Hi")),
        body: Stack(
          children: <Widget>[mapWithStreaming(), _goToClosest()],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: _createOperationButtons());
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

  Widget _createOperationButtons() {
    FloatingActionButton zoomIn = new FloatingActionButton(
      child: Icon(Icons.zoom_in),
      onPressed: () {
        _mapController.animateCamera(CameraUpdate.zoomIn());
      },
    );

    FloatingActionButton zoomOut = new FloatingActionButton(
      child: Icon(Icons.zoom_out),
      onPressed: () {
        _mapController.animateCamera(CameraUpdate.zoomOut());
      },
    );

    return Row(
      children: <Widget>[
        Expanded(child: SizedBox()),
        Column(
          children: <Widget>[
            SizedBox(
              height: 130.0,
            ),
            zoomIn,
            SizedBox(
              height: 10.0,
            ),
            zoomOut,
            Expanded(child: SizedBox()),
            _centerGpsCamera(),
          ],
        ),
      ],
    );
  }

  FloatingActionButton _centerGpsCamera() {
    return FloatingActionButton(
      onPressed: () async {
        await _mapController
            .animateCamera(CameraUpdate.newLatLngZoom(_myPosition, 14.0));
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
          //Verificar performance y uso de bateria de actualización en tiempo real de instituciones cercanas.

          if (_mapController != null && _areMarkersDrawed == false) {
            widget = drawInstitutionsOnMap();
          } else if (_mapController != null && _areMarkersDrawed) {
            _setDistanceBetweenPositionAndInstitutions();
            List<String> topThree = _loadClosestThreeOfEach();

            if (!listEquals(topThree, _closestThreeOfEachInstitutionId)) {
              _closestThreeOfEachInstitutionId = topThree;
              _clearMarkers();
              _addMarkers();
            }
          }

          //_setDistanceBetweenPositionAndInstitutions();
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
        initialCameraPosition: CameraPosition(target: _myPosition, zoom: 14),
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
          _allData = snapshot.data;
          _setDistanceBetweenPositionAndInstitutions();
          _closestThreeOfEachInstitutionId = _loadClosestThreeOfEach();
          if (_closestThreeOfEachInstitutionId != null) {
            _addMarkers();
            _areMarkersDrawed = true;
          }

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

  void _addMarkers() async {
    for (String id in _closestThreeOfEachInstitutionId) {
      Institution item = _allData[id];
      String iconImage = utils.iconByInstitution(id.substring(id.length - 5));
      await _addSymbol(iconImage, LatLng(item.latitude, item.longitude));
    }
  }

  void _clearMarkers() async {
    await _mapController.clearSymbols();
  }

  // void _addMarkers(String institutionName) async {
  //   List<Institution> institutionList =
  //       provider.listByInstitution(institutionName);
  //   String iconImage = utils.iconByInstitution(institutionName);

  //   for (Institution item in institutionList) {
  //     await _addSymbol(iconImage, LatLng(item.latitude, item.longitude));
  //   }
  // }

  Widget _getClosestButtons() {
    TextStyle textStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        fontStyle: FontStyle.italic);

    FloatingActionButton closestUrgencias =
        _createClosestButton("assets/Urgencias_Chile.png");
    FloatingActionButton closestBomberos =
        _createClosestButton("assets/Bomberos_Chile.png");
    FloatingActionButton closestCarabineros =
        _createClosestButton("assets/Carabineros_Chile.png");

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
    String institutionName = _institutionNameByAssetImage(assetImage);
    return FloatingActionButton(
      child: Image(
        image: AssetImage(assetImage),
        height: 45.0,
        width: 45.0,
      ),
      onPressed: () {
        _goToClosestBuilding(institutionName);
      },
      backgroundColor: Colors.white,
    );
  }

  void _goToClosestBuilding(String institutionName) {
    int idElementIndex = 0;
    int distanceIndex = 1;
    closestInformation = _getClosestInformation(institutionName);
    if (closestInformation != null) {
      String closestId = closestInformation[idElementIndex];
      Institution closestInstitution = _allData[closestId];
      double zoom =
          utils.setZoomLevel(num.parse(closestInformation[distanceIndex]));
      _mapController.moveCamera(CameraUpdate.newLatLngZoom(
          LatLng(closestInstitution.latitude, closestInstitution.longitude),
          zoom));
    }
  }

  void _setDistanceBetweenPositionAndInstitutions() {
    if (_allData != null) {
      _allData.forEach((key, value) {
        Institution inst = value;
        inst.calculateMetersFromActualPosition(_myPosition);
        value = inst;
      });
    }
  }

  _getClosestInformation(String institutionName) {
    final latlong.Distance distance = new latlong.Distance();
    latlong.LatLng mypos =
        latlong.LatLng(_myPosition.latitude, _myPosition.longitude);
    num minorDistance;
    int closestId;
    List<Institution> servicesList =
        provider.listByInstitution(institutionName);

    for (int i = 0; i < servicesList.length; i++) {
      latlong.LatLng objectPosition =
          latlong.LatLng(servicesList[i].latitude, servicesList[i].longitude);
      num distanceBetween = distance.distance(mypos, objectPosition);

      if (minorDistance == null || distanceBetween < minorDistance) {
        minorDistance = distanceBetween;
        closestId = i;
      }
    }

    return (closestId != null)
        ? [
            closestId.toString() + "_" + institutionName,
            minorDistance.toString()
          ]
        : null;
  }

  String _institutionNameByAssetImage(String assetImage) {
    String value;
    switch (assetImage) {
      case "assets/Urgencias_Chile.png":
        value = "Urgen";
        break;
      case "assets/Bomberos_Chile.png":
        value = "Bombe";
        break;
      case "assets/Carabineros_Chile.png":
        value = "Carab";
        break;
      default:
        value = null;
        break;
    }
    return value;
  }

  _loadClosestThreeOfEach() {
    List<String> sortedKeys = _allData.keys.toList(growable: false)
      ..sort((k1, k2) => _allData[k1]
          .metersFromActualPosition
          .compareTo(_allData[k2].metersFromActualPosition));

    return _topThreeByInstitution(sortedKeys, "Urgen") +
        _topThreeByInstitution(sortedKeys, "Bombe") +
        _topThreeByInstitution(sortedKeys, "Carab");
  }

  List<String> _topThreeByInstitution(
      List<String> sortedKeys, String institutionName) {
    List<String> topThree = sortedKeys
        .where((value) => value.substring(value.length - 5) == institutionName)
        .toList();
    return [topThree[0], topThree[1], topThree[2]];
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
