import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:quotes_app/Model/OrderModel.dart';
import 'package:quotes_app/Model/urlModel.dart';
import 'package:quotes_app/Page/data_edit.dart';
import 'package:quotes_app/Page/data_pesanan.dart';
import 'package:quotes_app/Page/price_quote.dart';
import 'package:quotes_app/Page/success_save.dart';
import 'package:quotes_app/db_order.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RingkasanPesananPage extends StatefulWidget {
  const RingkasanPesananPage({Key? key, required this.pc, required this.tw})
      : super(key: key);
  final int pc;
  final int tw;

  @override
  State<RingkasanPesananPage> createState() => _RingkasanPesananPageState();
}

class _RingkasanPesananPageState extends State<RingkasanPesananPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _topController = TextEditingController();
  final TextEditingController _ovController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _cycController = TextEditingController();
  final TextEditingController _deliverController = TextEditingController();
  final TextEditingController _moqController = TextEditingController();
  UrlModel? _urlModel;
  List<OrderModel> listOrder = [];
  bool isLoading = false;
  var body = "";
  // int ind = 0;

  Future getData() async {
    isLoading = true;
    listOrder = await OrderDatabase.instance.readAll();
    print("DATA LIST: " + listOrder.length.toString());
    setState(() {
      isLoading = false;
    });
  }

  void masukData() async {
    listOrder.forEach((OrderModel model) {
      body += model.items +
          "#" +
          model.color +
          "#" +
          model.qty +
          "#" +
          model.lebar +
          "#" +
          model.panjang +
          "#" +
          model.pitch +
          "#" +
          model.hrgZip +
          "#" +
          model.lbrZip +
          "#" +
          model.tw.toString() +
          "#" +
          model.disc +
          "#" +
          model.price +
          "#" +
          model.pc.toString() +
          "###" +
          model.sipSession;
    });
    print("ISI BODY DATA: " + body);
  }

  getSubmit() async {
    final prefs = await SharedPreferences.getInstance();
    String url = "http://128.199.81.36/api/insertpq_new.php";
    Map<String, dynamic> data = {
      "api_key": "kspconnectpedia2020feb",
      "username": prefs.getString('username').toString(),
      "id_perusahaan": prefs.getString('Idcompany').toString(),
      "nama_customer": prefs.getString('namaCust').toString(),
      "telp_customer": prefs.getString('noCust').toString(),
      "alamat_customer": prefs.getString('alamatCust').toString(),
      "cylinder": _cycController.text,
      "delivery": _deliverController.text,
      "moq": _moqController.text,
      "top": _topController.text,
      "notes": _noteController.text,
      "offer": _ovController.text,
      "conditions": _conditionController.text,
      "session_item_pesanan": body,
    };
    print("DATA: " + data.toString());
    var dataUtf = utf8.encode(json.encode(data));
    var dataBase64 = base64.encode(dataUtf);
    final response =
        await http.post(Uri.parse(url), body: {'data': dataBase64});
    _urlModel = UrlModel.fromJson(json.decode(response.body.toString()));
    print("RESPON: " + _urlModel!.urlPdf.toString());
    print("STATUS: " + response.statusCode.toString());
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => SuccessSavePage(
              url: _urlModel!.urlPdf,
            )));
    OrderDatabase.instance.deleteAll();
  }

  static const top_list = [
    "Cash in Advance",
    "50% DP % remaining before deliver",
    "30 days after delivery",
    "60 days delivery"
  ];

  static const ov_list = ["7 Working Day", "14 Working Days"];

  static const condition_list = ["Delivery Tolerance +- 10% from total Qty"];

  static const note_list = ["Harga exclude PPN"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => PriceQuotePage()),
                (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        appBar: appBarQuote("3. Ringkasan Pesanan"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      listRangkuman(),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      addOrderButton(),
                      SizedBox(
                        height: 20,
                      ),
                      inputFormDetail(),
                      SizedBox(
                        height: 20,
                      ),
                      saveButton(),
                      SizedBox(
                        height: 15,
                      ),
                      cancelButton(),
                    ],
                  ),
                ),
              ),
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

  Widget addOrderButton() {
    return Container(
      width: 335,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "Tambahkan Pesanan",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () {
          Navigator.pop(context);
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

  Widget listRangkuman() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            height: 200,
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
                itemCount: listOrder.length,
                itemBuilder: (context, index) {
                  int no = index + 1;
                  // ind = index;
                  final item = listOrder[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No          : ' + no.toString()),
                      Text('Item       : ' + item.items),
                      Text('Size        : ' +
                          item.tebal +
                          " X " +
                          item.lebar +
                          " X " +
                          item.panjang),
                      Text('Spec       : ' + item.spec),
                      Text('Color      : ' + item.color),
                      Text('Qty          : ' + item.qty),
                      Text('Disc        : ' + item.disc),
                      Text('Price       : ' + item.price),
                      SizedBox(
                        height: 10,
                      ),
                      btnListRangkum(listOrder[index].id),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  );
                }));
  }

  Widget btnListRangkum(int? id) {
    return Row(
      children: [
        Container(
          width: 160,
          height: 50,
          child: ElevatedButton(
            child: Text(
              "Rubah",
              style: TextStyle(fontSize: 14),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DataEditPage(
                            id: id,
                            pc: widget.pc,
                            tw: widget.tw,
                          )));
              Future.delayed(Duration(seconds: 2));
              print('result: ' + result);

              getData();
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
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 160,
          height: 50,
          child: ElevatedButton(
            child: Text(
              "Hapus",
              style: TextStyle(fontSize: 14),
            ),
            onPressed: () async {
              print("deleting data : " + id.toString());
              isLoading = true;
              await OrderDatabase.instance.delete(id);
              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  // Here you can write your code for open new view
                  getData();
                  isLoading = false;
                });
              });
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
        )
      ],
    );
  }

  Widget inputFormDetail() {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter text';
            }
            return null;
          },
          controller: _cycController,
          style: TextStyle(fontSize: 19, color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "Cylinder",
            hintStyle: TextStyle(fontSize: 19),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter text';
            }
            return null;
          },
          controller: _deliverController,
          style: TextStyle(fontSize: 19, color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "Delivery",
            hintStyle: TextStyle(fontSize: 19),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter text';
            }
            return null;
          },
          controller: _moqController,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 19, color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "MOQ",
            hintStyle: TextStyle(fontSize: 19),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          child: Column(
            children: [
              TypeAheadFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter text';
                  }
                  return null;
                },
                suggestionsCallback: (value) => top_list.where((element) =>
                    element.toLowerCase().contains(value.toLowerCase())),
                itemBuilder: (_, String item) => ListTile(
                  title: Text(
                    item,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                onSuggestionSelected: (String val) {
                  _topController.text = val;
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
                  controller: _topController,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TypeAheadFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter text';
                  }
                  return null;
                },
                suggestionsCallback: (value) => ov_list.where((element) =>
                    element.toLowerCase().contains(value.toLowerCase())),
                itemBuilder: (_, String item) => ListTile(
                  title: Text(
                    item,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                onSuggestionSelected: (String val) {
                  _ovController.text = val;
                },
                hideOnEmpty: true,
                autoFlipDirection: true,
                hideSuggestionsOnKeyboardHide: true,
                textFieldConfiguration: TextFieldConfiguration(
                  style: TextStyle(fontSize: 19, color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Offer Validity",
                    hintStyle: TextStyle(fontSize: 19),
                  ),
                  controller: _ovController,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TypeAheadFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter text';
                  }
                  return null;
                },
                suggestionsCallback: (value) => condition_list.where(
                    (element) =>
                        element.toLowerCase().contains(value.toLowerCase())),
                itemBuilder: (_, String item) => ListTile(
                  title: Text(
                    item,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                onSuggestionSelected: (String val) {
                  _conditionController.text = val;
                },
                hideOnEmpty: true,
                autoFlipDirection: true,
                hideSuggestionsOnKeyboardHide: true,
                textFieldConfiguration: TextFieldConfiguration(
                  style: TextStyle(fontSize: 19, color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Conditions",
                    hintStyle: TextStyle(fontSize: 19),
                  ),
                  controller: _conditionController,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TypeAheadFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter text';
                  }
                  return null;
                },
                suggestionsCallback: (value) => note_list.where((element) =>
                    element.toLowerCase().contains(value.toLowerCase())),
                itemBuilder: (_, String item) => ListTile(
                  title: Text(
                    item,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                onSuggestionSelected: (String val) {
                  _noteController.text = val;
                },
                hideOnEmpty: true,
                autoFlipDirection: true,
                hideSuggestionsOnKeyboardHide: true,
                textFieldConfiguration: TextFieldConfiguration(
                  style: TextStyle(fontSize: 19, color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Catatan",
                    hintStyle: TextStyle(fontSize: 19),
                  ),
                  controller: _noteController,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget saveButton() {
    return Container(
      width: 335,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "Simpan Price Quote",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            masukData();
            getSubmit();
          }
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

  Widget cancelButton() {
    return Container(
      width: 335,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "Batalkan",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => PriceQuotePage()),
              (Route<dynamic> route) => false);
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
