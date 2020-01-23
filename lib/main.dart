import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:chilemergencias/utils/utils.dart' as utils;
import 'package:chilemergencias/utils/routes.dart' as routes;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _permissionsAndFunctionalitiesAreEnabled(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
              title: 'Chilemergencias',
              initialRoute: snapshot.data ? "home" : "error",
              routes: routes.routeMap(),
              debugShowCheckedModeBanner: false);
        } else {
          return Container(
              child: Center(child: new CircularProgressIndicator()),
              color: Colors.white,);
        }
      },
    );
  }

  Future<bool> _permissionsAndFunctionalitiesAreEnabled() async {
    bool _isPermissionGranted = await utils.isPermissionStatusGranted();
    bool _isStatusEnabled = await utils.isServiceStatusEnabled();
    bool _haveConectivity = await utils.phoneHaveConectivity();
    
    if(!_isPermissionGranted)
    {
      _isPermissionGranted = await LocationPermissions().requestPermissions() == PermissionStatus.granted;
    }
    if (_isPermissionGranted && _isStatusEnabled && _haveConectivity) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> openAppSettings() async
  {
    return await LocationPermissions().openAppSettings();
  }  
}
