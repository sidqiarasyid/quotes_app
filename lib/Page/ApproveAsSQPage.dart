import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quotes_app/Model/ApiConstant.dart';
import 'package:quotes_app/Model/UpdateToSQ.dart';
import 'package:quotes_app/Model/detailPQ.dart';
import 'package:quotes_app/Page/DownloadPDFPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ApproveAsSQPage extends StatefulWidget {
  const ApproveAsSQPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ApproveAsSQPage> createState() => _ApproveAsSQPageState();
}

class _ApproveAsSQPageState extends State<ApproveAsSQPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  List dataDetail = [];
  var expT;
  int lengthDatapesanan = 0;
  List total = [];
  List discount = [];
  List grandtotal = [];
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  late String baseimage = "";

  getDetailPQ() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> datapost = {
      "api_key": apikey,
      "id_sales": prefs.getString('username').toString(),
      "id_pq": "2"
    };

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    Map<String, dynamic> bodyParameters = {
      "data": "${stringToBase64.encode(json.encode(datapost))}"
    };

    var result = await DetailPQ().detailpq(bodyParameters);
    setState(() {
      dataDetail = result!;
      expT = dataDetail[0]['date'].split("-");
      lengthDatapesanan = dataDetail[1]['data_pesanan'].length;
      for (var i = 0; i < lengthDatapesanan; i++) {
        int jml = 0;
        double jmldiscount = 0;
        int jmltotal = 0;
        for (var j = 0;
            j < dataDetail[1]['data_pesanan'][i]['detail_produk '].length;
            j++) {
          jml += int.parse(dataDetail[1]['data_pesanan'][i]['qty']) *
              int.parse(dataDetail[1]['data_pesanan'][i]['detail_produk '][j]
                  ['harga']);
        }
        total.add(jml);
        jmldiscount = (total[i] *
                int.parse(dataDetail[1]['data_pesanan'][i]['cash_discount'])) /
            100;
        discount.add(jmldiscount);

        jmltotal = (total[i] - discount[i].toInt());
        grandtotal.add(jmltotal);
      }
    });
  }

  _submitCustomerApprove() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> datapost = {
      "api_key": apikey,
      "id_sales": prefs.getString('username').toString(),
      "id_pq": "2",
      "image": "$baseimage"
    };

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    Map<String, dynamic> bodyParameters = {
      "data": "${stringToBase64.encode(json.encode(datapost))}"
    };

    var result = await UpdateSQ().updatesq(bodyParameters);
    if (result!.response == "True") {
      await EasyLoading.dismiss();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              DownloadPDFpage(title: widget.title),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getDetailPQ();
  }

  _pickImage(ImageSource src) async {
    var image = await _picker.pickImage(source: src);
    setState(() {
      _image = image;

      List<int> imageBytes = File(_image!.path).readAsBytesSync();
      baseimage = base64Encode(imageBytes);
    });
  }

  Widget _ambilGambar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Wrap(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: const Text(
              "Ambil Gambar",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                      child: Column(
                        children: [
                          const Icon(
                            Icons.camera,
                            size: 40,
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: const Text("Ambil dari Kamera"))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                      child: Column(
                        children: [
                          const Icon(
                            Icons.image,
                            size: 40,
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: const Text("Ambil dari Galeri"))
                        ],
                      ),
                    ),
                  ),
                ]),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarQuote("Price Quote"),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (dataDetail.isEmpty)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                thickness: 2,
                                color: Color(0xffD3D3D3),
                              ),
                              itemCount: 5,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      height: 10.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      height: 10.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      height: 10.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      height: 20.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "${formatDate(DateTime(int.parse(expT[0]), int.parse(expT[1]), int.parse(expT[2])), [
                                d,
                                ' ',
                                MM,
                                ' ',
                                yyyy
                              ])}"),
                          Text("${dataDetail[1]['data_pesanan'][0]['no_pq']}"),
                          Text("Kop: ${dataDetail[0]['nama_customer']}"),
                          const Text(""),
                          Text(
                            "${dataDetail[0]['nama_customer']}",
                            style: const TextStyle(fontSize: 20),
                          ),
                          // Text(
                          //     "Jl Kertajaya Indah Timur no 80-100 Surabaya, Jawa Timur"),
                        ],
                      ),
                    ),
              const Divider(
                thickness: 2,
                color: Color(0xffD3D3D3),
              ),
              for (var i = 0; i < lengthDatapesanan; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "${dataDetail[1]['data_pesanan'][i]['nama_pesanan']}"),
                          for (var j = 0;
                              j <
                                  dataDetail[1]['data_pesanan'][i]
                                          ['detail_produk ']
                                      .length;
                              j++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    "Size: ${dataDetail[1]['data_pesanan'][i]['lebar']}x${dataDetail[1]['data_pesanan'][i]['panjang']}x${dataDetail[1]['data_pesanan'][i]['detail_produk '][j]['tebal']}"),
                                Text(
                                    "Spec: ${dataDetail[1]['data_pesanan'][i]['detail_produk '][j]['nama_produk']}"),
                                Text(
                                    "Color: ${dataDetail[1]['data_pesanan'][i]['color']}"),
                                Text(
                                    "${dataDetail[1]['data_pesanan'][i]['qty']} x ${dataDetail[1]['data_pesanan'][i]['detail_produk '][j]['harga']}"),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                      "Catatan: ${dataDetail[0]['catatan']}"),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      color: Color(0xffD3D3D3),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(child: Text("Total")),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child:
                                          Text("${myFormat.format(total[i])}")))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      "Diskon ${dataDetail[1]['data_pesanan'][i]['cash_discount']}%")),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "${myFormat.format(discount[i].toInt())}")))
                            ],
                          ),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Grand Total",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "${myFormat.format(grandtotal[i])}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold))))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      color: Color(0xffD3D3D3),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _image == null
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: ((builder) => _ambilGambar()),
                                );
                              });
                            },
                            child: Container(
                                // color: const Color(0xffD3D3D3),
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  color: Color(0xffD3D3D3),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Icon(
                                          Icons.camera_enhance,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                        )),
                                    const Text(
                                      "Upload Bukti Approval",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                )),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: ((builder) => _ambilGambar()),
                                );
                              });
                            },
                            child: Container(
                                // color: const Color(0xffD3D3D3),
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  color: Color(0xffD3D3D3),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Image.file(
                                          File(_image!.path),
                                          height: double.infinity,
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                        )),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Text(
                                          "${_image!.name}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            "Submit Customer Approval",
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () async {
                            await EasyLoading.show(
                              status: 'loading...',
                              maskType: EasyLoadingMaskType.black,
                            );
                            setState(() {
                              _submitCustomerApprove();
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            "Back",
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            setState(() {});
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
