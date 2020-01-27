import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:college_situation/common/my_utils.dart';
import 'package:college_situation/models/listingModel.dart';
import 'package:college_situation/models/storyCreateResponse.dart'
    as storyCreateModel;
import 'package:http/http.dart' as http;

class StoryFormData {
  String title;
  String photo;
  String description;
  String featured;
  String category;
  String owner;

  StoryFormData(
      {this.title,
      //this.photo,
      this.description,
      this.featured,
      this.category,
      this.owner});
}

class ListingFormData {
  List<String> photos;
  Owner owner;
  String type;
  String address;
  String bedrooms;
  String bathrooms;
  String price;
  String size;
  String briefDescription;
  String availability;
  String catFriendly;
  String dogFriendly;
  String laundryType;
  String parkingType;
  String acType;
  String heatingType;
  String city;
  String state;
  String zip;
  DateTime dateOfCreation;
  int iV;

  ListingFormData(
      {this.photos,
      this.owner,
      this.type,
      this.address,
      this.bedrooms,
      this.bathrooms,
      this.price,
      this.size,
      this.briefDescription,
      this.availability,
      this.catFriendly,
      this.dogFriendly,
      this.laundryType,
      this.parkingType,
      this.acType,
      this.heatingType,
      this.city,
      this.state,
      this.zip,
      this.dateOfCreation,
      this.iV});
}

class Forms {
  Future<storyCreateModel.StoryCreateResponse> submitStory(
      StoryFormData storyFormData, String token) async {
    var url = MyUtils.buildUrl('story/createNewStory');

    var body = {
      'title': storyFormData.title,
      'description': storyFormData.description,
      'featured': storyFormData.featured ?? 'no',
      'category': storyFormData.category,
      'owner': storyFormData.owner,
      //'photo': storyFormData.photo,
    };

    var headers = {
      "x-access-token": token,
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    try {
      var response = await http.post(url, headers: headers, body: body);
      print(response.body);
      if (response.statusCode == 200) {
        return storyCreateModel.StoryCreateResponse.fromJson(
            json.decode(response.body));
      } else {
        throw "A network error occured";
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map> submitListing(
      ListingFormData listingformData, String token) async {
    var url = MyUtils.buildUrl('housing/createHouse');
    Map<String, dynamic> body = <String, dynamic>{
      'type': listingformData.type,
      'address': listingformData.address,
      'bedrooms': listingformData.bedrooms,
      'bathrooms': listingformData.bathrooms,
      'price': listingformData.price,
      'availability': listingformData.availability,
      'size': listingformData.size,
      'briefDescription': listingformData.briefDescription,
      'city': listingformData.city,
      'state': listingformData.state,
      'zip': listingformData.zip,
      'dogFriendly': listingformData.dogFriendly,
      'catFriendly': listingformData.catFriendly,
      'laundryType': listingformData.laundryType ?? 'None',
      'heatingType': listingformData.heatingType ?? 'None',
      'acType': listingformData.acType ?? 'None',
      'parkingType': listingformData.parkingType ?? 'None',
      'owner': listingformData.owner.sId,
      'mainPhoto': listingformData.photos.elementAt(0),
      'photo1': listingformData.photos.elementAt(0) ?? '',
      'photo2': listingformData.photos.elementAt(1) ?? '',
      'photo3': listingformData.photos.elementAt(2) ?? '',
      'photo4': listingformData.photos.elementAt(3) ?? '',
      'photo5': listingformData.photos.elementAt(4) ?? '',
      'photo6': listingformData.photos.elementAt(5) ?? '',
    };
    if (listingformData.photos.length > 6) {
      if (listingformData.photos.length == 7) {
        body.addAll({
          'photo7': listingformData.photos.elementAt(6) ?? '',
        });
      } else if (listingformData.photos.length == 8) {
        body.addAll({
          'photo7': listingformData.photos.elementAt(6) ?? '',
          'photo8': listingformData.photos.elementAt(7) ?? '',
        });
      } else if (listingformData.photos.length == 9) {
        body.addAll({
          'photo7': listingformData.photos.elementAt(6) ?? '',
          'photo8': listingformData.photos.elementAt(7) ?? '',
          'photo9': listingformData.photos.elementAt(8) ?? '',
        });
      } else {
        body.addAll({
          'photo7': listingformData.photos.elementAt(6) ?? '',
          'photo8': listingformData.photos.elementAt(7) ?? '',
          'photo9': listingformData.photos.elementAt(8) ?? '',
          'photo10': listingformData.photos.elementAt(9) ?? '',
        });
      }
    }
    var headers = {
      "x-access-token": token,
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };
    var response;
    var responseBody;
    try {
      response = await http.post(url, headers: headers, body: body);
      print(response.body);
    } catch (e) {
      print('OOO $e');
    } finally {
      print(response.body);
      responseBody = jsonDecode(response.body);
      print(responseBody);
    }
    Map resp = {
      'res': responseBody['success'],
      'id': responseBody['data']['_id'],
    };
    return resp;
  }
}
