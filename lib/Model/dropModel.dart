// To parse this JSON data, do
//
//     final dropModel = dropModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DropModel dropModelFromJson(String str) => DropModel.fromJson(json.decode(str));

String dropModelToJson(DropModel data) => json.encode(data.toJson());

class DropModel {
  DropModel({
    required this.response,
    required this.dataCompany,
    required this.dataCustomer,
    required this.dataItem,
  });

  String response;
  List<DataCompany> dataCompany;
  List<DataCustomer> dataCustomer;
  List<DataItem> dataItem;

  factory DropModel.fromJson(Map<String, dynamic> json) => DropModel(
        response: json["Response"],
        dataCompany: List<DataCompany>.from(
            json["data_company"].map((x) => DataCompany.fromJson(x))),
        dataCustomer: List<DataCustomer>.from(
            json["data_customer"].map((x) => DataCustomer.fromJson(x))),
        dataItem: List<DataItem>.from(
            json["data_item"].map((x) => DataItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "data_company": List<dynamic>.from(dataCompany.map((x) => x.toJson())),
        "data_customer":
            List<dynamic>.from(dataCustomer.map((x) => x.toJson())),
        "data_item": List<dynamic>.from(dataItem.map((x) => x.toJson())),
      };
}

class DataCompany {
  DataCompany({
    required this.nama,
    required this.id,
  });

  String nama;
  String id;

  factory DataCompany.fromJson(Map<String, dynamic> json) => DataCompany(
        nama: json["nama"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "id": id,
      };
}

class DataCustomer {
  DataCustomer({
    required this.nama,
    required this.alamat,
    required this.telp,
    required this.id,
    required this.status,
  });

  String nama;
  String alamat;
  String telp;
  String id;
  dynamic status;

  factory DataCustomer.fromJson(Map<String, dynamic> json) => DataCustomer(
        nama: json["nama"],
        alamat: json["alamat"],
        telp: json["telp"],
        id: json["id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "alamat": alamat,
        "telp": telp,
        "id": id,
        "status": status,
      };
}

class DataItem {
  DataItem({
    required this.idBarang,
    required this.nama,
  });

  String idBarang;
  String nama;

  factory DataItem.fromJson(Map<String, dynamic> json) => DataItem(
        idBarang: json["id_barang"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "id_barang": idBarang,
        "nama": nama,
      };
}
