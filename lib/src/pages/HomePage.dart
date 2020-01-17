import 'dart:async';
import 'package:chilemergencias/src/controllers/SymbolController.dart';
import 'package:chilemergencias/src/models/BomberosModel.dart';
import 'package:chilemergencias/src/models/CarabinerosModel.dart';
import 'package:chilemergencias/src/models/UrgenciasModel.dart';
import 'package:chilemergencias/src/providers/Provider.dart';
import 'package:chilemergencias/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' as latlong;
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

  Color _showFilterUrgenciasButtonColor = Colors.white54;
  Color _showFilterBomberosButtonColor = Colors.white54;
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
          children: <Widget>[mapWithStreaming(), _filtering(), _goToClosest()],
        ),
        floatingActionButton: _centerGpsCamera());
  }

  Row _filtering() {
    return Row(
      children: <Widget>[
        Container(
          child: _filterButtons(),
          height: 250.0,
          width: 70.0,
          decoration: ShapeDecoration(
              shape: StadiumBorder(), color: Color.fromRGBO(80, 154, 195, 0.5)),
        ),
        Expanded(
          child: Container(),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );
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
          _allData = snapshot.data;
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

  //TODO: Agregar verificación
  void _deleteMarkers(String institution) async {
    List<String> symbolIds = new List<String>();
    switch (institution) {
      case "Urgencias":
        for (Symbol item in _symbolController.urgenciasSymbols)
          symbolIds.add(item.id);
        _symbolController.urgenciasSymbols = new List<Symbol>();
        break;
      case "Bomberos":
        for (Symbol item in _symbolController.bomberosSymbols)
          symbolIds.add(item.id);
        _symbolController.bomberosSymbols = new List<Symbol>();
        break;
      case "Carabineros":
        for (Symbol item in _symbolController.carabinerosSymbols)
          symbolIds.add(item.id);
        _symbolController.carabinerosSymbols = new List<Symbol>();
        break;
      default:
        throw new Exception("Opción inválida");
        break;
    }
    await _mapController.customClearSymbols(symbolIds);
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

  //TODO: Refactorizar código para que quede mas ordenado.
  Widget _filterButtons() {
    TextStyle textStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        fontStyle: FontStyle.italic);

    FloatingActionButton filterUrgencias = new FloatingActionButton(
      child: Image(
        image: AssetImage("assets/urgencias_Chile.png"),
        height: 45.0,
        width: 45.0,
      ),
      onPressed: () {
        setState(() {
          _symbolController.showUrgencias = !_symbolController.showUrgencias;
          (_symbolController.showUrgencias)
              ? _showFilterUrgenciasButtonColor = Colors.white54
              : _showFilterUrgenciasButtonColor = Color.fromRGBO(189, 0, 26, 1);
          (_symbolController.showUrgencias)
              ? _addMarkers("Urgencias")
              : _deleteMarkers("Urgencias");
        });
      },
      backgroundColor: _showFilterUrgenciasButtonColor,
    );

    FloatingActionButton filterBomberos = new FloatingActionButton(
        child: Image(
          image: AssetImage("assets/Bomberos_Chile.png"),
        ),
        onPressed: () {
          setState(() {
            _symbolController.showBomberos = !_symbolController.showBomberos;
            (_symbolController.showBomberos)
                ? _showFilterBomberosButtonColor = Colors.white54
                : _showFilterBomberosButtonColor =
                    Color.fromRGBO(189, 0, 26, 1);
            (_symbolController.showBomberos)
                ? _addMarkers("Bomberos")
                : _deleteMarkers("Bomberos");
          });
        },
        backgroundColor: _showFilterBomberosButtonColor);

    FloatingActionButton filterCarabineros = new FloatingActionButton(
        child: Image(
          image: AssetImage("assets/carabineros_Chile.png"),
        ),
        onPressed: () {
          setState(() {
            _symbolController.showCarabineros =
                !_symbolController.showCarabineros;
            (_symbolController.showCarabineros)
                ? _showFilterCarabinerosButtonColor = Colors.white54
                : _showFilterCarabinerosButtonColor =
                    Color.fromRGBO(189, 0, 26, 1);
            (_symbolController.showCarabineros)
                ? _addMarkers("Carabineros")
                : _deleteMarkers("Carabineros");
          });
        },
        backgroundColor: _showFilterCarabinerosButtonColor);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        Text(
          "Filtrar:",
          style: textStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
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
    );
  }

  //TODO: Refactorizar codigo para que sea mas corto.
  Widget _getClosestButtons() {
    int idElementIndex = 0;
    dynamic closestInformation;
    TextStyle textStyle = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        fontStyle: FontStyle.italic);

    FloatingActionButton closestUrgencias = new FloatingActionButton(
      child: Image(
        image: AssetImage("assets/urgencias_Chile.png"),
        height: 45.0,
        width: 45.0,
      ),
      onPressed: (_symbolController.showUrgencias)
          ? () {
              closestInformation =
                  _goToClosestUrgencias(closestInformation, idElementIndex);
            }
          : null,
      backgroundColor: _showFilterUrgenciasButtonColor,
    );

    FloatingActionButton closestBomberos = new FloatingActionButton(
        child: Image(
          image: AssetImage("assets/Bomberos_Chile.png"),
        ),
        onPressed: (_symbolController.showBomberos)
            ? () {
                closestInformation =
                    _goToClosestBombero(closestInformation, idElementIndex);
              }
            : null,
        backgroundColor: _showFilterBomberosButtonColor);

    FloatingActionButton closestCarabineros = new FloatingActionButton(
        child: Image(
          image: AssetImage("assets/carabineros_Chile.png"),
        ),
        onPressed: (_symbolController.showCarabineros)
            ? () {
                _goToClosestCarabineros(closestInformation, idElementIndex);
              }
            : null,
        backgroundColor: _showFilterCarabinerosButtonColor);

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

  dynamic _goToClosestCarabineros(closestInformation, int idElementIndex) {
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
    return closestInformation;
  }

  dynamic _goToClosestUrgencias(closestInformation, int idElementIndex) {
    int distanceIndex = 1;
    closestInformation = getClosestUrgenciaId();
    if (closestInformation != null) {
      String closestId = closestInformation[idElementIndex];
      UrgenciasModel closestUrgencia = _allData[closestId];
      double zoom = setZoomLevel(num.parse(closestInformation[distanceIndex]));
      _mapController.moveCamera(CameraUpdate.newLatLngZoom(
          LatLng(closestUrgencia.latitude, closestUrgencia.longitude), zoom));
    }
    return closestInformation;
  }

  dynamic _goToClosestBombero(closestInformation, int idElementIndex) {
    int distanceIndex = 1;
    closestInformation = getClosestBomberoId();
    if (closestInformation != null) {
      String closestId = getClosestBomberoId()[idElementIndex];
      BomberosModel closestBombero = _allData[closestId];
      double zoom = setZoomLevel(num.parse(closestInformation[distanceIndex]));
      _mapController.moveCamera(CameraUpdate.newLatLngZoom(
          LatLng(closestBombero.latitude, closestBombero.longitude), zoom));
    }
    return closestInformation;
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
//a
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
}
