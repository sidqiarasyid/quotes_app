// To parse this JSON data, do
//
//     final hasilModel = hasilModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

HasilModel hasilModelFromJson(String str) =>
    HasilModel.fromJson(json.decode(str));

String hasilModelToJson(HasilModel data) => json.encode(data.toJson());

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
  double grandTotal;
  double grandTotalBag;
  String grandTotalDisplay;
  double grandTotalValue;
  String message;

  factory HasilModel.fromJson(Map<String, dynamic> json) => HasilModel(
        response: json["Response"],
        idCust: json["id_cust"],
        grandTotal: json["grand_total"].toDouble(),
        grandTotalBag: json["grand_total_bag"].toDouble(),
        grandTotalDisplay: json["grand_total_display"],
        grandTotalValue: json["grand_total_value"].toDouble(),
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
