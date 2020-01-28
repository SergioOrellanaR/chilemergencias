import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

Map<String, AlertHandler> alertController = {
  "permissionGranted": AlertHandler(
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

  "statusEnabled": AlertHandler(
      title: "Localización inactiva",
      description:
          "El servicio de localización no se encuentra disponible en estos momentos, intente mas tarde.",
      iconData: Icons.location_off,
      iconColor: Colors.red,
      isPersistentOnStartUp: true,
      isPersistent: false,
      iconBackgroundColor: Colors.grey,
      action: (){}),

  "haveConectivity": AlertHandler(
      title: "Teléfono sin conexión",
      description:
          "Por favor, verifique que la conexión de su dispositivo sea correcta",
      iconData: Icons.signal_wifi_off,
      iconColor: Color.fromRGBO(67, 65, 69, 1.0),
      isPersistentOnStartUp: true,
      isPersistent: false,
      action: (){},
      iconBackgroundColor: Color.fromRGBO(0, 169, 143, 1.0)),
      
  "isGPSActivated": AlertHandler(
      title: "GPS Desactivado",
      description:
          "Por favor, active la funcionalidad de GPS en su dispositivo.",
      iconData: Icons.gps_off,
      iconColor: Colors.blue,
      iconBackgroundColor: Colors.white,
      action: (){},),

  "unknownError": AlertHandler(
      title: "Error desconocido",
      description:
          "Ha ocurrido un error desconocido.",
      iconData: Icons.warning,
      iconColor: Colors.yellow,
      iconBackgroundColor: Colors.orange,
      action: (){},),
  
  "unreachableStore": AlertHandler(
    title: "La tienda no está disponible en estos momentos",
    description: "No existe acceso a la tienda, verifique que tiene conexión a internet y tiene una cuenta vinculada a su dispositivo.",
    iconData: Icons.sentiment_dissatisfied,
    iconColor: Color.fromRGBO(153, 249, 240, 1.0),
    iconBackgroundColor: Color.fromRGBO(118, 145, 215, 1.0),
    action: (){} 
  ),
  
  "succesfulDonation": AlertHandler(
    title: "La compra ha sido realizada con éxito",
    description: "Mil gracias por la compra!, gracias a donaciones como estas es que puedo seguir trabajando en más softwares útiles para las personas.",
    iconData: Icons.sentiment_very_satisfied,
    iconColor: Color.fromRGBO(153, 249, 240, 1.0),
    iconBackgroundColor: Color.fromRGBO(118, 145, 215, 1.0),
    action: (){} 
  ),

  "unsuccesfulDonation": AlertHandler(
    title: "No ha sido posible realizar la compra.",
    description: "No ha sido posible llevar a cabo la compra solicitada",
    iconData: Icons.sentiment_dissatisfied,
    iconColor: Color.fromRGBO(153, 249, 240, 1.0),
    iconBackgroundColor: Color.fromRGBO(118, 145, 215, 1.0),
    action: (){} 
  )
};

class AlertHandler {
  String title;
  String description;
  IconData iconData;
  Color iconColor;
  Color iconBackgroundColor;
  Function action = () async {};
  bool isPersistent;
  bool isPersistentOnStartUp;

  AlertHandler({this.title, this.description, this.iconData, this.iconColor, this.iconBackgroundColor, this.action, this.isPersistent = false, this.isPersistentOnStartUp = false});
}
