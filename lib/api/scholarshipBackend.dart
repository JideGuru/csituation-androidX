import 'dart:async';

import 'package:college_situation/common/my_strings.dart';
import 'package:http/http.dart' as http;

abstract class ScholarshipBackend {
  static Future<String> get(String token) async {
    var headers = {
      "x-access-token": token,
    };
    try {
      //POST REQUEST BUILD
      var url = Strings.apiLink + '/scholarship/getAllScholarships';

      final responseBody = (await http.get(url, headers: headers)).body;
      //print(responseBody);

      return responseBody;
    } catch (e) {
      //if (e.response.body != null) {

      // print(e.response);

    }

    return null;
  }


  static Future<String> getSingleScholarshipDetails(String id, String token) async {
    var headers = {
      "x-access-token": token,
    };
    try {
      //POST REQUEST BUILD
      var url =
          Strings.apiLink + '/scholarship/getSingleScholarship/$id';

      final responseBody = (await http.get(url, headers: headers)).body;
      //print(responseBody);

      return responseBody;
    } catch (e) {
      //if (e.response.body != null) {

      // print(e.response);

    }

    return null;
  }
}
