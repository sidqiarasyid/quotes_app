// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:quotes_app/Page/SalesContract.dart';

class DownloadPDFpage extends StatefulWidget {
  const DownloadPDFpage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DownloadPDFpage> createState() => _DownloadPDFpageState();
}

class _DownloadPDFpageState extends State<DownloadPDFpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                  child: Icon(
                Icons.check_circle,
                size: MediaQuery.of(context).size.width * 0.2,
                color: const Color(0xff008000),
              )),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50.0, right: 50.0),
              child: Text(
                "Price Quote telah ter-approve dan Sales Contract telah terkirim ke customer.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, color: Color(0xff008000)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: ButtonTheme(
                // minWidth: MediaQuery.of(context).size.width,
                height: 45.0,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: const Color(0xff008000),
                  onPressed: () {
                    setState(() {});
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Text(
                    "Download PDF",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: 40.0,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: 40.0,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SalesContractPage(title: widget.title),
                        ),
                      );
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Text(
                    "SALES CONTRACT",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
