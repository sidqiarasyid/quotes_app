import 'package:flutter/material.dart';
import 'package:quotes_app/Page/data_customer.dart';

class PriceQuotePage extends StatefulWidget {
  const PriceQuotePage({Key? key}) : super(key: key);

  @override
  State<PriceQuotePage> createState() => _PriceQuotePageState();
}

class _PriceQuotePageState extends State<PriceQuotePage> {
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
}
