// To parse this JSON data, do
//
//     final userModelHome = userModelHomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserModelHome userModelHomeFromJson(String str) =>
    UserModelHome.fromJson(json.decode(str));

String userModelHomeToJson(UserModelHome data) => json.encode(data.toJson());

class UserModelHome {
  UserModelHome({
    required this.response,
    required this.message,
    required this.username,
    required this.name,
    required this.email,
    required this.telp,
    required this.jabatan,
  });

  String response;
  String message;
  String username;
  String name;
  String email;
  String telp;
  String jabatan;

  factory UserModelHome.fromJson(Map<String, dynamic> json) => UserModelHome(
        response: json["Response"],
        message: json["Message"],
        username: json["username"],
        name: json["name"],
        email: json["email"],
        telp: json["telp"],
        jabatan: json["jabatan"],
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "Message": message,
        "username": username,
        "name": name,
        "email": email,
        "telp": telp,
        "jabatan": jabatan,
      };
}
