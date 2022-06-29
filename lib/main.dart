import 'package:flutter/material.dart';
import 'package:quotes_app/Page/data_customer.dart';
import 'package:quotes_app/Page/intro.dart';
import 'package:quotes_app/Page/price_quote.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DataCustomer(),
    );
  }
}
