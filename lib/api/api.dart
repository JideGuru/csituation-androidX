import 'dart:convert';

import 'package:college_situation/models/newUserModel.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIRequest {
  static Future<UserModel> login({String email, String password}) async {
    var headers = {
      'Content-type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
    };
    var body = {"email": email, "password": password};

    final response = await http.post(
      "https://thecollegesituation.herokuapp.com/api/v1/student/login",
      headers: headers,
      body: json.encode(body),
    );

    try {
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = UserModel.fromJson(
          json.decode(response.body),
        );
        prefs.setString(
          'userData',
          json.encode(data.toJson()),
        );
        return data;
      } else {
        if (response.body.toLowerCase().contains('invalid email')) {
          throw 'Invalid Email Address Passed';
        }
      }
    } catch (e) {
      print(e.toString());

      return null;
    }

    return null;
  }
}
