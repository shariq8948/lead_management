import 'package:get/get.dart';

class ItemModel {
  String id;
  String name;
  String code;
  double saleRate;
  RxBool isSelected;
  int qty;
  double discount;
  double total;
  double taxable;
  double gst;

  ItemModel({
    required this.id,
    required this.name,
    required this.code,
    required this.saleRate,
    bool isSelected = false,
    this.qty = 1,
    this.discount = 0.0,
    this.total = 0.0,
    this.taxable = 0.0,
    this.gst = 0.0,
  }) : isSelected = RxBool(isSelected);

  @override
  String toString() {
    return 'ItemModel(name: $name, code: $code, saleRate: $saleRate, qty: $qty, discount: $discount, total: $total, taxable: $taxable, gst: $gst)';
  }
}
