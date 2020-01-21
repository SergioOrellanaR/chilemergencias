import 'package:flutter/material.dart';

Map<String, ErrorHandler> errorController = {
  "permissionGranted": ErrorHandler(
      title: "Falta de permisos",
      description:
          "Autorice a la aplicación para poder acceder a su ubicación o no podrá visualizar los servicios de urgencia mas cercanos.",
      iconData: Icons.no_encryption,
      iconColor: Colors.yellow,
      iconBackgroundColor: Colors.orange),
  "statusEnabled": ErrorHandler(
      title: "Localización inactiva",
      description:
          "El servicio de localización no se encuentra disponible en estos momentos, intente mas tarde.",
      iconData: Icons.location_off,
      iconColor: Colors.red,
      iconBackgroundColor: Colors.grey),
  "haveConectivity": ErrorHandler(
      title: "Teléfono sin conexión",
      description:
          "La conexión a internet de su dispositivo es inestable, por lo que su ubicación podría ser inexacta.",
      iconData: Icons.signal_wifi_off,
      iconColor: Color.fromRGBO(67, 65, 69, 1.0),
      iconBackgroundColor: Color.fromRGBO(0, 169, 143, 1.0)),
  "isGPSActivated": ErrorHandler(
      title: "GPS Desactivado",
      description:
          "Por favor, active la funcionalidad de GPS en su dispositivo.",
      iconData: Icons.gps_off,
      iconColor: Colors.blue,
      iconBackgroundColor: Colors.white),
  "unknownError": ErrorHandler(
      title: "Error desconocido",
      description:
          "Ha ocurrido un error desconocido, pruebe a reiniciar la aplicación.",
      iconData: Icons.warning,
      iconColor: Colors.yellow,
      iconBackgroundColor: Colors.orange)
};

class ErrorHandler {
  String title;
  String description;
  IconData iconData;
  Color iconColor;
  Color iconBackgroundColor;

  ErrorHandler({this.title, this.description, this.iconData, this.iconColor, this.iconBackgroundColor});
}
