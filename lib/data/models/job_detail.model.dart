class JobDetailModel {
  String? id;
  String? jobid;
  String? jobno;
  String? jobdate;
  String? customername;
  String? companyname;
  String? mobile;
  String? email;
  String? productid;
  String? productname;
  String? qty;
  String? rate;
  String? discount;
  String? amount;
  String? advance;
  String? balance;
  String? remark;
  String? size;
  String? sizeSqft;
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
  String? days;
  String? designerid;
  String? printingid;
  String? fabricationid;
  String? vendorid;
  String? dispatchremark;
  String? designerremark;
  String? printingremark;
  String? fabricationremark;
  String? vendorremark;
  String? dispatchremarkupdate;
  String? designerremarkupdate;
  String? printingremarkupdate;
  String? fabricationremarkupdate;
  String? vendorremarkupdate;
  String? designerupdatedate;
  String? printingupdatedate;
  String? fabricationupdatedate;
  String? vendorupdatedate;
  String? add1;
  String? add2;
  String? status;
  String? link;
  String? designCost;
  String? createdby;
  String? createdon;
  String? editedby;
  String? editedon;
  String? approved;
  String? approvedby;
  String? approvedDate;
  String? designReady;
  String? lotno;
  String? imageUrl;
  List<Services>? services;
  List<Labels>? labels;
  List<Vendors>? vendors;
  List<Payment>? payment;

  JobDetailModel(
      {this.id,
      this.jobid,
      this.jobno,
      this.jobdate,
      this.customername,
      this.companyname,
      this.mobile,
      this.email,
      this.productid,
      this.productname,
      this.qty,
      this.rate,
      this.discount,
      this.amount,
      this.advance,
      this.balance,
      this.remark,
      this.size,
      this.sizeSqft,
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
      this.days,
      this.designerid,
      this.printingid,
      this.fabricationid,
      this.vendorid,
      this.dispatchremark,
      this.designerremark,
      this.printingremark,
      this.fabricationremark,
      this.vendorremark,
      this.dispatchremarkupdate,
      this.designerremarkupdate,
      this.printingremarkupdate,
      this.fabricationremarkupdate,
      this.vendorremarkupdate,
      this.designerupdatedate,
      this.printingupdatedate,
      this.fabricationupdatedate,
      this.vendorupdatedate,
      this.add1,
      this.add2,
      this.status,
      this.link,
      this.designCost,
      this.createdby,
      this.createdon,
      this.editedby,
      this.editedon,
      this.approved,
      this.approvedby,
      this.approvedDate,
      this.designReady,
      this.lotno,
      this.imageUrl,
      this.services,
      this.labels,
      this.vendors,
      this.payment});

  JobDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    jobid = json['Jobid'];
    jobno = json['Jobno'];
    jobdate = json['Jobdate'];
    customername = json['Customername'];
    companyname = json['Companyname'];
    mobile = json['Mobile'];
    email = json['Email'];
    productid = json['Productid'];
    productname = json['Productname'];
    qty = json['Qty'];
    rate = json['Rate'];
    discount = json['Discount'];
    amount = json['Amount'];
    advance = json['Advance'];
    balance = json['Balance'];
    remark = json['Remark'];
    size = json['Size'];
    sizeSqft = json['SizeSqft'];
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
    days = json['Days'];
    designerid = json['Designerid'];
    printingid = json['Printingid'];
    fabricationid = json['Fabricationid'];
    vendorid = json['Vendorid'];
    dispatchremark = json['dispatchremark'];
    designerremark = json['Designerremark'];
    printingremark = json['Printingremark'];
    fabricationremark = json['Fabricationremark'];
    vendorremark = json['Vendorremark'];
    dispatchremarkupdate = json['Dispatchremarkupdate'];
    designerremarkupdate = json['Designerremarkupdate'];
    printingremarkupdate = json['Printingremarkupdate'];
    fabricationremarkupdate = json['Fabricationremarkupdate'];
    vendorremarkupdate = json['Vendorremarkupdate'];
    designerupdatedate = json['Designerupdatedate'];
    printingupdatedate = json['Printingupdatedate'];
    fabricationupdatedate = json['Fabricationupdatedate'];
    vendorupdatedate = json['Vendorupdatedate'];
    add1 = json['Add1'];
    add2 = json['Add2'];
    status = json['Status'];
    link = json['Link'];
    designCost = json['DesignCost'];
    createdby = json['Createdby'];
    createdon = json['Createdon'];
    editedby = json['Editedby'];
    editedon = json['Editedon'];
    approved = json['Approved'];
    approvedby = json['Approvedby'];
    approvedDate = json['ApprovedDate'];
    designReady = json['DesignReady'];
    lotno = json['Lotno'];
    imageUrl = json['ImageUrl'];
    if (json['Services'] != null) {
      services = <Services>[];
      json['Services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    if (json['Labels'] != null) {
      labels = <Labels>[];
      json['Labels'].forEach((v) {
        labels!.add(Labels.fromJson(v));
      });
    }
    if (json['Vendors'] != null) {
      vendors = <Vendors>[];
      json['Vendors'].forEach((v) {
        vendors!.add(Vendors.fromJson(v));
      });
    }
    if (json['Payment'] != null) {
      payment = <Payment>[];
      json['Payment'].forEach((v) {
        payment!.add(Payment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Jobid'] = jobid;
    data['Jobno'] = jobno;
    data['Jobdate'] = jobdate;
    data['Customername'] = customername;
    data['Companyname'] = companyname;
    data['Mobile'] = mobile;
    data['Email'] = email;
    data['Productid'] = productid;
    data['Productname'] = productname;
    data['Qty'] = qty;
    data['Rate'] = rate;
    data['Discount'] = discount;
    data['Amount'] = amount;
    data['Advance'] = advance;
    data['Balance'] = balance;
    data['Remark'] = remark;
    data['Size'] = size;
    data['SizeSqft'] = sizeSqft;
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
    data['Days'] = days;
    data['Designerid'] = designerid;
    data['Printingid'] = printingid;
    data['Fabricationid'] = fabricationid;
    data['Vendorid'] = vendorid;
    data['dispatchremark'] = dispatchremark;
    data['Designerremark'] = designerremark;
    data['Printingremark'] = printingremark;
    data['Fabricationremark'] = fabricationremark;
    data['Vendorremark'] = vendorremark;
    data['Dispatchremarkupdate'] = dispatchremarkupdate;
    data['Designerremarkupdate'] = designerremarkupdate;
    data['Printingremarkupdate'] = printingremarkupdate;
    data['Fabricationremarkupdate'] = fabricationremarkupdate;
    data['Vendorremarkupdate'] = vendorremarkupdate;
    data['Designerupdatedate'] = designerupdatedate;
    data['Printingupdatedate'] = printingupdatedate;
    data['Fabricationupdatedate'] = fabricationupdatedate;
    data['Vendorupdatedate'] = vendorupdatedate;
    data['Add1'] = add1;
    data['Add2'] = add2;
    data['Status'] = status;
    data['Link'] = link;
    data['DesignCost'] = designCost;
    data['Createdby'] = createdby;
    data['Createdon'] = createdon;
    data['Editedby'] = editedby;
    data['Editedon'] = editedon;
    data['Approved'] = approved;
    data['Approvedby'] = approvedby;
    data['ApprovedDate'] = approvedDate;
    data['DesignReady'] = designReady;
    data['Lotno'] = lotno;
    data['ImageUrl'] = imageUrl;
    if (services != null) {
      data['Services'] = services!.map((v) => v.toJson()).toList();
    }
    if (labels != null) {
      data['Labels'] = labels!.map((v) => v.toJson()).toList();
    }
    if (vendors != null) {
      data['Vendors'] = vendors!.map((v) => v.toJson()).toList();
    }
    if (payment != null) {
      data['Payment'] = payment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  @override
  String toString() {
    return 'JobDetailModel('
        'id: $id, '
        'jobid: $jobid, '
        'jobno: $jobno, '
        'jobdate: $jobdate, '
        'customername: $customername, '
        'companyname: $companyname, '
        'mobile: $mobile, '
        'email: $email, '
    // Include the other necessary fields here
        'services: ${services?.map((s) => s.toString()).join(', ')}, '
        'labels: ${labels?.map((l) => l.toString()).join(', ')}, '
        'vendors: ${vendors?.map((v) => v.toString()).join(', ')}, '
        'payment: ${payment?.map((p) => p.toString()).join(', ')}'
        ')';
  }
}

class Services {
  String? id;
  String? jobID;
  String? jobsldID;
  String? productID;
  String? jobProductServicesID;
  String? jobProductServicesName;
  String? jobProductServicesCategory;
  String? jobServicesIngredientID;
  String? jobServicesIngredientName;
  String? servicesStatus;
  String? servicesBy;
  String? remarks;
  String? userID;

  Services(
      {this.id,
      this.jobID,
      this.jobsldID,
      this.productID,
      this.jobProductServicesID,
      this.jobProductServicesName,
      this.jobProductServicesCategory,
      this.jobServicesIngredientID,
      this.jobServicesIngredientName,
      this.servicesStatus,
      this.servicesBy,
      this.remarks,
      this.userID});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    jobID = json['JobID'];
    jobsldID = json['JobsldID'];
    productID = json['ProductID'];
    jobProductServicesID = json['Job_Product_Services_ID'];
    jobProductServicesName = json['Job_Product_Services_Name'];
    jobProductServicesCategory = json['Job_Product_Services_Category'];
    jobServicesIngredientID = json['Job_Services_ingredient_ID'];
    jobServicesIngredientName = json['Job_Services_ingredient_Name'];
    servicesStatus = json['ServicesStatus'];
    servicesBy = json['ServicesBy'];
    remarks = json['Remarks'];
    userID = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['JobID'] = jobID;
    data['JobsldID'] = jobsldID;
    data['ProductID'] = productID;
    data['Job_Product_Services_ID'] = jobProductServicesID;
    data['Job_Product_Services_Name'] = jobProductServicesName;
    data['Job_Product_Services_Category'] = jobProductServicesCategory;
    data['Job_Services_ingredient_ID'] = jobServicesIngredientID;
    data['Job_Services_ingredient_Name'] = jobServicesIngredientName;
    data['ServicesStatus'] = servicesStatus;
    data['ServicesBy'] = servicesBy;
    data['Remarks'] = remarks;
    data['UserID'] = userID;
    return data;
  }
  @override
  String toString() {
    return 'Services('
        // 'id: $id, '
        // 'jobID: $jobID, '
        // 'jobsldID: $jobsldID, '
        // 'productID: $productID, '
        // 'jobProductServicesID: $jobProductServicesID, '
        // 'jobProductServicesName: $jobProductServicesName, '
        // 'jobProductServicesCategory: $jobProductServicesCategory, '
        // 'jobServicesIngredientID: $jobServicesIngredientID, '
        // 'jobServicesIngredientName: $jobServicesIngredientName, '
        // 'servicesStatus: $servicesStatus, '
        // 'servicesBy: $servicesBy, '
        'remarks: $remarks, '
        // 'userID: $userID'
        'jobServicesIngredientName: $jobServicesIngredientName '

        ')';
  }
}

class Labels {
  String? id;
  String? jobid;
  String? joblabel;
  String? keyId;
  String? labelname;
  String? labelcolour;
  String? labelfor;
  String? userid;

  Labels(
      {this.id,
      this.jobid,
      this.joblabel,
      this.keyId,
      this.labelname,
      this.labelcolour,
      this.labelfor,
      this.userid});

  Labels.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    jobid = json['Jobid'];
    joblabel = json['Joblabel'];
    keyId = json['KeyId'];
    labelname = json['labelname'];
    labelcolour = json['Labelcolour'];
    labelfor = json['Labelfor'];
    userid = json['Userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Jobid'] = jobid;
    data['Joblabel'] = joblabel;
    data['KeyId'] = keyId;
    data['labelname'] = labelname;
    data['Labelcolour'] = labelcolour;
    data['Labelfor'] = labelfor;
    data['Userid'] = userid;
    return data;
  }
}

class Vendors {
  String? id;
  String? jobsldid;
  String? vendorid;
  String? vendorname;
  String? remarks;
  String? createdby;
  String? createdon;

  Vendors(
      {this.id,
      this.jobsldid,
      this.vendorid,
      this.vendorname,
      this.remarks,
      this.createdby,
      this.createdon});

  Vendors.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    jobsldid = json['Jobsldid'];
    vendorid = json['Vendorid'];
    vendorname = json['Vendorname'];
    remarks = json['Remarks'];
    createdby = json['Createdby'];
    createdon = json['Createdon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Jobsldid'] = jobsldid;
    data['Vendorid'] = vendorid;
    data['Vendorname'] = vendorname;
    data['Remarks'] = remarks;
    data['Createdby'] = createdby;
    data['Createdon'] = createdon;
    return data;
  }
}

class Payment {
  String? id;
  String? jobId;
  String? date;
  String? paymentType;
  String? paymentMode;
  String? paymenttransationid;
  String? amount;
  String? remark;

  Payment(
      {this.id,
      this.jobId,
      this.date,
      this.paymentType,
      this.paymentMode,
      this.paymenttransationid,
      this.amount,
      this.remark});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    jobId = json['JobId'];
    date = json['Date'];
    paymentType = json['PaymentType'];
    paymentMode = json['PaymentMode'];
    paymenttransationid = json['Paymenttransationid'];
    amount = json['Amount'];
    remark = json['Remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['JobId'] = jobId;
    data['Date'] = date;
    data['PaymentType'] = paymentType;
    data['PaymentMode'] = paymentMode;
    data['Paymenttransationid'] = paymenttransationid;
    data['Amount'] = amount;
    data['Remark'] = remark;
    return data;
  }
}

// class JobDetailModel {
//   String? id;
//   String? jobno;
//   String? jobdate;
//   String? customername;
//   String? companyname;
//   String? mobile;
//   String? email;
//   String? productid;
//   String? productname;
//   String? qty;
//   String? rate;
//   String? amount;
//   String? advance;
//   String? balance;
//   String? remark;
//   String? size;
//   String? deliverydate;
//   String? deliveryMode;
//   String? isUrgent;
//   String? storageLocation;
//   String? workDesign;
//   String? workPrint;
//   String? workFabrication;
//   String? workOther;
//   String? designby;
//   String? designdate;
//   String? printingby;
//   String? printingdate;
//   String? fabricationby;
//   String? fabricationdate;
//   String? vendorby;
//   String? vendordate;
//   String? designStatus;
//   String? printStatus;
//   String? fabricationStatus;
//   String? dispatchStatus;
//   String? days;
//   String? designerid;
//   String? printingid;
//   String? fabricationid;
//   String? vendorid;
//   String? dispatchremark;
//   String? designerremark;
//   String? printingremark;
//   String? fabricationremark;
//   String? vendorremark;
//   String? dispatchremarkupdate;
//   String? designerremarkupdate;
//   String? printingremarkupdate;
//   String? fabricationremarkupdate;
//   String? vendorremarkupdate;
//   String? designerupdatedate;
//   String? printingupdatedate;
//   String? fabricationupdatedate;
//   String? vendorupdatedate;
//   String? add1;
//   String? add2;
//   String? status;
//   String? link;
//   String? designCost;
//   String? createdby;
//   String? createdon;
//   String? editedby;
//   String? editedon;
//   String? approved;
//   String? approvedby;
//   String? approvedDate;
//   String? designReady;
//   String? lotno;
//   List<Services>? services;
//   List<Labels>? labels;
//   List<Vendors>? vendors;

//   JobDetailModel(
//       {this.id,
//       this.jobno,
//       this.jobdate,
//       this.customername,
//       this.companyname,
//       this.mobile,
//       this.email,
//       this.productid,
//       this.productname,
//       this.qty,
//       this.rate,
//       this.amount,
//       this.advance,
//       this.balance,
//       this.remark,
//       this.size,
//       this.deliverydate,
//       this.deliveryMode,
//       this.isUrgent,
//       this.storageLocation,
//       this.workDesign,
//       this.workPrint,
//       this.workFabrication,
//       this.workOther,
//       this.designby,
//       this.designdate,
//       this.printingby,
//       this.printingdate,
//       this.fabricationby,
//       this.fabricationdate,
//       this.vendorby,
//       this.vendordate,
//       this.designStatus,
//       this.printStatus,
//       this.fabricationStatus,
//       this.dispatchStatus,
//       this.days,
//       this.designerid,
//       this.printingid,
//       this.fabricationid,
//       this.vendorid,
//       this.dispatchremark,
//       this.designerremark,
//       this.printingremark,
//       this.fabricationremark,
//       this.vendorremark,
//       this.dispatchremarkupdate,
//       this.designerremarkupdate,
//       this.printingremarkupdate,
//       this.fabricationremarkupdate,
//       this.vendorremarkupdate,
//       this.designerupdatedate,
//       this.printingupdatedate,
//       this.fabricationupdatedate,
//       this.vendorupdatedate,
//       this.add1,
//       this.add2,
//       this.status,
//       this.link,
//       this.designCost,
//       this.createdby,
//       this.createdon,
//       this.editedby,
//       this.editedon,
//       this.approved,
//       this.approvedby,
//       this.approvedDate,
//       this.designReady,
//       this.lotno,
//       this.services,
//       this.labels,
//       this.vendors});

//   JobDetailModel.fromJson(Map<String, dynamic> json) {
//     id = json['Id'];
//     jobno = json['Jobno'];
//     jobdate = json['Jobdate'];
//     customername = json['Customername'];
//     companyname = json['Companyname'];
//     mobile = json['Mobile'];
//     email = json['Email'];
//     productid = json['Productid'];
//     productname = json['Productname'];
//     qty = json['Qty'];
//     rate = json['Rate'];
//     amount = json['Amount'];
//     advance = json['Advance'];
//     balance = json['Balance'];
//     remark = json['Remark'];
//     size = json['Size'];
//     deliverydate = json['Deliverydate'];
//     deliveryMode = json['DeliveryMode'];
//     isUrgent = json['IsUrgent'];
//     storageLocation = json['StorageLocation'];
//     workDesign = json['Work_design'];
//     workPrint = json['Work_print'];
//     workFabrication = json['Work_fabrication'];
//     workOther = json['Work_other'];
//     designby = json['Designby'];
//     designdate = json['Designdate'];
//     printingby = json['Printingby'];
//     printingdate = json['Printingdate'];
//     fabricationby = json['Fabricationby'];
//     fabricationdate = json['Fabricationdate'];
//     vendorby = json['Vendorby'];
//     vendordate = json['Vendordate'];
//     designStatus = json['DesignStatus'];
//     printStatus = json['PrintStatus'];
//     fabricationStatus = json['FabricationStatus'];
//     dispatchStatus = json['DispatchStatus'];
//     days = json['Days'];
//     designerid = json['Designerid'];
//     printingid = json['Printingid'];
//     fabricationid = json['Fabricationid'];
//     vendorid = json['Vendorid'];
//     dispatchremark = json['dispatchremark'];
//     designerremark = json['Designerremark'];
//     printingremark = json['Printingremark'];
//     fabricationremark = json['Fabricationremark'];
//     vendorremark = json['Vendorremark'];
//     dispatchremarkupdate = json['Dispatchremarkupdate'];
//     designerremarkupdate = json['Designerremarkupdate'];
//     printingremarkupdate = json['Printingremarkupdate'];
//     fabricationremarkupdate = json['Fabricationremarkupdate'];
//     vendorremarkupdate = json['Vendorremarkupdate'];
//     designerupdatedate = json['Designerupdatedate'];
//     printingupdatedate = json['Printingupdatedate'];
//     fabricationupdatedate = json['Fabricationupdatedate'];
//     vendorupdatedate = json['Vendorupdatedate'];
//     add1 = json['Add1'];
//     add2 = json['Add2'];
//     status = json['Status'];
//     link = json['Link'];
//     designCost = json['DesignCost'];
//     createdby = json['Createdby'];
//     createdon = json['Createdon'];
//     editedby = json['Editedby'];
//     editedon = json['Editedon'];
//     approved = json['Approved'];
//     approvedby = json['Approvedby'];
//     approvedDate = json['ApprovedDate'];
//     designReady = json['DesignReady'];
//     lotno = json['Lotno'];
//     if (json['Services'] != null) {
//       services = <Services>[];
//       json['Services'].forEach((v) {
//         services!.add(Services.fromJson(v));
//       });
//     }
//     if (json['Labels'] != null) {
//       labels = <Labels>[];
//       json['Labels'].forEach((v) {
//         labels!.add(Labels.fromJson(v));
//       });
//     }
//     if (json['Vendors'] != null) {
//       vendors = <Vendors>[];
//       json['Vendors'].forEach((v) {
//         vendors!.add(Vendors.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Id'] = id;
//     data['Jobno'] = jobno;
//     data['Jobdate'] = jobdate;
//     data['Customername'] = customername;
//     data['Companyname'] = companyname;
//     data['Mobile'] = mobile;
//     data['Email'] = email;
//     data['Productid'] = productid;
//     data['Productname'] = productname;
//     data['Qty'] = qty;
//     data['Rate'] = rate;
//     data['Amount'] = amount;
//     data['Advance'] = advance;
//     data['Balance'] = balance;
//     data['Remark'] = remark;
//     data['Size'] = size;
//     data['Deliverydate'] = deliverydate;
//     data['DeliveryMode'] = deliveryMode;
//     data['IsUrgent'] = isUrgent;
//     data['StorageLocation'] = storageLocation;
//     data['Work_design'] = workDesign;
//     data['Work_print'] = workPrint;
//     data['Work_fabrication'] = workFabrication;
//     data['Work_other'] = workOther;
//     data['Designby'] = designby;
//     data['Designdate'] = designdate;
//     data['Printingby'] = printingby;
//     data['Printingdate'] = printingdate;
//     data['Fabricationby'] = fabricationby;
//     data['Fabricationdate'] = fabricationdate;
//     data['Vendorby'] = vendorby;
//     data['Vendordate'] = vendordate;
//     data['DesignStatus'] = designStatus;
//     data['PrintStatus'] = printStatus;
//     data['FabricationStatus'] = fabricationStatus;
//     data['DispatchStatus'] = dispatchStatus;
//     data['Days'] = days;
//     data['Designerid'] = designerid;
//     data['Printingid'] = printingid;
//     data['Fabricationid'] = fabricationid;
//     data['Vendorid'] = vendorid;
//     data['dispatchremark'] = dispatchremark;
//     data['Designerremark'] = designerremark;
//     data['Printingremark'] = printingremark;
//     data['Fabricationremark'] = fabricationremark;
//     data['Vendorremark'] = vendorremark;
//     data['Dispatchremarkupdate'] = dispatchremarkupdate;
//     data['Designerremarkupdate'] = designerremarkupdate;
//     data['Printingremarkupdate'] = printingremarkupdate;
//     data['Fabricationremarkupdate'] = fabricationremarkupdate;
//     data['Vendorremarkupdate'] = vendorremarkupdate;
//     data['Designerupdatedate'] = designerupdatedate;
//     data['Printingupdatedate'] = printingupdatedate;
//     data['Fabricationupdatedate'] = fabricationupdatedate;
//     data['Vendorupdatedate'] = vendorupdatedate;
//     data['Add1'] = add1;
//     data['Add2'] = add2;
//     data['Status'] = status;
//     data['Link'] = link;
//     data['DesignCost'] = designCost;
//     data['Createdby'] = createdby;
//     data['Createdon'] = createdon;
//     data['Editedby'] = editedby;
//     data['Editedon'] = editedon;
//     data['Approved'] = approved;
//     data['Approvedby'] = approvedby;
//     data['ApprovedDate'] = approvedDate;
//     data['DesignReady'] = designReady;
//     data['Lotno'] = lotno;
//     if (services != null) {
//       data['Services'] = services!.map((v) => v.toJson()).toList();
//     }
//     if (labels != null) {
//       data['Labels'] = labels!.map((v) => v.toJson()).toList();
//     }
//     if (vendors != null) {
//       data['Vendors'] = vendors!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Services {
//   String? id;
//   String? jobID;
//   String? jobsldID;
//   String? productID;
//   String? jobProductServicesID;
//   String? jobProductServicesName;
//   String? jobProductServicesCategory;
//   String? jobServicesIngredientID;
//   String? jobServicesIngredientName;
//   String? servicesStatus;
//   String? servicesBy;
//   String? remarks;
//   String? userID;

//   Services(
//       {this.id,
//       this.jobID,
//       this.jobsldID,
//       this.productID,
//       this.jobProductServicesID,
//       this.jobProductServicesName,
//       this.jobProductServicesCategory,
//       this.jobServicesIngredientID,
//       this.jobServicesIngredientName,
//       this.servicesStatus,
//       this.servicesBy,
//       this.remarks,
//       this.userID});

//   Services.fromJson(Map<String, dynamic> json) {
//     id = json['Id'];
//     jobID = json['JobID'];
//     jobsldID = json['JobsldID'];
//     productID = json['ProductID'];
//     jobProductServicesID = json['Job_Product_Services_ID'];
//     jobProductServicesName = json['Job_Product_Services_Name'];
//     jobProductServicesCategory = json['Job_Product_Services_Category'];
//     jobServicesIngredientID = json['Job_Services_ingredient_ID'];
//     jobServicesIngredientName = json['Job_Services_ingredient_Name'];
//     servicesStatus = json['ServicesStatus'];
//     servicesBy = json['ServicesBy'];
//     remarks = json['Remarks'];
//     userID = json['UserID'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Id'] = id;
//     data['JobID'] = jobID;
//     data['JobsldID'] = jobsldID;
//     data['ProductID'] = productID;
//     data['Job_Product_Services_ID'] = jobProductServicesID;
//     data['Job_Product_Services_Name'] = jobProductServicesName;
//     data['Job_Product_Services_Category'] = jobProductServicesCategory;
//     data['Job_Services_ingredient_ID'] = jobServicesIngredientID;
//     data['Job_Services_ingredient_Name'] = jobServicesIngredientName;
//     data['ServicesStatus'] = servicesStatus;
//     data['ServicesBy'] = servicesBy;
//     data['Remarks'] = remarks;
//     data['UserID'] = userID;
//     return data;
//   }
// }

// class Labels {
//   String? id;
//   String? jobid;
//   String? joblabel;
//   String? keyId;
//   String? labelname;
//   String? labelcolour;
//   String? userid;

//   Labels(
//       {this.id,
//       this.jobid,
//       this.joblabel,
//       this.keyId,
//       this.labelname,
//       this.labelcolour,
//       this.userid});

//   Labels.fromJson(Map<String, dynamic> json) {
//     id = json['Id'];
//     jobid = json['Jobid'];
//     joblabel = json['Joblabel'];
//     keyId = json['KeyId'];
//     labelname = json['labelname'];
//     labelcolour = json['Labelcolour'];
//     userid = json['Userid'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Id'] = id;
//     data['Jobid'] = jobid;
//     data['Joblabel'] = joblabel;
//     data['KeyId'] = keyId;
//     data['labelname'] = labelname;
//     data['Labelcolour'] = labelcolour;
//     data['Userid'] = userid;
//     return data;
//   }
// }

// class Vendors {
//   String? id;
//   String? jobsldid;
//   String? vendorid;
//   String? vendorname;
//   String? remarks;
//   String? createdby;
//   String? createdon;

//   Vendors(
//       {this.id,
//       this.jobsldid,
//       this.vendorid,
//       this.vendorname,
//       this.remarks,
//       this.createdby,
//       this.createdon});

//   Vendors.fromJson(Map<String, dynamic> json) {
//     id = json['Id'];
//     jobsldid = json['Jobsldid'];
//     vendorid = json['Vendorid'];
//     vendorname = json['Vendorname'];
//     remarks = json['Remarks'];
//     createdby = json['Createdby'];
//     createdon = json['Createdon'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Id'] = id;
//     data['Jobsldid'] = jobsldid;
//     data['Vendorid'] = vendorid;
//     data['Vendorname'] = vendorname;
//     data['Remarks'] = remarks;
//     data['Createdby'] = createdby;
//     data['Createdon'] = createdon;
//     return data;
//   }
// }

class JobAttachmentModel {
  String? id;
  String? imageBase64;
  String? imagePath;
  String? xpixel;
  String? ypixel;
  String? filenameprefix;
  String? ext;

  JobAttachmentModel(
      {this.id,
      this.imageBase64,
      this.imagePath,
      this.xpixel,
      this.ypixel,
      this.filenameprefix,
      this.ext});

  JobAttachmentModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    imageBase64 = json['ImageBase64'];
    imagePath = json['ImagePath'];
    xpixel = json['Xpixel'];
    ypixel = json['Ypixel'];
    filenameprefix = json['Filenameprefix'];
    ext = json['ext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ImageBase64'] = imageBase64;
    data['ImagePath'] = imagePath;
    data['Xpixel'] = xpixel;
    data['Ypixel'] = ypixel;
    data['Filenameprefix'] = filenameprefix;
    data['ext'] = ext;
    return data;
  }
}
