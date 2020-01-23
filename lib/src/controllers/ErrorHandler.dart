import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

Map<String, ErrorHandler> errorController = {
  "permissionGranted": ErrorHandler(
      title: "Falta de permisos",
      description:
          "Autorice a la aplicación para poder acceder a su ubicación o no podrá visualizar los servicios de urgencia mas cercanos",
      iconData: Icons.no_encryption,
      iconColor: Colors.yellow,
      iconBackgroundColor: Colors.orange,
      isPersistent: true,
      isPersistentOnStartUp: true,
      action: () async {
        bool gotPermission = await LocationPermissions().requestPermissions() == PermissionStatus.granted;
        if(!gotPermission)
        {
          await LocationPermissions().openAppSettings();
        }
      }),

  "statusEnabled": ErrorHandler(
      title: "Localización inactiva",
      description:
          "El servicio de localización no se encuentra disponible en estos momentos, intente mas tarde.",
      iconData: Icons.location_off,
      iconColor: Colors.red,
      isPersistentOnStartUp: true,
      isPersistent: false,
      iconBackgroundColor: Colors.grey,
      action: (){}),

  "haveConectivity": ErrorHandler(
      title: "Teléfono sin conexión",
      description:
          "Por favor, verifique que la conexión de su dispositivo sea correcta",
      iconData: Icons.signal_wifi_off,
      iconColor: Color.fromRGBO(67, 65, 69, 1.0),
      isPersistentOnStartUp: true,
      isPersistent: false,
      action: (){},
      iconBackgroundColor: Color.fromRGBO(0, 169, 143, 1.0)),
      
  "isGPSActivated": ErrorHandler(
      title: "GPS Desactivado",
      description:
          "Por favor, active la funcionalidad de GPS en su dispositivo.",
      iconData: Icons.gps_off,
      iconColor: Colors.blue,
      iconBackgroundColor: Colors.white,
      action: (){},),

  "unknownError": ErrorHandler(
      title: "Error desconocido",
      description:
          "Ha ocurrido un error desconocido, pruebe a reiniciar la aplicación.",
      iconData: Icons.warning,
      iconColor: Colors.yellow,
      iconBackgroundColor: Colors.orange,
      action: (){},),
  
  "unreachableStore": ErrorHandler(
    title: "La tienda no está disponible en estos momentos",
    description: "No existe acceso a la tienda, verifique que tiene conexión a internet y tiene una cuenta vinculada a su dispositivo.",
    iconData: Icons.sentiment_dissatisfied,
    iconColor: Color.fromRGBO(153, 249, 240, 1.0),
    iconBackgroundColor: Color.fromRGBO(118, 145, 215, 1.0),
    action: (){} 
  )
};

class ErrorHandler {
  String title;
  String description;
  IconData iconData;
  Color iconColor;
  Color iconBackgroundColor;
  Function action = () async {};
  bool isPersistent;
  bool isPersistentOnStartUp;

  ErrorHandler({this.title, this.description, this.iconData, this.iconColor, this.iconBackgroundColor, this.action, this.isPersistent = false, this.isPersistentOnStartUp = false});
}
