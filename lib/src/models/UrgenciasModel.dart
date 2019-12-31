import 'dart:convert';
import 'package:chilemergencias/src/models/Institution.dart';


class UrgenciasModel extends Institution {
  
  String type;

  UrgenciasModel
  ({
    address,
    commune,
    country,
    latitude,
    longitude,
    name,
    phone,
    region,
    this.type
  }) 
  :
  super
  (
    address: address,
    commune: commune,
    country: country,
    latitude: latitude,
    longitude: longitude,
    name: name,
    phone: phone,
    region: region
  );

  @override
  Map<String, dynamic> toJson() => 
  {
        "address": address,
        "commune": commune,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
        "name": name,
        "type": type,
        "phone": phone,
        "region": region
  };

  factory UrgenciasModel.fromJson(Map<String, dynamic> json) => UrgenciasModel(
        address: json["address"],
        commune: json["commune"],
        country: json["country"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        name: json["name"],
        type: json["type"],
        phone: json["phone"],
        region: json["region"],
    );
}

// To parse this JSON data, do
//
//     final urgenciasModel = urgenciasModelFromJson(jsonString);

UrgenciasModel urgenciasModelFromJson(String str) => UrgenciasModel.fromJson(json.decode(str));

String urgenciasModelToJson(UrgenciasModel data) => json.encode(data.toJson());