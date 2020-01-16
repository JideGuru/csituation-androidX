class StoriesCatModel {
  bool success;
  List<StoryCatData> data;

  StoriesCatModel({this.success, this.data});

  StoriesCatModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<StoryCatData>();
      json['data'].forEach((v) {
        data.add(new StoryCatData.fromJson(v));
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

class StoryCatData {
  String sId;
  String name;
  String dateOfCreation;
  int iV;

  StoryCatData({this.sId, this.name, this.dateOfCreation, this.iV});

  StoryCatData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    dateOfCreation = json['dateOfCreation'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['dateOfCreation'] = this.dateOfCreation;
    data['__v'] = this.iV;
    return data;
  }
}

