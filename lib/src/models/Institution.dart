

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

  Institution({
    this.address,
    this.commune,
    this.country,
    this.latitude,
    this.longitude,
    this.name,
    this.phone,
    this.region,
  });

  Map<String, dynamic> toJson();
}