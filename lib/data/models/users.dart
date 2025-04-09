class User {
  final String title;
  final String firstName;
  final String lastName;
  final String username;
  final String? userId;
  final String mobile;
  final String mobile2;
  final String? imeiNo;
  final String? macId;
  final String? deviceId;
  final String? activatedDate;
  final String? vDate;
  final String? lastSeen;
  final String? appStatus;
  final String id;
  final String login;
  final String password;
  final String isActive;
  final String email;
  final String? isDeleted;
  final String? deletedBy;
  final String? deletedOn;
  final String joiningDate;
  final String dob;
  final String address;
  final String userType;
  final String userTypeName;
  final String? dLayout;
  final String? imagePath;
  final String? executiveId;
  final String? oldPassword;
  final String? accessByOrganizer;
  final String stateID;
  final String? state;
  final String cityID;
  final String? city;
  final String? isApproved;
  final String? sysBranchId;
  final String? sysCompanyId;
  final String userCode;
  final String userTypeId;
  final String? companyName;

  User({
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.userId,
    required this.mobile,
    required this.mobile2,
    this.imeiNo,
    this.macId,
    this.deviceId,
    this.activatedDate,
    this.vDate,
    this.lastSeen,
    this.appStatus,
    required this.id,
    required this.login,
    required this.password,
    required this.isActive,
    required this.email,
    this.isDeleted,
    this.deletedBy,
    this.deletedOn,
    required this.joiningDate,
    required this.dob,
    required this.address,
    required this.userType,
    required this.userTypeName,
    this.dLayout,
    this.imagePath,
    this.executiveId,
    this.oldPassword,
    this.accessByOrganizer,
    required this.stateID,
    this.state,
    required this.cityID,
    this.city,
    this.isApproved,
    this.sysBranchId,
    this.sysCompanyId,
    required this.userCode,
    required this.userTypeId,
    this.companyName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      title: json['title'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      username: json['username'] as String,
      userId: json['userId'] as String?,
      mobile: json['mobile'] as String,
      mobile2: json['mobile2'] as String,
      imeiNo: json['imeino'] as String?,
      macId: json['macid'] as String?,
      deviceId: json['deviceid'] as String?,
      activatedDate: json['activateddate'] as String?,
      vDate: json['vdate'] as String?,
      lastSeen: json['lastseen'] as String?,
      appStatus: json['appstatus'] as String?,
      id: json['id'] as String,
      login: json['login'] as String,
      password: json['password'] as String,
      isActive: json['isActive'] as String,
      email: json['email'] as String,
      isDeleted: json['isDeleted'] as String?,
      deletedBy: json['deletedBy'] as String?,
      deletedOn: json['deletedOn'] as String?,
      joiningDate: json['joiningDate'] as String,
      dob: json['dob'] as String,
      address: json['address'] as String,
      userType: json['userType'] as String,
      userTypeName: json['usertypename'] as String,
      dLayout: json['dlayout'] as String?,
      imagePath: json['imagePath'] as String?,
      executiveId: json['excutiveId'] as String?,
      oldPassword: json['oldPassword'] as String?,
      accessByOrganizer: json['accessByOrganizer'] as String?,
      stateID: json['stateID'] as String,
      state: json['state'] as String?,
      cityID: json['cityID'] as String,
      city: json['city'] as String?,
      isApproved: json['isapproved'] as String?,
      sysBranchId: json['sysbranchid'] as String?,
      sysCompanyId: json['syscompanyid'] as String?,
      userCode: json['usercode'] as String,
      userTypeId: json['userTypeid'] as String,
      companyName: json['companyName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'userId': userId,
      'mobile': mobile,
      'mobile2': mobile2,
      'imeino': imeiNo,
      'macid': macId,
      'deviceid': deviceId,
      'activateddate': activatedDate,
      'vdate': vDate,
      'lastseen': lastSeen,
      'appstatus': appStatus,
      'id': id,
      'login': login,
      'password': password,
      'isActive': isActive,
      'email': email,
      'isDeleted': isDeleted,
      'deletedBy': deletedBy,
      'deletedOn': deletedOn,
      'joiningDate': joiningDate,
      'dob': dob,
      'address': address,
      'userType': userType,
      'usertypename': userTypeName,
      'dlayout': dLayout,
      'imagePath': imagePath,
      'excutiveId': executiveId,
      'oldPassword': oldPassword,
      'accessByOrganizer': accessByOrganizer,
      'stateID': stateID,
      'state': state,
      'cityID': cityID,
      'city': city,
      'isapproved': isApproved,
      'sysbranchid': sysBranchId,
      'syscompanyid': sysCompanyId,
      'usercode': userCode,
      'userTypeid': userTypeId,
      'companyName': companyName,
    };
  }

  static List<User> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => User.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<User> users) {
    return users.map((user) => user.toJson()).toList();
  }
}
