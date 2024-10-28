class ReportsModel {
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
  String? dispatchremark;
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

  ReportsModel(
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
      this.dispatchremark,
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

  ReportsModel.fromJson(Map<String, dynamic> json) {
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
    dispatchremark = json['dispatchremark'];
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
    data['dispatchremark'] = dispatchremark;
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

enum ReportTypes {
  inDesign,
  inPrinting,
  inFabrication,
  readyForDispatch,
  jobAtVendor,
  unassignedJobs,
  designerCollection,
  datewiseCustomerJobs,
}

class ReportsArg {
  ReportTypes? type;
  String? url;
  String? title;

  ReportsArg({this.type, this.url, this.title});

  ReportsArg.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['url'] = url;
    data['title'] = title;
    return data;
  }
}

class DesignerCollectionModel {
  String? designerName;
  String? amount;
  String? jobcounts;

  DesignerCollectionModel({this.designerName, this.amount, this.jobcounts});

  DesignerCollectionModel.fromJson(Map<String, dynamic> json) {
    designerName = json['DesignerName'];
    amount = json['Amount'];
    jobcounts = json['Jobcounts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DesignerName'] = designerName;
    data['Amount'] = amount;
    data['Jobcounts'] = jobcounts;
    return data;
  }
}
