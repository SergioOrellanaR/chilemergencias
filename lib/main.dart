import 'dart:io';

import 'package:chilemergencias/utils/routes.dart' as routes;
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //TODO: Controlar cuando se deniegue acceso a gps
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
    //TODO: Checkear que GPS Tiene permisos, y si no, solicitarlos o pedir activar
    //TODO: Checkear que GPS funcione.
    //TODO: Que al activar o mejorar la condición de alguno de estos problemas la aplicación vuelva a cargar (Usar streams).
    bool _posPermission = await _isLocationStatusAndPermissionsEnabled();
    bool _haveConectivity = await _phoneHaveConectivity();
    print("El teléfono " + (_haveConectivity ? "" : "no ") + "tiene conexión");  

    if (_posPermission && _haveConectivity) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _isLocationStatusAndPermissionsEnabled() async {
    PermissionStatus _permissionStatus =
        await LocationPermissions().checkPermissionStatus();
    ServiceStatus _serviceStatus =
        await LocationPermissions().checkServiceStatus();
    print(
        "Validando permiso de gps, su estado es: $_permissionStatus y el estado del servicio de localización es: $_serviceStatus");
    return (_permissionStatus == PermissionStatus.granted &&
        _serviceStatus == ServiceStatus.enabled);
  }

  Future<bool> _phoneHaveConectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      else
      {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
