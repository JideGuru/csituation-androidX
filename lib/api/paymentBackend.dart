import 'dart:async';

import 'package:college_situation/common/my_strings.dart';
import 'package:http/http.dart' as http;

abstract class PaymentBackend {
  static Future<String> getPlans(String token) async {
    var headers = {
      "x-access-token": token,
    };
    try {
      //POST REQUEST BUILD
      var url =
          Strings.apiLink + '/subscription/getAllSubscriptions';

      final responseBody = (await http.get(url, headers: headers)).body;
      //print(responseBody);

      return responseBody;
    } catch (e) {
      //if (e.response.body != null) {

      // print(e.response);

    }

    return null;
  }
  
  static Future<String> getKeys(String token) async {
    var headers = {
      "x-access-token": token,
    };
    try {
      //POST REQUEST BUILD
      var url =
          Strings.apiLink + '/key/getAllKeys';

      final responseBody = (await http.get(url, headers: headers)).body;
      //print(responseBody);

      return responseBody;
    } catch (e) {
      //if (e.response.body != null) {

      // print(e.response);

    }

    return null;
  }


  static Future<String> getUserPlan(String id, String token) async {
    var headers = {
      "x-access-token": token,
    };
    try {
      //POST REQUEST BUILD
      var url = 
          Strings.apiLink + '/student/subscription/$id';

      final responseBody = (await http.get(url, headers: headers)).body;
     // print(responseBody);

      return responseBody;
    } catch (e) {
      //if (e.response.body != null) {

      // print(e.response);

    }

    return null;
  }
}
