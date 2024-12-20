import 'package:get/get.dart';

class TaskList {
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
  String? relatedUsers;
  RxBool isChecked; // Make isChecked an RxBool

  TaskList({
  this.id,
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
    this.relatedUsers,
    bool? checked = false, // Optional parameter for initialization
  }) : isChecked = RxBool(checked ?? false); // Initialize isChecked

  TaskList.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        leadId = json['leadId'],
        userID = json['userID'],
        mobile = json['mobile'],
        email = json['email'],
        cname = json['cname'],
        customertype = json['customertype'],
        vdate = json['vdate'],
        activitytype = json['activitytype'],
        activitystatus = json['activitystatus'],
        activitytime = json['activitytime'],
        stateID = json['stateID'],
        cityID = json['cityID'],
        areaID = json['areaID'],
        state = json['state'],
        city = json['city'],
        area = json['area'],
        pinCode = json['pinCode'],
        remark = json['remark'],
        address = json['address'],
        gstno = json['gstno'],
        mrid = json['mrid'],
        username = json['username'],
        vStatus = json['vStatus'],
        isCall = json['isCall'],
        callPurposeId = json['callPurposeId'],
        callStatusId = json['callStatusId'],
        callStatus = json['callStatus'],
        activitydetails = json['activitydetails'],
        remindertime = json['remindertime'],
        asm = json['asm'],
        sman = json['sman'],
        contactperson = json['contactperson'],
        activityspec = json['activityspec'],
        customerid = json['customerid'],
        dueDate = json['dueDate'],
        priority = json['priority'],
        ownerid = json['ownerid'],
        reminder = json['reminder'],
        reminderalert = json['reminderalert'],
        relatedto = json['relatedto'],
        status = json['status'],
        description = json['description'],
        whendatetime = json['whendatetime'],
        reminderemailsms = json['reminderemailsms'],
        activitysubject = json['activitysubject'],
        company = json['company'],
        title = json['title'],
        leadname = json['leadname'],
        leadsource = json['leadsource'],
        leadstatus = json['leadstatus'],
        industrytype = json['industrytype'],
        noofemployee = json['noofemployee'],
        annualrevenue = json['annualrevenue'],
        rating = json['rating'],
        emailoptout = json['emailoptout'],
        skypeid = json['skypeid'],
        twitter = json['twitter'],
        secondemail = json['secondemail'],
        expecteddate = json['expecteddate'],
        entrytype = json['entrytype'],
        budget = json['budget'],
        promotionType = json['promotionType'],
        totalExpActivity = json['totalExpActivity'],
        assigntoid = json['assigntoid'],
        leadpriorityid = json['leadpriorityid'],
        phone = json['phone'],
        followUpDateTime = json['followUpDateTime'],
        followUpRemark = json['followUpRemark'],
        createdByName = json['createdByName'],
        assigntoName = json['assigntoName'],
        createdDateTime = json['createdDateTime'],
        callStatusName = json['callStatusName'],
        activityDateFormate = json['activityDateFormate'],
        checkinDatetime = json['checkinDatetime'],
        checkoutDatetime = json['checkoutDatetime'],
        prospectid = json['prospectid'],
        productid = json['productid'],
        dealSize = json['dealSize'],
        closingRemark = json['closingRemark'],
        assignTaskDatetime = json['assignTaskDatetime'],
        relatedUsers = json['relatedUsers'],
        isChecked = RxBool(json['isChecked'] ?? false); // Initialize from JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['leadId'] = leadId;
    data['userID'] = userID;
    data['mobile'] = mobile;
    data['email'] = email;
    data['cname'] = cname;
    data['customertype'] = customertype;
    data['vdate'] = vdate;
    data['activitytype'] = activitytype;
    data['activitystatus'] = activitystatus;
    data['activitytime'] = activitytime;
    data['stateID'] = stateID;
    data['cityID'] = cityID;
    data['areaID'] = areaID;
    data['state'] = state;
    data['city'] = city;
    data['area'] = area;
    data['pinCode'] = pinCode;
    data['remark'] = remark;
    data['address'] = address;
    data['gstno'] = gstno;
    data['mrid'] = mrid;
    data['username'] = username;
    data['vStatus'] = vStatus;
    data['isCall'] = isCall;
    data['callPurposeId'] = callPurposeId;
    data['callStatusId'] = callStatusId;
    data['callStatus'] = callStatus;
    data['activitydetails'] = activitydetails;
    data['remindertime'] = remindertime;
    data['asm'] = asm;
    data['sman'] = sman;
    data['contactperson'] = contactperson;
    data['activityspec'] = activityspec;
    data['customerid'] = customerid;
    data['dueDate'] = dueDate;
    data['priority'] = priority;
    data['ownerid'] = ownerid;
    data['reminder'] = reminder;
    data['reminderalert'] = reminderalert;
    data['relatedto'] = relatedto;
    data['status'] = status;
    data['description'] = description;
    data['whendatetime'] = whendatetime;
    data['reminderemailsms'] = reminderemailsms;
    data['activitysubject'] = activitysubject;
    data['company'] = company;
    data['title'] = title;
    data['leadname'] = leadname;
    data['leadsource'] = leadsource;
    data['leadstatus'] = leadstatus;
    data['industrytype'] = industrytype;
    data['noofemployee'] = noofemployee;
    data['annualrevenue'] = annualrevenue;
    data['rating'] = rating;
    data['emailoptout'] = emailoptout;
    data['skypeid'] = skypeid;
    data['twitter'] = twitter;
    data['secondemail'] = secondemail;
    data['expecteddate'] = expecteddate;
    data['entrytype'] = entrytype;
    data['budget'] = budget;
    data['promotionType'] = promotionType;
    data['totalExpActivity'] = totalExpActivity;
    data['assigntoid'] = assigntoid;
    data['leadpriorityid'] = leadpriorityid;
    data['phone'] = phone;
    data['followUpDateTime'] = followUpDateTime;
    data['followUpRemark'] = followUpRemark;
    data['createdByName'] = createdByName;
    data['assigntoName'] = assigntoName;
    data['createdDateTime'] = createdDateTime;
    data['callStatusName'] = callStatusName;
    data['activityDateFormate'] = activityDateFormate;
    data['checkinDatetime'] = checkinDatetime;
    data['checkoutDatetime'] = checkoutDatetime;
    data['prospectid'] = prospectid;
    data['productid'] = productid;
    data['dealSize'] = dealSize;
    data['closingRemark'] = closingRemark;
    data['assignTaskDatetime'] = assignTaskDatetime;
    data['relatedUsers'] = relatedUsers;
    data['isChecked'] = isChecked.value; // Serialize RxBool to JSON
    return data;
  }
}