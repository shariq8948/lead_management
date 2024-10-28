class ProductModel {
  String? id;
  String? code;
  String? productId;
  String? userId;
  String? product;
  String? categoryId;
  String? category;
  String? gST;
  String? unit;
  String? unitId;
  String? remarks;
  String? x;
  String? y;
  String? qty1;
  String? rate1;
  String? qty2;
  String? rate2;
  String? qty3;
  String? rate3;
  String? qty4;
  String? rate4;
  String? lastrate;
  String? lastJobId;
  String? message;

  ProductModel({
    this.id,
    this.code,
    this.productId,
    this.userId,
    this.product,
    this.categoryId,
    this.category,
    this.gST,
    this.unit,
    this.unitId,
    this.remarks,
    this.x,
    this.y,
    this.qty1,
    this.rate1,
    this.qty2,
    this.rate2,
    this.qty3,
    this.rate3,
    this.qty4,
    this.rate4,
    this.lastrate,
    this.lastJobId,
    this.message,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    code = json['Code'];
    productId = json['ProductId'];
    userId = json['UserId'];
    product = json['Product'];
    categoryId = json['CategoryId'];
    category = json['Category'];
    gST = json['GST'];
    unit = json['Unit'];
    unitId = json['UnitId'];
    remarks = json['Remarks'];
    x = json['X'];
    y = json['Y'];
    qty1 = json['Qty1'];
    rate1 = json['Rate1'];
    qty2 = json['Qty2'];
    rate2 = json['Rate2'];
    qty3 = json['Qty3'];
    rate3 = json['Rate3'];
    qty4 = json['Qty4'];
    rate4 = json['Rate4'];
    lastrate = json['Lastrate'];
    lastJobId = json['LastJobId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Code'] = code;
    data['ProductId'] = productId;
    data['UserId'] = userId;
    data['Product'] = product;
    data['CategoryId'] = categoryId;
    data['Category'] = category;
    data['GST'] = gST;
    data['Unit'] = unit;
    data['UnitId'] = unitId;
    data['Remarks'] = remarks;
    data['X'] = x;
    data['Y'] = y;
    data['Qty1'] = qty1;
    data['Rate1'] = rate1;
    data['Qty2'] = qty2;
    data['Rate2'] = rate2;
    data['Qty3'] = qty3;
    data['Rate3'] = rate3;
    data['Qty4'] = qty4;
    data['Rate4'] = rate4;
    data['Lastrate'] = lastrate;
    data['LastJobId'] = lastJobId;
    return data;
  }
}
