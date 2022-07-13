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
          padding: EdgeInsets.symmetric(horizontal: 20),
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
                  SizedBox(height: 10),
                  Text(
                    'Sales Executive -  Surabaya',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        '085400293454',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 5,),
                      Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        'asdfs@gmail.com',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 75,
                        width: 120,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code, color: Colors.white,),
                            SizedBox(width: 3),
                            Text('QR Code',
                                style: TextStyle(fontSize: 12, color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(
                        height: 75,
                        width: 170,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.contact_mail, color: Colors.white,),
                            SizedBox(width: 3),
                            Text('Share Contact Card',
                                style: TextStyle(fontSize: 12, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(

                    ),
                  ),
                  Container(
                    height: 50,
                    width: 340,
                    child: ElevatedButton(
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/report_billing.png",
                            height: 25,
                          ),
                          SizedBox(width: 3),
                          Text('Harga update: 1 Januari 2022 pk 10:00 WIB ',
                              style: TextStyle(fontSize: 12)),
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
                  SizedBox(height: 5,),
                  Container(
                    width: 340,
                    child: ElevatedButton(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/report_billing.png",
                                height: 40,
                              ),
                              SizedBox(width: 10),
                              Text('Price Quotation',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(children: [
                            Icon(Icons.circle, color: Colors.red, size: 14,),
                            SizedBox(width: 5,),
                            Text('8 Quotation menunggu approval', style: TextStyle(
                              fontWeight: FontWeight.w300
                            ),)
                          ],)
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
                  SizedBox(height: 15,),
                  Container(
                    width: 340,
                    child: ElevatedButton(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.attach_money),
                              SizedBox(width: 10),
                              Text('Sales Contract',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(children: [
                            Icon(Icons.circle, color: Colors.red, size: 14,),
                            SizedBox(width: 5,),
                            Text('8 sales contract telah lewat jatuh tempo', style: TextStyle(
                                fontWeight: FontWeight.w300
                            ),)
                          ],)
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
                  SizedBox(height: 15,),
                  Container (
                    width: 340,
                    child: ElevatedButton(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people),
                              SizedBox(width: 10),
                              Text('Customer Database',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(children: [
                            Icon(Icons.circle, color: Colors.white, size: 14,),
                            SizedBox(width: 5,),
                            Text('Total 800 Customers', style: TextStyle(
                                fontWeight: FontWeight.w300
                            ),)
                          ],)
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
