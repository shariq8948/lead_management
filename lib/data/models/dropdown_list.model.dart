class DropdownListModel {
  String? id;
  String? name;
  String? mobileNo;
  String? jobCount;
  String? totalunseenforZerojob;

  DropdownListModel(
      {this.id,
      this.name,
      this.mobileNo,
      this.jobCount,
      this.totalunseenforZerojob});

  DropdownListModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    mobileNo = json['MobileNo'];
    jobCount = json['JobCount'];
    totalunseenforZerojob = json['TotalunseenforZerojob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['MobileNo'] = mobileNo;
    data['JobCount'] = jobCount;
    data['TotalunseenforZerojob'] = totalunseenforZerojob;
    return data;
  }
}

class CustomerResponseModel {
  final String id;
  final String title;
  final String code;
  final String? name;
  final String displayName;
  final String? address1;
  final String address2;
  final String address3;
  final String category;
  final String fax;
  final String state;
  final String stateCode;
  final String city;
  final String area;
  final String stateId;
  final String cityId;
  final String areaId;
  final String mobile;
  final String whatsapp;
  final String phone;
  final String? email;
  final String website;
  final String customerType;
  final String pin;
  final String cDays;
  final String cLimit;
  final String sman;
  final String discount;
  final String registrationType;
  final String partyType;
  final String gstNo;
  final String vatNo;
  final String otherTax;
  final String contact;
  final String transport;
  final String status;
  final String remark1;
  final String remark2;
  final String remark3;
  final String remark4;
  final String bank;
  final String ccEmail;
  final String dob;
  final String doa;
  final String active;
  final String cstNo;
  final String adhNo;
  final String currencyName;
  final String currencySign;
  final String createdBy;
  final String createdOn;
  final String modifiedBy;
  final String bankId;
  final String transportId;
  final String smanId;
  final String ledgerId;
  final String vendorCode;
  final String autoCode;
  final String isProspect;
  final String approvalStatus;
  final String approvedOn;
  final String isApproved;
  final String approvalRemark;
  final String username;
  final String customerPending;
  final String customerHold;
  final String customerDisapprove;
  final String tcsRate;
  final String stateName;
  final String stateImpCode;
  final String isDuplicateUpdated;
  final String freight;

  CustomerResponseModel({
    required this.id,
    required this.title,
    required this.code,
    required this.name,
    required this.displayName,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.category,
    required this.fax,
    required this.state,
    required this.stateCode,
    required this.city,
    required this.area,
    required this.stateId,
    required this.cityId,
    required this.areaId,
    required this.mobile,
    required this.whatsapp,
    required this.phone,
    required this.email,
    required this.website,
    required this.customerType,
    required this.pin,
    required this.cDays,
    required this.cLimit,
    required this.sman,
    required this.discount,
    required this.registrationType,
    required this.partyType,
    required this.gstNo,
    required this.vatNo,
    required this.otherTax,
    required this.contact,
    required this.transport,
    required this.status,
    required this.remark1,
    required this.remark2,
    required this.remark3,
    required this.remark4,
    required this.bank,
    required this.ccEmail,
    required this.dob,
    required this.doa,
    required this.active,
    required this.cstNo,
    required this.adhNo,
    required this.currencyName,
    required this.currencySign,
    required this.createdBy,
    required this.createdOn,
    required this.modifiedBy,
    required this.bankId,
    required this.transportId,
    required this.smanId,
    required this.ledgerId,
    required this.vendorCode,
    required this.autoCode,
    required this.isProspect,
    required this.approvalStatus,
    required this.approvedOn,
    required this.isApproved,
    required this.approvalRemark,
    required this.username,
    required this.customerPending,
    required this.customerHold,
    required this.customerDisapprove,
    required this.tcsRate,
    required this.stateName,
    required this.stateImpCode,
    required this.isDuplicateUpdated,
    required this.freight,
  });

  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerResponseModel(
      id: json['ID'] ?? '',
      title: json['CTITLE'] ?? '',
      code: json['CODE'] ?? '',
      name: json['name'] ?? '',
      displayName: json['Displayname'] ?? '',
      address1: json['ADD1'] ?? '',
      address2: json['ADD2'] ?? '',
      address3: json['Add3'] ?? '',
      category: json['CATEGORY'] ?? '',
      fax: json['FAX'] ?? '',
      state: json['State'] ?? '',
      stateCode: json['StateCode'] ?? '',
      city: json['City'] ?? '',
      area: json['Area'] ?? '',
      stateId: json['StateID'] ?? '',
      cityId: json['CityID'] ?? '',
      areaId: json['AreaID'] ?? '',
      mobile: json['MOBILE'] ?? '',
      whatsapp: json['Whatsapp'] ?? '',
      phone: json['PHONE'] ?? '',
      email: json['EMAIL'] ?? '',
      website: json['Website'] ?? '',
      customerType: json['CustType'] ?? '',
      pin: json['Pin'] ?? '',
      cDays: json['CDAYS'] ?? '',
      cLimit: json['CLimit'] ?? '',
      sman: json['SMAN'] ?? '',
      discount: json['DISCOUNT'] ?? '',
      registrationType: json['RegistationType'] ?? '',
      partyType: json['PartyType'] ?? '',
      gstNo: json['Gstno'] ?? '',
      vatNo: json['VatNo'] ?? '',
      otherTax: json['OTHERTAX'] ?? '',
      contact: json['Contact'] ?? '',
      transport: json['Transport'] ?? '',
      status: json['STATUS'] ?? '',
      remark1: json['REMARK1'] ?? '',
      remark2: json['REMARK2'] ?? '',
      remark3: json['REMARK3'] ?? '',
      remark4: json['REMARK4'] ?? '',
      bank: json['BANK'] ?? '',
      ccEmail: json['CCEMAIL'] ?? '',
      dob: json['DOB'] ?? '',
      doa: json['DOA'] ?? '',
      active: json['Active'] ?? '',
      cstNo: json['CstNo'] ?? '',
      adhNo: json['ADHNO'] ?? '',
      currencyName: json['CurrencyName'] ?? '',
      currencySign: json['CurrencySign'] ?? '',
      createdBy: json['CreatedBy'] ?? '',
      createdOn: json['Createdon'] ?? '',
      modifiedBy: json['ModifiedBy'] ?? '',
      bankId: json['BankId'] ?? '',
      transportId: json['TransportId'] ?? '',
      smanId: json['SmanId'] ?? '',
      ledgerId: json['Ledgerid'] ?? '',
      vendorCode: json['Vendorcode'] ?? '',
      autoCode: json['Autocode'] ?? '',
      isProspect: json['Isprospect'] ?? '',
      approvalStatus: json['Approvalstatus'] ?? '',
      approvedOn: json['Approvedon'] ?? '',
      isApproved: json['Isapproved'] ?? '',
      approvalRemark: json['Approvalremark'] ?? '',
      username: json['Username'] ?? '',
      customerPending: json['Customerpending'] ?? '',
      customerHold: json['Customeryhold'] ?? '',
      customerDisapprove: json['Customerdisapprove'] ?? '',
      tcsRate: json['Tcsrate'] ?? '',
      stateName: json['State_Name'] ?? '',
      stateImpCode: json['State_ImpCode'] ?? '',
      isDuplicateUpdated: json['Isduplicateupdated'] ?? '',
      freight: json['Freight'] ?? '',
    );
  }
}

class DomainListModel {
  String? domainUrl;
  String? companyName;

  DomainListModel({this.domainUrl, this.companyName});

  DomainListModel.fromJson(Map<String, dynamic> json) {
    domainUrl = json['DomainUrl'];
    companyName = json['CompanyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DomainUrl'] = domainUrl;
    data['CompanyName'] = companyName;
    return data;
  }
}

class ProductListDropDown {
  String? productId;
  String? productName;
  String? productCode;

  ProductListDropDown({this.productName, this.productCode, this.productId});

  ProductListDropDown.fromJson(Map<String, dynamic> json) {
    productName = json['iname'] ?? ""; // Default to an empty string if null
    productCode = json['icode'] ?? "";
    productId = json['id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'icode': productCode ?? "", // Ensure no null values in the output
      'iname': productName ?? "",
      'id': productId ?? "",
    };
  }
}

class LeadSourceDropdownList {
  String? id;
  String? name;

  LeadSourceDropdownList({this.id, this.name});

  LeadSourceDropdownList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ownerDropdownList {
  String? id;
  String? name;

  ownerDropdownList({this.id, this.name});

  ownerDropdownList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class IndustryListDropdown {
  String? id;
  String? name;

  IndustryListDropdown({this.id, this.name});

  IndustryListDropdown.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class StateListDropdown {
  String? id;
  String? state;
  String? userId;
  String? statecode;

  StateListDropdown({this.id, this.state, this.userId, this.statecode});

  StateListDropdown.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    userId = json['userId'];
    statecode = json['statecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    data['userId'] = this.userId;
    data['statecode'] = this.statecode;
    return data;
  }
}

class cityListDropDown {
  String? city;
  String? cityID;

  cityListDropDown({this.city, this.cityID});

  cityListDropDown.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    cityID = json['cityID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['cityID'] = this.cityID;
    return data;
  }
}

class areaListDropDown {
  String? area;
  String? areaID;

  areaListDropDown({this.area, this.areaID});

  areaListDropDown.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    areaID = json['areaID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['areaID'] = this.areaID;
    return data;
  }
}
