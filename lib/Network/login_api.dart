import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:quotes_app/Model/user_model.dart';

class LoginApi {
  final url = Uri.parse('http://128.199.81.36/api/login.php');

  Future<UserModel> postLogin(
      {required String username, required String password}) async {
    Map<String, dynamic> data = {
      "api_key": "kspconnectpedia2020feb",
      "username": username,
      "password": password,
    };
    var dataUtf = utf8.encode(json.encode(data));
    var dataBase64 = base64.encode(dataUtf);
    final response = await http.post(url, body: {'data': dataBase64});
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw HttpException('request error code ${response.statusCode}');
    }
  }
}
