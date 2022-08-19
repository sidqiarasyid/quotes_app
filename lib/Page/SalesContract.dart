// ignore_for_file: file_names, unnecessary_string_interpolations, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quotes_app/Model/ApiConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Model/salesContract.dart';
import 'home.dart';

class SalesContractPage extends StatefulWidget {
  const SalesContractPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SalesContractPage> createState() => _SalesContractPageState();
}

class _SalesContractPageState extends State<SalesContractPage> {
  List dataList = [];

  getListSalesContract() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> datapost = {
      "api_key": apikey,
      "id_sales": prefs.getString('username').toString(),
    };

    var stringToBase64 = utf8.fuse(base64);

    Map<String, dynamic> bodyParameters = {
      "data": "${stringToBase64.encode(json.encode(datapost))}"
    };
    var result = await ListSalesContract().listsalescontract(bodyParameters);
    setState(() {
      dataList = result!;
    });
  }

  @override
  void initState() {
    super.initState();
    getListSalesContract();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 75,
          title: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            thickness: 2,
            height: 1.0,
            color: Color(0xffD3D3D3),
          ),
          itemCount: (dataList.isEmpty) ? 0 : dataList.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(25.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("PQ-${dataList[index]['no_pq']}"),
              Text(
                "${dataList[index]['nama']}",
                style: const TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ButtonTheme(
                  height: 30.0,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    onPressed: () async {
                      setState(() {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            ModalRoute.withName("/HomePage"));
                        launch(dataList[index]['idheader']);
                        // downloadPDF(dataList[index]['idheader']);
                      });
                    },
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Text(
                      "Download PDF",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
