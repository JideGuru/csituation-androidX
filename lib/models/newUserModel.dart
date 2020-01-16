class UserModel {
  bool auth;
  String token;
  User user;
  bool loggedIn;

  UserModel({this.auth, this.token, this.user, this.loggedIn});

  UserModel.fromJson(Map<String, dynamic> json) {
    auth = json['auth'];
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    loggedIn = json['loggedIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth'] = this.auth;
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['loggedIn'] = this.loggedIn;
    return data;
  }
}

class User {
  bool hasAppliedFreeSubscription;
  bool isActive;
  String sId;
  String firstName;
  String lastName;
  String email;
  String password;
  String dateOfCreation;
  int iV;
  Profile profile;
  UserSubscription userSubscription;

  User(
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

  User.fromJson(Map<String, dynamic> json) {
    hasAppliedFreeSubscription = json['hasAppliedFreeSubscription'];
    isActive = json['isActive'];
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    dateOfCreation = json['dateOfCreation'];
    iV = json['__v'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    userSubscription = json['userSubscription'] != null
        ? new UserSubscription.fromJson(json['userSubscription'])
        : null;
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
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    if (this.userSubscription != null) {
      data['userSubscription'] = this.userSubscription.toJson();
    }
    return data;
  }
}

class Profile {
  String sId;
  String authInfo;
  int iV;

  Profile({this.sId, this.authInfo, this.iV});

  Profile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    authInfo = json['authInfo'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['authInfo'] = this.authInfo;
    data['__v'] = this.iV;
    return data;
  }
}

class UserSubscription {
  bool isActive;
  String sId;
  String authInfo;
  String subscription;
  String startDate;
  String endDate;
  String dateOfCreation;
  int iV;

  UserSubscription(
      {this.isActive,
      this.sId,
      this.authInfo,
      this.subscription,
      this.startDate,
      this.endDate,
      this.dateOfCreation,
      this.iV});

  UserSubscription.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    sId = json['_id'];
    authInfo = json['authInfo'];
    subscription = json['subscription'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    dateOfCreation = json['dateOfCreation'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isActive'] = this.isActive;
    data['_id'] = this.sId;
    data['authInfo'] = this.authInfo;
    data['subscription'] = this.subscription;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['dateOfCreation'] = this.dateOfCreation;
    data['__v'] = this.iV;
    return data;
  }
}