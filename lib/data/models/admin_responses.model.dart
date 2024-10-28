class AdminCountsModel {
  String? design;
  String? printing;
  String? fabrication;
  String? dispatch;
  String? vendor;
  String? message;

  AdminCountsModel({
    this.design,
    this.printing,
    this.fabrication,
    this.dispatch,
    this.vendor,
    this.message,
  });

  AdminCountsModel.fromJson(Map<String, dynamic> json) {
    design = json['Design'];
    printing = json['Printing'];
    fabrication = json['Fabrication'];
    dispatch = json['Dispatch'];
    vendor = json['Vendor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Design'] = design;
    data['Printing'] = printing;
    data['Fabrication'] = fabrication;
    data['Dispatch'] = dispatch;
    data['Vendor'] = vendor;
    return data;
  }
}

class AdminTodayCountsModel {
  String? jobs;
  String? design;
  String? printing;
  String? fabrication;
  String? dispatch;
  String? inquiry;
  String? message;

  AdminTodayCountsModel({
    this.jobs,
    this.design,
    this.printing,
    this.fabrication,
    this.dispatch,
    this.inquiry,
    this.message,
  });

  AdminTodayCountsModel.fromJson(Map<String, dynamic> json) {
    jobs = json['Jobs'];
    design = json['Design'];
    printing = json['Printing'];
    fabrication = json['Fabrication'];
    dispatch = json['Dispatch'];
    inquiry = json['Inquiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Jobs'] = jobs;
    data['Design'] = design;
    data['Printing'] = printing;
    data['Fabrication'] = fabrication;
    data['Dispatch'] = dispatch;
    data['Inquiry'] = inquiry;
    return data;
  }
}

class AdminJobsModel {
  String? id;
  String? jobno;
  String? idforweb;
  String? jobdate;
  String? customername;
  String? companyname;
  String? mobile;
  String? email;
  String? productid;
  String? productname;
  String? designCost;
  String? balance;
  String? qty;
  String? rate;
  String? size;
  String? remark;
  String? deliverydate;
  String? deliveryMode;
  String? isUrgent;
  String? storageLocation;
  String? workDesign;
  String? workPrint;
  String? workFabrication;
  String? workOther;
  String? designby;
  String? designdate;
  String? printingby;
  String? printingdate;
  String? fabricationby;
  String? fabricationdate;
  String? vendorby;
  String? vendordate;
  String? designStatus;
  String? printStatus;
  String? fabricationStatus;
  String? dispatchStatus;
  String? vendorStatus;
  String? days;
  String? designerid;
  String? printingid;
  String? faricationid;
  String? vendorid;
  String? designerremark;
  String? designerupdateremark;
  String? printingremark;
  String? faricationremark;
  String? vendorremark;
  String? createdby;
  String? createdon;
  String? editedby;
  String? editedon;
  String? approved;
  String? approvedby;
  String? approvedDate;
  String? designReady;
  String? vendordispatchremark;
  String? vendorcost;
  String? vendorchallan;
  String? vendorchallandate;
  String? pendingDays;
  String? status;
  String? challanno;
  String? challanDate;
  String? unseencount;
  String? jobid;

  AdminJobsModel(
      {this.id,
      this.jobno,
      this.idforweb,
      this.jobdate,
      this.customername,
      this.companyname,
      this.mobile,
      this.email,
      this.productid,
      this.productname,
      this.designCost,
      this.balance,
      this.qty,
      this.rate,
      this.size,
      this.remark,
      this.deliverydate,
      this.deliveryMode,
      this.isUrgent,
      this.storageLocation,
      this.workDesign,
      this.workPrint,
      this.workFabrication,
      this.workOther,
      this.designby,
      this.designdate,
      this.printingby,
      this.printingdate,
      this.fabricationby,
      this.fabricationdate,
      this.vendorby,
      this.vendordate,
      this.designStatus,
      this.printStatus,
      this.fabricationStatus,
      this.dispatchStatus,
      this.vendorStatus,
      this.days,
      this.designerid,
      this.printingid,
      this.faricationid,
      this.vendorid,
      this.designerremark,
      this.designerupdateremark,
      this.printingremark,
      this.faricationremark,
      this.vendorremark,
      this.createdby,
      this.createdon,
      this.editedby,
      this.editedon,
      this.approved,
      this.approvedby,
      this.approvedDate,
      this.designReady,
      this.vendordispatchremark,
      this.vendorcost,
      this.vendorchallan,
      this.vendorchallandate,
      this.pendingDays,
      this.status,
      this.challanno,
      this.challanDate,
      this.unseencount,
      this.jobid});

  AdminJobsModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    jobno = json['Jobno'];
    idforweb = json['Idforweb'];
    jobdate = json['Jobdate'];
    customername = json['Customername'];
    companyname = json['Companyname'];
    mobile = json['Mobile'];
    email = json['Email'];
    productid = json['Productid'];
    productname = json['Productname'];
    designCost = json['DesignCost'];
    balance = json['Balance'];
    qty = json['Qty'];
    rate = json['Rate'];
    size = json['Size'];
    remark = json['Remark'];
    deliverydate = json['Deliverydate'];
    deliveryMode = json['DeliveryMode'];
    isUrgent = json['IsUrgent'];
    storageLocation = json['StorageLocation'];
    workDesign = json['Work_design'];
    workPrint = json['Work_print'];
    workFabrication = json['Work_fabrication'];
    workOther = json['Work_other'];
    designby = json['Designby'];
    designdate = json['Designdate'];
    printingby = json['Printingby'];
    printingdate = json['Printingdate'];
    fabricationby = json['Fabricationby'];
    fabricationdate = json['Fabricationdate'];
    vendorby = json['Vendorby'];
    vendordate = json['Vendordate'];
    designStatus = json['DesignStatus'];
    printStatus = json['PrintStatus'];
    fabricationStatus = json['FabricationStatus'];
    dispatchStatus = json['DispatchStatus'];
    vendorStatus = json['VendorStatus'];
    days = json['Days'];
    designerid = json['Designerid'];
    printingid = json['Printingid'];
    faricationid = json['Faricationid'];
    vendorid = json['Vendorid'];
    designerremark = json['Designerremark'];
    designerupdateremark = json['Designerupdateremark'];
    printingremark = json['Printingremark'];
    faricationremark = json['Faricationremark'];
    vendorremark = json['Vendorremark'];
    createdby = json['Createdby'];
    createdon = json['Createdon'];
    editedby = json['Editedby'];
    editedon = json['Editedon'];
    approved = json['Approved'];
    approvedby = json['Approvedby'];
    approvedDate = json['ApprovedDate'];
    designReady = json['Design_Ready'];
    vendordispatchremark = json['Vendordispatchremark'];
    vendorcost = json['Vendorcost'];
    vendorchallan = json['Vendorchallan'];
    vendorchallandate = json['Vendorchallandate'];
    pendingDays = json['PendingDays'];
    status = json['Status'];
    challanno = json['Challanno'];
    challanDate = json['ChallanDate'];
    unseencount = json['Unseencount'];
    jobid = json['jobid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Jobno'] = jobno;
    data['Idforweb'] = idforweb;
    data['Jobdate'] = jobdate;
    data['Customername'] = customername;
    data['Companyname'] = companyname;
    data['Mobile'] = mobile;
    data['Email'] = email;
    data['Productid'] = productid;
    data['Productname'] = productname;
    data['DesignCost'] = designCost;
    data['Balance'] = balance;
    data['Qty'] = qty;
    data['Rate'] = rate;
    data['Size'] = size;
    data['Remark'] = remark;
    data['Deliverydate'] = deliverydate;
    data['DeliveryMode'] = deliveryMode;
    data['IsUrgent'] = isUrgent;
    data['StorageLocation'] = storageLocation;
    data['Work_design'] = workDesign;
    data['Work_print'] = workPrint;
    data['Work_fabrication'] = workFabrication;
    data['Work_other'] = workOther;
    data['Designby'] = designby;
    data['Designdate'] = designdate;
    data['Printingby'] = printingby;
    data['Printingdate'] = printingdate;
    data['Fabricationby'] = fabricationby;
    data['Fabricationdate'] = fabricationdate;
    data['Vendorby'] = vendorby;
    data['Vendordate'] = vendordate;
    data['DesignStatus'] = designStatus;
    data['PrintStatus'] = printStatus;
    data['FabricationStatus'] = fabricationStatus;
    data['DispatchStatus'] = dispatchStatus;
    data['VendorStatus'] = vendorStatus;
    data['Days'] = days;
    data['Designerid'] = designerid;
    data['Printingid'] = printingid;
    data['Faricationid'] = faricationid;
    data['Vendorid'] = vendorid;
    data['Designerremark'] = designerremark;
    data['Designerupdateremark'] = designerupdateremark;
    data['Printingremark'] = printingremark;
    data['Faricationremark'] = faricationremark;
    data['Vendorremark'] = vendorremark;
    data['Createdby'] = createdby;
    data['Createdon'] = createdon;
    data['Editedby'] = editedby;
    data['Editedon'] = editedon;
    data['Approved'] = approved;
    data['Approvedby'] = approvedby;
    data['ApprovedDate'] = approvedDate;
    data['Design_Ready'] = designReady;
    data['Vendordispatchremark'] = vendordispatchremark;
    data['Vendorcost'] = vendorcost;
    data['Vendorchallan'] = vendorchallan;
    data['Vendorchallandate'] = vendorchallandate;
    data['PendingDays'] = pendingDays;
    data['Status'] = status;
    data['Challanno'] = challanno;
    data['ChallanDate'] = challanDate;
    data['Unseencount'] = unseencount;
    data['jobid'] = jobid;
    return data;
  }
}

class CreateInqResponse {
  String? result;
  String? id;
  String? message;

  CreateInqResponse({
    this.result,
    this.id,
    this.message,
  });

  CreateInqResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Result'] = result;
    data['id'] = id;
    return data;
  }
}

class YearsModel {
  String? years;

  YearsModel({this.years});

  YearsModel.fromJson(Map<String, dynamic> json) {
    years = json['Year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Year'] = years;
    return data;
  }
}

class MonthsModel {
  String month;
  String value;

  MonthsModel({required this.month, required this.value});
}

class AdminGraphModel {
  String? name;
  String? amount;
  String? received;
  String? balance;

  AdminGraphModel({this.name, this.amount, this.received, this.balance});

  AdminGraphModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    amount = json['Amount'];
    received = json['Received'];
    balance = json['Balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Amount'] = amount;
    data['Received'] = received;
    data['Balance'] = balance;
    return data;
  }
  @override
  String toString() {
    return 'AdminGraphModel(name: $name, amount: $amount, received: $received, balance: $balance)';
  }
}


class InquiryModel {
  String? id;
  String? inquiryno;
  String? date;
  String? customerName;
  String? companyName;
  String? mobileNo;
  String? email;
  String? productId;
  String? product;
  String? qty;
  String? rate;
  String? amount;
  String? remark;
  String? status;
  String? userId;
  String? jobNo;

  InquiryModel(
      {this.id,
      this.jobNo,
      this.inquiryno,
      this.date,
      this.customerName,
      this.companyName,
      this.mobileNo,
      this.email,
      this.productId,
      this.product,
      this.qty,
      this.rate,
      this.amount,
      this.remark,
      this.status,
      this.userId});

  InquiryModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    jobNo= json['Jobno'];
    inquiryno = json['Inquiryno'];
    date = json['Date'];
    customerName = json['CustomerName'];
    companyName = json['CompanyName'];
    mobileNo = json['MobileNo'];
    email = json['Email'];
    productId = json['ProductId'];
    product = json['Product'];
    qty = json['Qty'];
    rate = json['Rate'];
    amount = json['Amount'];
    remark = json['Remark'];
    status = json['Status'];
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Inquiryno'] = inquiryno;
    data['Date'] = date;
    data['CustomerName'] = customerName;
    data['CompanyName'] = companyName;
    data['MobileNo'] = mobileNo;
    data['Email'] = email;
    data['ProductId'] = productId;
    data['Product'] = product;
    data['Qty'] = qty;
    data['Rate'] = rate;
    data['Amount'] = amount;
    data['Remark'] = remark;
    data['Status'] = status;
    data['UserId'] = userId;
    return data;
  }
  @override
  String toString() {
    return 'InquiryModel{id: $id, inquiryno: $inquiryno, date: $date, customerName: $customerName, companyName: $companyName, mobileNo: $mobileNo, email: $email, productId: $productId, product: $product, qty: $qty, rate: $rate, amount: $amount, remark: $remark, status: $status, userId: $userId, jobNo:$jobNo}';
  }
}

class InquiryFollowUpModel {
  String? id;
  String? inqId;
  String? mobileNo;
  String? name;
  String? date;
  String? followUpby;
  String? followUpto;
  String? remark;
  String? status;
  String? userId;

  InquiryFollowUpModel(
      {this.id,
      this.inqId,
      this.mobileNo,
      this.name,
      this.date,
      this.followUpby,
      this.followUpto,
      this.remark,
      this.status,
      this.userId});

  InquiryFollowUpModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    inqId = json['InqId'];
    mobileNo = json['MobileNo'];
    name = json['Name'];
    date = json['Date'];
    followUpby = json['FollowUpby'];
    followUpto = json['FollowUpto'];
    remark = json['Remark'];
    status = json['Status'];
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['InqId'] = inqId;
    data['MobileNo'] = mobileNo;
    data['Name'] = name;
    data['Date'] = date;
    data['FollowUpby'] = followUpby;
    data['FollowUpto'] = followUpto;
    data['Remark'] = remark;
    data['Status'] = status;
    data['UserId'] = userId;
    return data;
  }
}
