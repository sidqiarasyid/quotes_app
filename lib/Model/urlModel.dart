// To parse this JSON data, do
//
//     final urlModel = urlModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UrlModel urlModelFromJson(String str) => UrlModel.fromJson(json.decode(str));

String urlModelToJson(UrlModel data) => json.encode(data.toJson());

class UrlModel {
  UrlModel({
    required this.message,
    required this.response,
    required this.urlPdf,
  });

  String message;
  String response;
  String urlPdf;

  factory UrlModel.fromJson(Map<String, dynamic> json) => UrlModel(
        message: json["Message"],
        response: json["Response"],
        urlPdf: json["url_pdf"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Response": response,
        "url_pdf": urlPdf,
      };
}
