import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes_app/Model/price_model.dart';
import 'package:quotes_app/Page/ApproveAsSQPage.dart';
import 'package:quotes_app/Page/data_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class PriceQuotePage extends StatefulWidget {
  const PriceQuotePage({Key? key}) : super(key: key);

  @override
  State<PriceQuotePage> createState() => _PriceQuotePageState();
}

class _PriceQuotePageState extends State<PriceQuotePage> {
  PriceModel? _priceModel;
  List<Datum> items = [];

  getPrice() async {
    final prefs = await SharedPreferences.getInstance();
    String url = "http://128.199.81.36/api/list_price_quote.php";
    Map<String, dynamic> data = {
      "api_key": "kspconnectpedia2020feb",
      "id_sales": prefs.getString('username').toString(),
    };
    var dataUtf = utf8.encode(json.encode(data));
    var dataBase64 = base64.encode(dataUtf);
    final response =
        await http.post(Uri.parse(url), body: {'data': dataBase64});
    _priceModel = PriceModel.fromJson(json.decode(response.body.toString()));
    items.addAll(_priceModel!.data);
  }

  @override
  void initState() {
    getPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarQuote("Price Quote"),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Center(
          child: Column(
            children: [
              addPriceButton(),
              listPriceQuote(),
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

  Widget addPriceButton() {
    return Container(
      width: 360,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "Buat Price Quote Baru",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => DataCustomerPage()));
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

  Widget listPriceQuote() {
    return Builder(
      builder: (context) {
        var height = MediaQuery.of(context).size.height;
        return Container(
            height: height * 0.75,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[index].noPq + ', ',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        items[index].nama + ' : ',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 125,
                            child: ElevatedButton(
                              child: Text(
                                "Download PDF",
                                style: TextStyle(fontSize: 10),
                              ),
                              onPressed: () {
                                int angka = index + 1;
                                print("Index: " + angka.toString());
                                _launchUrl(angka.toString());
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 125,
                            child: ElevatedButton(
                              child: Text(
                                "Approve as SQ",
                                style: TextStyle(fontSize: 10),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext c) =>
                                            ApproveAsSQPage(
                                                title: "Price Quote")));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ));
                }));
      },
    );
  }

  void _launchUrl(String id) async {
    var dio = Dio();
    var dir = await getExternalStorageDirectory();
    var knockDir = await new Directory('${dir?.path}').create(recursive: true);
    try {
      var response = await dio.download(
          'http://128.199.81.36/generate-new.php?id=' + id,
          '${knockDir.path}/FileBaru.pdf');
      print(response.statusCode);
      print('${knockDir.path}/FileBaru.pdf');
    } catch (e) {
      print(e);
    }
  }
}
