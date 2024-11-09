class LoginResponse {
  String? id;
  String? username;
  String? userType;
  String? login;
  String? userId;
  String? email;
  String? stateId;
  String? cityId;
  String? state;
  String? city;
  String? joiningMonth;
  String? joiningYear;
  String? success;
  String? message;
  String? tokenId;
  String? address;
  String? title;
  String? firstName;
  String? lastName;
  String? layoutId;
  String? newUserTypeColumn;

  LoginResponse({
    this.id,
    this.username,
    this.userType,
    this.login,
    this.userId,
    this.email,
    this.stateId,
    this.cityId,
    this.state,
    this.city,
    this.joiningMonth,
    this.joiningYear,
    this.success,
    this.message,
    this.tokenId,
    this.address,
    this.title,
    this.firstName,
    this.lastName,
    this.layoutId,
    this.newUserTypeColumn,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    userType = json['userType'];
    login = json['login'];
    userId = json['userId'];
    email = json['email'];
    stateId = json['stateid'];
    cityId = json['cityid'];
    state = json['state'];
    city = json['city'];
    joiningMonth = json['joiningMonth'];
    joiningYear = json['joiningYear'];
    success = json['success'];
    message = json['message'];
    tokenId = json['tokenid'];
    address = json['address'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    layoutId = json['layoutid'];
    newUserTypeColumn = json['newusertypecolumn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['userType'] = userType;
    data['login'] = login;
    data['userId'] = userId;
    data['email'] = email;
    data['stateid'] = stateId;
    data['cityid'] = cityId;
    data['state'] = state;
    data['city'] = city;
    data['joiningMonth'] = joiningMonth;
    data['joiningYear'] = joiningYear;
    data['success'] = success;
    data['message'] = message;
    data['tokenid'] = tokenId;
    data['address'] = address;
    data['title'] = title;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['layoutid'] = layoutId;
    data['newusertypecolumn'] = newUserTypeColumn;
    return data;
  }

  LoginResponse copyWith({
    String? id,
    String? username,
    String? userType,
    String? login,
    String? userId,
    String? email,
    String? stateId,
    String? cityId,
    String? state,
    String? city,
    String? joiningMonth,
    String? joiningYear,
    String? success,
    String? message,
    String? tokenId,
    String? address,
    String? title,
    String? firstName,
    String? lastName,
    String? layoutId,
    String? newUserTypeColumn,
  }) {
    return LoginResponse(
      id: id ?? this.id,
      username: username ?? this.username,
      userType: userType ?? this.userType,
      login: login ?? this.login,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      stateId: stateId ?? this.stateId,
      cityId: cityId ?? this.cityId,
      state: state ?? this.state,
      city: city ?? this.city,
      joiningMonth: joiningMonth ?? this.joiningMonth,
      joiningYear: joiningYear ?? this.joiningYear,
      success: success ?? this.success,
      message: message ?? this.message,
      tokenId: tokenId ?? this.tokenId,
      address: address ?? this.address,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      layoutId: layoutId ?? this.layoutId,
      newUserTypeColumn: newUserTypeColumn ?? this.newUserTypeColumn,
    );
  }
}
