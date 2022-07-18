// To parse this JSON data, do
//
//     final priceModel = priceModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PriceModel priceModelFromJson(String str) =>
    PriceModel.fromJson(json.decode(str));

String priceModelToJson(PriceModel data) => json.encode(data.toJson());

class PriceModel {
  PriceModel({
    required this.response,
    required this.data,
  });

  String response;
  List<Datum> data;

  factory PriceModel.fromJson(Map<String, dynamic> json) => PriceModel(
    response: json["Response"],
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Response": response,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.idPq,
    required this.nama,
    required this.noPq,
    required this.approval,
    required this.idheader
  });

  String idPq;
  String nama;
  String noPq;
  dynamic approval;
  String idheader;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    idPq: json["id_pq"],
    nama: json["nama"],
    noPq: json["no_pq"],
    approval: json["approval"],
    idheader: json["idheader"],
  );

  Map<String, dynamic> toJson() => {
    "id_pq": idPq,
    "nama": nama,
    "no_pq": noPq,
    "approval": approval,
    "idheader": idheader,
  };
}