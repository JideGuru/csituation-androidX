class User {
  bool isActive;
  String sId;
  String firstName;
  String lastName;
  String email;
  String password;
  String dateOfCreation;
  int iV;

  User(
      {this.isActive,
      this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.dateOfCreation,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    dateOfCreation = json['dateOfCreation'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isActive'] = this.isActive;
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['dateOfCreation'] = this.dateOfCreation;
    data['__wv'] = this.iV;
    return data;
  }
}