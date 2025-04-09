import 'dart:convert';

class Quotation {
  String? id;
  String? quotNo;
  String? quotDate;
  String? utype;
  String? custName;
  String? custMobile;
  String? custEmail;
  String? custAddress;
  String? acno;
  String? custId;
  String? kindAtt;
  String? refNo;
  String? discRate;
  String? spDiscount;
  String? cdRate;
  String? cdDiscount;
  String? iDiscount;
  String? fright;
  String? drCr;
  String? addTotal;
  String? ftax;
  String? ftaxId;
  String? cashAdv;
  String? roundOff;
  String? cessAmt;
  String? other;
  String? desp1;
  String? desp2;
  String? desp3;
  String? desp4;
  String? dest1;
  String? dest2;
  String? dest3;
  String? dest4;
  String? despDocNo;
  String? term1;
  String? term2;
  String? term3;
  String? term4;
  String? term5;
  String? term6;
  String? term7;
  String? term8;
  String? term9;
  String? term10;
  String? netValue;
  String? discount;
  String? sgstAmt;
  String? cgstAmt;
  String? igstAmt;
  String? bAmt;
  String? remark;
  String? dpId;
  String? smanId;
  String? revice;
  String? noOfItem;
  String? inquiryRefNo;
  String? approvalStatus;
  String? approvedOn;
  String? isApproved;
  String? approvalRemark;
  String? userName;
  String? customerType;
  String? exportStatus;
  String? isFullExported;
  String? followupStatus;
  String? importedInqNo;

  Quotation({
    this.id,
    this.quotNo,
    this.quotDate,
    this.utype,
    this.custName,
    this.custMobile,
    this.custEmail,
    this.custAddress,
    this.acno,
    this.custId,
    this.kindAtt,
    this.refNo,
    this.discRate,
    this.spDiscount,
    this.cdRate,
    this.cdDiscount,
    this.iDiscount,
    this.fright,
    this.drCr,
    this.addTotal,
    this.ftax,
    this.ftaxId,
    this.cashAdv,
    this.roundOff,
    this.cessAmt,
    this.other,
    this.desp1,
    this.desp2,
    this.desp3,
    this.desp4,
    this.dest1,
    this.dest2,
    this.dest3,
    this.dest4,
    this.despDocNo,
    this.term1,
    this.term2,
    this.term3,
    this.term4,
    this.term5,
    this.term6,
    this.term7,
    this.term8,
    this.term9,
    this.term10,
    this.netValue,
    this.discount,
    this.sgstAmt,
    this.cgstAmt,
    this.igstAmt,
    this.bAmt,
    this.remark,
    this.dpId,
    this.smanId,
    this.revice,
    this.noOfItem,
    this.inquiryRefNo,
    this.approvalStatus,
    this.approvedOn,
    this.isApproved,
    this.approvalRemark,
    this.userName,
    this.customerType,
    this.exportStatus,
    this.isFullExported,
    this.followupStatus,
    this.importedInqNo,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) => Quotation(
        id: json["Id"],
        quotNo: json["QuotNo"],
        quotDate: json["QuotDate"],
        utype: json["utype"],
        custName: json["CustName"],
        custMobile: json["Custmobile"],
        custEmail: json["Custemail"],
        custAddress: json["Custaddress"],
        acno: json["Acno"],
        custId: json["CustId"],
        kindAtt: json["KindAtt"],
        refNo: json["RefNo"],
        discRate: json["Discrate"],
        spDiscount: json["Spdiscount"],
        cdRate: json["Cd_rate"],
        cdDiscount: json["Cddiscount"],
        iDiscount: json["Idiscount"],
        fright: json["Fright"],
        drCr: json["Drcr"],
        addTotal: json["Addtotal"],
        ftax: json["Ftax"],
        ftaxId: json["Ftaxid"],
        cashAdv: json["Cashadv"],
        roundOff: json["Roundoff"],
        cessAmt: json["Cessamt"],
        other: json["Other"],
        desp1: json["Desp1"],
        desp2: json["Desp2"],
        desp3: json["Desp3"],
        desp4: json["Desp4"],
        dest1: json["Dest1"],
        dest2: json["Dest2"],
        dest3: json["Dest3"],
        dest4: json["Dest4"],
        despDocNo: json["DespDocno"],
        term1: json["Term1"],
        term2: json["Term2"],
        term3: json["Term3"],
        term4: json["Term4"],
        term5: json["Term5"],
        term6: json["Term6"],
        term7: json["Term7"],
        term8: json["Term8"],
        term9: json["Term9"],
        term10: json["Term10"],
        netValue: json["netvalue"],
        discount: json["Discount"],
        sgstAmt: json["SGSTAMT"],
        cgstAmt: json["CGSTAMT"],
        igstAmt: json["IGSTAMT"],
        bAmt: json["BAmt"],
        remark: json["Remark"],
        dpId: json["Dpid"],
        smanId: json["Smanid"],
        revice: json["Revice"],
        noOfItem: json["NoOFITem"],
        inquiryRefNo: json["Inquiryrefno"],
        approvalStatus: json["Approvalstatus"],
        approvedOn: json["Approvedon"],
        isApproved: json["Isapproved"],
        approvalRemark: json["Approvalremark"],
        userName: json["Username"],
        customerType: json["Customertype"],
        exportStatus: json["Exportstatus"],
        isFullExported: json["Isfullexported"],
        followupStatus: json["Followupstatus"],
        importedInqNo: json["ImportedInqno"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "QuotNo": quotNo,
        "QuotDate": quotDate,
        "utype": utype,
        "CustName": custName,
        "Custmobile": custMobile,
        "Custemail": custEmail,
        "Custaddress": custAddress,
        "Acno": acno,
        "CustId": custId,
        "KindAtt": kindAtt,
        "RefNo": refNo,
        "Discrate": discRate,
        "Spdiscount": spDiscount,
        "Cd_rate": cdRate,
        "Cddiscount": cdDiscount,
        "Idiscount": iDiscount,
        "Fright": fright,
        "Drcr": drCr,
        "Addtotal": addTotal,
        "Ftax": ftax,
        "Ftaxid": ftaxId,
        "Cashadv": cashAdv,
        "Roundoff": roundOff,
        "Cessamt": cessAmt,
        "Other": other,
        "Desp1": desp1,
        "Desp2": desp2,
        "Desp3": desp3,
        "Desp4": desp4,
        "Dest1": dest1,
        "Dest2": dest2,
        "Dest3": dest3,
        "Dest4": dest4,
        "DespDocno": despDocNo,
        "Term1": term1,
        "Term2": term2,
        "Term3": term3,
        "Term4": term4,
        "Term5": term5,
        "Term6": term6,
        "Term7": term7,
        "Term8": term8,
        "Term9": term9,
        "Term10": term10,
        "netvalue": netValue,
        "Discount": discount,
        "SGSTAMT": sgstAmt,
        "CGSTAMT": cgstAmt,
        "IGSTAMT": igstAmt,
        "BAmt": bAmt,
        "Remark": remark,
        "Dpid": dpId,
        "Smanid": smanId,
        "Revice": revice,
        "NoOFITem": noOfItem,
        "Inquiryrefno": inquiryRefNo,
        "Approvalstatus": approvalStatus,
        "Approvedon": approvedOn,
        "Isapproved": isApproved,
        "Approvalremark": approvalRemark,
        "Username": userName,
        "Customertype": customerType,
        "Exportstatus": exportStatus,
        "Isfullexported": isFullExported,
        "Followupstatus": followupStatus,
        "ImportedInqno": importedInqNo,
      };
}

// Function to parse JSON list into List<Quotation>
List<Quotation> quotationFromJson(String str) => List<Quotation>.from(
    json.decode(str)["data"].map((x) => Quotation.fromJson(x)));

// Function to convert List<Quotation> into JSON string
String quotationToJson(List<Quotation> data) =>
    json.encode({"data": List<dynamic>.from(data.map((x) => x.toJson()))});
