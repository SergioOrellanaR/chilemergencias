import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

double setZoomLevel(num metersToClosest) {
    double zoomValue;
    if (metersToClosest < 500) {
      zoomValue = 15.2;
    } else if (metersToClosest < 1000) {
      zoomValue = 14;
    } else if (metersToClosest < 2000) {
      zoomValue = 13;
    } else if (metersToClosest < 4000) {
      zoomValue = 12;
    } else if (metersToClosest < 8000) {
      zoomValue = 11;
    } else if (metersToClosest < 16000) {
      zoomValue = 9.5;
    } else if (metersToClosest < 32000) {
      zoomValue = 8.5;
    } else if (metersToClosest < 64000) {
      zoomValue = 7.5;
    } else if (metersToClosest < 128000) {
      zoomValue = 6.35;
    } else if (metersToClosest < 256000) {
      zoomValue = 6;
    } else {
      zoomValue = 4;
    }
    return zoomValue;
  }

String iconByInstitution(String institutionName) {
    String value;
    switch (institutionName) {
      case "Urgen":
        value = "hospital-15";
        break;
      case "Bombe":
        value = "fire-station-15";
        break;
      case "Carab":
        value = "police-15";
        break;
      default:
        break;
    }
    return value;
  }

String assetImageOnClosestButtonByInstitutionCode(String institutionCode) {
    String value;
    switch (institutionCode) {
      case "Urgen":
        value = "assets/Urgencias_Chile.png";
        break;
      case "Bombe":
        value = "assets/Bomberos_Chile.png";
        break;
      case "Carab":
        value = "assets/Carabineros_Chile.png";
        break;
      default:
        break;
    }
    return value;
  }

String assetImageOnCardByInstitutionCode(String institutionCode) {
    String value;
    switch (institutionCode) {
      case "Urgen":
        value = "assets/Urgencias_Chile.png";
        break;
      case "Bombe":
        value = "assets/Bomberos3DSinRelleno.png";
        break;
      case "Carab":
        value = "assets/Carabineros3D.png";
        break;
      default:
        break;
    }
    return value;
  }

Color setColorByInstitutionCode(String institutionCode)
  {
    Color color;

    switch (institutionCode) {
      case "Urgen":
        color = Color.fromRGBO(138, 3, 18, 0.6);
        break;
      case "Bombe":
        color = Color.fromRGBO(50, 50, 138, 0.4);
        break;
      case "Carab":
        color = Color.fromRGBO(50, 138, 50, 0.4);
        break;
      default:
        break;
    }
    return color;
  }

TextStyle setTitleFontSize(int length)
{
  double _fontSize;
  if (length<30)
  {
    _fontSize = 14.0;
  }
  else if (length<40)
  {
    _fontSize = 12.0;
  }
  else if(length<50)
  {
    _fontSize = 10.5;
  }
  else
  {
    _fontSize = 8.0;
  }

  return TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold);
}

TextStyle setAddressFontSize(int length)
{
  double _fontSize = 14.0;
  if (length>85)
  {
    _fontSize = 12.0;
  }

  return TextStyle(fontSize: _fontSize);
}

class MapUtils {

  MapUtils._();
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude";
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}