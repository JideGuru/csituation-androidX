class PaymentPlansModel {
  bool success;
  List<PlanData> data;

  PaymentPlansModel({this.success, this.data});

  PaymentPlansModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<PlanData>();
      json['data'].forEach((v) {
        data.add(new PlanData.fromJson(v));
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

class PlanData {
  bool isActive;
  String sId;
  String name;
  int price;
  int duration;
  String tag;
  String desc;
  String validity;
  String dateOfCreation;
  int iV;

  PlanData(
      {this.isActive,
      this.sId,
      this.name,
      this.price,
      this.duration,
      this.tag,
      this.desc,
      this.validity,
      this.dateOfCreation,
      this.iV});

  PlanData.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    duration = json['duration'];
    tag = json['tag'];
    desc = json['desc'];
    validity = json['validity'];
    dateOfCreation = json['dateOfCreation'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isActive'] = this.isActive;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['tag'] = this.tag;
    data['desc'] = this.desc;
    data['validity'] = this.validity;
    data['dateOfCreation'] = this.dateOfCreation;
    data['__v'] = this.iV;
    return data;
  }
}

