import 'package:chilemergencias/src/models/Institution.dart';
import 'dart:convert';
// To parse this JSON data, do
//
//     final carabinerosModel = carabinerosModelFromJson(jsonString);


class CarabinerosModel extends Institution {
  bool isRural;
  String type;

  CarabinerosModel({
    address,
    commune,
    country,
    latitude,
    longitude,
    name,
    phone,
    region,
    this.type,
    this.isRural,
  }) : super(
            address: address,
            commune: commune,
            country: country,
            latitude: latitude,
            longitude: longitude,
            name: name,
            phone: phone,
            region: region);

  factory CarabinerosModel.fromJson(Map<String, dynamic> json) => CarabinerosModel(
        address: json["address"],
        commune: json["commune"],
        country: json["country"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        name: json["name"],
        type: json["type"],
        phone: json["phone"],
        region: json["region"],
        isRural: json["isRural"],
    );


  @override
  Map<String, dynamic> toJson() => {
        "address": address,
        "commune": commune,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
        "name": name,
        "type": type,
        "phone": phone,
        "region": region,
        "isRural": isRural,
      };
}

CarabinerosModel carabinerosModelFromJson(String str) => CarabinerosModel.fromJson(json.decode(str));

String carabinerosModelToJson(CarabinerosModel data) => json.encode(data.toJson());
