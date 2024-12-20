class LeadList {
  final String leadId;
  final String guid;
  final String leadSr;
  final String leadNo;
  final String leadStatusId;
  final String leadName;
  final String leadStatus;
  final String leadSourceId;
  final String leadSource;
  final String custProsId;
  final String custProsType;
  final String name;
  final String mobile;
  final String email;
  final String vdate;
  final String ownerId;
  final String assigntoId;
  final String createdBy;
  final String createdOn;
  final String modifiedOn;
  final String modifiedBy;
  final String stateID;
  final String cityID;
  final String areaID;
  final String state;
  final String city;
  final String area;
  final String address;
  final String gstno;
  final String pinCode;
  final String time;
  final String remark;
  final String whatsapp;
  final String isDeleted;
  final String deletedBy;
  final String deletedOn;
  final String dueDate;
  final String priority;
  final String reminder;
  final String reminderAlert;
  final String relatedTo;
  final String description;
  final String company;
  final String title;
  final String industryType;
  final String noOfEmployee;
  final String annualRevenue;
  final String rating;
  final String emailOptOut;
  final String skypeId;
  final String twitter;
  final String secondEmail;
  final String expectedDate;
  final String budget;
  final String longitude;
  final String latitude;
  final String priorityId;
  final String phone;
  final String nextFollowUp;
  final String dealSize;
  final String closingRemark;
  final String ownerName;
  final String assignToName;
  final String leadStatusLabel;
  final String comment;
  final String commentDate;
  final dynamic relatedPeople; // Adjusted to handle null or other types
  final dynamic relatedBillList; // Adjusted to handle null or other types

  LeadList({
    required this.leadId,
    required this.guid,
    required this.leadSr,
    required this.leadNo,
    required this.leadStatusId,
    required this.leadName,
    required this.leadStatus,
    required this.leadSourceId,
    required this.leadSource,
    required this.custProsId,
    required this.custProsType,
    required this.name,
    required this.mobile,
    required this.email,
    required this.vdate,
    required this.ownerId,
    required this.assigntoId,
    required this.createdBy,
    required this.createdOn,
    required this.modifiedOn,
    required this.modifiedBy,
    required this.stateID,
    required this.cityID,
    required this.areaID,
    required this.state,
    required this.city,
    required this.area,
    required this.address,
    required this.gstno,
    required this.pinCode,
    required this.time,
    required this.remark,
    required this.whatsapp,
    required this.isDeleted,
    required this.deletedBy,
    required this.deletedOn,
    required this.dueDate,
    required this.priority,
    required this.reminder,
    required this.reminderAlert,
    required this.relatedTo,
    required this.description,
    required this.company,
    required this.title,
    required this.industryType,
    required this.noOfEmployee,
    required this.annualRevenue,
    required this.rating,
    required this.emailOptOut,
    required this.skypeId,
    required this.twitter,
    required this.secondEmail,
    required this.expectedDate,
    required this.budget,
    required this.longitude,
    required this.latitude,
    required this.priorityId,
    required this.phone,
    required this.nextFollowUp,
    required this.dealSize,
    required this.closingRemark,
    required this.ownerName,
    required this.assignToName,
    required this.leadStatusLabel,
    required this.comment,
    required this.commentDate,
    this.relatedPeople,
    this.relatedBillList,
  });

  factory LeadList.fromJson(Map<String, dynamic> json) {
    return LeadList(
      leadId: json['leadid']?.toString() ?? '',
      guid: json['guid'] ?? '',
      leadSr: json['leadSr'] ?? '',
      leadNo: json['leadNo'] ?? '',
      leadStatusId: json['leadStatusId'] ?? '',
      leadName: json['leadName'] ?? '',
      leadStatus: json['leadStatus'] ?? '',
      leadSourceId: json['leadSourceId'] ?? '',
      leadSource: json['leadSource'] ?? '',
      custProsId: json['custProsId'] ?? '',
      custProsType: json['custProsType'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      vdate: json['vdate'] ?? '',
      ownerId: json['ownerId'] ?? '',
      assigntoId: json['assigntoId'] ?? '',
      createdBy: json['createdby'] ?? '',
      createdOn: json['createdOn'] ?? '',
      modifiedOn: json['modifiedOn'] ?? '',
      modifiedBy: json['modifiedBy'] ?? '',
      stateID: json['stateID'] ?? '',
      cityID: json['cityID'] ?? '',
      areaID: json['areaID'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      address: json['address'] ?? '',
      gstno: json['gstno'] ?? '',
      pinCode: json['pinCode'] ?? '',
      time: json['time'] ?? '',
      remark: json['remark'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      isDeleted: json['isdeleted'] ?? '',
      deletedBy: json['deletedby'] ?? '',
      deletedOn: json['deletedon'] ?? '',
      dueDate: json['dueDate'] ?? '',
      priority: json['priority'] ?? '',
      reminder: json['reminder'] ?? '',
      reminderAlert: json['reminderalert'] ?? '',
      relatedTo: json['relatedto'] ?? '',
      description: json['description'] ?? '',
      company: json['company'] ?? '',
      title: json['title'] ?? '',
      industryType: json['industrytype'] ?? '',
      noOfEmployee: json['noofemployee'] ?? '',
      annualRevenue: json['annualrevenue'] ?? '',
      rating: json['rating'] ?? '',
      emailOptOut: json['emailoptout'] ?? '',
      skypeId: json['skypeid'] ?? '',
      twitter: json['twitter'] ?? '',
      secondEmail: json['secondemail'] ?? '',
      expectedDate: json['expecteddate'] ?? '',
      budget: json['budget'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      priorityId: json['priorityid'] ?? '',
      phone: json['phone']?.toString() ?? '',
      nextFollowUp: json['nextfollowup'] ?? '',
      dealSize: json['dealSize']?.toString() ?? '',
      closingRemark: json['closingRemark'] ?? '',
      ownerName: json['ownerName'] ?? '',
      assignToName: json['assignToName'] ?? '',
      leadStatusLabel: json['leadStatusLabel'] ?? '',
      comment: json['comment'] ?? '',
      commentDate: json['commentDate'] ?? '',
      relatedPeople: json['relatedPeople'], // Keep as is for dynamic types
      relatedBillList: json['relatedBillList'], // Keep as is for dynamic types
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leadId': leadId,
      'guid': guid,
      'leadSr': leadSr,
      'leadNo': leadNo,
      'leadStatusId': leadStatusId,
      'leadName': leadName,
      'leadStatus': leadStatus,
      'leadSourceId': leadSourceId,
      'leadSource': leadSource,
      'custProsId': custProsId,
      'custProsType': custProsType,
      'name': name,
      'mobile': mobile,
      'email': email,
      'vdate': vdate,
      'ownerId': ownerId,
      'assigntoId': assigntoId,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'modifiedOn': modifiedOn,
      'modifiedBy': modifiedBy,
      'stateID': stateID,
      'cityID': cityID,
      'areaID': areaID,
      'state': state,
      'city': city,
      'area': area,
      'address': address,
      'gstno': gstno,
      'pinCode': pinCode,
      'time': time,
      'remark': remark,
      'whatsapp': whatsapp,
      'isDeleted': isDeleted,
      'deletedBy': deletedBy,
      'deletedOn': deletedOn,
      'dueDate': dueDate,
      'priority': priority,
      'reminder': reminder,
      'reminderAlert': reminderAlert,
      'relatedTo': relatedTo,
      'description': description,
      'company': company,
      'title': title,
      'industryType': industryType,
      'noOfEmployee': noOfEmployee,
      'annualRevenue': annualRevenue,
      'rating': rating,
      'emailOptOut': emailOptOut,
      'skypeId': skypeId,
      'twitter': twitter,
      'secondEmail': secondEmail,
      'expectedDate': expectedDate,
      'budget': budget,
      'longitude': longitude,
      'latitude': latitude,
      'priorityId': priorityId,
      'phone': phone,
      'nextFollowUp': nextFollowUp,
      'dealSize': dealSize,
      'closingRemark': closingRemark,
      'ownerName': ownerName,
      'assignToName': assignToName,
      'leadStatusLabel': leadStatusLabel,
      'comment': comment,
      'commentDate': commentDate,
      'relatedPeople': relatedPeople,
      'relatedBillList': relatedBillList,
    };
  }
}
