import 'dart:async';

import 'package:college_situation/common/my_strings.dart';
import 'package:http/http.dart' as http;

abstract class AdviceBackend {
  ///Fectch feeds from GQBUZZ's api by passing in the page number
  static Future<String> get(String token) async {
    var headers = {
      "x-access-token": token,
    };
    try {
      //POST REQUEST BUILD
      var url =
          Strings.apiLink + '/advice/allAdvices';

      final responseBody = (await http.get(url, headers: headers)).body;
    
      return responseBody;
    } catch (e) {
      //if (e.response.body != null) {

      // print(e.response);

    }

    return null;
  }
}
