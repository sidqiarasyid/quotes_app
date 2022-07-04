import 'package:flutter/material.dart';
import 'package:quotes_app/Page/price_quote.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Image.asset(
                      "assets/images/logo-removebg.png",
                      height: 150,
                    ),
                  ),
                  Text(
                    "PT. ANEKA PRATAMA PLASTINDO",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                    endIndent: 75,
                    indent: 75,
                  ),
                  Text(
                    "PLASTIC ROTOGRAVURE PRINTING",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 10),
                    child: Image.asset(
                      "assets/images/profile_default.png",
                      height: 125,
                    ),
                  ),
                  Text(
                    widget.username,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 50),
                  Container(
                    height: 75,
                    width: 275,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    child: ElevatedButton(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/report_billing.png",
                            height: 40,
                          ),
                          SizedBox(width: 10),
                          Text('Price Quotation',
                              style: TextStyle(fontSize: 17)),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PriceQuotePage()));
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent)),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Version 1.6 Flutter",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
