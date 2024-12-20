class QuotationFollowUpModel {
  final String? id;
  final String? quotNo;
  final String? quotDate;
  final String? utype;
  final String? custName;
  final String? custMobile;
  final String? custEmail;
  final String? custAddress;
  final String? acno;
  final String? custId;
  final String? kindAtt;
  final String? refNo;
  final String? discrate;
  final String? spDiscount;
  final String? cdRate;
  final String? cdDiscount;
  final String? iDiscount;
  final String? fright;
  final String? drCr;
  final String? addTotal;
  final String? ftax;
  final String? ftaxId;
  final String? cashAdv;
  final String? roundOff;
  final String? cessAmt;
  final String? other;
  final String? desp1;
  final String? desp2;
  final String? desp3;
  final String? desp4;
  final String? dest1;
  final String? dest2;
  final String? dest3;
  final String? dest4;
  final String? despDocNo;
  final String? term1;
  final String? term2;
  final String? term3;
  final String? term4;
  final String? term5;
  final String? term6;
  final String? term7;
  final String? term8;
  final String? term9;
  final String? term10;
  final String? netValue;
  final String? discount;
  final String? sgstAmt;
  final String? cgstAmt;
  final String? igstAmt;
  final String? bAmt;
  final String? remark;
  final String? dpId;
  final String? smanId;
  final String? revice;
  final String? noOfItem;
  final String? inquiryRefNo;
  final String? approvalStatus;
  final String? approvedOn;
  final String? isApproved;
  final String? approvalRemark;
  final String? userName;
  final String? customerType;
  final String? exportStatus;
  final String? isFullExported;
  final String? followUpStatus;
  final String? importedInqNo;

  QuotationFollowUpModel({
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
    this.discrate,
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
    this.followUpStatus,
    this.importedInqNo,
  });

  factory QuotationFollowUpModel.fromJson(Map<String, dynamic> json) {
    return QuotationFollowUpModel(
      id: json['Id'],
      quotNo: json['QuotNo'],
      quotDate: json['QuotDate'],
      utype: json['utype'],
      custName: json['CustName'],
      custMobile: json['Custmobile'],
      custEmail: json['Custemail'],
      custAddress: json['Custaddress'],
      acno: json['Acno'],
      custId: json['CustId'],
      kindAtt: json['KindAtt'],
      refNo: json['RefNo'],
      discrate: json['Discrate'],
      spDiscount: json['Spdiscount'],
      cdRate: json['Cd_rate'],
      cdDiscount: json['Cddiscount'],
      iDiscount: json['Idiscount'],
      fright: json['Fright'],
      drCr: json['Drcr'],
      addTotal: json['Addtotal'],
      ftax: json['Ftax'],
      ftaxId: json['Ftaxid'],
      cashAdv: json['Cashadv'],
      roundOff: json['Roundoff'],
      cessAmt: json['Cessamt'],
      other: json['Other'],
      desp1: json['Desp1'],
      desp2: json['Desp2'],
      desp3: json['Desp3'],
      desp4: json['Desp4'],
      dest1: json['Dest1'],
      dest2: json['Dest2'],
      dest3: json['Dest3'],
      dest4: json['Dest4'],
      despDocNo: json['DespDocno'],
      term1: json['Term1'],
      term2: json['Term2'],
      term3: json['Term3'],
      term4: json['Term4'],
      term5: json['Term5'],
      term6: json['Term6'],
      term7: json['Term7'],
      term8: json['Term8'],
      term9: json['Term9'],
      term10: json['Term10'],
      netValue: json['netvalue'],
      discount: json['Discount'],
      sgstAmt: json['SGSTAMT'],
      cgstAmt: json['CGSTAMT'],
      igstAmt: json['IGSTAMT'],
      bAmt: json['BAmt'],
      remark: json['Remark'],
      dpId: json['Dpid'],
      smanId: json['Smanid'],
      revice: json['Revice'],
      noOfItem: json['NoOFITem'],
      inquiryRefNo: json['Inquiryrefno'],
      approvalStatus: json['Approvalstatus'],
      approvedOn: json['Approvedon'],
      isApproved: json['Isapproved'],
      approvalRemark: json['Approvalremark'],
      userName: json['Username'],
      customerType: json['Customertype'],
      exportStatus: json['Exportstatus'],
      isFullExported: json['Isfullexported'],
      followUpStatus: json['Followupstatus'],
      importedInqNo: json['ImportedInqno'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      "Discrate": discrate,
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
      "Followupstatus": followUpStatus,
      "ImportedInqno": importedInqNo,
    };
  }
}
