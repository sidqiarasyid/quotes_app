import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotes_app/Page/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 200, bottom: 50),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 125,
                    height: 125,
                  ),
                ),
                formLogin(),
                formButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formLogin() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          width: double.infinity,
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please username';
              } else if (value != "resha") {
                return "Username salah";
              }
              return null;
            },
            controller: username,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Username',
              hintStyle: GoogleFonts.openSans(color: Colors.grey),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          width: double.infinity,
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please password';
              } else if (value != "123456") {
                return "Password salah";
              }
              return null;
            },
            controller: password,
            obscureText: true,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Password',
              hintStyle: GoogleFonts.openSans(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget formButton() {
    return Container(
      width: 275,
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: ElevatedButton(
        child: Text('Login'),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _onLoading();
          }
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent)),
      ),
    );
  }

  void _onLoading() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => HomePage(username: username.text)));
  }
}
