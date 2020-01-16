class AdviceModel {
  bool success;
  List<Data> data;

  AdviceModel({this.success, this.data});

  AdviceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String sId;
  String adviceBody;
  String dateOfCreation;
  int iV;

  Data({this.sId, this.adviceBody, this.dateOfCreation, this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    adviceBody = json['adviceBody'];
    dateOfCreation = json['dateOfCreation'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['adviceBody'] = this.adviceBody;
    data['dateOfCreation'] = this.dateOfCreation;
    data['__v'] = this.iV;
    return data;
  }
}