import 'package:meta/meta.dart';
import 'dart:convert';

DupModel dupModelFromJson(String str) => DupModel.fromJson(json.decode(str));

String dupModelToJson(DupModel data) => json.encode(data.toJson());

class DupModel {
  DupModel({
    required this.response,
    required this.data,
  });

  String response;
  List<Datum1> data;

  factory DupModel.fromJson(Map<String, dynamic> json) => DupModel(
    response: json["Response"],
    data: List<Datum1>.from(json["Data"].map((x) => Datum1.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Response": response,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum1 {
  Datum1({
    required this.namaCustomer,
    required this.cylinder,
    required this.idPq,
    required this.noPq,
    required this.moq,
    required this.delivery,
    required this.termofpayment,
    required this.offerValidity,
    required this.conditions,
    required this.catatan,
    required this.date,
    required this.hour,
    required this.noUrut,
    required this.dataPesanan,
  });

  String namaCustomer;
  String cylinder;
  String idPq;
  String noPq;
  String moq;
  String delivery;
  String termofpayment;
  String offerValidity;
  String conditions;
  String catatan;
  String date;
  String hour;
  String noUrut;
  List<DataPesanan>? dataPesanan;

  factory Datum1.fromJson(Map<String, dynamic> json) => Datum1(
    namaCustomer:
    json["nama_customer"] == null ? "-" : json["nama_customer"],
    cylinder: json["cylinder "] == null ? "-" : json["cylinder "],
    idPq: json["id_pq"] == null ? "-" : json["id_pq"],
    noPq: json["no_pq"] == null ? "-" : json["no_pq"],
    moq: json["moq"] == null ? "-" : json["moq"],
    delivery: json["delivery"] == null ? "-" : json["delivery"],
    termofpayment:
    json["termofpayment"] == null ? "-" : json["termofpayment"],
    offerValidity:
    json["offer_validity"] == null ? "-" : json["offer_validity"],
    conditions: json["conditions"] == null ? "-" : json["conditions"],
    catatan: json["catatan"] == null ? "-" : json["catatan"],
    date: json["date"] == null ? "-" : json["date"],
    hour: json["hour"] == null ? "-" : json["hour"],
    noUrut: json["no_urut"] == null ? "-" : json["no_urut"],
    dataPesanan: json["data_pesanan"] == null
        ? null
        : List<DataPesanan>.from(
        json["data_pesanan"].map((x) => DataPesanan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "nama_customer": namaCustomer == null ? "-" : namaCustomer,
    "cylinder ": cylinder == null ? "-" : cylinder,
    "id_pq": idPq == null ? "-" : idPq,
    "no_pq": noPq == null ? "-" : noPq,
    "moq": moq == null ? "-" : moq,
    "delivery": delivery == null ? "-" : delivery,
    "termofpayment": termofpayment == null ? "-" : termofpayment,
    "offer_validity": offerValidity == null ? "-" : offerValidity,
    "conditions": conditions == null ? "-" : conditions,
    "catatan": catatan == null ? "-" : catatan,
    "date": date == null ? "-" : date,
    "hour": hour == null ? "-" : hour,
    "no_urut": noUrut == null ? "-" : noUrut,
    "data_pesanan": dataPesanan == null
        ? "-"
        : List<dynamic>.from(dataPesanan!.map((x) => x.toJson())),
  };
}

class DataPesanan {
  DataPesanan({
    required this.namaPesanan,
    required this.noPq,
    required this.color,
    required this.lebar,
    required this.panjang,
    required this.kodeProduksi,
    required this.pitch,
    required this.zipper,
    required this.hrgZipper,
    required this.tolWaste,
    required this.cashDiscount,
    required this.totalValue,
    required this.qty,
    required this.detailProduk,
  });

  String namaPesanan;
  dynamic noPq;
  String color;
  String lebar;
  String panjang;
  String kodeProduksi;
  String pitch;
  String zipper;
  String hrgZipper;
  String tolWaste;
  String cashDiscount;
  String totalValue;
  String qty;
  List<DetailProduk> detailProduk;

  factory DataPesanan.fromJson(Map<String, dynamic> json) => DataPesanan(
    namaPesanan: json["nama_pesanan"],
    noPq: json["no_pq"],
    color: json["color"],
    lebar: json["lebar"],
    panjang: json["panjang"],
    kodeProduksi: json["kode_produksi"],
    pitch: json["pitch"],
    zipper: json["zipper"],
    hrgZipper: json["harga_zipper"],
    tolWaste: json["tol_waste"],
    cashDiscount: json["cash_discount"],
    totalValue: json["total_value"],
    qty: json["qty"],
    detailProduk: List<DetailProduk>.from(
        json["detail_produk "].map((x) => DetailProduk.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "nama_pesanan": namaPesanan,
    "no_pq": noPq,
    "color": color,
    "lebar": lebar,
    "panjang": panjang,
    "kode_produksi": kodeProduksi,
    "pitch": pitch,
    "zipper": zipper,
    "harga_zipper": hrgZipper,
    "tol_waste": tolWaste,
    "cash_discount": cashDiscount,
    "total_value": totalValue,
    "qty": qty,
    "detail_produk ":
    List<dynamic>.from(detailProduk.map((x) => x.toJson())),
  };
}

class DetailProduk {
  DetailProduk({
    required this.idProduk,
    required this.namaProduk,
    required this.harga,
    required this.tebal,
    required this.catatan,
  });

  String idProduk;
  String namaProduk;
  String harga;
  String tebal;
  String catatan;

  factory DetailProduk.fromJson(Map<String, dynamic> json) => DetailProduk(
    idProduk: json["id_produk"],
    namaProduk: json["nama_produk"],
    harga: json["harga"],
    tebal: json["tebal"],
    catatan: json["catatan"],
  );

  Map<String, dynamic> toJson() => {
    "id_produk": idProduk,
    "nama_produk": namaProduk,
    "harga": harga,
    "tebal": tebal,
    "catatan": catatan,
  };
}