class LoginResponse {
  String? franchiseId;
  String? branchId;
  String? branchName;
  String? name;
  String? mobile;
  String? userType;
  String? userId;
  String? dLayout;
  String? joiningMonth;
  String? joiningYear;
  String? login;
  String? password;
  String? userTypeName;
  String? imagepath;
  String? designerCast;
  String? message;

  LoginResponse({
    this.franchiseId,
    this.branchId,
    this.branchName,
    this.name,
    this.mobile,
    this.userType,
    this.userId,
    this.dLayout,
    this.joiningMonth,
    this.joiningYear,
    this.login,
    this.password,
    this.userTypeName,
    this.imagepath,
    this.designerCast,
    this.message,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    franchiseId = json['FranchiseId'];
    branchId = json['BranchId'];
    branchName = json['BranchName'];
    name = json['Name'];
    mobile = json['Mobile'];
    userType = json['UserType'];
    userId = json['UserId'];
    dLayout = json['DLayout'];
    joiningMonth = json['JoiningMonth'];
    joiningYear = json['JoiningYear'];
    login = json['Login'];
    password = json['Password'];
    userTypeName = json['UserTypeName'];
    imagepath = json['Imagepath'];
    designerCast = json['DesignerCast'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FranchiseId'] = franchiseId;
    data['BranchId'] = branchId;
    data['BranchName'] = branchName;
    data['Name'] = name;
    data['Mobile'] = mobile;
    data['UserType'] = userType;
    data['UserId'] = userId;
    data['DLayout'] = dLayout;
    data['JoiningMonth'] = joiningMonth;
    data['JoiningYear'] = joiningYear;
    data['Login'] = login;
    data['Password'] = password;
    data['UserTypeName'] = userTypeName;
    data['Imagepath'] = imagepath;
    data['DesignerCast'] = designerCast;
    return data;
  }

  LoginResponse copyWith({
    String? franchiseId,
    String? branchId,
    String? branchName,
    String? name,
    String? mobile,
    String? userType,
    String? userId,
    String? dLayout,
    String? joiningMonth,
    String? joiningYear,
    String? login,
    String? password,
    String? userTypeName,
    String? imagepath,
    String? designerCast,
    String? message,
  }) {
    return LoginResponse(
      franchiseId: franchiseId ?? this.franchiseId,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      userType: userType ?? this.userType,
      userId: userId ?? this.userId,
      dLayout: dLayout ?? this.dLayout,
      joiningMonth: joiningMonth ?? this.joiningMonth,
      joiningYear: joiningYear ?? this.joiningYear,
      login: login ?? this.login,
      password: password ?? this.password,
      userTypeName: userTypeName ?? this.userTypeName,
      imagepath: imagepath ?? this.imagepath,
      designerCast: designerCast ?? this.designerCast,
      message: message ?? this.message,
    );
  }
}
