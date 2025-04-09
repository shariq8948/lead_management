import 'dart:convert';

class LoginResponse {
  final String? id;
  final String? username;
  final String? userType;
  final String? login;
  final String? userId;
  final String? password;
  final String? email;
  final String? stateid;
  final String? cityid;
  final String? state;
  final String? city;
  final String? area;
  final String? joiningMonth;
  final String? joiningYear;
  final String? success;
  final String? message;
  final String? imagePath;
  final String? tokenid;
  final String? imeino;
  final String? syscompanyid;
  final String? sysbranchid;
  final String? crid;
  final String? dpid;
  final String? address;
  final String? title;
  final String? firstName;
  final String? lastName;
  final bool? isFirstLogin;
  final String? planname;
  final String? subscriptionEndDate;
  final String? subscriptionStartDate;
  final int? subscriptionPendingDays;
  final String? productLicenceKey;
  final String? companyname;
  final String? userlogo;
  final String? planid;
  final String? layoutid;
  final String? newUserTypeColumn;
  final String? createdBy;
  final String? customertype;
  final String? industry;
  final bool? isAdmin;
  final String? registrationType;
  final String? mobile;

  LoginResponse({
    this.id,
    this.username,
    this.userType,
    this.login,
    this.userId,
    this.password,
    this.email,
    this.stateid,
    this.cityid,
    this.state,
    this.city,
    this.area,
    this.joiningMonth,
    this.joiningYear,
    this.success,
    this.message,
    this.imagePath,
    this.tokenid,
    this.imeino,
    this.syscompanyid,
    this.sysbranchid,
    this.crid,
    this.dpid,
    this.address,
    this.title,
    this.firstName,
    this.lastName,
    this.isFirstLogin,
    this.planname,
    this.subscriptionEndDate,
    this.subscriptionStartDate,
    this.subscriptionPendingDays,
    this.productLicenceKey,
    this.companyname,
    this.userlogo,
    this.planid,
    this.layoutid,
    this.newUserTypeColumn,
    this.createdBy,
    this.customertype,
    this.industry,
    this.isAdmin,
    this.registrationType,
    this.mobile,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      username: json['username'],
      userType: json['userType'],
      login: json['login'],
      userId: json['userId'],
      password: json['password'],
      email: json['email'],
      stateid: json['stateid'],
      cityid: json['cityid'],
      state: json['state'],
      city: json['city'],
      area: json['area'],
      joiningMonth: json['joiningMonth'],
      joiningYear: json['joiningYear'],
      success: json['success'],
      message: json['message'],
      imagePath: json['imagePath'],
      tokenid: json['tokenid'],
      imeino: json['imeino'],
      syscompanyid: json['syscompanyid'],
      sysbranchid: json['sysbranchid'],
      crid: json['crid'],
      dpid: json['dpid'],
      address: json['address'],
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      isFirstLogin:
          json['isFirstLogin'] == null ? null : json['isFirstLogin'] == "true",
      planname: json['planname'],
      subscriptionEndDate: json['subscriptionenddate'],
      subscriptionStartDate: json['subscriptionstartdate'],
      subscriptionPendingDays: json['subscriptionpendingdays'],
      productLicenceKey: json['productlicencekey'],
      companyname: json['companyname'],
      userlogo: json['userlogo'],
      planid: json['planid'],
      layoutid: json['layoutid'],
      newUserTypeColumn: json['newusertypecolumn'],
      createdBy: json['createdby'],
      customertype: json['customertype'],
      industry: json['industry'],
      isAdmin: json['isadmin'] == null ? null : json['isadmin'] == "true",
      registrationType: json['registrationtype'],
      mobile: json['mobile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userType': userType,
      'login': login,
      'userId': userId,
      'password': password,
      'email': email,
      'stateid': stateid,
      'cityid': cityid,
      'state': state,
      'city': city,
      'area': area,
      'joiningMonth': joiningMonth,
      'joiningYear': joiningYear,
      'success': success,
      'message': message,
      'imagePath': imagePath,
      'tokenid': tokenid,
      'imeino': imeino,
      'syscompanyid': syscompanyid,
      'sysbranchid': sysbranchid,
      'crid': crid,
      'dpid': dpid,
      'address': address,
      'title': title,
      'firstName': firstName,
      'lastName': lastName,
      'isFirstLogin': isFirstLogin,
      'planname': planname,
      'subscriptionenddate': subscriptionEndDate,
      'subscriptionstartdate': subscriptionStartDate,
      'subscriptionpendingdays': subscriptionPendingDays,
      'productlicencekey': productLicenceKey,
      'companyname': companyname,
      'userlogo': userlogo,
      'planid': planid,
      'layoutid': layoutid,
      'newusertypecolumn': newUserTypeColumn,
      'createdby': createdBy,
      'customertype': customertype,
      'industry': industry,
      'isadmin': isAdmin,
      'registrationtype': registrationType,
      'mobile': mobile,
    };
  }

  static List<LoginResponse> fromJsonList(String jsonString) {
    final parsed = json.decode(jsonString) as List<dynamic>;
    return parsed.map((json) => LoginResponse.fromJson(json)).toList();
  }
}
