class CustomerDetail {
  final String id;
  final String ctitle;
  final String code;
  final String name;
  final String displayName;
  final String adD1;
  final String adD2;
  final String add3;
  final String? category;
  final String fax;
  final String state;
  final String? stateCode;
  final String city;
  final String area;
  final String stateID;
  final String cityID;
  final String areaID;
  final String mobile;
  final String whatsapp;
  final String phone;
  final String email;
  final String website;
  final String custType;
  final String pin;
  final String cdays;
  final String cLimit;
  final String sman;
  final String discount;
  final String registationType;
  final String partyType;
  final String gstno;
  final String vatNo;
  final String othertax;
  final String contact;
  final String transport;
  final String status;
  final String remarK1;
  final String remarK2;
  final String remarK3;
  final String remarK4;
  final String bank;
  final String ccemail;
  final String dob;
  final String doa;
  final String active;
  final String cstNo;
  final String adhno;
  final String currencyName;
  final String currencySign;
  final String? address;
  final String? createdBy;
  final String createdOn;
  final String? modifiedBy;
  final String bankId;
  final String transportId;
  final String smanId;
  final String ledgerid;
  final String vendorcode;
  final String? autocode;
  final String isprospect;
  final String approvalStatus;
  final String approvedOn;
  final String isApproved;
  final String approvalRemark;
  final String username;
  final String? customerPending;
  final String? customerHold;
  final String? customerDisapprove;
  final String tcsRate;
  final String? state_Code;
  final String? state_Name;
  final String? state_ImpCode;
  final String? isDuplicateUpdated;
  final String freight;

  CustomerDetail({
    required this.id,
    required this.ctitle,
    required this.code,
    required this.name,
    required this.displayName,
    required this.adD1,
    required this.adD2,
    required this.add3,
    this.category,
    required this.fax,
    required this.state,
    this.stateCode,
    required this.city,
    required this.area,
    required this.stateID,
    required this.cityID,
    required this.areaID,
    required this.mobile,
    required this.whatsapp,
    required this.phone,
    required this.email,
    required this.website,
    required this.custType,
    required this.pin,
    required this.cdays,
    required this.cLimit,
    required this.sman,
    required this.discount,
    required this.registationType,
    required this.partyType,
    required this.gstno,
    required this.vatNo,
    required this.othertax,
    required this.contact,
    required this.transport,
    required this.status,
    required this.remarK1,
    required this.remarK2,
    required this.remarK3,
    required this.remarK4,
    required this.bank,
    required this.ccemail,
    required this.dob,
    required this.doa,
    required this.active,
    required this.cstNo,
    required this.adhno,
    required this.currencyName,
    required this.currencySign,
    this.address,
    this.createdBy,
    required this.createdOn,
    this.modifiedBy,
    required this.bankId,
    required this.transportId,
    required this.smanId,
    required this.ledgerid,
    required this.vendorcode,
    this.autocode,
    required this.isprospect,
    required this.approvalStatus,
    required this.approvedOn,
    required this.isApproved,
    required this.approvalRemark,
    required this.username,
    this.customerPending,
    this.customerHold,
    this.customerDisapprove,
    required this.tcsRate,
    this.state_Code,
    this.state_Name,
    this.state_ImpCode,
    this.isDuplicateUpdated,
    required this.freight,
  });

  // Factory constructor to parse JSON
  factory CustomerDetail.fromJson(Map<String, dynamic> json) {
    return CustomerDetail(
      id: json['id'] ?? '',
      ctitle: json['ctitle'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      displayName: json['displayname'] ?? '',
      adD1: json['adD1'] ?? '',
      adD2: json['adD2'] ?? '',
      add3: json['add3'] ?? '',
      category: json['category'],
      fax: json['fax'] ?? '',
      state: json['state'] ?? '',
      stateCode: json['stateCode'],
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      stateID: json['stateID'] ?? '',
      cityID: json['cityID'] ?? '',
      areaID: json['areaID'] ?? '',
      mobile: json['mobile'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      custType: json['custType'] ?? '',
      pin: json['pin'] ?? '',
      cdays: json['cdays'] ?? '',
      cLimit: json['cLimit'] ?? '',
      sman: json['sman'] ?? '',
      discount: json['discount'] ?? '',
      registationType: json['registationType'] ?? '',
      partyType: json['partyType'] ?? '',
      gstno: json['gstno'] ?? '',
      vatNo: json['vatNo'] ?? '',
      othertax: json['othertax'] ?? '',
      contact: json['contact'] ?? '',
      transport: json['transport'] ?? '',
      status: json['status'] ?? '',
      remarK1: json['remarK1'] ?? '',
      remarK2: json['remarK2'] ?? '',
      remarK3: json['remarK3'] ?? '',
      remarK4: json['remarK4'] ?? '',
      bank: json['bank'] ?? '',
      ccemail: json['ccemail'] ?? '',
      dob: json['dob'] ?? '',
      doa: json['doa'] ?? '',
      active: json['active'] ?? '',
      cstNo: json['cstNo'] ?? '',
      adhno: json['adhno'] ?? '',
      currencyName: json['currencyName'] ?? '',
      currencySign: json['currencySign'] ?? '',
      address: json['address'],
      createdBy: json['createdBy'],
      createdOn: json['createdon'] ?? '',
      modifiedBy: json['modifiedBy'],
      bankId: json['bankId'] ?? '',
      transportId: json['transportId'] ?? '',
      smanId: json['smanId'] ?? '',
      ledgerid: json['ledgerid'] ?? '',
      vendorcode: json['vendorcode'] ?? '',
      autocode: json['autocode'],
      isprospect: json['isprospect'] ?? '',
      approvalStatus: json['approvalstatus'] ?? '',
      approvedOn: json['approvedon'] ?? '',
      isApproved: json['isapproved'] ?? '',
      approvalRemark: json['approvalremark'] ?? '',
      username: json['username'] ?? '',
      customerPending: json['customerpending'],
      customerHold: json['customeryhold'],
      customerDisapprove: json['customerdisapprove'],
      tcsRate: json['tcsrate'] ?? '',
      state_Code: json['state_Code'],
      state_Name: json['state_Name'],
      state_ImpCode: json['state_ImpCode'],
      isDuplicateUpdated: json['isduplicateupdated'],
      freight: json['freight'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "city": city,
    };
  }
}
