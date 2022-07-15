import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:quotes_app/Page/price_quote.dart';
import 'package:quotes_app/Page/success_save.dart';

class RingkasanPesananDupPage extends StatefulWidget {
  const RingkasanPesananDupPage({Key? key}) : super(key: key);

  @override
  State<RingkasanPesananDupPage> createState() => _RingkasanPesananDupPageState();
}

class _RingkasanPesananDupPageState extends State<RingkasanPesananDupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _topController = TextEditingController();
  final TextEditingController _ovController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarQuote("3. Ringkasan Pesanan"),
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
            child: Column(
              children: [
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

  Widget addOrderButton() {
    return Container(
      width: 335,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "Tambahkan Pesanan",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () {},
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

  Widget inputFormDetail() {
    return Column(
      children: [
        TextFormField(
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
        Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                TypeAheadField(
                  suggestionsCallback: (value) => top_list.where((element) =>
                      element.toLowerCase().contains(value.toLowerCase())),
                  itemBuilder: (_, String item) => ListTile(
                    title: Text(
                      item,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  onSuggestionSelected: (String val) {
                    this._topController.text = val;
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
                    controller: this._topController,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TypeAheadField(
                  suggestionsCallback: (value) => ov_list.where((element) =>
                      element.toLowerCase().contains(value.toLowerCase())),
                  itemBuilder: (_, String item) => ListTile(
                    title: Text(
                      item,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  onSuggestionSelected: (String val) {
                    this._ovController.text = val;
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
                    controller: this._ovController,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TypeAheadField(
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
                    this._conditionController.text = val;
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
                    controller: this._conditionController,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TypeAheadField(
                  suggestionsCallback: (value) => note_list.where((element) =>
                      element.toLowerCase().contains(value.toLowerCase())),
                  itemBuilder: (_, String item) => ListTile(
                    title: Text(
                      item,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  onSuggestionSelected: (String val) {
                    this._noteController.text = val;
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
                    controller: this._noteController,
                  ),
                ),
              ],
            ),
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SuccessSavePage()));
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PriceQuotePage()));
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
