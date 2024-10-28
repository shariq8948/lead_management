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

class JobServiceIngModel {
  String? serviceid;
  String? servicesIngredientId;
  String? remark;

  JobServiceIngModel({this.serviceid, this.servicesIngredientId, this.remark});

  JobServiceIngModel.fromJson(Map<String, dynamic> json) {
    serviceid = json['Serviceid'];
    servicesIngredientId = json['Services_ingredient_id'];
    remark = json['Remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Serviceid'] = serviceid;
    data['Services_ingredient_id'] = servicesIngredientId;
    data['Remark'] = remark ?? "";
    return data;
  }

  JobServiceIngModel copyWith({
    String? serviceid,
    String? servicesIngredientId,
    String? remark,
  }) {
    return JobServiceIngModel(
      serviceid: serviceid ?? this.serviceid,
      servicesIngredientId: servicesIngredientId ?? this.servicesIngredientId,
      remark: remark ?? this.remark,
    );
  }
}

class CustomerListModel {
  String? iD;
  String? gNameId;
  String? name;
  String? code;
  String? companyName;
  String? address;
  String? mobile;
  String? phoneNo;
  String? email;
  String? ledgerGroup;
  String? remarks;
  String? debitAmount;
  String? creditAmount;
  String? gSTNo;
  String? createdBy;
  String? modifiedBy;
  String? deletedBy;

  CustomerListModel(
      {this.iD,
      this.gNameId,
      this.name,
      this.code,
      this.companyName,
      this.address,
      this.mobile,
      this.phoneNo,
      this.email,
      this.ledgerGroup,
      this.remarks,
      this.debitAmount,
      this.creditAmount,
      this.gSTNo,
      this.createdBy,
      this.modifiedBy,
      this.deletedBy});

  CustomerListModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    gNameId = json['GNameId'];
    name = json['Name'];
    code = json['Code'];
    companyName = json['CompanyName'];
    address = json['Address'];
    mobile = json['Mobile'];
    phoneNo = json['PhoneNo'];
    email = json['Email'];
    ledgerGroup = json['LedgerGroup'];
    remarks = json['Remarks'];
    debitAmount = json['DebitAmount'];
    creditAmount = json['CreditAmount'];
    gSTNo = json['GSTNo'];
    createdBy = json['CreatedBy'];
    modifiedBy = json['ModifiedBy'];
    deletedBy = json['DeletedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['GNameId'] = gNameId;
    data['Name'] = name;
    data['Code'] = code;
    data['CompanyName'] = companyName;
    data['Address'] = address;
    data['Mobile'] = mobile;
    data['PhoneNo'] = phoneNo;
    data['Email'] = email;
    data['LedgerGroup'] = ledgerGroup;
    data['Remarks'] = remarks;
    data['DebitAmount'] = debitAmount;
    data['CreditAmount'] = creditAmount;
    data['GSTNo'] = gSTNo;
    data['CreatedBy'] = createdBy;
    data['ModifiedBy'] = modifiedBy;
    data['DeletedBy'] = deletedBy;
    return data;
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

class StorageLocationModel {
  String? storageLocationId;
  String? storageLocation;

  StorageLocationModel({this.storageLocationId, this.storageLocation});

  StorageLocationModel.fromJson(Map<String, dynamic> json) {
    storageLocationId = json['StorageLocationId'];
    storageLocation = json['StorageLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StorageLocationId'] = storageLocationId;
    data['StorageLocation'] = storageLocation;
    return data;
  }
}

class PaymentModeModel {
  String? paymentModeId;
  String? paymentMode;

  PaymentModeModel({this.paymentModeId, this.paymentMode});

  PaymentModeModel.fromJson(Map<String, dynamic> json) {
    paymentModeId = json['PaymentModeId'];
    paymentMode = json['PaymentMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PaymentModeId'] = paymentModeId;
    data['PaymentMode'] = paymentMode;
    return data;
  }
}
