// To parse this JSON data, do
//
//     final restaurantLocationModel = restaurantLocationModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RestaurantLocationModel restaurantLocationModelFromJson(String str) =>
    RestaurantLocationModel.fromJson(json.decode(str));

String restaurantLocationModelToJson(RestaurantLocationModel data) =>
    json.encode(data.toJson());

class RestaurantLocationModel {
  RestaurantLocationModel({
    required this.lng,
    required this.lat,
  });

  final double lng;
  final double lat;

  factory RestaurantLocationModel.fromJson(Map<String, dynamic> json) =>
      RestaurantLocationModel(
        lng: json["lng"].toDouble(),
        lat: json["lat"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lng": lng,
        "lat": lat,
      };
}
