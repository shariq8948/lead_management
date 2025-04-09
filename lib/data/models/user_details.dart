import 'dart:convert';

class UserDetailsModel {
  String? title;
  String? firstName;
  String? lastName;
  String? username;
  String? userId;
  String? mobile;
  String? mobile2;
  String? imeino;
  String? macid;
  String? deviceid;
  String? activateddate;
  String? vdate;
  String? lastseen;
  String? appstatus;
  String? id;
  String? login;
  String? password;
  String? isActive;
  String? email;
  String? isDeleted;
  String? deletedBy;
  String? deletedOn;
  String? joiningDate;
  String? dob;
  String? address;
  String? userType;
  String? usertypename;
  String? dlayout;
  String? imagePath;
  String? excutiveId;
  String? oldPassword;
  String? accessByOrganizer;
  String? stateID;
  String? state;
  String? cityID;
  String? city;
  String? isapproved;
  String? sysbranchid;
  String? syscompanyid;
  String? usercode;
  String? userTypeid;
  String? companyName;

  UserDetailsModel({
    this.title,
    this.firstName,
    this.lastName,
    this.username,
    this.userId,
    this.mobile,
    this.mobile2,
    this.imeino,
    this.macid,
    this.deviceid,
    this.activateddate,
    this.vdate,
    this.lastseen,
    this.appstatus,
    this.id,
    this.login,
    this.password,
    this.isActive,
    this.email,
    this.isDeleted,
    this.deletedBy,
    this.deletedOn,
    this.joiningDate,
    this.dob,
    this.address,
    this.userType,
    this.usertypename,
    this.dlayout,
    this.imagePath,
    this.excutiveId,
    this.oldPassword,
    this.accessByOrganizer,
    this.stateID,
    this.state,
    this.cityID,
    this.city,
    this.isapproved,
    this.sysbranchid,
    this.syscompanyid,
    this.usercode,
    this.userTypeid,
    this.companyName,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        title: json["title"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        username: json["username"],
        userId: json["userId"],
        mobile: json["mobile"],
        mobile2: json["mobile2"],
        imeino: json["imeino"],
        macid: json["macid"],
        deviceid: json["deviceid"],
        activateddate: json["activateddate"],
        vdate: json["vdate"],
        lastseen: json["lastseen"],
        appstatus: json["appstatus"],
        id: json["id"],
        login: json["login"],
        password: json["password"],
        isActive: json["isActive"],
        email: json["email"],
        isDeleted: json["isDeleted"],
        deletedBy: json["deletedBy"],
        deletedOn: json["deletedOn"],
        joiningDate: json["joiningDate"],
        dob: json["dob"],
        address: json["address"],
        userType: json["userType"],
        usertypename: json["usertypename"],
        dlayout: json["dlayout"],
        imagePath: json["imagePath"],
        excutiveId: json["excutiveId"],
        oldPassword: json["oldPassword"],
        accessByOrganizer: json["accessByOrganizer"],
        stateID: json["stateID"],
        state: json["state"],
        cityID: json["cityID"],
        city: json["city"],
        isapproved: json["isapproved"],
        sysbranchid: json["sysbranchid"],
        syscompanyid: json["syscompanyid"],
        usercode: json["usercode"],
        userTypeid: json["userTypeid"],
        companyName: json["companyName"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "userId": userId,
        "mobile": mobile,
        "mobile2": mobile2,
        "imeino": imeino,
        "macid": macid,
        "deviceid": deviceid,
        "activateddate": activateddate,
        "vdate": vdate,
        "lastseen": lastseen,
        "appstatus": appstatus,
        "id": id,
        "login": login,
        "password": password,
        "isActive": isActive,
        "email": email,
        "isDeleted": isDeleted,
        "deletedBy": deletedBy,
        "deletedOn": deletedOn,
        "joiningDate": joiningDate,
        "dob": dob,
        "address": address,
        "userType": userType,
        "usertypename": usertypename,
        "dlayout": dlayout,
        "imagePath": imagePath,
        "excutiveId": excutiveId,
        "oldPassword": oldPassword,
        "accessByOrganizer": accessByOrganizer,
        "stateID": stateID,
        "state": state,
        "cityID": cityID,
        "city": city,
        "isapproved": isapproved,
        "sysbranchid": sysbranchid,
        "syscompanyid": syscompanyid,
        "usercode": usercode,
        "userTypeid": userTypeid,
        "companyName": companyName,
      };
}

// Function to parse JSON list into List<UserModel>
List<UserDetailsModel> userModelFromJson(String str) =>
    List<UserDetailsModel>.from(
        json.decode(str).map((x) => UserDetailsModel.fromJson(x)));

// Function to convert List<UserModel> into JSON string
String userModelToJson(List<UserDetailsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
