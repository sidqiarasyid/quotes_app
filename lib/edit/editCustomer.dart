import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:quotes_app/Model/DupModel.dart';
import 'package:quotes_app/Model/dropModel.dart';
import 'package:quotes_app/Model/user_model.dart';
import 'package:quotes_app/Page/data_pesanan.dart';
import 'package:http/http.dart' as http;
import 'package:quotes_app/dup/dupRangkuman.dart';
import 'package:quotes_app/edit/editRangkuman.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/OrderModel.dart';
import '../db_order.dart';

class DataCustomerEdit extends StatefulWidget {
  final String idPq;
  const DataCustomerEdit({Key? key, required this.idPq}) : super(key: key);

  @override
  State<DataCustomerEdit> createState() => _DataCustomerEditState();
}

class _DataCustomerEditState extends State<DataCustomerEdit> {
  DropModel? _dropModel;
  DataCompany? _dataCompany;
  UserModel? _user;
  DupModel? _dup;
  List<DataCompany> _itemCompany = [];
  List<DataCustomer> _itemCustomer = [];
  List<Datum1>? listData = [];
  String Idcompany = "";
  String company = "";
  String namaCust = "";
  String alamatCust = "";
  String noCust = "";
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController nomor = TextEditingController();
  int hasilTebal = 0;
  String spec = "";
  String cat = "";
  String idDrops = "";
  String sessionItem = "";

  Future<String> getCompany() async {
    String url = "http://128.199.81.36/api/list_data.php";
    Map<String, dynamic> data = {
      "api_key": "kspconnectpedia2020feb",
      "username": _user?.username,
    };
    var dataUtf = utf8.encode(json.encode(data));
    var dataBase64 = base64.encode(dataUtf);
    final response =
    await http.post(Uri.parse(url), body: {'data': dataBase64});
    _dropModel = DropModel.fromJson(json.decode(response.body.toString()));
    setState(() {
      _itemCompany = _dropModel!.dataCompany;
    });
    return "Success";
  }

  Future<String> getCustomer() async {
    String url = "http://128.199.81.36/api/list_data.php";
    Map<String, dynamic> data = {
      "api_key": "kspconnectpedia2020feb",
      "username": _user?.username,
    };
    var dataUtf = utf8.encode(json.encode(data));
    var dataBase64 = base64.encode(dataUtf);
    final response =
    await http.post(Uri.parse(url), body: {'data': dataBase64});
    _dropModel = DropModel.fromJson(json.decode(response.body.toString()));
    setState(() {
      _itemCustomer = _dropModel!.dataCustomer;
    });
    print(_itemCustomer);
    return "Success";
  }

  getDuplicate() async {
    final prefs = await SharedPreferences.getInstance();
    String url = "http://128.199.81.36/api/list_detail_pq.php";
    Map<String, dynamic> data = {
      "api_key": "kspconnectpedia2020feb",
      "id_sales": prefs.getString('username'),
      "id_pq": "2",
    };
    print("ID PQ: " + widget.idPq);
    var dataUtf = utf8.encode(json.encode(data));
    var dataBase64 = base64.encode(dataUtf);
    final response =
    await http.post(Uri.parse(url), body: {'data': dataBase64});
    _dup = DupModel.fromJson(json.decode(response.body.toString()));
    setState(() {
      nama.text = _dup!.data[0].namaCustomer;
      listData = _dup!.data;
    });
    for(int i = 0; i < listData![1].dataPesanan!.length; i++){
      for(int a = 0; a < listData![1].dataPesanan![i].detailProduk.length; a++){
        hasilTebal += int.parse(listData![1].dataPesanan![i].detailProduk[a].tebal);
        spec += listData![1].dataPesanan![i].detailProduk[a].namaProduk + "-" + listData![1].dataPesanan![i].detailProduk[a].tebal + "//";
        cat += listData![1].dataPesanan![i].detailProduk[a].catatan + "-" + "/";
        idDrops +=  listData![1].dataPesanan![i].detailProduk[a].idProduk + "*" + "/";
        sessionItem += listData![1].dataPesanan![i].detailProduk[a].idProduk + "#" + listData![1].dataPesanan![i].detailProduk[a].namaProduk + "#" + listData![1].dataPesanan![i].detailProduk[a].tebal + "#-##";
      }
      var order;
      order = OrderModel(
          items: listData![1].dataPesanan![i].namaPesanan,
          tebal: hasilTebal.toString(),
          lebar: listData![1].dataPesanan![i].lebar,
          panjang: listData![1].dataPesanan![i].panjang,
          spec: spec,
          color: listData![1].dataPesanan![i].color,
          qty: listData![1].dataPesanan![i].qty,
          disc: listData![1].dataPesanan![i].cashDiscount,
          price: listData![1].dataPesanan![i].totalValue,
          catatan: cat,
          tw: int.parse(listData![1].dataPesanan![i].tolWaste),
          pc: int.parse(listData![1].dataPesanan![i].kodeProduksi),
          sipSession: sessionItem,
          dropId: idDrops,
          pitch: listData![1].dataPesanan![i].pitch,
          hrgZip: listData![1].dataPesanan![i].hrgZipper,
          lbrZip: listData![1].dataPesanan![i].zipper);
      await OrderDatabase.instance.create(order);
        hasilTebal = 0;
        spec = "";
        cat = "";
        idDrops = "";
        sessionItem = "";

    }

  }
  // Future getData() async {
  //   List<OrderModel> listOrder = [];
  //   listOrder = await OrderDatabase.instance.readAll();
  //   print("DATA DUP: " + listOrder.length.toString());
  //   final data = listOrder[0];
  //   print("NAMA PESANAN: " + data.items);
  // }





  @override
  void initState() {
    // TODO: implement initState
    getCompany();
    getCustomer();
    super.initState();
    getDuplicate();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarQuote("Data Customer"),
      body: SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              itemDropDown(),
              SizedBox(
                height: 15,
              ),
              inputFormDataCustomer(),
              SizedBox(
                height: 20,
              ),
              nextButton(),
              SizedBox(
                height: 20,
              ),
              backButton(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBarQuote(String title) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 75,
      title: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget itemDropDown() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: DropdownButton<DataCompany>(
          hint: Text("Pilih Company"),
          isExpanded: true,
          value: _dataCompany,
          icon: Icon(Icons.arrow_drop_down),
          onChanged: (DataCompany? newValue) {
            setState(() {
              _dataCompany = newValue;
            });
            print("INDEX: " + _dataCompany!.id.toString());
          },
          isDense: true,
          underline: SizedBox.shrink(),
          items: _itemCompany.map((DataCompany item) {
            return DropdownMenuItem<DataCompany>(
              child: Text(
                item.nama,
              ),
              value: item,
            );
          }).toList(),
        ));
  }

  Widget inputFormDataCustomer() {
    return Column(
      children: [
        TypeAheadField(
          suggestionsCallback: (value) => _itemCustomer.where((element) =>
              element.nama.toLowerCase().contains(value.toLowerCase())),
          itemBuilder: (_, DataCustomer item) => ListTile(
            title: Text(
              item.nama,
              style: TextStyle(color: Colors.black),
            ),
          ),
          onSuggestionSelected: (DataCustomer val) {
            nama.text = val.nama.toString();
            alamat.text = val.alamat.toString();
            nomor.text = val.telp.toString();
          },
          hideOnEmpty: true,
          autoFlipDirection: true,
          textFieldConfiguration: TextFieldConfiguration(
            style: TextStyle(fontSize: 19, color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: "Term of Payment",
              hintStyle: TextStyle(fontSize: 19),
            ),
            controller: nama,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: alamat,
          style: TextStyle(fontSize: 19, color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "Alamat Customer",
            hintStyle: TextStyle(fontSize: 19),
          ),
          maxLines: 4,
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: nomor,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 19, color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "Telp Customer",
            hintStyle: TextStyle(fontSize: 19),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style: TextStyle(fontSize: 19, color: Colors.black),
    ),
  );

  Widget nextButton() {
    return Container(
      width: 335,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "Lanjut",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () async {
          setState(() {
            company = _dataCompany!.nama;
            Idcompany = _dataCompany!.id;
            namaCust = nama.text;
            alamatCust = alamat.text;
            noCust = nomor.text;
          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("namaCust", namaCust);
          prefs.setString("alamatCust", alamatCust);
          prefs.setString("noCust", noCust);
          prefs.setString("company", company);
          prefs.setString("Idcompany", Idcompany);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => EditRingkasanPage()));
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget backButton() {
    return Container(
      width: 335,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "Kembali",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}