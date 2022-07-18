import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/Model/OrderModel.dart';
import 'package:quotes_app/Model/dropModel.dart';
import 'package:quotes_app/Model/hasil_model.dart';
import 'package:quotes_app/Model/user_model.dart';
import 'package:quotes_app/Page/ringkasan_pesanan.dart';
import 'package:http/http.dart' as http;
import 'package:quotes_app/db_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataPesananPage extends StatefulWidget {
  const DataPesananPage({Key? key}) : super(key: key);

  @override
  State<DataPesananPage> createState() => _DataPesananPageState();
}

class _DataPesananPageState extends State<DataPesananPage> {
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
  var order;

  Future createDb() async {
    final prefs = await SharedPreferences.getInstance();
    order = OrderModel(
        items: nameCont.text,
        tebal: prefs.getString("jumlah").toString(),
        lebar: _lebar.text,
        panjang: _panjang.text,
        spec: item,
        color: colorCont.text,
        qty: _qty.text,
        disc: _discount.text,
        price: _hasilModel!.grandTotal.toString(),
        tw: tw,
        pc: pc);
    await OrderDatabase.instance.create(order);
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
      "panjang": _panjang.text,
      "lebar": _lebar.text,
      "cash_disc": _discount.text,
      "kode_produksi": _selectedValueRadioButtonPC.toString(),
      "qty": _qty.text,
      "item": _dataItem!.nama,
      "tol_wase": _selectedValueRadioButtonTW.toString(),
      "hrgZipper": _hrgZipper.text,
      "etPitch": _pitch.text,
      "etLbZipper": _lbZipper.text,
    };
    var dataUtf = utf8.encode(json.encode(data));
    var dataBase64 = base64.encode(dataUtf);
    final response =
        await http.post(Uri.parse(url), body: {'data': dataBase64});
    _hasilModel = HasilModel.fromJson(json.decode(response.body.toString()));
    setState(() {
      _none = _hasilModel!.grandTotalDisplay;
      _isLoadingHasil = false;
    });
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
    return Scaffold(
      appBar: appBarQuote("2. Data Pesanan"),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
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
        child: DropdownButton<DataItem>(
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
          underline: SizedBox.shrink(),
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
          setState(() {
            isShown = true;
            item = _dataItem!.nama;
            idItem = _dataItem!.idBarang;
            jumlah = tebalCont.text;
            catatan = catatanCont.text;
            if (isShown == true) {
              tebalCont.clear();
              catatanCont.clear();
            }
          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("jumlah", jumlah);
          prefs.setString("item_drop", item);
          prefs.setString("id_drop", idItem);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item + ' - ' + jumlah,
                style: TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isShown = false;
                  item = "";
                  jumlah = "";
                  catatan = "";
                });
              },
              icon: Icon(Icons.clear),
              iconSize: 25,
            )
          ],
        ),
        Text(catatan, style: TextStyle(fontSize: 16)),
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 1,
          color: Colors.grey,
        )
      ],
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
            "Discount",
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
          setState(() {
            pitch = _pitch.text;
            hrgZipper = _hrgZipper.text;
            lbZipper = _lbZipper.text;
          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("pitch", pitch);
          prefs.setString("hrgZipper", hrgZipper);
          prefs.setString("lbZipper", lbZipper);
          getHasil();
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
          createDb();
          setState(() {
            pc = _selectedValueRadioButtonPC;
            tw = _selectedValueRadioButtonTW;
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => RingkasanPesananPage(
                    pc: pc,
                    tw: tw,
                  )));
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
