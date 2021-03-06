import 'dart:async';
import 'package:chilemergencias/src/widgets/InformationCard.dart';
import 'package:chilemergencias/src/widgets/ValidatorWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:chilemergencias/src/models/Institution.dart';
import 'package:chilemergencias/src/providers/Provider.dart';
import 'package:chilemergencias/utils/utils.dart' as utils;
import 'package:chilemergencias/utils/globals.dart' as globals;

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
  List<String> _closestThreeOfEachInstitutionId;
  Map<String, String> _symbolInstitutionConnected;
  Map<String, Symbol> _markers;
  dynamic closestInformation;
  InformationCard _informationCard;
  bool _buttonPressedonZoom = false;
  bool _loopActiveOnZoom = false;
  Size _screenSize;

  @override
  void initState() {
    super.initState();
    _myPosition = new LatLng(0, 0);
    _markers = new Map<String, Symbol>();
    _createMapBoxMap();
  }

  @override
  Widget build(BuildContext context) {
    _lockOrientationToPortrait();
    _screenSize = MediaQuery.of(context).size;
    return Semantics(
      child: Scaffold(
          body: Stack(children: <Widget>[
            mapWithStreaming(),
            ValidatorWidget(),
            _mapController == null ? Container() : _goToClosest(),
            _informationCard ?? Container()
          ]),
          floatingActionButton: _mapController == null
              ? Container()
              : _createOperationButtons(context)),
      label: "Mapa",
    );
  }

  Future<void> _lockOrientationToPortrait() {
    //TODO: Eliminar método cuando mapbox resuelva error.
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
        ),
      ],
    );
  }

  Widget _createOperationButtons(BuildContext context) {
    Listener zoomIn = _zoomButtonListener(isZoomIn: true);
    Listener zoomOut = _zoomButtonListener(isZoomIn: false);

    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(),
        ),
        SizedBox(
          height: 115.0,
        ),
        zoomIn,
        SizedBox(
          height: 15.0,
        ),
        zoomOut,
        Expanded(
          child: SizedBox(),
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 30.0,
            ),
            _goToInformation(context),
            Expanded(
              child: SizedBox(),
            ),
            _centerGpsCamera(),
          ],
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }

  Listener _zoomButtonListener({bool isZoomIn}) {
    return Listener(
      onPointerDown: (details) {
        _buttonPressedonZoom = true;
        _zoomWhilePressed(isZoomIn);
      },
      onPointerUp: (details) {
        _buttonPressedonZoom = false;
      },
      child: _zoomButtonConfiguration(isZoomIn),
    );
  }

  FloatingActionButton _zoomButtonConfiguration(bool isZoomIn) {
    return new FloatingActionButton(
      child: Icon(isZoomIn ? Icons.zoom_in : Icons.zoom_out, size: 35.0),
      elevation: 50.0,
      onPressed: () {},
      backgroundColor: Color.fromRGBO(80, 80, 80, 1.0),
      heroTag: isZoomIn ? "btnZoomIn" : "btnZoomOut",
      mini: true,
    );
  }

  void _zoomWhilePressed(bool isZoomIn) async {
    // make sure that only one loop is active
    if (_loopActiveOnZoom) return;

    _loopActiveOnZoom = true;

    while (_buttonPressedonZoom) {
      setState(() {
        if (isZoomIn) {
          _mapController.animateCamera(CameraUpdate.zoomIn());
        } else {
          _mapController.animateCamera(CameraUpdate.zoomOut());
        }
      });

      await Future.delayed(Duration(milliseconds: 400));
    }

    _loopActiveOnZoom = false;
  }

  FloatingActionButton _goToInformation(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btnInformation",
      onPressed: () {
        Navigator.pushNamed(context, "information");
      },
      child: Icon(Icons.info_outline, size: 35.0),
      backgroundColor: Color.fromRGBO(80, 80, 80, 1.0),
      mini: true,
    );
  }

  FloatingActionButton _centerGpsCamera() {
    return FloatingActionButton(
      onPressed: () async {
        await _mapController
            .animateCamera(CameraUpdate.newLatLngZoom(_myPosition, 14.0));
      },
      child: Icon(Icons.gps_fixed, size: 35.0),
      backgroundColor: Color.fromRGBO(80, 80, 80, 1.0),
      heroTag: "btnCenterGPS",
      mini: true,
    );
  }

  mapWithStreaming() {
    var location = new Location();
    return StreamBuilder(
      stream: location.onLocationChanged(),
      builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
        if (snapshot.hasData) {

          Widget widget = Container();
          _myPosition = LatLng(snapshot.data.latitude, snapshot.data.longitude);
          //Verificar performance y uso de bateria de actualización en tiempo real de instituciones cercanas.

          if (_mapController != null && _markers.isEmpty) {
            widget = drawInstitutionsOnMap();
          } else if (_mapController != null && _markers.isNotEmpty) {
            updateIconsAtNewPosition();
          }

          //_setDistanceBetweenPositionAndInstitutions();
          return Stack(
            children: <Widget>[_mapBoxMap, widget],
          );
        } else {
          // print(snapshot.connectionState);
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void updateIconsAtNewPosition() {
    _setDistanceBetweenPositionAndInstitutions();
    List<String> topThree = _loadClosestThreeOfEach();
    if (!listEquals(topThree, _closestThreeOfEachInstitutionId)) {
      _closestThreeOfEachInstitutionId = topThree;
      _clearMarkers();
      _addMarkers();
    }
  }

  void _createMapBoxMap() {
    _mapBoxMap = MapboxMap(
        initialCameraPosition: CameraPosition(target: _myPosition, zoom: 14),
        myLocationEnabled: true,
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
          _mapController.onSymbolTapped.add((symbol) {
            String institutionId = _symbolInstitutionConnected[symbol.id];
            LatLng focusedInstitution = _loadInformationCard(institutionId);
            _mapController.animateCamera(
                CameraUpdate.newLatLngZoom(focusedInstitution, 14.0));
          });
        },
        compassEnabled: true,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: true,
        styleString: MapboxStyles.DARK,
        zoomGesturesEnabled: true);
  }

  LatLng _loadInformationCard(String institutionId) {
    Institution institution = _allData[institutionId];
    setState(() {
      globals.isInformationCardVisible = true;
      _informationCard = InformationCard(
        name: institution.name,
        address: institution.address,
        commune: institution.commune,
        phone: institution.phone,
        institutionCode: institutionCode(institutionId),
        latitude: institution.latitude,
        longitude: institution.longitude,
      );
    });
    return LatLng(institution.latitude, institution.longitude);
  }

  Widget drawInstitutionsOnMap() {
    return FutureBuilder(
      future: provider.allDataToMap(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
          _allData = snapshot.data;
          _setDistanceBetweenPositionAndInstitutions();
          _closestThreeOfEachInstitutionId = _loadClosestThreeOfEach();
          if (_closestThreeOfEachInstitutionId != null) {
            _addMarkers();
          }

          return Container();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<Symbol> _addSymbol(String iconImage, LatLng latLng) async {
    return _mapController.addSymbol(SymbolOptions(
        geometry: latLng,
        iconImage: iconImage,
        draggable: false,
        iconSize: _screenSize.height * 0.0014));
  }

  void _addMarkers() async {
    _symbolInstitutionConnected = new Map<String, String>();
    for (String institutionId in _closestThreeOfEachInstitutionId) {
      String _institutionCode = institutionCode(institutionId);

      Institution item = _allData[institutionId];
      String symbolIcon = utils.iconOnMapByInstitution(_institutionCode);
      Symbol sym =
          await _addSymbol(symbolIcon, LatLng(item.latitude, item.longitude));
      
      _markers.putIfAbsent(institutionId, () => sym);

      _symbolInstitutionConnected.putIfAbsent(sym.id, () => institutionId);
    }
  }

  void _clearMarkers() async {
    await _mapController.clearSymbols();
    _markers = new Map<String, Symbol>();
  }

  Widget _getClosestButtons() {
    TextStyle textStyle = TextStyle(
        color: Colors.white, fontSize: 18.0, fontStyle: FontStyle.italic);

    FloatingActionButton closestUrgencias = _createClosestButton("Urgen");
    FloatingActionButton closestBomberos = _createClosestButton("Bombe");
    FloatingActionButton closestCarabineros = _createClosestButton("Carab");

    return Column(
      children: <Widget>[
        Container(
          child: Text(
            "Buscar mas cercano",
            style: textStyle,
          ),
          decoration: ShapeDecoration(
            shape: StadiumBorder(),
            color: Color.fromRGBO(20, 20, 20, 0.2),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          children: <Widget>[
            closestUrgencias,
            closestBomberos,
            closestCarabineros
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        )
      ],
    );
  }

  FloatingActionButton _createClosestButton(String institutionCode) {
    String assetImage =
        utils.assetImageOnClosestButtonByInstitutionCode(institutionCode);
    return FloatingActionButton(
      child: Image(
        image: AssetImage(assetImage),
        height: 45.0,
        width: 45.0,
      ),
      onPressed: () {
        String closestId = _closestBuilding(institutionCode);
        _loadInformationCard(closestId);
      },
      backgroundColor: utils.setColorByInstitutionCode(institutionCode),
      heroTag: "btnGoTo$institutionCode",
    );
  }

  String _closestBuilding(String institutionCode) {
    int idElementIndex = 0;
    int distanceIndex = 1;
    closestInformation = _getClosestInformation(institutionCode);
    String closestId;
    if (closestInformation != null) {
      closestId = closestInformation[idElementIndex];
      Institution closestInstitution = _allData[closestId];
      double zoom =
          utils.setZoomLevel(num.parse(closestInformation[distanceIndex]));
      _mapController.moveCamera(CameraUpdate.newLatLngZoom(
          LatLng(closestInstitution.latitude, closestInstitution.longitude),
          zoom));
    }
    return closestId;
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

  _getClosestInformation(String institutionCode) {
    final latlong.Distance distance = new latlong.Distance();
    latlong.LatLng mypos =
        latlong.LatLng(_myPosition.latitude, _myPosition.longitude);
    num minorDistance;
    int closestId;
    List<Institution> servicesList =
        provider.listByInstitution(institutionCode);

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
            closestId.toString() + "_" + institutionCode,
            minorDistance.toString()
          ]
        : null;
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
        .where((value) => institutionCode(value) == institutionName)
        .toList();
    return [topThree[0], topThree[1], topThree[2]];
  }

  String institutionCode(String institutionId) {
    return institutionId.substring(institutionId.length - 5);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
