import 'dart:convert';
import 'package:chilemergencias/src/models/Institution.dart';

class BomberosModel extends Institution {
  
  BomberosModel
  ({
    address,
    commune,
    country,
    latitude,
    longitude,
    name,
    phone,
    region
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
        "phone": phone,
        "region": region
  };

  factory BomberosModel.fromJson(Map<String, dynamic> json) => BomberosModel(
        address: json["address"],
        commune: json["commune"],
        country: json["country"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        name: json["name"],
        phone: json["phone"],
        region: json["region"],
    );
}

// To parse this JSON data, do
//
//     final bomberosModel = bomberosModelFromJson(jsonString);

BomberosModel bomberosModelFromJson(String str) => BomberosModel.fromJson(json.decode(str));

String bomberosModelToJson(BomberosModel data) => json.encode(data.toJson());