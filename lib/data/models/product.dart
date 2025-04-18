import 'package:flutter/material.dart'; // Required for TextEditingController
import 'package:get/get.dart';

class Products1 {
  final String id;
  final String? sN;
  final String iname;
  final String? icode;
  final String? autocode;
  final String igroup;
  final String? subigroup;
  final String undergroup;
  final String? undergroupid;
  final String company;
  final String minqty;
  final String maxqty;
  final String stax;
  final String ptax;
  final String packing;
  final String boxsize;
  final String unit;
  final String prate;
  final String rate1;
  final String netrate;
  final String? mrp;
  final String sname;
  final String? imageUrl;
  final String? Imagepath;
  final String? approvalstatus;
  final String? approvedon;
  final String? isapproved;
  final String username;
  RxBool isSelected;
  RxInt qty = RxInt(1); // Default quantity
  RxDouble discount = RxDouble(0); // Default discount
  double customerDiscount;

  // Controllers for managing text input
  late TextEditingController qtyController;
  late TextEditingController discountController;

  // Update quantity with validation
  void updateQuantity(String value) {
    int newQty = int.tryParse(value) ?? 1;
    if (newQty > 0) {
      qty.value = newQty;
      if (qtyController.text != newQty.toString()) {
        qtyController.text = newQty.toString();
      }
    }
  }

  // Update discount with validation
  void updateDiscount(String value) {
    double newDiscount = double.tryParse(value) ?? 0.0;
    if (newDiscount >= 0 && newDiscount <= 100) {
      discount.value = newDiscount;
      discountController.text = newDiscount.toString();
    }
  }

  Products1({
    required this.id,
    this.sN,
    this.imageUrl,
    this.mrp,
    this.Imagepath,
    required this.iname,
    this.icode,
    this.autocode,
    required this.igroup,
    this.subigroup,
    required this.undergroup,
    this.undergroupid,
    required this.company,
    required this.minqty,
    required this.maxqty,
    required this.stax,
    required this.ptax,
    required this.packing,
    required this.boxsize,
    required this.unit,
    required this.prate,
    required this.rate1,
    required this.netrate,
    required this.sname,
    this.approvalstatus,
    this.approvedon,
    this.isapproved,
    required this.username,
    bool isSelected = false,
    int qty = 1, // Default qty is 1
    double discount = 0, // Default discount is 0
    this.customerDiscount = 0.0,
  })  : isSelected = RxBool(isSelected),
        qty = RxInt(qty),
        discount = RxDouble(discount),
        // Initialize controllers with default values.  The text is set later in fromJson
        qtyController = TextEditingController(),
        discountController = TextEditingController();

  factory Products1.fromJson(Map<String, dynamic> json) {
    return Products1(
      id: json['Id'] ?? '',
      sN: json['SN'],
      mrp: json['Mrp'],
      imageUrl: json['Imageurl'],
      Imagepath: json['Imagepath'],
      iname: json['Iname'] ?? '',
      icode: json['Icode'],
      autocode: json['Autocode'],
      igroup: json['Igroup'] ?? '',
      subigroup: json['Subigroup'],
      undergroup: json['Undergroup'] ?? '',
      undergroupid: json['Undergroupid'],
      company: json['Company'] ?? '',
      minqty: json['Minqty'] ?? '',
      maxqty: json['Maxqty'] ?? '',
      stax: json['Stax'] ?? '',
      ptax: json['Ptax'] ?? '',
      packing: json['Packing'] ?? '',
      boxsize: json['Boxsize'] ?? '',
      unit: json['Unit'] ?? '',
      prate: json['Prate'] ?? '',
      rate1: json['Rate1'] ?? '',
      netrate: json['Netrate'] ?? '',
      sname: json['Sname'] ?? '',
      approvalstatus: json['Approvalstatus'],
      approvedon: json['Approvedon'],
      isapproved: json['Isapproved'],
      username: json['Username'] ?? '',
      qty:
          int.tryParse(json['Qty']?.toString() ?? '1') ?? 1, // Safely parse qty
      discount: double.tryParse(json['Discount']?.toString() ?? '0') ??
          0.0, // Safely parse discount
    )
      ..qtyController.text = (json['Qty'] ?? 1).toString()
      ..discountController.text = (json['Discount'] ?? 0.0).toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'SN': sN,
      'Mrp': mrp,
      'Imageurl': imageUrl,
      'Imagepath': Imagepath,
      'Iname': iname,
      'Icode': icode,
      'Autocode': autocode,
      'Igroup': igroup,
      'Subigroup': subigroup,
      'Undergroup': undergroup,
      'Undergroupid': undergroupid,
      'Company': company,
      'Minqty': minqty,
      'Maxqty': maxqty,
      'Stax': stax,
      'Ptax': ptax,
      'Packing': packing,
      'Boxsize': boxsize,
      'Unit': unit,
      'Prate': prate,
      'Rate1': rate1,
      'Netrate': netrate,
      'Sname': sname,
      'Approvalstatus': approvalstatus,
      'Approvedon': approvedon,
      'Isapproved': isapproved,
      'Username': username,
      'Qty': qty.value, // Include RxInt value
      'Discount': discount.value, // Include RxDouble value
    };
  }
}
