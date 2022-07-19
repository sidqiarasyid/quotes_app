import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:quotes_app/Model/dropModel.dart';
import 'package:quotes_app/Model/user_model.dart';
import 'package:quotes_app/Page/data_pesanan.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataCustomerPage extends StatefulWidget {
  const DataCustomerPage({Key? key}) : super(key: key);

  @override
  State<DataCustomerPage> createState() => _DataCustomerPageState();
}

class _DataCustomerPageState extends State<DataCustomerPage> {
  DropModel? _dropModel;
  DataCompany? _dataCompany;
  UserModel? _user;
  List<DataCompany> _itemCompany = [];
  String Idcompany = "";
  String company = "";
  String namaCust = "";
  String alamatCust = "";
  String noCust = "";
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController nomor = TextEditingController();

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
    print(_itemCompany);
    return "Success";
  }

  @override
  void initState() {
    // TODO: implement initState
    getCompany();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarQuote("1. Data Customer"),
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
        TextFormField(
          controller: nama,
          style: TextStyle(fontSize: 19, color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "Pilih Customer",
            hintStyle: TextStyle(fontSize: 19),
          ),
          minLines: 1,
          maxLines: 5,
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
              builder: (BuildContext context) => DataPesananPage()));
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