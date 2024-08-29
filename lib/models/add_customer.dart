import 'package:flutter/cupertino.dart';

class AddCustomer {
  int? id;
  String? name;
  String? mobile;
  String? email;
  String? address;
  String? latitude;
  String? longitude;
  String? image;


  AddCustomer({this.id, this.name, this.mobile, this.email, this.address,
      this.latitude, this.longitude, this.image});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['mobile'] = mobile;
    map['email'] = email;
    map['address'] = address;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['image'] = image;
    return map;
  }

  AddCustomer.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.mobile = map['mobile'];
    this.email = map['email'];
    this.address = map['address'];
    this.latitude = map['latitude'];
    this.longitude = map['longitude'];
    this.image = map['image'];

  }
}