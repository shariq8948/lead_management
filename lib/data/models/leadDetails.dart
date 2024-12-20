import 'dart:convert';

class LeadResponse {
  String leadid;
  String? guid;
  String leadSr;
  String leadNo;
  String leadStatusId;
  String leadName;
  String leadStatus;
  String leadSourceId;
  String leadSource;
  String custProsId;
  String custProsType;
  String? name;
  String mobile;
  String? email;
  String vdate;
  String ownerId;
  String assigntoId;
  String createdby;
  String createdOn;
  String modifiedOn;
  String modifiedBy;
  String stateID;
  String cityID;
  String areaID;
  String state;
  String city;
  String area;
  String address;
  String gstno;
  String pinCode;
  String time;
  String remark;
  String whatsapp;
  String isdeleted;
  String deletedby;
  String deletedon;
  String dueDate;
  String priority;
  String reminder;
  String reminderalert;
  String relatedto;
  String description;
  String? company;
  String title;
  String industrytype;
  String noofemployee;
  String annualrevenue;
  String rating;
  String emailoptout;
  String skypeid;
  String twitter;
  String secondemail;
  String expecteddate;
  String budget;
  String longitude;
  String latitude;
  String priorityid;
  String phone;
  String nextfollowup;
  String dealSize;
  dynamic closingRemark;
  String ownerName;
  String assignToName;
  String leadStatusLabel;
  String comment;
  String commentDate;
  List<RelatedPeople> relatedPeople;
  List<RelatedBillList> relatedBillList;

  LeadResponse({
    required this.leadid,
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
    required this.createdby,
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
    required this.isdeleted,
    required this.deletedby,
    required this.deletedon,
    required this.dueDate,
    required this.priority,
    required this.reminder,
    required this.reminderalert,
    required this.relatedto,
    required this.description,
    required this.company,
    required this.title,
    required this.industrytype,
    required this.noofemployee,
    required this.annualrevenue,
    required this.rating,
    required this.emailoptout,
    required this.skypeid,
    required this.twitter,
    required this.secondemail,
    required this.expecteddate,
    required this.budget,
    required this.longitude,
    required this.latitude,
    required this.priorityid,
    required this.phone,
    required this.nextfollowup,
    required this.dealSize,
    required this.closingRemark,
    required this.ownerName,
    required this.assignToName,
    required this.leadStatusLabel,
    required this.comment,
    required this.commentDate,
    required this.relatedPeople,
    required this.relatedBillList,
  });

  factory LeadResponse.fromJson(Map<String, dynamic> json) {
    return LeadResponse(
      leadid: json['leadid'] ?? "",
      guid: json['guid'] ?? "",
      leadSr: json['leadSr'] ?? "",
      leadNo: json['leadNo'] ?? "",
      leadStatusId: json['leadStatusId'] ?? "",
      leadName: json['leadName'] ?? "",
      leadStatus: json['leadStatus'] ?? "",
      leadSourceId: json['leadSourceId'] ?? "",
      leadSource: json['leadSource'] ?? "",
      custProsId: json['custProsId'] ?? "",
      custProsType: json['custProsType'] ?? "",
      name: json['name'] ?? "",
      mobile: json['mobile'] ?? "",
      email: json['email'] ?? "",
      vdate: json['vdate'] ?? "",
      ownerId: json['ownerId'] ?? "",
      assigntoId: json['assigntoId'] ?? "",
      createdby: json['createdby'] ?? "",
      createdOn: json['createdOn'] ?? "",
      modifiedOn: json['modifiedOn'] ?? "",
      modifiedBy: json['modifiedBy'] ?? "",
      stateID: json['stateID'] ?? "",
      cityID: json['cityID'] ?? "",
      areaID: json['areaID'] ?? "",
      state: json['state'] ?? "",
      city: json['city'] ?? "",
      area: json['area'] ?? "",
      address: json['address'] ?? "",
      gstno: json['gstno'] ?? "",
      pinCode: json['pinCode'] ?? "",
      time: json['time'] ?? "",
      remark: json['remark'] ?? "",
      whatsapp: json['whatsapp'] ?? "",
      isdeleted: json['isdeleted'] ?? "",
      deletedby: json['deletedby'] ?? "",
      deletedon: json['deletedon'] ?? "",
      dueDate: json['dueDate'] ?? "",
      priority: json['priority'] ?? "",
      reminder: json['reminder'] ?? "",
      reminderalert: json['reminderalert'] ?? "",
      relatedto: json['relatedto'] ?? "",
      description: json['description'] ?? "",
      company: json['company'] ?? "",
      title: json['title'] ?? "",
      industrytype: json['industrytype'] ?? "",
      noofemployee: json['noofemployee'] ?? "",
      annualrevenue: json['annualrevenue'] ?? "",
      rating: json['rating'] ?? "",
      emailoptout: json['emailoptout'] ?? "",
      skypeid: json['skypeid'] ?? "",
      twitter: json['twitter'] ?? "",
      secondemail: json['secondemail'] ?? "",
      expecteddate: json['expecteddate'] ?? "",
      budget: json['budget'] ?? "",
      longitude: json['longitude'] ?? "",
      latitude: json['latitude'] ?? "",
      priorityid: json['priorityid'] ?? "",
      phone: json['phone'] ?? "",
      nextfollowup: json['nextfollowup'] ?? "",
      dealSize: json['dealSize'] ?? "0",
      closingRemark: json['closingRemark'],
      ownerName: json['ownerName'] ?? "",
      assignToName: json['assignToName'] ?? "",
      leadStatusLabel: json['leadStatusLabel'] ?? "",
      comment: json['comment'] ?? "",
      commentDate: json['commentDate'] ?? "",
      relatedPeople: (json['relatedPeople'] as List)
          .map((e) => RelatedPeople.fromJson(e))
          .toList(),
      relatedBillList: (json['relatedBillList'] as List)
          .map((e) => RelatedBillList.fromJson(e))
          .toList(),
    );
  }
}

class RelatedPeople {
  String userid;
  String username;
  String usertype;

  RelatedPeople({
    required this.userid,
    required this.username,
    required this.usertype,
  });

  factory RelatedPeople.fromJson(Map<String, dynamic> json) {
    return RelatedPeople(
      userid: json['userid'] ?? "",
      username: json['username'] ?? "",
      usertype: json['usertype'] ?? "",
    );
  }
}

class RelatedBillList {
  String id;
  String uninumber;
  String date;
  String recordtype;

  RelatedBillList({
    required this.id,
    required this.uninumber,
    required this.date,
    required this.recordtype,
  });

  factory RelatedBillList.fromJson(Map<String, dynamic> json) {
    return RelatedBillList(
      id: json['id'] ?? "",
      uninumber: json['uninumber'] ?? "",
      date: json['date'] ?? "",
      recordtype: json['recordtype'] ?? "",
    );
  }
}

// Parsing the JSON response
List<LeadResponse> leadResponseFromJson(String str) => List<LeadResponse>.from(
    json.decode(str).map((x) => LeadResponse.fromJson(x)));
