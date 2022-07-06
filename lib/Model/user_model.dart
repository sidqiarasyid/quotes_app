// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.response,
    required this.message,
    required this.username,
    required this.name,
  });

  String response;
  String message;
  String username;
  String name;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        response: json["Response"],
        message: json["Message"],
        username: json["username"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "Message": message,
        "username": username,
        "name": name,
      };
}
