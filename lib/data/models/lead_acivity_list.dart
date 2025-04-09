class LeadActivityListModel {
  final String? id;
  final String? leadId;
  final String? userID;
  final String? mobile;
  final String? email;
  final String? cname;
  final String? customertype;
  final String vdate;
  final String activitytype;
  final String? activitystatus;
  final String? activitytime;
  final String? stateID;
  final String? cityID;
  final String? areaID;
  final String? state;
  final String? city;
  final String? area;
  final String? pinCode;
  final String remark;
  final String? address;
  final String? gstno;
  final String? mrid;
  final String? username;
  final String? vStatus;
  final String? isCall;
  final String? callPurposeId;
  final String? callStatusId;
  final String? callStatus;
  final String? activitydetails;
  final String? remindertime;
  final String? asm;
  final String? sman;
  final String? contactperson;
  final String? activityspec;
  final String? customerid;
  final String? dueDate;
  final String? priority;
  final String? ownerid;
  final String? reminder;
  final String? reminderalert;
  final String? relatedto;
  final String? status;
  final String description;
  final String whendatetime;
  final String? reminderemailsms;
  final String activitysubject;
  final String? company;
  final String? title;
  final String? leadname;
  final String? leadsource;
  final String? leadstatus;
  final String? industrytype;
  final String? noofemployee;
  final String? annualrevenue;
  final String? rating;
  final String? emailoptout;
  final String? skypeid;
  final String? twitter;
  final String? secondemail;
  final String? expecteddate;
  final String entrytype;
  final String? budget;
  final String? promotionType;
  final String? totalExpActivity;
  final String? assigntoid;
  final String? leadpriorityid;
  final String? phone;
  final String followUpDateTime;
  final String followUpRemark;
  final String createdByName;
  final String? assigntoName;
  final String createdDateTime;
  final String? callStatusName;
  final String activityDateFormate;
  final String? checkinDatetime;
  final String? checkoutDatetime;
  final String? prospectid;
  final String? productid;
  final String? dealSize;
  final String? closingRemark;
  final String? assignTaskDatetime;
  final String? stateCode;
  final String? product;
  final String? alternatePhone;
  final String? relatedUsers;

  LeadActivityListModel({
    this.id,
    this.leadId,
    this.userID,
    this.mobile,
    this.email,
    this.cname,
    this.customertype,
    required this.vdate,
    required this.activitytype,
    this.activitystatus,
    this.activitytime,
    this.stateID,
    this.cityID,
    this.areaID,
    this.state,
    this.city,
    this.area,
    this.pinCode,
    required this.remark,
    this.address,
    this.gstno,
    this.mrid,
    this.username,
    this.vStatus,
    this.isCall,
    this.callPurposeId,
    this.callStatusId,
    this.callStatus,
    this.activitydetails,
    this.remindertime,
    this.asm,
    this.sman,
    this.contactperson,
    this.activityspec,
    this.customerid,
    this.dueDate,
    this.priority,
    this.ownerid,
    this.reminder,
    this.reminderalert,
    this.relatedto,
    this.status,
    required this.description,
    required this.whendatetime,
    this.reminderemailsms,
    required this.activitysubject,
    this.company,
    this.title,
    this.leadname,
    this.leadsource,
    this.leadstatus,
    this.industrytype,
    this.noofemployee,
    this.annualrevenue,
    this.rating,
    this.emailoptout,
    this.skypeid,
    this.twitter,
    this.secondemail,
    this.expecteddate,
    required this.entrytype,
    this.budget,
    this.promotionType,
    this.totalExpActivity,
    this.assigntoid,
    this.leadpriorityid,
    this.phone,
    required this.followUpDateTime,
    required this.followUpRemark,
    required this.createdByName,
    this.assigntoName,
    required this.createdDateTime,
    this.callStatusName,
    required this.activityDateFormate,
    this.checkinDatetime,
    this.checkoutDatetime,
    this.prospectid,
    this.productid,
    this.dealSize,
    this.closingRemark,
    this.assignTaskDatetime,
    this.stateCode,
    this.product,
    this.alternatePhone,
    this.relatedUsers,
  });

  // Factory method to create the object from JSON
  factory LeadActivityListModel.fromJson(Map<String, dynamic> json) {
    return LeadActivityListModel(
      id: json['id'],
      leadId: json['leadId'],
      userID: json['userID'],
      mobile: json['mobile'],
      email: json['email'],
      cname: json['cname'],
      customertype: json['customertype'],
      vdate: json['vdate'] ?? '',
      activitytype: json['activitytype'] ?? '',
      activitystatus: json['activitystatus'],
      activitytime: json['activitytime'],
      stateID: json['stateID'],
      cityID: json['cityID'],
      areaID: json['areaID'],
      state: json['state'],
      city: json['city'],
      area: json['area'],
      pinCode: json['pinCode'],
      remark: json['remark'] ?? '',
      address: json['address'],
      gstno: json['gstno'],
      mrid: json['mrid'],
      username: json['username'],
      vStatus: json['vStatus'],
      isCall: json['isCall'],
      callPurposeId: json['callPurposeId'],
      callStatusId: json['callStatusId'],
      callStatus: json['callStatus'],
      activitydetails: json['activitydetails'],
      remindertime: json['remindertime'],
      asm: json['asm'],
      sman: json['sman'],
      contactperson: json['contactperson'],
      activityspec: json['activityspec'],
      customerid: json['customerid'],
      dueDate: json['dueDate'],
      priority: json['priority'],
      ownerid: json['ownerid'],
      reminder: json['reminder'],
      reminderalert: json['reminderalert'],
      relatedto: json['relatedto'],
      status: json['status'],
      description: json['description'] ?? '',
      whendatetime: json['whendatetime'] ?? '',
      reminderemailsms: json['reminderemailsms'],
      activitysubject: json['activitysubject'] ?? '',
      company: json['company'],
      title: json['title'],
      leadname: json['leadname'],
      leadsource: json['leadsource'],
      leadstatus: json['leadstatus'],
      industrytype: json['industrytype'],
      noofemployee: json['noofemployee'],
      annualrevenue: json['annualrevenue'],
      rating: json['rating'],
      emailoptout: json['emailoptout'],
      skypeid: json['skypeid'],
      twitter: json['twitter'],
      secondemail: json['secondemail'],
      expecteddate: json['expecteddate'],
      entrytype: json['entrytype'] ?? '',
      budget: json['budget'],
      promotionType: json['promotionType'],
      totalExpActivity: json['totalExpActivity'],
      assigntoid: json['assigntoid'],
      leadpriorityid: json['leadpriorityid'],
      phone: json['phone'],
      followUpDateTime: json['followUpDateTime'] ?? '',
      followUpRemark: json['followUpRemark'] ?? '',
      createdByName: json['createdByName'] ?? '',
      assigntoName: json['assigntoName'],
      createdDateTime: json['createdDateTime'] ?? '',
      callStatusName: json['callStatusName'],
      activityDateFormate: json['activityDateFormate'] ?? '',
      checkinDatetime: json['checkinDatetime'],
      checkoutDatetime: json['checkoutDatetime'],
      prospectid: json['prospectid'],
      productid: json['productid'],
      dealSize: json['dealSize'],
      closingRemark: json['closingRemark'],
      assignTaskDatetime: json['assignTaskDatetime'],
      stateCode: json['stateCode'],
      product: json['product'],
      alternatePhone: json['alternatePhone'],
      relatedUsers: json['relatedUsers'],
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leadId': leadId,
      'userID': userID,
      'mobile': mobile,
      'email': email,
      'cname': cname,
      'customertype': customertype,
      'vdate': vdate,
      'activitytype': activitytype,
      'activitystatus': activitystatus,
      'activitytime': activitytime,
      'stateID': stateID,
      'cityID': cityID,
      'areaID': areaID,
      'state': state,
      'city': city,
      'area': area,
      'pinCode': pinCode,
      'remark': remark,
      'address': address,
      'gstno': gstno,
      'mrid': mrid,
      'username': username,
      'vStatus': vStatus,
      'isCall': isCall,
      'callPurposeId': callPurposeId,
      'callStatusId': callStatusId,
      'callStatus': callStatus,
      'activitydetails': activitydetails,
      'remindertime': remindertime,
      'asm': asm,
      'sman': sman,
      'contactperson': contactperson,
      'activityspec': activityspec,
      'customerid': customerid,
      'dueDate': dueDate,
      'priority': priority,
      'ownerid': ownerid,
      'reminder': reminder,
      'reminderalert': reminderalert,
      'relatedto': relatedto,
      'status': status,
      'description': description,
      'whendatetime': whendatetime,
      'reminderemailsms': reminderemailsms,
      'activitysubject': activitysubject,
      'company': company,
      'title': title,
      'leadname': leadname,
      'leadsource': leadsource,
      'leadstatus': leadstatus,
      'industrytype': industrytype,
      'noofemployee': noofemployee,
      'annualrevenue': annualrevenue,
      'rating': rating,
      'emailoptout': emailoptout,
      'skypeid': skypeid,
      'twitter': twitter,
      'secondemail': secondemail,
      'expecteddate': expecteddate,
      'entrytype': entrytype,
      'budget': budget,
      'promotionType': promotionType,
      'totalExpActivity': totalExpActivity,
      'assigntoid': assigntoid,
      'leadpriorityid': leadpriorityid,
      'phone': phone,
      'followUpDateTime': followUpDateTime,
      'followUpRemark': followUpRemark,
      'createdByName': createdByName,
      'assigntoName': assigntoName,
      'createdDateTime': createdDateTime,
      'callStatusName': callStatusName,
      'activityDateFormate': activityDateFormate,
      'checkinDatetime': checkinDatetime,
      'checkoutDatetime': checkoutDatetime,
      'prospectid': prospectid,
      'productid': productid,
      'dealSize': dealSize,
      'closingRemark': closingRemark,
      'assignTaskDatetime': assignTaskDatetime,
      'stateCode': stateCode,
      'product': product,
      'alternatePhone': alternatePhone,
      'relatedUsers': relatedUsers,
    };
  }
}
