import 'package:chilemergencias/utils/routes.dart' as routes;
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
 
void main() => runApp(MyApp());

class MyApp extends StatelessWidget 
{
  //TODO: Controlar cuando se deniegue acceso a gps
  @override
  Widget build(BuildContext context) {
    String _initialRoute = "home";
    _permissionsAndFunctinalitiesAreEnabled().then(
    (value)
    {
      _initialRoute = value ? "home" : "error";
    },
    onError: (error) => _initialRoute = "error");

    return MaterialApp(
      title: 'Chilemergencias',
      initialRoute: _initialRoute,
      routes: routes.routeMap(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
      ));
  }

  Future<bool> _permissionsAndFunctinalitiesAreEnabled() async
  {
    //TODO: Checkear que GPS Tiene permisos, y si no, solicitarlos o pedir activar
    //TODO: Checkear que GPS funcione.
    PermissionStatus _permissionStatus = await LocationPermissions().checkPermissionStatus();
    ServiceStatus _serviceStatus = await LocationPermissions().checkServiceStatus();
    print("Validando permiso de gps, su estado es: $_permissionStatus y el estado del servicio de localización es: $_serviceStatus");

    if(_permissionStatus == PermissionStatus.granted && _serviceStatus == ServiceStatus.enabled)
    {
      return true;
    }
    else
    {
      return false;
    }
    
  }
}