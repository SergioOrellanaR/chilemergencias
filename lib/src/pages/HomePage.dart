import 'dart:async';

import 'package:chilemergencias/src/providers/Provider.dart';
import 'package:chilemergencias/utils/private.dart' as privateInfo;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  LatLng _myPosition;
  StreamController streamController;

  Map<String, dynamic> _allData;
  
  MapboxMap _mapboxMap;
  int counter = 0;

  @override
  void initState() { 
    super.initState();
    _myPosition = new LatLng(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    // loadInformation();
    return Scaffold(
      // appBar: AppBar(title: Text("Hi")),
      body: mapWithStreaming(),
      floatingActionButton: FloatingActionButton(onPressed: (){},),
    );
  }


  Widget futureBuildMap()
  {
    return FutureBuilder(
      future: getMap(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData)
        {
          _mapboxMap = snapshot.data;
          return snapshot.data;
        }
        else
        {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  loadInformation() async
  {
    _allData = await provider.allDataToMap();
  }

  Future<MapboxMap> getMap() async
  {

    return MapboxMap(
      initialCameraPosition: CameraPosition(target: _myPosition, zoom: 8.0),
      // myLocationEnabled: true,
      // compassEnabled: true,
    );
  }

  // streamLocation()
  // {
  //   var location = new Location();

  //   location.onLocationChanged().listen((LocationData currentLocation) {
  //     LatLng latLng = new LatLng(currentLocation.latitude, currentLocation.longitude);
  //     setState(() {
  //       _myPosition = latLng;
  //     });
  //   });
    
  // }

  mapWithStreaming()
  {
    var location = new Location();
    return StreamBuilder(
      stream: location.onLocationChanged(),
      builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot)
      {
        if (snapshot.hasData) {
            _myPosition = LatLng(snapshot.data.latitude, snapshot.data.longitude);

          return MapboxMap(initialCameraPosition: CameraPosition(target: _myPosition));

        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // _loadListFromFirebase(ProductsBloc pbloc) {

  //   return StreamBuilder(
  //     stream: pbloc.productsStream ,
  //     builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
  //       if (snapshot.hasData) {
  //         final products = snapshot.data;

  //         return ListView.builder(
  //           itemCount: products.length,
  //           itemBuilder: (context, i) => _buildItem(context, products[i], pbloc),
  //         );
  //       } else {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //     },
  //   );
  // }
  // @override
  // Widget build(BuildContext context) {
  //   final MapboxMap mapboxMap = MapboxMap(
  //     onMapCreated: onMapCreated,
  //     initialCameraPosition: _kInitialPosition,
  //     trackCameraPosition: true,
  //     compassEnabled: _compassEnabled,
  //     cameraTargetBounds: _cameraTargetBounds,
  //     minMaxZoomPreference: _minMaxZoomPreference,
  //     styleString: _styleString,
  //     rotateGesturesEnabled: _rotateGesturesEnabled,
  //     scrollGesturesEnabled: _scrollGesturesEnabled,
  //     tiltGesturesEnabled: _tiltGesturesEnabled,
  //     zoomGesturesEnabled: _zoomGesturesEnabled,
  //     myLocationEnabled: _myLocationEnabled,
  //     myLocationTrackingMode: _myLocationTrackingMode,
  //     myLocationRenderMode: MyLocationRenderMode.GPS,
  //     onMapClick: (point, latLng) async {
  //       print("${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
  //       List features = await mapController.queryRenderedFeatures(point, [],null);
  //       if (features.length>0) {
  //         print(features[0]);
  //       }
  //     },
  //     onCameraTrackingDismissed: () {
  //       this.setState(() {
  //         _myLocationTrackingMode = MyLocationTrackingMode.None;
  //       });
  //     }
  //   );

  //   final List<Widget> columnChildren = <Widget>[
  //     Padding(
  //       padding: const EdgeInsets.all(10.0),
  //       child: Center(
  //         child: SizedBox(
  //           width: 300.0,
  //           height: 200.0,
  //           child: mapboxMap,
  //         ),
  //       ),
  //     ),
  //   ];

  //   if (mapController != null) {
  //     columnChildren.add(
  //       Expanded(
  //         child: ListView(
  //           children: <Widget>[
  //             Text('camera bearing: ${_position.bearing}'),
  //             Text(
  //                 'camera target: ${_position.target.latitude.toStringAsFixed(4)},'
  //                 '${_position.target.longitude.toStringAsFixed(4)}'),
  //             Text('camera zoom: ${_position.zoom}'),
  //             Text('camera tilt: ${_position.tilt}'),
  //             Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
  //             _compassToggler(),
  //             _myLocationTrackingModeCycler(),
  //             _latLngBoundsToggler(),
  //             _setStyleToSatellite(),
  //             _zoomBoundsToggler(),
  //             _rotateToggler(),
  //             _scrollToggler(),
  //             _tiltToggler(),
  //             _zoomToggler(),
  //             _myLocationToggler(),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: columnChildren,
  //   );
  // }

  // void onMapCreated(MapboxMapController controller) {
  //   mapController = controller;
  //   mapController.addListener(_onMapChanged);
  //   _extractMapInfo();
  //   setState(() {});
  // }
}