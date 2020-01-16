import 'dart:async';

import 'package:college_situation/common/my_strings.dart';
import 'package:http/http.dart' as http;

abstract class StoriesBackend {
  static Future<String> get(String token) async {
    var headers = {
      "x-access-token": token,
    };
    try {
      //POST REQUEST BUILD
      var url = Strings.apiLink + '/story/getAllStories';

      final responseBody = (await http.get(url, headers: headers)).body;
      //print(responseBody);

      return responseBody;
    } catch (e) {
      //if (e.response.body != null) {

      // print(e.response);

    }

    return null;
  }

  static Future<String> getStoriesCat(String token) async {
    var headers = {
      "x-access-token": token,
    };
    String responseB;
    try {
      //POST REQUEST BUILD
      var url = Strings.apiLink + '/storyCategory/getAllStoryCategories';

      responseB = (await http.get(url, headers: headers)).body;
      //print(responseBody);
    } catch (e) {
      //if (e.response.body != null) {

      // print(e.response);

    }
    return responseB;
  }

  static Future<String> getSingleStoryDetails(String id, String token) async {
    var headers = {
      "x-access-token": token,
    };
    try {
      //POST REQUEST BUILD
      var url = Strings.apiLink + '/story/getSingleStory/$id';

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw 'An Error Ocurred';
      }
    } catch (e) {
      //if (e.response.body != null) {

      print(e.toString());
    }

    return null;
  }

  static Future<bool> deleteSingleStoryDetails(String id, String token) async {
    var headers = {
      "x-access-token": token,
    };
    try {
      //POST REQUEST BUILD
      var url = Strings.apiLink + '/story/singleStory/delete/$id';

      final response = await http.delete(url, headers: headers);
      print(response.body);
      if (response.statusCode == 200 && response.body.contains('true')) {
        return true;
      }

      return false;
    } catch (e) {
      //if (e.response.body != null) {

      // print(e.response);

    }

    return false;
  }
}
