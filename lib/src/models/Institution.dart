import 'package:latlong/latlong.dart' as latlong;
import 'package:mapbox_gl/mapbox_gl.dart';

abstract class Institution 
{
  String address;
  String commune;
  String country;
  double latitude;
  double longitude;
  String name;
  String phone;
  String region;
  num metersFromActualPosition;

  Institution({
    this.address,
    this.commune,
    this.country,
    this.latitude,
    this.longitude,
    this.name,
    this.phone,
    this.region
  });

  Map<String, dynamic> toJson();

  void calculateMetersFromActualPosition(LatLng myPosition)
  {
    final latlong.Distance distance = new latlong.Distance();
    latlong.LatLng objectPosition = latlong.LatLng(latitude, longitude);
    latlong.LatLng myPos = latlong.LatLng(myPosition.latitude, myPosition.longitude);
    metersFromActualPosition = distance.distance(myPos, objectPosition);
  }
}