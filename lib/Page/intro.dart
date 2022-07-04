import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quotes_app/Page/login.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  void initState() {
    Future.delayed(
        Duration(seconds: 3),
        () => Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Image.asset("assets/images/logo.png", height: 200),
        ),
      ),
    );
  }
}
