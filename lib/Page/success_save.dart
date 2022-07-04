import 'package:flutter/material.dart';

class SuccessSavePage extends StatefulWidget {
  const SuccessSavePage({Key? key}) : super(key: key);

  @override
  State<SuccessSavePage> createState() => _SuccessSavePageState();
}

class _SuccessSavePageState extends State<SuccessSavePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarQuote("Price Quote"),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                "assets/images/success.png",
                width: 100,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Price Quote telah tersimpan",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 40,
              ),
              downloadButton(),
              SizedBox(
                height: 25,
              ),
              backButton(),
            ],
          ),
        ),
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

  Widget downloadButton() {
    return Container(
      width: 270,
      height: 60,
      child: ElevatedButton(
        child: Text(
          "Download PDF",
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
      width: 270,
      height: 60,
      child: ElevatedButton(
        child: Text(
          "BACK",
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
