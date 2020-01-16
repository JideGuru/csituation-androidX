class ScholarshipModel {
  bool success;
  List<ScholarshipData> data;

  ScholarshipModel({this.success, this.data});

  ScholarshipModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<ScholarshipData>();
      json['data'].forEach((v) {
        data.add(new ScholarshipData.fromJson(v));
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

class ScholarshipData {
  String sId;
  String title;
  String photo;
  String dueDate;
  String amount;
  String state;
  String status;
  String educationalLevel;
  String description;
  String featured;
  String link;
  int iV;

  ScholarshipData(
      {this.sId,
      this.title,
      this.photo,
      this.dueDate,
      this.amount,
      this.state,
      this.status,
      this.educationalLevel,
      this.description,
      this.featured,
      this.link,
      this.iV});

  ScholarshipData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    photo = json['photo'];
    dueDate = json['dueDate'];
    amount = json['amount'];
    state = json['state'];
    status = json['status'];
    educationalLevel = json['educationalLevel'];
    description = json['description'];
    featured = json['featured'];
    link = json['link'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['photo'] = this.photo;
    data['dueDate'] = this.dueDate;
    data['amount'] = this.amount;
    data['state'] = this.state;
    data['status'] = this.status;
    data['educationalLevel'] = this.educationalLevel;
    data['description'] = this.description;
    data['featured'] = this.featured;
    data['link'] = this.link;
    data['__v'] = this.iV;
    return data;
  }
}