// quotation_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/models/dropdown_list.model.dart';
import 'package:leads/utils/tags.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../data/api/api_client.dart';
import '../../data/models/product.dart';
import '../../utils/api_endpoints.dart';

class QuotationController extends GetxController {
  // Products related
  final productList = <Products1>[].obs;
  final selectedProducts = <Products1>[].obs;
  final productSearchQuery = ''.obs;
  final showSelectedProductsOnly = false.obs;

  // Customer related
  final selectedCustomer = Rxn<CustomerResponseModel>();
  final searchType = 'name'.obs;
  final customerSearchQuery = ''.obs;

  // Loading states
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final isSearchingCustomer = false.obs;
  final currentPage = 0.obs;
  final hasMoreProducts = true.obs;

  // Controllers
  final searchController = TextEditingController();
  final productSearchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isFetchingMore.value && hasMoreProducts.value) {
          fetchProducts(isInitialFetch: false);
        }
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    productSearchController.dispose();
    super.onClose();
  }

  // Product related calculations
  double get subtotal => selectedProducts.fold(
      0,
      (sum, product) =>
          sum +
          (double.parse(product.rate1) *
              product.qty.value *
              (1 - product.discount.value / 100)));

  double get totalGST => selectedProducts.fold(0,
      (sum, product) => sum + (subtotal * (double.parse(product.stax) / 100)));

  double get grandTotal => subtotal + totalGST;

  // Product filtering
  List<Products1> get filteredProducts {
    List<Products1> filtered = productList;
    if (productSearchQuery.isNotEmpty) {
      filtered = filtered
          .where((product) =>
              product.iname
                  .toLowerCase()
                  .contains(productSearchQuery.value.toLowerCase()) ||
              (product.icode
                      ?.toLowerCase()
                      .contains(productSearchQuery.value.toLowerCase()) ??
                  false))
          .toList();
    }
    if (showSelectedProductsOnly.value) {
      filtered = filtered.where((product) => product.isSelected.value).toList();
    }
    return filtered;
  }

  // Product actions
  void toggleProductSelection(Products1 product) {
    if (product.isSelected.value) {
      product.isSelected.value = false;
      selectedProducts.remove(product);
    } else {
      product.isSelected.value = true;
      selectedProducts.add(product);
    }
  }

  void updateProductQuantity(Products1 product, int newQty) {
    final validatedQty =
        newQty.clamp(int.parse(product.minqty), int.parse(product.maxqty));
    product.qty.value = validatedQty;
    product.qtyController.text = validatedQty.toString();
  }

  void updateProductDiscount(Products1 product, double newDiscount) {
    final validatedDiscount = newDiscount.clamp(0.0, product.customerDiscount);
    product.discount.value = validatedDiscount;
    product.discountController.text = validatedDiscount.toString();
  }

  // API calls
  Future<void> fetchProducts({bool isInitialFetch = true}) async {
    const String endpoint = ApiEndpoints.allProductsList;
    final String userId = GetStorage().read(StorageTags.userId);
    const String pageSize = "10";

    try {
      if (isInitialFetch) {
        isLoading.value = true;
        currentPage.value = 0;
      } else {
        isFetchingMore.value = true;
      }

      final newProducts = await ApiClient().getAllProductList(
        endPoint: endpoint,
        userId: userId,
        isPagination: "0",
        pageSize: pageSize,
        pageNumber: currentPage.value.toString(),
      );

      if (newProducts.isNotEmpty) {
        if (isInitialFetch) {
          productList.clear();
          productList.assignAll(newProducts);
        } else {
          productList.addAll(newProducts);
        }
        currentPage.value++;
        hasMoreProducts.value = newProducts.length >= int.parse(pageSize);
      } else {
        hasMoreProducts.value = false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch products. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  Future<void> searchCustomers(String query) async {
    try {
      isSearchingCustomer.value = true;
      // Implement your customer search API call here
      // Update selectedCustomer.value with the result
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to search customers. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isSearchingCustomer.value = false;
    }
  }

  Future<void> generateAndSharePDF() async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            children: [
              pw.Header(
                  level: 0,
                  child:
                      pw.Text('Quotation', style: pw.TextStyle(fontSize: 24))),
              pw.SizedBox(height: 20),
              pw.Text('Customer: ${selectedCustomer.value?.name ?? ""}'),
              pw.Text('Email: ${selectedCustomer.value?.email ?? ""}'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Product', 'Qty', 'Rate', 'Discount', 'Amount'],
                data: selectedProducts
                    .map((product) => [
                          product.iname,
                          product.qty.value.toString(),
                          product.rate1,
                          '${product.discount}%',
                          (double.parse(product.rate1) *
                                  product.qty.value *
                                  (1 - product.discount.value / 100))
                              .toStringAsFixed(2),
                        ])
                    .toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Subtotal: ${subtotal.toStringAsFixed(2)}'),
                      pw.Text('GST: ${totalGST.toStringAsFixed(2)}'),
                      pw.Text('Grand Total: ${grandTotal.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      final output = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${output.path}/quotation_$timestamp.pdf');
      await file.writeAsBytes(await pdf.save());

      if (await file.exists()) {
        final xFile = XFile(file.path);
        await Share.shareXFiles([xFile],
            text: 'Quotation #$timestamp', subject: 'Quotation Details');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to generate or share quotation.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    }
  }
}

// quotation_page.dart
class QuotationPage extends GetView<QuotationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quotation'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: controller.generateAndSharePDF,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCustomerSection(),
          _buildProductSection(),
          _buildQuotationSummary(),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: (value) {
                      controller.customerSearchQuery.value = value;
                      if (value.length >= 3) {
                        controller.searchCustomers(value);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Customer',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list),
                  onSelected: (value) => controller.searchType.value = value,
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'name', child: Text('By Name')),
                    PopupMenuItem(value: 'mobile', child: Text('By Mobile')),
                    PopupMenuItem(value: 'email', child: Text('By Email')),
                  ],
                ),
              ],
            ),
          ),
          Obx(
            () => controller.selectedCustomer.value == null
                ? SizedBox()
                : ListTile(
                    title: Text(controller.selectedCustomer.value!.name!),
                    subtitle:
                        Text(controller.selectedCustomer.value!.email ?? ""),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => controller.selectedCustomer.value = null,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.productSearchController,
                    onChanged: (value) =>
                        controller.productSearchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: 'Search products',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Obx(() => FilterChip(
                      label: Text('Selected Only'),
                      selected: controller.showSelectedProductsOnly.value,
                      onSelected: (value) =>
                          controller.showSelectedProductsOnly.value = value,
                    )),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchProducts(isInitialFetch: true),
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.filteredProducts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.filteredProducts.length) {
                      if (controller.isFetchingMore.value) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return SizedBox();
                    }

                    final product = controller.filteredProducts[index];
                    return _buildProductItem(product);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Products1 product) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Obx(() => ExpansionTile(
            title: Text(product.iname),
            subtitle: Text('Rate: ₹${product.rate1}'),
            leading: Checkbox(
              value: product.isSelected.value,
              onChanged: (_) => controller.toggleProductSelection(product),
            ),
            children: [
              if (product.isSelected.value)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Quantity:'),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => controller.updateProductQuantity(
                                product, product.qty.value - 1),
                          ),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: product.qtyController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final qty = int.tryParse(value) ?? 1;
                                controller.updateProductQuantity(product, qty);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => controller.updateProductQuantity(
                                product, product.qty.value + 1),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text('Discount (%):'),
                          SizedBox(width: 8),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: product.discountController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onChanged: (value) {
                                final discount = double.tryParse(value) ?? 0.0;
                                controller.updateProductDiscount(
                                    product, discount);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          )),
    );
  }

  Widget _buildQuotationSummary() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Obx(() => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Selected Items:'),
                        Text('${controller.selectedProducts.length}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal:'),
                        Text('₹${controller.subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('GST:'),
                        Text('₹${controller.totalGST.toStringAsFixed(2)}'),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grand Total:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${controller.grandTotal.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                )),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (controller.selectedCustomer.value == null) {
                  Get.snackbar(
                    "Error",
                    "Please select a customer first",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade100,
                  );
                  return;
                }
                if (controller.selectedProducts.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Please select at least one product",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade100,
                  );
                  return;
                }
                controller.generateAndSharePDF();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Generate Quotation',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
