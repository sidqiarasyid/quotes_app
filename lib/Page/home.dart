import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                "PT. ANEKA PRATAMA PLASTINDO",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.white,
                thickness: 2,
                endIndent: 50,
                indent: 50,
              ),
              Text(
                "PLASTIC ROTOGRAVURE PRINTING",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: 75, bottom: 10),
                child: Image.asset(
                  "assets/images/profile.png",
                  height: 150,
                ),
              ),
              Text(
                widget.username,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 100),
              Container(
                width: 275,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                child: ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.price_change),
                      SizedBox(width: 50),
                      Text('Price Quotation'),
                    ],
                  ),
                  onPressed: () {},
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent)),
                ),
              ),
              SizedBox(height: 100),
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
    );
  }
}
