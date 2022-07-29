// To parse this JSON data, do
//
//     final dupModel = dupModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

HasilModel dupModelFromJson(String str) => HasilModel.fromJson(json.decode(str));

String dupModelToJson(HasilModel data) => json.encode(data.toJson());

class HasilModel {
  HasilModel({
    required this.response,
    required this.idCust,
    required this.grandTotal,
    required this.grandTotalBag,
    required this.grandTotalDisplay,
    required this.grandTotalValue,
    required this.message,
  });

  String response;
  dynamic idCust;
  dynamic grandTotal;
  dynamic grandTotalBag;
  dynamic grandTotalDisplay;
  dynamic grandTotalValue;
  String message;

  factory HasilModel.fromJson(Map<String, dynamic> json) => HasilModel(
    response: json["Response"],
    idCust: json["id_cust"],
    grandTotal: json["grand_total"],
    grandTotalBag: json["grand_total_bag"],
    grandTotalDisplay: json["grand_total_display"],
    grandTotalValue: json["grand_total_value"],
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {
    "Response": response,
    "id_cust": idCust,
    "grand_total": grandTotal,
    "grand_total_bag": grandTotalBag,
    "grand_total_display": grandTotalDisplay,
    "grand_total_value": grandTotalValue,
    "Message": message,
  };
}
