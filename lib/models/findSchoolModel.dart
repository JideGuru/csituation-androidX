class FindSchoolModel {
  bool success;
  List<SchoolData> data;

  FindSchoolModel({this.success, this.data});

  FindSchoolModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<SchoolData>();
      json['data'].forEach((v) {
        data.add(new SchoolData.fromJson(v));
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

class SchoolData {
   bool isActive;
  String sId;
  String name;
  String desc;
  String population;
  String avgTuitionInternational;
  String avgTuitionLocal;
  String website;
  String address;
  String state;
  String city;
  String zip;
  String graduationRate;
  String acceptanceRate;
  String generalPhone;
  String intlAdmissionPhone;
  String photo;
  String courses;
  String scholarships;
  String category;
  String avgSAT;
  String avgACT;
  String applicationFee;
  String type;
  String email;
  String aboutLocation;
  String admissions;
  String academics;
  String fastFacts;
  String dateOfCreation;
  int iV;

  SchoolData(
      {this.isActive,
      this.sId,
      this.name,
      this.desc,
      this.population,
      this.avgTuitionInternational,
      this.avgTuitionLocal,
      this.website,
      this.address,
      this.state,
      this.city,
      this.zip,
      this.graduationRate,
      this.acceptanceRate,
      this.generalPhone,
      this.intlAdmissionPhone,
      this.photo,
      this.courses,
      this.scholarships,
      this.category,
      this.avgSAT,
      this.avgACT,
      this.applicationFee,
      this.type,
      this.email,
      this.aboutLocation,
      this.admissions,
      this.academics,
      this.fastFacts,
      this.dateOfCreation,
      this.iV});

  SchoolData.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    sId = json['_id'];
    name = json['name'];
    desc = json['desc'];
    population = json['population'];
    avgTuitionInternational = json['avgTuitionInternational'];
    avgTuitionLocal = json['avgTuitionLocal'];
    website = json['website'];
    address = json['address'];
    state = json['state'];
    city = json['city'];
    zip = json['zip'];
    graduationRate = json['graduationRate'];
    acceptanceRate = json['acceptanceRate'];
    generalPhone = json['generalPhone'];
    intlAdmissionPhone = json['intlAdmissionPhone'];
    photo = json['photo'];
    courses = json['courses'];
    scholarships = json['scholarships'];
    category = json['category'];
    avgSAT = json['avgSAT'];
    avgACT = json['avgACT'];
    type = json['type'];
    email = json['email'];
    applicationFee = json['applicationFee'];
    aboutLocation = json['aboutLocation'];
    admissions = json['admissions'];
    academics = json['academics'];
    fastFacts = json['fastFacts'];
    dateOfCreation = json['dateOfCreation'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isActive'] = this.isActive;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['population'] = this.population;
    data['avgTuitionInternational'] = this.avgTuitionInternational;
    data['avgTuitionLocal'] = this.avgTuitionLocal;
    data['website'] = this.website;
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['zip'] = this.zip;
    data['graduationRate'] = this.graduationRate;
    data['acceptanceRate'] = this.acceptanceRate;
    data['generalPhone'] = this.generalPhone;
    data['intlAdmissionPhone'] = this.intlAdmissionPhone;
    data['photo'] = this.photo;
    data['courses'] = this.courses;
    data['scholarships'] = this.scholarships;
    data['category'] = this.category;
    data['avgSAT'] = this.avgSAT;
    data['applicationFee'] = this.applicationFee;
    data['avgACT'] = this.avgACT;
    data['type'] = this.type;
    data['email'] = this.email;
    data['aboutLocation'] = this.aboutLocation;
    data['admissions'] = this.admissions;
    data['academics'] = this.academics;
    data['fastFacts'] = this.fastFacts;
    data['dateOfCreation'] = this.dateOfCreation;
    data['__v'] = this.iV;
    return data;

  }
}
