// quotation_controller.dart
import 'dart:convert';
import 'package:flutter/services.dart';
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
import 'package:dio/dio.dart';
import '../../data/api/api_client.dart';
import '../../data/models/product.dart';
import '../../utils/api_endpoints.dart';
import 'item_controller.dart';

// quotation_page.dart
class QuotationPage extends GetView<QuotationController> {
  final controller = Get.put(QuotationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quotation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: controller.generateAndSharePDF,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCustomerSection(),
          _buildProductSection(),
          _buildQuotationSummary(context),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          // Search customer
          Padding(
            padding: const EdgeInsets.all(12),
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
                      prefixIcon: const Icon(Icons.search, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.teal),
                  ),
                  onSelected: (value) => controller.searchType.value = value,
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'name', child: Text('By Name')),
                    const PopupMenuItem(
                        value: 'mobile', child: Text('By Mobile')),
                    const PopupMenuItem(
                        value: 'email', child: Text('By Email')),
                  ],
                ),
              ],
            ),
          ),

          // Search results
          Obx(() {
            if (controller.isSearchingCustomer.value) {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                ),
              );
            }

            if (controller.searchResults.isNotEmpty) {
              return Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.searchResults.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) {
                    final customer = controller.searchResults[index];
                    return ListTile(
                      title: Text(
                        customer.name ?? "No Name",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(customer.mobile ?? "No Mobile"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => controller.selectCustomer(customer),
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          }),

          // Selected customer info
          Obx(
            () => controller.selectedCustomer.value == null
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.selectedCustomer.value!.name ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.teal),
                              onPressed: controller.clearSelectedCustomer,
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                            ),
                          ],
                        ),
                        const Divider(
                            color: Colors.teal, height: 16, thickness: 0.5),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone,
                                size: 16, color: Colors.teal),
                            const SizedBox(width: 6),
                            Text(
                              'Mobile: ${controller.selectedCustomer.value!.mobile ?? ""}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.email,
                                size: 16, color: Colors.teal),
                            const SizedBox(width: 6),
                            Text(
                              'Email: ${controller.selectedCustomer.value!.email ?? ""}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.teal),
                            const SizedBox(width: 6),
                            Text(
                              'Location: ${controller.selectedCustomer.value!.city ?? ""}, ${controller.selectedCustomer.value!.state ?? ""}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.productSearchController,
                    onChanged: (value) =>
                        controller.productSearchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: 'Search products',
                      hintStyle:
                          TextStyle(color: Colors.grey[500], fontSize: 14),
                      prefixIcon:
                          Icon(Icons.search, color: Colors.teal[600], size: 20),
                      suffixIcon:
                          controller.productSearchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    controller.productSearchController.clear();
                                    controller.productSearchQuery.value = '';
                                  },
                                  child: Icon(Icons.clear,
                                      color: Colors.grey[500], size: 18),
                                )
                              : const SizedBox.shrink(),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.teal[400]!, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(() => FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            controller.showSelectedProductsOnly.value
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 16,
                            color: controller.showSelectedProductsOnly.value
                                ? Colors.teal[700]
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Selected Only',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  controller.showSelectedProductsOnly.value
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                              color: controller.showSelectedProductsOnly.value
                                  ? Colors.teal[700]
                                  : Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      selected: controller.showSelectedProductsOnly.value,
                      onSelected: (value) =>
                          controller.showSelectedProductsOnly.value = value,
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.teal[50],
                      checkmarkColor: Colors.teal,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: controller.showSelectedProductsOnly.value
                              ? Colors.teal[300]!
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                      pressElevation: 2,
                    )),
              ],
            ),
          ),
          // Selected products count and total
          Obx(
            () => controller.selectedProducts.isEmpty
                ? const SizedBox()
                : Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blue.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selected Products: ${controller.selectedProducts.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Total: ₹${controller.grandTotal.value.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
          ),

          // Product list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchProducts(isInitialFetch: true),
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.filteredProducts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.filteredProducts.length) {
                      if (controller.isFetchingMore.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox();
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
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: product.isSelected.value
                ? Colors.teal.withOpacity(0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: product.isSelected.value
                    ? Colors.teal.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: product.isSelected.value
                  ? Colors.teal.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.2),
              width: product.isSelected.value ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              // Product header with checkbox
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: product.isSelected.value
                        ? Colors.teal.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Checkbox(
                    activeColor: Colors.teal,
                    checkColor: Colors.white,
                    value: product.isSelected.value,
                    onChanged: (_) =>
                        controller.toggleProductSelection(product),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                title: Text(
                  product.iname,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        product.isSelected.value ? Colors.teal : Colors.black87,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '₹${product.rate1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (product.discount.value > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${product.discount.value}% OFF',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                trailing: product.isSelected.value
                    ? const Icon(Icons.keyboard_arrow_up, color: Colors.teal)
                    : const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                onTap: () {
                  // Toggle expansion when clicked
                  if (!product.isSelected.value) {
                    controller.toggleProductSelection(product);
                  }
                },
              ),

              // Expanded details for selected products
              if (product.isSelected.value)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quantity slider and input
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined,
                              color: Colors.teal, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Quantity:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.remove,
                                    color: Colors.white, size: 16),
                              ),
                              onPressed: () => controller.updateProductQuantity(
                                  product, product.qty.value - 1),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            Expanded(
                              child: Builder(builder: (context) {
                                // Safe parse minqty and maxqty with fallbacks
                                double min = 1.0;
                                double max = 100.0;

                                try {
                                  min = double.parse(product.minqty);
                                } catch (e) {
                                  // Use fallback value if parsing fails
                                  print('Error parsing minqty: $e');
                                }

                                try {
                                  max = double.parse(product.maxqty);
                                  // Ensure max is greater than min
                                  if (max <= min) {
                                    max = min +
                                        10; // Set a reasonable range if max <= min
                                  }
                                } catch (e) {
                                  // Use fallback value if parsing fails
                                  print('Error parsing maxqty: $e');
                                  max = min + 10; // Ensure max > min
                                }

                                // Ensure value is within range
                                double value = product.qty.value.toDouble();
                                if (value < min) {
                                  value = min;
                                } else if (value > max) {
                                  value = max;
                                }

                                return Slider(
                                  value: value,
                                  min: min,
                                  max: max,
                                  divisions: (max - min).toInt() > 0
                                      ? (max - min).toInt()
                                      : 1,
                                  activeColor: Colors.teal,
                                  inactiveColor: Colors.teal.withOpacity(0.2),
                                  onChanged: (value) {
                                    controller.updateProductQuantity(
                                        product, value.toInt());
                                  },
                                );
                              }),
                            ),
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.add,
                                    color: Colors.white, size: 16),
                              ),
                              onPressed: () => controller.updateProductQuantity(
                                  product, product.qty.value + 1),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 50,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.teal),
                              ),
                              child: TextField(
                                controller: product.qtyController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 8,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    final qty = int.tryParse(value) ?? 1;
                                    controller.updateProductQuantity(
                                        product, qty);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Discount input
                      Row(
                        children: [
                          const Icon(Icons.discount_outlined,
                              color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Discount (%):',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      value: product.discount.value,
                                      min: 0,
                                      max: 100,
                                      divisions: 20,
                                      activeColor: Colors.orange,
                                      inactiveColor:
                                          Colors.orange.withOpacity(0.2),
                                      onChanged: (value) {
                                        controller.updateProductDiscount(
                                            product, value);
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.orange),
                                    ),
                                    child: TextField(
                                      controller: product.discountController,
                                      textAlign: TextAlign.center,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 8,
                                        ),
                                        suffixText: '%',
                                        suffixStyle:
                                            TextStyle(color: Colors.orange),
                                      ),
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          final discount =
                                              double.tryParse(value) ?? 0.0;
                                          controller.updateProductDiscount(
                                              product, discount);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Pricing summary
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.teal.withOpacity(0.2)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Base Price:',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  '₹${product.rate1} × ${product.qty.value} = ₹${(double.parse(product.rate1) * product.qty.value).toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Discount:',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  '${product.discount.value}% = ₹${((double.parse(product.rate1) * product.qty.value) * (product.discount.value / 100)).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'GST (${product.stax}%):',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  '₹${(((double.parse(product.rate1) * product.qty.value) * (1 - product.discount.value / 100)) * (double.parse(product.stax) / 100)).toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  '₹${(((double.parse(product.rate1) * product.qty.value) * (1 - product.discount.value / 100)) * (1 + double.parse(product.stax) / 100)).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ));
  }

// Helper method to build summary rows
  Widget _buildSummaryRow(String label, String value, bool isTotal,
      {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 14,
            color: color,
          ),
        ),
      ],
    );
  }

// Helper method to build text fields
  Widget _buildQuotationSummary(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() => SingleChildScrollView(
          // Add SingleChildScrollView as the parent
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Collapsible header/button that's always visible
              InkWell(
                onTap: () => controller.toggle(),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_outlined,
                            color: theme.colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Quotation Summary',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '₹${controller.grandTotal.value.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Obx(() => Icon(
                                controller.expanded.value
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up,
                                color: theme.colorScheme.onPrimary,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Expandable content
              Obx(() => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: controller.expanded.value ? null : 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: controller.expanded.value ? 1.0 : 0.0,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Financial summary card
                            Card(
                              elevation: 2,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    _buildSummaryRow(
                                      'Subtotal',
                                      '₹${controller.subtotal.value.toStringAsFixed(2)}',
                                      false,
                                    ),
                                    const Divider(height: 24),
                                    _buildSummaryRow(
                                      'GST',
                                      '₹${controller.totalGST.value.toStringAsFixed(2)}',
                                      false,
                                    ),
                                    const Divider(height: 24),
                                    _buildSummaryRow(
                                      'Grand Total',
                                      '₹${controller.grandTotal.value.toStringAsFixed(2)}',
                                      true,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Additional information (expandable)
                            // Card(
                            //   elevation: 2,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            //   child: Theme(
                            //     // Use Theme to adjust ExpansionTile properties
                            //     data: Theme.of(context).copyWith(
                            //       dividerColor:
                            //           Colors.transparent, // Remove divider
                            //     ),
                            //     child: ExpansionTile(
                            //       title: Text(
                            //         "Additional Information",
                            //         style:
                            //             theme.textTheme.titleMedium?.copyWith(
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //       leading: Icon(Icons.info_outline,
                            //           color: theme.colorScheme.primary),
                            //       tilePadding: const EdgeInsets.symmetric(
                            //           horizontal: 16, vertical: 8),
                            //       childrenPadding: const EdgeInsets.all(16),
                            //       children: [
                            //         _buildScrollableTextField(
                            //           // Use custom scrollable text field
                            //           context: context,
                            //           labelText: 'Validity Period',
                            //           hintText: 'e.g., 30 days',
                            //           initialValue:
                            //               controller.validityPeriod.value,
                            //           onChanged: (value) => controller
                            //               .validityPeriod.value = value,
                            //           prefixIcon: Icons.calendar_today,
                            //         ),
                            //         const SizedBox(height: 16),
                            //         _buildScrollableTextField(
                            //           // Use custom scrollable text field
                            //           context: context,
                            //           labelText: 'Payment Terms',
                            //           hintText: 'e.g., 50% advance',
                            //           initialValue:
                            //               controller.paymentTerms.value,
                            //           onChanged: (value) =>
                            //               controller.paymentTerms.value = value,
                            //           prefixIcon: Icons.payment,
                            //         ),
                            //         const SizedBox(height: 16),
                            //         _buildScrollableTextField(
                            //           // Use custom scrollable text field
                            //           context: context,
                            //           labelText: 'Notes',
                            //           hintText: 'Additional notes',
                            //           initialValue:
                            //               controller.additionalNotes.value,
                            //           onChanged: (value) => controller
                            //               .additionalNotes.value = value,
                            //           prefixIcon: Icons.note,
                            //           maxLines: 3,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            //
                            // const SizedBox(height: 16),

                            // Submit button
                            ElevatedButton.icon(
                              onPressed: controller.selectedProducts.isEmpty ||
                                      controller.selectedCustomer.value == null
                                  ? null
                                  : () => controller.submitQuotation(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.check_circle),
                              label: const Text(
                                'Generate Quotation',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }

// New helper method for text fields that ensures visibility when keyboard appears
  Widget _buildScrollableTextField({
    required BuildContext context,
    required String labelText,
    required String hintText,
    required String initialValue,
    required Function(String) onChanged,
    required IconData prefixIcon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            // Add a small delay to ensure the widget tree is built
            Future.delayed(const Duration(milliseconds: 300), () {
              // This will ensure the text field is visible when focused
              Scrollable.ensureVisible(
                context,
                alignment: 0.5,
                duration: const Duration(milliseconds: 300),
              );
            });
          }
        },
        child: TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: Icon(prefixIcon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
