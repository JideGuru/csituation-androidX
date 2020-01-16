class ListingModel {
  bool success;
  List<ListingData> data;

  ListingModel({this.success, this.data});

  ListingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<ListingData>();
      json['data'].forEach((v) {
        data.add(new ListingData.fromJson(v));
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

class ListingData {
  List<String> photos;
  String sId;
  String type;
  String address;
  String bedrooms;
  String bathrooms;
  String price;
  String size;
  String briefDescription;
  String availability;
  String dogFriendly;
  String catFriendly;
  String heatingType;
  String laundryType;
  String parkingType;
  String acType;
  String city;
  String state;
  String zip;
  String mainPhoto;
  Owner owner;
  String dateOfCreation;
  int iV;

  ListingData(
      {this.photos,
      this.sId,
      this.type,
      this.address,
      this.bedrooms,
      this.bathrooms,
      this.price,
      this.size,
      this.briefDescription,
      this.availability,
      this.dogFriendly,
      this.catFriendly,
      this.laundryType,
      this.heatingType,
      this.parkingType,
      this.acType,
      this.city,
      this.state,
      this.zip,
      this.mainPhoto,
      this.owner,
      this.dateOfCreation,
      this.iV});

  ListingData.fromJson(Map<String, dynamic> json) {
    photos = json['photos'].cast<String>();
    sId = json['_id'];
    type = json['type'];
    address = json['address'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    price = json['price'];
    size = json['size'];
    briefDescription = json['briefDescription'];
    availability = json['availability'];
    dogFriendly = json['dogFriendly'];
    catFriendly = json['catFriendly'];
    laundryType = json['laundryType'];
    heatingType = json['heatingType'];
    parkingType = json['parkingType'];
    acType = json['acType'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    mainPhoto = json['mainPhoto'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    dateOfCreation = json['dateOfCreation'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photos'] = this.photos;
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['address'] = this.address;
    data['bedrooms'] = this.bedrooms;
    data['bathrooms'] = this.bathrooms;
    data['price'] = this.price;
    data['size'] = this.size;
    data['briefDescription'] = this.briefDescription;
    data['availability'] = this.availability;
    data['dogFriendly'] = this.dogFriendly;
    data['catFriendly'] = this.catFriendly;
    data['heatingType'] = this.heatingType;
    data['laundryType'] = this.laundryType;
    data['parkingType'] = this.parkingType;
    data['acType'] = this.acType;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['mainPhoto'] = this.mainPhoto;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['dateOfCreation'] = this.dateOfCreation;
    data['__v'] = this.iV;
    return data;
  }
}

class Owner {
  bool isActive;
  String sId;
  String firstName;
  String lastName;
  String email;
  String birthday;
  String password;
  String dateOfCreation;
  int iV;

  Owner(
      {this.isActive,
      this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.birthday,
      this.password,
      this.dateOfCreation,
      this.iV});

  Owner.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    birthday = json['birthday'];
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
    data['birthday'] = this.birthday;
    data['password'] = this.password;
    data['dateOfCreation'] = this.dateOfCreation;
    data['__v'] = this.iV;
    return data;
  }
}
