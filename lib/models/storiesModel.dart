import 'userModel.dart';
import 'storiesCatModel.dart';

class StoriesModel {
  bool success;
  List<StoriesData> data;

  StoriesModel({this.success, this.data});

  StoriesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<StoriesData>();
      json['data'].forEach((v) {
        data.add(new StoriesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StoriesData {
  String sId;
  String title;
  String photo;
  String description;
  String featured;
  StoryCatData category;
  User owner;
  String dateOfCreation;
  int iV;

  StoriesData(
      {this.sId,
      this.title,
      this.photo,
      this.description,
      this.featured,
      this.category,
      this.owner,
      this.dateOfCreation,
      this.iV});

  StoriesData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    photo = json['photo'];
    description = json['description'];
    featured = json['featured'];
    category = json['category'] != null
        ? new StoryCatData.fromJson(json['category'])
        : null;
    owner = json['owner'] != null ? new User.fromJson(json['owner']) : null;
    dateOfCreation = json['dateOfCreation'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['photo'] = this.photo;
    data['description'] = this.description;
    data['featured'] = this.featured;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['dateOfCreation'] = this.dateOfCreation;
    data['__v'] = this.iV;
    return data;
  }
}

