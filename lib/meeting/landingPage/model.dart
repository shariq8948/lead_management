import 'package:flutter/foundation.dart'; // Or wherever required is defined

class Meeting {
  String id;
  String?
      leadId; // Nullable fields can be explicitly String? or handled by '??' in fromJson
  String? userID;
  String mobile;
  String email;
  String cname;
  String? customertype;
  String vdate;
  String activitytype;
  String? activitystatus;
  String? activitytime;
  String? stateID;
  String? cityID;
  String? areaID;
  String? state;
  String? city;
  String? area;
  String? pinCode;
  String remark;
  String address;
  String? gstno;
  String? mrid;
  String? username;
  String? vStatus;
  String? isCall;
  String? callPurposeId;
  String? callStatusId;
  String? callStatus;
  String? activitydetails;
  String? remindertime;
  String? asm;
  String? sman;
  String? contactperson;
  String? activityspec;
  String? customerid;
  String? dueDate;
  String? priority;
  String? ownerid;
  String? reminder;
  String? reminderalert;
  String? relatedto;
  String? status;
  String description;
  String whendatetime;
  String? reminderemailsms;
  String activitysubject;
  String? company;
  String title;
  String? leadname;
  String? leadsourceid;
  String? leadsource;
  String? disqualificationReasonid;
  String? leadstatus;
  String? industrytype;
  String? noofemployee;
  String? annualrevenue;
  String? rating;
  String? emailoptout;
  String? skypeid;
  String? twitter;
  String? secondemail;
  String? expecteddate;
  String entrytype;
  String? budget;
  String? promotionType;
  String? totalExpActivity;
  String? assigntoid;
  String? leadpriorityid;
  String? phone;
  String followUpDateTime;
  String followUpRemark;
  String createdByName;
  String assigntoName;
  String createdDateTime;
  String callStatusName;
  String activityDateFormate;
  String checkin;
  String checkout;
  String checkout_Location;
  String checkout_longitude;
  String checkout_latitude;
  String checkin_Location;
  String checkin_longitude;
  String checkin_latitude;
  String checkinDatetime;
  String checkoutDatetime;
  String? prospectid;
  String? productid;
  String? dealSize;
  String? closingRemark;
  String assignTaskDatetime;
  String? stateCode;
  String? product;
  String? alternatePhone;
  String? webhookleadid;
  String? webhookleadtype;
  String? leadDateTime;
  String? relatedUsers; // Assuming this might be a JSON string or simple string

  Meeting({
    required this.id,
    this.leadId,
    this.userID,
    required this.mobile,
    required this.email,
    required this.cname,
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
    required this.address,
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
    required this.title,
    this.leadname,
    this.leadsourceid,
    this.leadsource,
    this.disqualificationReasonid,
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
    required this.assigntoName,
    required this.createdDateTime,
    required this.callStatusName,
    required this.activityDateFormate,
    required this.checkin,
    required this.checkout,
    required this.checkout_Location,
    required this.checkout_longitude,
    required this.checkout_latitude,
    required this.checkin_Location,
    required this.checkin_longitude,
    required this.checkin_latitude,
    required this.checkinDatetime,
    required this.checkoutDatetime,
    this.prospectid,
    this.productid,
    this.dealSize,
    this.closingRemark,
    required this.assignTaskDatetime,
    this.stateCode,
    this.product,
    this.alternatePhone,
    this.webhookleadid,
    this.webhookleadtype,
    this.leadDateTime,
    this.relatedUsers,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    // Defensive check for null json input
    if (json == null) {
      print("Warning: Received null JSON in Meeting.fromJson");
      json = {}; // Prevent null errors below, fields will default to '' or null
    }

    // Helper function for safe string conversion
    String _getString(dynamic value) => value?.toString() ?? '';
    String? _getNullableString(dynamic value) =>
        value?.toString(); // Returns null if value is null

    return Meeting(
      id: _getString(json['id']),
      leadId: _getNullableString(json['leadId']),
      userID: _getNullableString(json['userID']),
      mobile: _getString(json['mobile']),
      email: _getString(json['email']),
      cname: _getString(json['cname']),
      customertype: _getNullableString(json['customertype']),
      vdate: _getString(json['vdate']),
      activitytype: _getString(json['activitytype']),
      activitystatus: _getNullableString(json['activitystatus']),
      activitytime: _getNullableString(json['activitytime']),
      stateID: _getNullableString(json['stateID']),
      cityID: _getNullableString(json['cityID']),
      areaID: _getNullableString(json['areaID']),
      state: _getNullableString(json['state']),
      city: _getNullableString(json['city']),
      area: _getNullableString(json['area']),
      pinCode: _getNullableString(json['pinCode']),
      remark: _getString(json['remark']),
      address: _getString(json['address']),
      gstno: _getNullableString(json['gstno']),
      mrid: _getNullableString(json['mrid']),
      username: _getNullableString(json['username']),
      vStatus: _getNullableString(json['vStatus']),
      isCall: _getNullableString(json['isCall']),
      callPurposeId: _getNullableString(json['callPurposeId']),
      callStatusId: _getNullableString(json['callStatusId']),
      callStatus: _getNullableString(json['callStatus']),
      activitydetails: _getNullableString(json['activitydetails']),
      remindertime: _getNullableString(json['remindertime']),
      asm: _getNullableString(json['asm']),
      sman: _getNullableString(json['sman']),
      contactperson: _getNullableString(json['contactperson']),
      activityspec: _getNullableString(json['activityspec']),
      customerid: _getNullableString(json['customerid']),
      dueDate: _getNullableString(json['dueDate']),
      priority: _getNullableString(json['priority']),
      ownerid: _getNullableString(json['ownerid']),
      reminder: _getNullableString(json['reminder']),
      reminderalert: _getNullableString(json['reminderalert']),
      relatedto: _getNullableString(json['relatedto']),
      status: _getNullableString(json['status']),
      description: _getString(json['description']),
      whendatetime: _getString(json['whendatetime']),
      reminderemailsms: _getNullableString(json['reminderemailsms']),
      activitysubject: _getString(json['activitysubject']),
      company: _getNullableString(json['company']),
      title: _getString(json['title']),
      leadname: _getNullableString(json['leadname']),
      leadsourceid: _getNullableString(json['leadsourceid']),
      leadsource: _getNullableString(json['leadsource']),
      disqualificationReasonid:
          _getNullableString(json['disqualificationReasonid']),
      leadstatus: _getNullableString(json['leadstatus']),
      industrytype: _getNullableString(json['industrytype']),
      noofemployee: _getNullableString(json['noofemployee']),
      annualrevenue: _getNullableString(json['annualrevenue']),
      rating: _getNullableString(json['rating']),
      emailoptout: _getNullableString(json['emailoptout']),
      skypeid: _getNullableString(json['skypeid']),
      twitter: _getNullableString(json['twitter']),
      secondemail: _getNullableString(json['secondemail']),
      expecteddate: _getNullableString(json['expecteddate']),
      entrytype: _getString(json['entrytype']),
      budget: _getNullableString(json['budget']),
      promotionType: _getNullableString(json['promotionType']),
      totalExpActivity: _getNullableString(json['totalExpActivity']),
      assigntoid: _getNullableString(json['assigntoid']),
      leadpriorityid: _getNullableString(json['leadpriorityid']),
      phone: _getNullableString(json['phone']),
      followUpDateTime: _getString(json['followUpDateTime']),
      followUpRemark: _getString(json['followUpRemark']),
      createdByName: _getString(json['createdByName']),
      assigntoName: _getString(json['assigntoName']),
      createdDateTime: _getString(json['createdDateTime']),
      callStatusName: _getString(json['callStatusName']),
      activityDateFormate: _getString(json['activityDateFormate']),
      checkin: _getString(json['checkin']),
      checkout: _getString(json['checkout']),
      checkout_Location: _getString(json['checkout_Location']),
      checkout_longitude: _getString(json['checkout_longitude']),
      checkout_latitude: _getString(json['checkout_latitude']),
      checkin_Location: _getString(json['checkin_Location']),
      checkin_longitude: _getString(json['checkin_longitude']),
      checkin_latitude: _getString(json['checkin_latitude']),
      checkinDatetime: _getString(json['checkinDatetime']),
      checkoutDatetime: _getString(json['checkoutDatetime']),
      prospectid: _getNullableString(json['prospectid']),
      productid: _getNullableString(json['productid']),
      dealSize: _getNullableString(json['dealSize']),
      closingRemark: _getNullableString(json['closingRemark']),
      assignTaskDatetime: _getString(json['assignTaskDatetime']),
      stateCode: _getNullableString(json['stateCode']),
      product: _getNullableString(json['product']),
      alternatePhone: _getNullableString(json['alternatePhone']),
      webhookleadid: _getNullableString(json['webhookleadid']),
      webhookleadtype: _getNullableString(json['webhookleadtype']),
      leadDateTime: _getNullableString(json['leadDateTime']),
      relatedUsers: _getNullableString(json['relatedUsers']),
    );
  }

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
      'leadsourceid': leadsourceid,
      'leadsource': leadsource,
      'disqualificationReasonid': disqualificationReasonid,
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
      'checkin': checkin,
      'checkout': checkout,
      'checkout_Location': checkout_Location,
      'checkout_longitude': checkout_longitude,
      'checkout_latitude': checkout_latitude,
      'checkin_Location': checkin_Location,
      'checkin_longitude': checkin_longitude,
      'checkin_latitude': checkin_latitude,
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
      'webhookleadid': webhookleadid,
      'webhookleadtype': webhookleadtype,
      'leadDateTime': leadDateTime,
      'relatedUsers': relatedUsers,
    };
  }
}
