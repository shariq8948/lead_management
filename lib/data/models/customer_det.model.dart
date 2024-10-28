class CustomerDetModel {
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

  CustomerDetModel(
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

  CustomerDetModel.fromJson(Map<String, dynamic> json) {
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
