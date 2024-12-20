class TaskDetail {
  String? id;
  String? leadId;
  String? userID;
  String? mobile;
  String? email;
  String? cname;
  String? customertype;
  String? vdate;
  String? activitytype;
  String? activitystatus;
  String? activitytime;
  String? stateID;
  String? cityID;
  String? areaID;
  String? state;
  String? city;
  String? area;
  String? pinCode;
  String? remark;
  String? address;
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
  String? description;
  String? whendatetime;
  String? reminderemailsms;
  String? activitysubject;
  String? company;
  String? title;
  String? leadname;
  String? leadsource;
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
  String? entrytype;
  String? budget;
  String? promotionType;
  String? totalExpActivity;
  String? assigntoid;
  String? leadpriorityid;
  String? phone;
  String? followUpDateTime;
  String? followUpRemark;
  String? createdByName;
  String? assigntoName;
  String? createdDateTime;
  String? callStatusName;
  String? activityDateFormate;
  String? checkinDatetime;
  String? checkoutDatetime;
  String? prospectid;
  String? productid;
  String? dealSize;
  String? closingRemark;
  String? assignTaskDatetime;
  List<RelatedUsers>? relatedUsers;

  TaskDetail(
      {this.id,
        this.leadId,
        this.userID,
        this.mobile,
        this.email,
        this.cname,
        this.customertype,
        this.vdate,
        this.activitytype,
        this.activitystatus,
        this.activitytime,
        this.stateID,
        this.cityID,
        this.areaID,
        this.state,
        this.city,
        this.area,
        this.pinCode,
        this.remark,
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
        this.description,
        this.whendatetime,
        this.reminderemailsms,
        this.activitysubject,
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
        this.entrytype,
        this.budget,
        this.promotionType,
        this.totalExpActivity,
        this.assigntoid,
        this.leadpriorityid,
        this.phone,
        this.followUpDateTime,
        this.followUpRemark,
        this.createdByName,
        this.assigntoName,
        this.createdDateTime,
        this.callStatusName,
        this.activityDateFormate,
        this.checkinDatetime,
        this.checkoutDatetime,
        this.prospectid,
        this.productid,
        this.dealSize,
        this.closingRemark,
        this.assignTaskDatetime,
        this.relatedUsers});

  TaskDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['leadId'];
    userID = json['userID'];
    mobile = json['mobile'];
    email = json['email'];
    cname = json['cname'];
    customertype = json['customertype'];
    vdate = json['vdate'];
    activitytype = json['activitytype'];
    activitystatus = json['activitystatus'];
    activitytime = json['activitytime'];
    stateID = json['stateID'];
    cityID = json['cityID'];
    areaID = json['areaID'];
    state = json['state'];
    city = json['city'];
    area = json['area'];
    pinCode = json['pinCode'];
    remark = json['remark'];
    address = json['address'];
    gstno = json['gstno'];
    mrid = json['mrid'];
    username = json['username'];
    vStatus = json['vStatus'];
    isCall = json['isCall'];
    callPurposeId = json['callPurposeId'];
    callStatusId = json['callStatusId'];
    callStatus = json['callStatus'];
    activitydetails = json['activitydetails'];
    remindertime = json['remindertime'];
    asm = json['asm'];
    sman = json['sman'];
    contactperson = json['contactperson'];
    activityspec = json['activityspec'];
    customerid = json['customerid'];
    dueDate = json['dueDate'];
    priority = json['priority'];
    ownerid = json['ownerid'];
    reminder = json['reminder'];
    reminderalert = json['reminderalert'];
    relatedto = json['relatedto'];
    status = json['status'];
    description = json['description'];
    whendatetime = json['whendatetime'];
    reminderemailsms = json['reminderemailsms'];
    activitysubject = json['activitysubject'];
    company = json['company'];
    title = json['title'];
    leadname = json['leadname'];
    leadsource = json['leadsource'];
    leadstatus = json['leadstatus'];
    industrytype = json['industrytype'];
    noofemployee = json['noofemployee'];
    annualrevenue = json['annualrevenue'];
    rating = json['rating'];
    emailoptout = json['emailoptout'];
    skypeid = json['skypeid'];
    twitter = json['twitter'];
    secondemail = json['secondemail'];
    expecteddate = json['expecteddate'];
    entrytype = json['entrytype'];
    budget = json['budget'];
    promotionType = json['promotionType'];
    totalExpActivity = json['totalExpActivity'];
    assigntoid = json['assigntoid'];
    leadpriorityid = json['leadpriorityid'];
    phone = json['phone'];
    followUpDateTime = json['followUpDateTime'];
    followUpRemark = json['followUpRemark'];
    createdByName = json['createdByName'];
    assigntoName = json['assigntoName'];
    createdDateTime = json['createdDateTime'];
    callStatusName = json['callStatusName'];
    activityDateFormate = json['activityDateFormate'];
    checkinDatetime = json['checkinDatetime'];
    checkoutDatetime = json['checkoutDatetime'];
    prospectid = json['prospectid'];
    productid = json['productid'];
    dealSize = json['dealSize'];
    closingRemark = json['closingRemark'];
    assignTaskDatetime = json['assignTaskDatetime'];
    if (json['relatedUsers'] != null) {
      relatedUsers = <RelatedUsers>[];
      json['relatedUsers'].forEach((v) {
        relatedUsers!.add(new RelatedUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['leadId'] = this.leadId;
    data['userID'] = this.userID;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['cname'] = this.cname;
    data['customertype'] = this.customertype;
    data['vdate'] = this.vdate;
    data['activitytype'] = this.activitytype;
    data['activitystatus'] = this.activitystatus;
    data['activitytime'] = this.activitytime;
    data['stateID'] = this.stateID;
    data['cityID'] = this.cityID;
    data['areaID'] = this.areaID;
    data['state'] = this.state;
    data['city'] = this.city;
    data['area'] = this.area;
    data['pinCode'] = this.pinCode;
    data['remark'] = this.remark;
    data['address'] = this.address;
    data['gstno'] = this.gstno;
    data['mrid'] = this.mrid;
    data['username'] = this.username;
    data['vStatus'] = this.vStatus;
    data['isCall'] = this.isCall;
    data['callPurposeId'] = this.callPurposeId;
    data['callStatusId'] = this.callStatusId;
    data['callStatus'] = this.callStatus;
    data['activitydetails'] = this.activitydetails;
    data['remindertime'] = this.remindertime;
    data['asm'] = this.asm;
    data['sman'] = this.sman;
    data['contactperson'] = this.contactperson;
    data['activityspec'] = this.activityspec;
    data['customerid'] = this.customerid;
    data['dueDate'] = this.dueDate;
    data['priority'] = this.priority;
    data['ownerid'] = this.ownerid;
    data['reminder'] = this.reminder;
    data['reminderalert'] = this.reminderalert;
    data['relatedto'] = this.relatedto;
    data['status'] = this.status;
    data['description'] = this.description;
    data['whendatetime'] = this.whendatetime;
    data['reminderemailsms'] = this.reminderemailsms;
    data['activitysubject'] = this.activitysubject;
    data['company'] = this.company;
    data['title'] = this.title;
    data['leadname'] = this.leadname;
    data['leadsource'] = this.leadsource;
    data['leadstatus'] = this.leadstatus;
    data['industrytype'] = this.industrytype;
    data['noofemployee'] = this.noofemployee;
    data['annualrevenue'] = this.annualrevenue;
    data['rating'] = this.rating;
    data['emailoptout'] = this.emailoptout;
    data['skypeid'] = this.skypeid;
    data['twitter'] = this.twitter;
    data['secondemail'] = this.secondemail;
    data['expecteddate'] = this.expecteddate;
    data['entrytype'] = this.entrytype;
    data['budget'] = this.budget;
    data['promotionType'] = this.promotionType;
    data['totalExpActivity'] = this.totalExpActivity;
    data['assigntoid'] = this.assigntoid;
    data['leadpriorityid'] = this.leadpriorityid;
    data['phone'] = this.phone;
    data['followUpDateTime'] = this.followUpDateTime;
    data['followUpRemark'] = this.followUpRemark;
    data['createdByName'] = this.createdByName;
    data['assigntoName'] = this.assigntoName;
    data['createdDateTime'] = this.createdDateTime;
    data['callStatusName'] = this.callStatusName;
    data['activityDateFormate'] = this.activityDateFormate;
    data['checkinDatetime'] = this.checkinDatetime;
    data['checkoutDatetime'] = this.checkoutDatetime;
    data['prospectid'] = this.prospectid;
    data['productid'] = this.productid;
    data['dealSize'] = this.dealSize;
    data['closingRemark'] = this.closingRemark;
    data['assignTaskDatetime'] = this.assignTaskDatetime;
    if (this.relatedUsers != Null) {
      data['relatedUsers'] = this.relatedUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RelatedUsers {
  String? userid;
  String? username;
  String? usertype;

  RelatedUsers({this.userid, this.username, this.usertype});

  RelatedUsers.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    username = json['username'];
    usertype = json['usertype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['username'] = this.username;
    data['usertype'] = this.usertype;
    return data;
  }
}
