import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/Model/OrderModel.dart';
import 'package:quotes_app/Model/dropModel.dart';
import 'package:quotes_app/Model/hasil_model.dart';
import 'package:quotes_app/Model/modelTambahData.dart';
import 'package:quotes_app/Model/user_model.dart';
import 'package:quotes_app/Page/ringkasan_pesanan.dart';
import 'package:http/http.dart' as http;
import 'package:quotes_app/db_order.dart';
import 'package:quotes_app/dup/dupRangkuman.dart';
import 'package:shared_preferences/shared_preferences.dart';

class dupDataPesanan extends StatefulWidget {
  const dupDataPesanan({
    Key? key,
  }) : super(key: key);

  @override
  State<dupDataPesanan> createState() => _dupDataPesananState();
}

class _dupDataPesananState extends State<dupDataPesanan> {
  final _formKey = GlobalKey<FormState>();
  ModelTambahData? _model;
  List<ModelTambahData> _listTambahData = [];
  DropModel? _dropModel;
  DataItem? _dataItem;
  String _none = "-";
  HasilModel? _hasilModel;
  UserModel? _user;
  List<DataItem> _itemlist = [];
  int _selectedValueRadioButtonPC = 1;
  int _selectedValueRadioButtonTW = 8;
  bool isShown = false;
  TextEditingController _panjang = TextEditingController();
  TextEditingController _lebar = TextEditingController();
  TextEditingController _discount = TextEditingController();
  TextEditingController _qty = TextEditingController();
  TextEditingController _hrgZipper = TextEditingController();
  TextEditingController _pitch = TextEditingController();
  TextEditingController _lbZipper = TextEditingController();
  TextEditingController tebalCont = TextEditingController();
  TextEditingController catatanCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController colorCont = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingHasil = false;
  String item = "";
  String idItem = "";
  int pc = 1;
  int tw = 8;
  String jumlah = "";
  String catatan = "";
  String pitch = "";
  String hrgZipper = "";
  String lbZipper = "";
  String specLebar = "";
  int hasiTebal = 0;
  String cat = "";
  String idDrops = "";
  String sessionItem = "";
  int idx = -1;
  String item_hitung = "";

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Total belum dihitung"),
      actions: [
        okButton,
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

  format_hitung() {
    _listTambahData.forEach((ModelTambahData model) {
      item_hitung += model.dropId +
          "#" +
          model.item +
          "#" +
          model.tebal.replaceAll(" ", "") +
          "#" +
          model.catatan +
          "##";
    });
  }

  Future createDb() async {
    var order;
    order = OrderModel(
        items: nameCont.text,
        tebal: hasiTebal.toString(),
        lebar: _lebar.text == "" ? "0" : _lebar.text,
        panjang: _panjang.text == "" ? "0" : _panjang.text,
        spec: specLebar,
        color: colorCont.text,
        qty: _qty.text == "" ? "0" : _qty.text,
        disc: _discount.text == "" ? "0" : _discount.text,
        price: _none == "-" ? "0" : _hasilModel!.grandTotal.toString(),
        catatan: cat,
        tw: tw,
        pc: pc,
        sipSession: sessionItem,
        dropId: idDrops,
        pitch: _pitch.text == "" ? "0" : _pitch.text,
        lbrZip: _lbZipper.text == "" ? "0" : _lbZipper.text,
        hrgZip: _hrgZipper.text == "" ? "0" : _hrgZipper.text);
    await OrderDatabase.instance.create(order);
    _listTambahData.clear();
    setState(() {
      specLebar = "";
      hasiTebal = 0;
      cat = "";
      idDrops = "";
      sessionItem = "";
    });
    Navigator.pop(context, 'update');
  }

  Future<String> getItem() async {
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
      _itemlist = _dropModel!.dataItem;
    });
    print(_itemlist);
    return "Success";
  }

  getHasil() async {
    String url = "http://128.199.81.36/api/hitungtotal.php";
    setState(() {
      _isLoadingHasil = true;
    });
    Map<String, dynamic> data = {
      "api_key": "kspconnectpedia2020feb",
      "panjang": _panjang.text.isEmpty ? "" : _panjang.text,
      "lebar": _lebar.text.isEmpty ? "" : _lebar.text,
      "cash_disc": _discount.text.isEmpty ? "0" : _discount.text,
      "kode_produksi": _selectedValueRadioButtonPC.toString(),
      "qty": _qty.text.isEmpty ? "" : _qty.text,
      "item": item_hitung,
      "tol_wase": _selectedValueRadioButtonTW.toString(),
      "hrgZipper": _hrgZipper.text.isEmpty ? "" : _hrgZipper.text,
      "etPitch": _pitch.text.isEmpty ? "" : _pitch.text,
      "etLbZipper": _lbZipper.text.isEmpty ? "" : _lbZipper.text,
    };
    var dataUtf = utf8.encode(json.encode(data));
    var dataBase64 = base64.encode(dataUtf);
    final response =
        await http.post(Uri.parse(url), body: {'data': dataBase64});
    _hasilModel = HasilModel.fromJson(json.decode(response.body.toString()));
    setState(() {
      _none = _hasilModel!.grandTotalDisplay;
      _isLoadingHasil = false;
      item_hitung = "";
    });
  }

  masukData() {
    _listTambahData.forEach((ModelTambahData model) {
      specLebar += model.item + "-" + model.tebal.replaceAll(" ", "") + "//";
      cat += model.catatan + "-" + "/";
      idDrops += model.dropId + "*" + "/";
      sessionItem += model.dropId +
          "#" +
          model.item +
          "#" +
          model.tebal.replaceAll(" ", "") +
          "#-##";
      var lebarInt = int.parse(model.tebal);
      setState(() {
        hasiTebal += lebarInt;
      });
      print("ID: " + model.dropId);
    });
    print('Hasil Lebar: ' + hasiTebal.toString());
    print('Drop IDs ' + idDrops);
    print('SESSION ITEMS: ' + sessionItem);
  }

  @override
  void initState() {
    // TODO: implement initState
    getItem();
    super.initState();
    isShown = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'update');
        return true;
      },
      child: Scaffold(
        appBar: appBarQuote("Data Pesanan"),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 30, right: 20, bottom: 30),
                      child: Column(
                        children: [
                          inputFormName(),
                          SizedBox(
                            height: 10,
                          ),
                          radioButtonPC(),
                          SizedBox(
                            height: 10,
                          ),
                          itemDropDown(),
                          SizedBox(
                            height: 15,
                          ),
                          inputFormNote(),
                          SizedBox(
                            height: 20,
                          ),
                          addButton(),
                          SizedBox(
                            height: 10,
                          ),
                          isShown ? orderSum() : Container(),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            color: Colors.black54,
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          inputFormPitch(),
                          SizedBox(
                            height: 15,
                          ),
                          radioButtonTW(),
                          Divider(
                            color: Colors.black54,
                            thickness: 1,
                          ),
                          inputFormDiscount(),
                          SizedBox(
                            height: 25,
                          ),
                          textPPN(),
                          SizedBox(
                            height: 15,
                          ),
                          countButton(),
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

  Widget inputFormName() {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter text';
            }
            return null;
          },
          controller: nameCont,
          style: TextStyle(fontSize: 19, color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "Nama Pesanan",
            hintStyle: TextStyle(fontSize: 19),
          ),
          minLines: 1,
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
          controller: colorCont,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 19, color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "Color",
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
          controller: _qty,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 19, color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "Qty",
            hintStyle: TextStyle(fontSize: 19),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter text';
                  }
                  return null;
                },
                controller: _lebar,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 19, color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: "Lebar",
                  hintStyle: TextStyle(fontSize: 19),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Flexible(
              flex: 1,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter text';
                  }
                  return null;
                },
                controller: _panjang,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 19, color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: "Panjang",
                  hintStyle: TextStyle(fontSize: 19),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget radioButtonPC() {
    return Row(
      children: [
        Text(
          "Kode Produksi",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        Row(
          children: [
            Transform.scale(
              scale: 1.1,
              child: Radio(
                value: 1,
                groupValue: _selectedValueRadioButtonPC,
                onChanged: (value) =>
                    setState(() => _selectedValueRadioButtonPC = 1),
                activeColor: Colors.black54,
              ),
            ),
            Text(
              "1",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            Transform.scale(
              scale: 1.1,
              child: Radio(
                value: 2,
                groupValue: _selectedValueRadioButtonPC,
                onChanged: (value) =>
                    setState(() => _selectedValueRadioButtonPC = 2),
                activeColor: Colors.black54,
              ),
            ),
            Text(
              "2",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            Transform.scale(
              scale: 1.1,
              child: Radio(
                value: 3,
                groupValue: _selectedValueRadioButtonPC,
                onChanged: (value) =>
                    setState(() => _selectedValueRadioButtonPC = 3),
                activeColor: Colors.black54,
              ),
            ),
            Text(
              "3",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
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
        child: DropdownButtonFormField<DataItem>(
          decoration: InputDecoration.collapsed(hintText: ''),
          validator: (value) {
            if (value == null) {
              return 'Please enter item, quantity, notes';
            }
            return null;
          },
          hint: Text("Pilih Item"),
          isExpanded: true,
          value: _dataItem,
          icon: Icon(Icons.arrow_drop_down),
          onChanged: (DataItem? newValue) {
            setState(() {
              _dataItem = newValue;
            });
            print("DATA INDEX: " + _dataItem!.idBarang.toString());
          },
          isDense: true,
          items: _itemlist.map((DataItem item) {
            return DropdownMenuItem<DataItem>(
              child: Text(
                item.nama,
              ),
              value: item,
            );
          }).toList(),
        ));
  }

  Widget inputFormNote() {
    return Column(
      children: [
        TextFormField(
          controller: tebalCont,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 19, color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "tebal / jumlah",
            hintStyle: TextStyle(fontSize: 19),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: catatanCont,
          style: TextStyle(fontSize: 19, color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "Catatan",
            hintStyle: TextStyle(fontSize: 19),
          ),
        ),
      ],
    );
  }

  Widget addButton() {
    return Container(
      width: 335,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "Tambahkan",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              for (int i = 0; i < _listTambahData.length; i++) {
                if (_listTambahData[i].item == _dataItem!.nama.toString()) {
                  idx = i;
                }
              }
              if (idx == -1) {
                _listTambahData.add(ModelTambahData(_dataItem!.nama,
                    tebalCont.text, catatanCont.text, _dataItem!.idBarang));
              } else {
                _listTambahData[idx].tebal = tebalCont.text.toString();
                _listTambahData[idx].catatan = catatanCont.text.toString();
              }

              idx = -1;
            });

            isShown = true;
            if (isShown == true) {
              tebalCont.clear();
              catatanCont.clear();
            }
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

  Widget orderSum() {
    return Container(
      height: 100,
      child: ListView.builder(
          itemCount: _listTambahData.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _listTambahData[index].item.toString() +
                            ' - ' +
                            _listTambahData[index].tebal.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _listTambahData.removeAt(index);
                        });
                      },
                      icon: Icon(Icons.clear),
                      iconSize: 25,
                    )
                  ],
                ),
                Text(_listTambahData[index].catatan.toString(),
                    style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                )
              ],
            );
          }),
    );
  }

  Widget inputFormPitch() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: TextFormField(
            controller: _pitch,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 19, color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: "Pitch",
              hintStyle: TextStyle(fontSize: 19),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Flexible(
          flex: 1,
          child: TextFormField(
            controller: _lbZipper,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 19, color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: "Lb Zipper",
              hintStyle: TextStyle(fontSize: 19),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Flexible(
          flex: 1,
          child: TextFormField(
            controller: _hrgZipper,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 19, color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: "Hrg Zipper",
              hintStyle: TextStyle(fontSize: 19),
            ),
          ),
        ),
      ],
    );
  }

  Widget radioButtonTW() {
    return Row(
      children: [
        Text(
          "Tol. Waste:",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        Row(
          children: [
            Transform.scale(
              scale: 1.1,
              child: Radio(
                value: 8,
                groupValue: _selectedValueRadioButtonTW,
                onChanged: (value) =>
                    setState(() => _selectedValueRadioButtonTW = 8),
                activeColor: Colors.black54,
              ),
            ),
            Text(
              "8",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            Transform.scale(
              scale: 1.1,
              child: Radio(
                value: 10,
                groupValue: _selectedValueRadioButtonTW,
                onChanged: (value) =>
                    setState(() => _selectedValueRadioButtonTW = 10),
                activeColor: Colors.black54,
              ),
            ),
            Text(
              "10",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            Transform.scale(
              scale: 1.1,
              child: Radio(
                value: 15,
                groupValue: _selectedValueRadioButtonTW,
                onChanged: (value) =>
                    setState(() => _selectedValueRadioButtonTW = 15),
                activeColor: Colors.black54,
              ),
            ),
            Text(
              "15",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget inputFormDiscount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Text(
            "Discount %",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: TextFormField(
            controller: _discount,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 19, color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textPPN() {
    return Row(
      children: [
        Text(
          "Total exc PPN",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: 100,
        ),
        _isLoadingHasil
            ? CircularProgressIndicator()
            : Text(
                _none,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ],
    );
  }

  Widget countButton() {
    return Container(
      width: 335,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "Hitung",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              pitch = _pitch.text;
              hrgZipper = _hrgZipper.text;
              lbZipper = _lbZipper.text;
            });
            final prefs = await SharedPreferences.getInstance();
            prefs.setString("pitch", pitch);
            prefs.setString("hrgZipper", hrgZipper);
            prefs.setString("lbZipper", lbZipper);
            format_hitung();
            getHasil();
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
          if (_formKey.currentState!.validate() && _none != "-") {
            masukData();
            createDb();
          } else if (_none == "-") {
            showAlertDialog(context);
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
          Navigator.pop(context, 'update');
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
