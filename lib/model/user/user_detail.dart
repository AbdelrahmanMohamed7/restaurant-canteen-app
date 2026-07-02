// To parse this JSON data, do
//
//     final userDetailModel = userDetailModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserDetailModel userDetailModelFromJson(String str) =>
    UserDetailModel.fromJson(json.decode(str));

String userDetailModelToJson(UserDetailModel data) =>
    json.encode(data.toJson());

class UserDetailModel {
  UserDetailModel({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.comment,
    required this.phoneNumber,
  });

  final String firstName;
  final String lastName;
  final String address;
  final String comment;
  final String phoneNumber;

  factory UserDetailModel.fromJson(Map<String, dynamic> json) =>
      UserDetailModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        address: json["address"],
        comment: json["comment"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "address": address,
        "comment": comment,
        "phone_number": phoneNumber,
      };
}
