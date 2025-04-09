class ProductDetailModel {
  String? id;
  String? sn;
  String? iname;
  String? icode;
  String? autocode;
  String? igroup;
  String? subigroup;
  String? undergroup;
  String? undergroupid;
  String? company;
  String? minqty;
  String? maxqty;
  String? stax;
  String? ptax;
  String? packing;
  String? boxsize;
  String? unit;
  String? srate;
  String? prate;
  String? cqty1;
  String? opqty;
  String? lotno;
  String? rate1;
  String? netrate;
  String? rate3;
  String? rate4;
  String? rate5;
  String? rate6;
  String? rate7;
  String? rate8;
  String? rate9;
  String? rate10;
  String? rate11;
  String? rate12;
  String? sname;
  String? itemdisc;
  String? remark1;
  String? remark2;
  String? remark3;
  String? remark4;
  String? remark5;
  String? pwp;
  String? barcode;
  String? imagepath;
  String? itype;
  String? ssize;
  String? syn;
  String? appimagepath;
  String? drugschedule;
  String? selfno;
  String? mrp;
  String? cprate;
  String? itemforapp;
  String? companyId;
  String? unitId;
  String? staxId;
  String? pTaxId;
  String? packingId;
  String? hsnId;
  String? hsncode;
  String? igroupId;
  String? newproduct;
  String? bestsellerproduct;
  String? toprated;
  String? createdby;
  String? createdon;
  String? modifiedby;
  String? modifiedon;
  String? imageurl;
  String? smallimageurl;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? filetype;
  String? services;
  String? minorderqty;
  String? maxorderqty;
  String? ispackagingmaterial;
  String? approvalstatus;
  String? approvedon;
  String? isapproved;
  String? approvalremark;
  String? username;
  String? message;
  String? action;
  String? size;
  String? cess;
  String? isduplicateupdated;
  String? property;

  ProductDetailModel(
      {this.id,
      this.sn,
      this.iname,
      this.icode,
      this.autocode,
      this.igroup,
      this.subigroup,
      this.undergroup,
      this.undergroupid,
      this.company,
      this.minqty,
      this.maxqty,
      this.stax,
      this.ptax,
      this.packing,
      this.boxsize,
      this.unit,
      this.srate,
      this.prate,
      this.cqty1,
      this.opqty,
      this.lotno,
      this.rate1,
      this.netrate,
      this.rate3,
      this.rate4,
      this.rate5,
      this.rate6,
      this.rate7,
      this.rate8,
      this.rate9,
      this.rate10,
      this.rate11,
      this.rate12,
      this.sname,
      this.itemdisc,
      this.remark1,
      this.remark2,
      this.remark3,
      this.remark4,
      this.remark5,
      this.pwp,
      this.barcode,
      this.imagepath,
      this.itype,
      this.ssize,
      this.syn,
      this.appimagepath,
      this.drugschedule,
      this.selfno,
      this.mrp,
      this.cprate,
      this.itemforapp,
      this.companyId,
      this.unitId,
      this.staxId,
      this.pTaxId,
      this.packingId,
      this.hsnId,
      this.hsncode,
      this.igroupId,
      this.newproduct,
      this.bestsellerproduct,
      this.toprated,
      this.createdby,
      this.createdon,
      this.modifiedby,
      this.modifiedon,
      this.imageurl,
      this.smallimageurl,
      this.image1,
      this.image2,
      this.image3,
      this.image4,
      this.filetype,
      this.services,
      this.minorderqty,
      this.maxorderqty,
      this.ispackagingmaterial,
      this.approvalstatus,
      this.approvedon,
      this.isapproved,
      this.approvalremark,
      this.username,
      this.message,
      this.action,
      this.size,
      this.cess,
      this.isduplicateupdated,
      this.property});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sn = json['sn'];
    iname = json['iname'];
    icode = json['icode'];
    autocode = json['autocode'];
    igroup = json['igroup'];
    subigroup = json['subigroup'];
    undergroup = json['undergroup'];
    undergroupid = json['undergroupid'];
    company = json['company'];
    minqty = json['minqty'];
    maxqty = json['maxqty'];
    stax = json['stax'];
    ptax = json['ptax'];
    packing = json['packing'];
    boxsize = json['boxsize'];
    unit = json['unit'];
    srate = json['srate'];
    prate = json['prate'];
    cqty1 = json['cqty1'];
    opqty = json['opqty'];
    lotno = json['lotno'];
    rate1 = json['rate1'];
    netrate = json['netrate'];
    rate3 = json['rate3'];
    rate4 = json['rate4'];
    rate5 = json['rate5'];
    rate6 = json['rate6'];
    rate7 = json['rate7'];
    rate8 = json['rate8'];
    rate9 = json['rate9'];
    rate10 = json['rate10'];
    rate11 = json['rate11'];
    rate12 = json['rate12'];
    sname = json['sname'];
    itemdisc = json['itemdisc'];
    remark1 = json['remark1'];
    remark2 = json['remark2'];
    remark3 = json['remark3'];
    remark4 = json['remark4'];
    remark5 = json['remark5'];
    pwp = json['pwp'];
    barcode = json['barcode'];
    imagepath = json['imagepath'];
    itype = json['itype'];
    ssize = json['ssize'];
    syn = json['syn'];
    appimagepath = json['appimagepath'];
    drugschedule = json['drugschedule'];
    selfno = json['selfno'];
    mrp = json['mrp'];
    cprate = json['cprate'];
    itemforapp = json['itemforapp'];
    companyId = json['companyId'];
    unitId = json['unitId'];
    staxId = json['staxId'];
    pTaxId = json['pTaxId'];
    packingId = json['packingId'];
    hsnId = json['hsnId'];
    hsncode = json['hsncode'];
    igroupId = json['igroupId'];
    newproduct = json['newproduct'];
    bestsellerproduct = json['bestsellerproduct'];
    toprated = json['toprated'];
    createdby = json['createdby'];
    createdon = json['createdon'];
    modifiedby = json['modifiedby'];
    modifiedon = json['modifiedon'];
    imageurl = json['imageurl'];
    smallimageurl = json['smallimageurl'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    image4 = json['image4'];
    filetype = json['filetype'];
    services = json['services'];
    minorderqty = json['minorderqty'];
    maxorderqty = json['maxorderqty'];
    ispackagingmaterial = json['ispackagingmaterial'];
    approvalstatus = json['approvalstatus'];
    approvedon = json['approvedon'];
    isapproved = json['isapproved'];
    approvalremark = json['approvalremark'];
    username = json['username'];
    message = json['message'];
    action = json['action'];
    size = json['size'];
    cess = json['cess'];
    isduplicateupdated = json['isduplicateupdated'];
    property = json['property'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sn'] = this.sn;
    data['iname'] = this.iname;
    data['icode'] = this.icode;
    data['autocode'] = this.autocode;
    data['igroup'] = this.igroup;
    data['subigroup'] = this.subigroup;
    data['undergroup'] = this.undergroup;
    data['undergroupid'] = this.undergroupid;
    data['company'] = this.company;
    data['minqty'] = this.minqty;
    data['maxqty'] = this.maxqty;
    data['stax'] = this.stax;
    data['ptax'] = this.ptax;
    data['packing'] = this.packing;
    data['boxsize'] = this.boxsize;
    data['unit'] = this.unit;
    data['srate'] = this.srate;
    data['prate'] = this.prate;
    data['cqty1'] = this.cqty1;
    data['opqty'] = this.opqty;
    data['lotno'] = this.lotno;
    data['rate1'] = this.rate1;
    data['netrate'] = this.netrate;
    data['rate3'] = this.rate3;
    data['rate4'] = this.rate4;
    data['rate5'] = this.rate5;
    data['rate6'] = this.rate6;
    data['rate7'] = this.rate7;
    data['rate8'] = this.rate8;
    data['rate9'] = this.rate9;
    data['rate10'] = this.rate10;
    data['rate11'] = this.rate11;
    data['rate12'] = this.rate12;
    data['sname'] = this.sname;
    data['itemdisc'] = this.itemdisc;
    data['remark1'] = this.remark1;
    data['remark2'] = this.remark2;
    data['remark3'] = this.remark3;
    data['remark4'] = this.remark4;
    data['remark5'] = this.remark5;
    data['pwp'] = this.pwp;
    data['barcode'] = this.barcode;
    data['imagepath'] = this.imagepath;
    data['itype'] = this.itype;
    data['ssize'] = this.ssize;
    data['syn'] = this.syn;
    data['appimagepath'] = this.appimagepath;
    data['drugschedule'] = this.drugschedule;
    data['selfno'] = this.selfno;
    data['mrp'] = this.mrp;
    data['cprate'] = this.cprate;
    data['itemforapp'] = this.itemforapp;
    data['companyId'] = this.companyId;
    data['unitId'] = this.unitId;
    data['staxId'] = this.staxId;
    data['pTaxId'] = this.pTaxId;
    data['packingId'] = this.packingId;
    data['hsnId'] = this.hsnId;
    data['hsncode'] = this.hsncode;
    data['igroupId'] = this.igroupId;
    data['newproduct'] = this.newproduct;
    data['bestsellerproduct'] = this.bestsellerproduct;
    data['toprated'] = this.toprated;
    data['createdby'] = this.createdby;
    data['createdon'] = this.createdon;
    data['modifiedby'] = this.modifiedby;
    data['modifiedon'] = this.modifiedon;
    data['imageurl'] = this.imageurl;
    data['smallimageurl'] = this.smallimageurl;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    data['image4'] = this.image4;
    data['filetype'] = this.filetype;
    data['services'] = this.services;
    data['minorderqty'] = this.minorderqty;
    data['maxorderqty'] = this.maxorderqty;
    data['ispackagingmaterial'] = this.ispackagingmaterial;
    data['approvalstatus'] = this.approvalstatus;
    data['approvedon'] = this.approvedon;
    data['isapproved'] = this.isapproved;
    data['approvalremark'] = this.approvalremark;
    data['username'] = this.username;
    data['message'] = this.message;
    data['action'] = this.action;
    data['size'] = this.size;
    data['cess'] = this.cess;
    data['isduplicateupdated'] = this.isduplicateupdated;
    data['property'] = this.property;
    return data;
  }
}
