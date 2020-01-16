class StoryCreateResponse {
  bool success;
  Data data;

  StoryCreateResponse({this.success, this.data});

  StoryCreateResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String sId;
  String title;
  String photo;
  String description;
  String featured;
  String category;
  Owner owner;
  String dateOfCreation;
  int iV;

  Data(
      {this.sId,
      this.title,
      this.photo,
      this.description,
      this.featured,
      this.category,
      this.owner,
      this.dateOfCreation,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    photo = json['photo'];
    description = json['description'];
    featured = json['featured'];
    category = json['category'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
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
    data['category'] = this.category;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['dateOfCreation'] = this.dateOfCreation;
    data['__v'] = this.iV;
    return data;
  }
}

class Owner {
  bool hasAppliedFreeSubscription;
  bool isActive;
  String sId;
  String firstName;
  String lastName;
  String email;
  String password;
  String dateOfCreation;
  int iV;
  String profile;
  String userSubscription;

  Owner(
      {this.hasAppliedFreeSubscription,
      this.isActive,
      this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.dateOfCreation,
      this.iV,
      this.profile,
      this.userSubscription});

  Owner.fromJson(Map<String, dynamic> json) {
    hasAppliedFreeSubscription = json['hasAppliedFreeSubscription'];
    isActive = json['isActive'];
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    dateOfCreation = json['dateOfCreation'];
    iV = json['__v'];
    profile = json['profile'];
    userSubscription = json['userSubscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasAppliedFreeSubscription'] = this.hasAppliedFreeSubscription;
    data['isActive'] = this.isActive;
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['dateOfCreation'] = this.dateOfCreation;
    data['__v'] = this.iV;
    data['profile'] = this.profile;
    data['userSubscription'] = this.userSubscription;
    return data;
  }
}