class OrderItems {
  final String itemId;
  final String iCode;
  final String quantity;
  final String free;
  final String rate;
  final String discount;
  final String total;
  final String taxableValue;
  final String gst;
  final String customerId;
  final String orderBy;
  final String cgstAmount;
  final String sgstAmount;
  final String igstAmount;
  final String sTotal;
  final String baseAmount;
  final String mrId;
  final String userId;
  final String other;
  final String fright;
  final String remark;

  OrderItems({
    required this.itemId,
    required this.iCode,
    required this.quantity,
    required this.free,
    required this.rate,
    required this.discount,
    required this.total,
    required this.taxableValue,
    required this.gst,
    required this.customerId,
    required this.orderBy,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.igstAmount,
    required this.sTotal,
    required this.baseAmount,
    required this.mrId,
    required this.userId,
    required this.other,
    required this.fright,
    required this.remark,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
      itemId: json['Id']?.toString() ?? "",
      iCode: json['Icode'] ?? "",
      quantity: json['Qty']?.toString() ?? "0",
      free: json['Free']?.toString() ?? "0",
      rate: json['Prate']?.toString() ?? "0",
      discount: json['Discount']?.toString() ?? "0",
      total: json['Total']?.toString() ?? "0",
      taxableValue: json['taxablevalue']?.toString() ?? "0",
      gst: json['gst_rate']?.toString() ?? "0",
      customerId: json['Custid'] ?? "",
      orderBy: json['Orderby'] ?? "",
      cgstAmount: json['Cgstamt']?.toString() ?? "0",
      sgstAmount: json['Sgstamt']?.toString() ?? "0",
      igstAmount: json['Igstamt']?.toString() ?? "0",
      sTotal: json['STotal']?.toString() ?? "0",
      baseAmount: json['Bamt']?.toString() ?? "0",
      mrId: json['Mrid']?.toString() ?? "",
      userId: json['Userid']?.toString() ?? "",
      other: json['Other']?.toString() ?? "0",
      fright: json['Fright']?.toString() ?? "0",
      remark: json['Remark'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': itemId,
      'Icode': iCode,
      'Qty': quantity,
      'Free': free,
      'Prate': rate,
      'Discount': discount,
      'Total': total,
      'taxablevalue': taxableValue,
      'gst_rate': gst,
      'Custid': customerId,
      'Orderby': orderBy,
      'Cgstamt': cgstAmount,
      'Sgstamt': sgstAmount,
      'Igstamt': igstAmount,
      'STotal': sTotal,
      'Bamt': baseAmount,
      'Mrid': mrId,
      'Userid': userId,
      'Other': other,
      'Fright': fright,
      'Remark': remark,
    };
  }

  static List<OrderItems> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OrderItems.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<OrderItems> items) {
    return items.map((item) => item.toJson()).toList();
  }
}
