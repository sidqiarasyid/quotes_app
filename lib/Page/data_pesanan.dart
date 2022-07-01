import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DataPesananPage extends StatefulWidget {
  const DataPesananPage({Key? key}) : super(key: key);

  @override
  State<DataPesananPage> createState() => _DataPesananPageState();
}

class _DataPesananPageState extends State<DataPesananPage> {
  int _selectedValueRadioButtonPC = 1;
  int _selectedValueRadioButtonTW = 8;
  final _items = ["OPP", "OOP MATTE", "OOP HEAT SEAL", "PET"];
  String? _valueDropDown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarQuote("2. Data Pesanan"),
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 30),
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

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 19, color: Colors.black),
        ),
      );

  Widget inputFormName() {
    return Column(
      children: [
        TextFormField(
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: _valueDropDown,
          items: _items.map(buildMenuItem).toList(),
          onChanged: (value) => setState(() => this._valueDropDown = value),
          isExpanded: true,
          iconSize: 0.0,
          hint: Text(
            "OPP",
            style: TextStyle(fontSize: 19, color: Colors.black),
          ),
          dropdownOverButton: true,
        ),
      ),
    );
  }

  Widget inputFormNote() {
    return Column(
      children: [
        TextFormField(
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

  Widget inputFormPitch() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: TextFormField(
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
        Text(
          "-",
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

  Widget nextButton() {
    return Container(
      width: 335,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "Lanjut",
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

  Widget backButton() {
    return Container(
      width: 335,
      height: 50,
      child: ElevatedButton(
        child: Text(
          "Kembali",
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
}