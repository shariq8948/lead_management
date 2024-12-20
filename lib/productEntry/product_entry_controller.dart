import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/product_list.model.dart';
class ProductEntryController extends GetxController{
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxString productId = "".obs;
  final jobEdtCtlr = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Rx<ProductModel?> selectedProduct = (null as ProductModel?).obs;
  @override
  void onInit() {
    super.onInit();
    products.addAll([
      ProductModel(
        id: '1',
        code: 'P001',
        productId: '101',
        userId: 'U001',
        product: 'Product A',
        categoryId: 'C001',
        category: 'Electronics',
        gST: '18%',
        unit: 'Piece',
        unitId: 'U1',
        remarks: 'High quality',
        qty1: '10',
        rate1: '100',
        qty2: '5',
        rate2: '95',
        qty3: '20',
        rate3: '90',
        lastrate: '85',
        lastJobId: 'J001',
        message: 'Special discount',
      ),
      ProductModel(
        id: '2',
        code: 'P002',
        productId: '102',
        userId: 'U002',
        product: 'Product B',
        categoryId: 'C002',
        category: 'Furniture',
        gST: '12%',
        unit: 'Set',
        unitId: 'U2',
        remarks: 'New arrival',
        qty1: '15',
        rate1: '200',
        qty2: '10',
        rate2: '190',
        lastrate: '180',
        lastJobId: 'J002',
        message: 'Limited stock',
      ),
      // Add more products as needed
    ]);
  }



}
