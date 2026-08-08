import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'parents/model.dart';

class Address extends Model {
  String id;
  String description;
  String address;
  double latitude;
  double longitude;
  bool isDefault;
  String userId;
  String zipCode;

  Address(
      {this.id,
      this.description,
      this.address,
      this.latitude,
      this.longitude,
      this.isDefault,
      this.userId,
      this.zipCode});

  Address.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    description = stringFromJson(json, 'description');
    address = stringFromJson(json, 'address');
    latitude = doubleFromJson(json, 'latitude', defaultValue: null);
    longitude = doubleFromJson(json, 'longitude', defaultValue: null);
    isDefault = boolFromJson(json, 'default');
    userId = stringFromJson(json, 'user_id');
    zipCode = stringFromJson(json, 'zipcode');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.id != null && this.id.length != 0) {
      data['id'] = this.id;
    }
    data['description'] = this.description;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['default'] = this.isDefault;
    if (this.userId != null && this.userId.length != 0) {
      data['user_id'] = this.userId;
    }
    data['zipcode'] = this.zipCode;
    return data;
  }

  bool isUnknown() {
    return latitude == null || longitude == null;
  }

  String get getDescription {
    if (hasDescription()) return description;
    return address.substring(0, min(address.length, 10));
  }

  bool hasDescription() {
    if (description != null && description.isNotEmpty) return true;
    return false;
  }

  LatLng getLatLng() {
    if (this.isUnknown()) {
      return LatLng(40.4, 7);
    } else {
      return LatLng(this.latitude, this.longitude);
    }
  }
}
