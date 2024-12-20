class TaskActivityModel {
  String? type;
  String? typename;
  String? typemsg;
  String? actihisycreatedbyname;
  String? hon;
  String? formateddate;

  TaskActivityModel(
      {this.type,
        this.typename,
        this.typemsg,
        this.actihisycreatedbyname,
        this.hon,
        this.formateddate});

  TaskActivityModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    typename = json['typename'];
    typemsg = json['typemsg'];
    actihisycreatedbyname = json['actihisycreatedbyname'];
    hon = json['hon'];
    formateddate = json['formateddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['typename'] = this.typename;
    data['typemsg'] = this.typemsg;
    data['actihisycreatedbyname'] = this.actihisycreatedbyname;
    data['hon'] = this.hon;
    data['formateddate'] = this.formateddate;
    return data;
  }
}
