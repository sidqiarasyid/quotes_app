import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes_app/Model/dupModel.dart';
import 'package:quotes_app/Model/price_model.dart';
import 'package:quotes_app/Model/user_model.dart';
import 'package:quotes_app/Page/ApproveAsSQPage.dart';
import 'package:quotes_app/Page/data_customer.dart';
import 'package:quotes_app/Page/home.dart';
import 'package:quotes_app/db_order.dart';
import 'package:quotes_app/dup/dupCustomer.dart';
import 'package:quotes_app/edit/editCustomer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class PriceQuotePage extends StatefulWidget {
  const PriceQuotePage({Key? key}) : super(key: key);

  @override
  State<PriceQuotePage> createState() => _PriceQuotePageState();
}

class _PriceQuotePageState extends State<PriceQuotePage> {
  PriceModel? _priceModel;
  List<Datum> items = [];
  bool isLoading = false;

  getPrice() async {
    setState(() {
      isLoading = true;
    });
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
    setState(() {
      items.addAll(_priceModel!.data);
      setState(() {
        isLoading = false;
      });
    });
  }

  delete(String id) async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String url = "http://128.199.81.36/api/delete_pq.php";
    Map<String, dynamic> data = {
      "api_key": "kspconnectpedia2020feb",
      "id_sales": prefs.getString('username').toString(),
      "id_pq": id,
    };
    var dataUtf = utf8.encode(json.encode(data));
    var dataBase64 = base64.encode(dataUtf);
    final response =
        await http.post(Uri.parse(url), body: {'data': dataBase64});
    jsonDecode(response.body);
    if (response.statusCode == 200) {
      items.clear();
      getPrice();
      setState(() {
        isLoading = false;
      });
    }
  }

  showAlertDialog(BuildContext context, int i) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        delete(items[i].idPq);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deleting item"),
      content: Text("Are you sure want to delete this?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    getPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final prefs = await SharedPreferences.getInstance();

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage(username: prefs.getString('username').toString())),
                (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        appBar: appBarQuote("Price Quote"),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      addPriceButton(),
                      listPriceQuote(),
                    ],
                  ),
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
          OrderDatabase.instance.deleteAll();
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
            padding: EdgeInsets.only(top: 20),
            height: height * 0.77,
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
                                _launchUrl(items[index].idPq);
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
                                                title: "Price Quote",
                                                id_pq: items[index].idPq)));
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
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: ElevatedButton(
                              child: Text(
                                "Duplicate",
                                style: TextStyle(fontSize: 10),
                              ),
                              onPressed: () {
                                OrderDatabase.instance.deleteAll();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => DataCustomerDup(
                                              idPq: items[index].idPq,
                                            ))));
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
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                              child: Text(
                                "Delete",
                                style: TextStyle(fontSize: 10),
                              ),
                              onPressed: () {
                                showAlertDialog(context, index);

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
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                              child: Text(
                                "Edit PQ",
                                style: TextStyle(fontSize: 10),
                              ),
                              onPressed: () {
                                OrderDatabase.instance.deleteAll();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => DataCustomerEdit(
                                              idPq: items[index].idPq,
                                            ))));
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

  _launchUrl(String id) async {
    var url = 'http://128.199.81.36/generate-new.php?id=' + id;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // void _launchUrl(String id) async {
  //   var dio = Dio();
  //   var dir = await getExternalStorageDirectory();
  //   var knockDir = await new Directory('${dir?.path}').create(recursive: true);
  //   try {
  //     var response = await dio.download(
  //         'http://128.199.81.36/generate-new.php?id=' + id,
  //         '${knockDir.path}/FileBaru.pdf');
  //     print(response.statusCode);
  //     print('${knockDir.path}/FileBaru.pdf');
  //     if (response.statusCode == 200) {
  //       showDialog(
  //           context: context,
  //           builder: (_) {
  //             return AlertDialog(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //               contentPadding: EdgeInsets.all(20.0),
  //               content: Builder(builder: (context) {
  //                 var height = MediaQuery.of(context).size.height;
  //                 var width = MediaQuery.of(context).size.width;
  //
  //                 return Container(
  //                   // height: height - 400,
  //                   width: 400,
  //                   child: Text(
  //                     'Download Success',
  //                     style: TextStyle(fontSize: 20),
  //                   ),
  //                 );
  //               }),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: Text('Ok'),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                 )
  //               ],
  //             );
  //           });
  //     } else {
  //       showDialog(
  //           context: context,
  //           builder: (_) {
  //             return AlertDialog(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //               contentPadding: EdgeInsets.all(20.0),
  //               content: Builder(builder: (context) {
  //                 var height = MediaQuery.of(context).size.height;
  //                 var width = MediaQuery.of(context).size.width;
  //
  //                 return Container(
  //                   // height: height - 400,
  //                   width: 400,
  //                   child: Text(
  //                     'Download Failed',
  //                     style: TextStyle(fontSize: 20),
  //                   ),
  //                 );
  //               }),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: Text('Ok'),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                 )
  //               ],
  //             );
  //           });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

}
