import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotes_app/Model/user_model.dart';
import 'package:quotes_app/Network/login_api.dart';
import 'package:quotes_app/Page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
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
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
              return value.toString().trim().isEmpty
                  ? 'Field can\'t be blank'
                  : null;
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
              return value.toString().trim().isEmpty
                  ? 'Field can\'t be blank'
                  : null;
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
            _login();
          }
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent)),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = !_isLoading;
    });
    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      UserModel result = await LoginApi()
          .postLogin(username: username.text, password: password.text);
      if (result.username.isNotEmpty) {
        setState(() {
          _isLoading = false;
        });
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('username', result.username);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext c) => HomePage(username: result.name)));
      }
    }
  }
}
