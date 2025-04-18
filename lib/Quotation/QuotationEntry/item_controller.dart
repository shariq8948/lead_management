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
  final searchResults = <CustomerResponseModel>[].obs;

  // Loading states
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final isSearchingCustomer = false.obs;
  final currentPage = 0.obs;
  final hasMoreProducts = true.obs;

  // Payment and additional info
  final advanceAmount = 0.0.obs;
  final validityPeriod = "30 days".obs; // Default validity period for quotation
  final paymentTerms = "Advance 50%, Balance before shipping".obs;
  final termsAndConditions = "Standard terms apply".obs;
  final additionalNotes = "".obs;

  // Totals (RxDouble for reactivity)
  final subtotal = 0.0.obs;
  final totalGST = 0.0.obs;
  final grandTotal = 0.0.obs;

  // Controllers
  final searchController = TextEditingController();
  final productSearchController = TextEditingController();
  final scrollController = ScrollController();
  final ApiClient _apiProvider = ApiClient();
  final box = GetStorage();

  final expanded = false.obs;

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

  // No getters here anymore - using Rx variables instead

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

  void toggle() {
    expanded.value = !expanded.value;
  }

  // Calculation methods
  void calculateTotals() {
    subtotal.value = 0.0;
    totalGST.value = 0.0;
    grandTotal.value = 0.0;

    for (var product in selectedProducts) {
      // Get base values
      double price = double.tryParse(product.rate1) ?? 0.0;
      int quantity = product.qty.value;
      double discount = product.discount.value;
      double gstRate = double.tryParse(product.stax) ?? 0.0;

      // Calculate product total
      double itemTotal = price * quantity;
      double discountAmount = (itemTotal * discount) / 100;
      double itemSubtotal = itemTotal - discountAmount;
      double gstAmount = (itemSubtotal * gstRate) / 100;

      // Add to totals
      subtotal.value += itemSubtotal;
      totalGST.value += gstAmount;
      grandTotal.value += itemSubtotal + gstAmount;
    }

    // Debugging
    print(
        'Calculated totals - Subtotal: ${subtotal.value}, GST: ${totalGST.value}, Grand Total: ${grandTotal.value}');
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

    // Recalculate totals whenever a product is selected or deselected
    calculateTotals();
  }

  void updateProductQuantity(Products1 product, int newQty) {
    print('Attempting to update quantity to: $newQty');

    // Make sure minqty and maxqty are valid numbers
    // int minQty = 1;
    // int maxQty = 1000;
    //
    // try {
    //   minQty = int.parse(product.minqty);
    // } catch (e) {
    //   print('Error parsing minqty: $e');
    // }
    //
    // try {
    //   maxQty = int.parse(product.maxqty);
    //   if (maxQty < minQty) maxQty = minQty;
    // } catch (e) {
    //   print('Error parsing maxqty: $e');
    //   maxQty = minQty > 1 ? minQty : 1000;
    // }
    //
    // // For quotations, we don't need to check stock, but we'll still respect minimum/maximum limits
    // final validatedQty = newQty.clamp(minQty, maxQty);
    //
    // print('Validated quantity: $validatedQty');

    // Update the reactive value
    if (newQty >= 0) {
      product.qty.value = newQty;
      product.qtyController.text = newQty.toString();
    }

    // Ensure the controller text is updated as well
    // if (product.qtyController.text != validatedQty.toString()) {
    //   // Disconnect value listener temporarily
    //   product.qtyController.text = validatedQty.toString();
    // }

    // Recalculate totals with a slight delay to ensure the value has propagated
    Future.delayed(Duration.zero, () {
      calculateTotals();
      print('Updated quantity for ${product.iname} to ${product.qty.value}');
    });
  }

  void updateProductDiscount(Products1 product, double newDiscount) {
    // Skip if it's the same discount to avoid unnecessary updates
    if (product.discount.value == newDiscount) return;

    // For quotations, we allow any discount up to 100%
    final validatedDiscount = newDiscount.clamp(0.0, 100.0);

    // Update the reactive value
    product.discount.value = validatedDiscount;

    // Format the discount to 2 decimal places
    final formattedDiscount = validatedDiscount.toStringAsFixed(2);

    // Update the controller text only if it differs from current value
    // This prevents cursor jumping in the text field
    if (product.discountController.text != formattedDiscount) {
      product.discountController.text = formattedDiscount;
    }

    // Recalculate totals
    calculateTotals();

    // Debug log
    print('Updated discount for ${product.iname} to $validatedDiscount%');
  }

  // API calls
  Future<void> fetchProducts({bool isInitialFetch = true}) async {
    const String endpoint = ApiEndpoints.allProductsList;
    final String userId = GetStorage().read(StorageTags.userId);
    const String pageSize = "10";

    try {
      if (isInitialFetch) {
        clearSelections();

        isLoading.value = true;
        currentPage.value = 0;
      } else {
        isFetchingMore.value = true;
      }

      final newProducts = await ApiClient().getAllProductList(
        endPoint: endpoint,
        userId: userId,
        isPagination: "1",
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
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isSearchingCustomer.value = true;
    try {
      final domain = box.read(StorageTags.baseUrl) ?? '';
      if (domain.isEmpty) {
        throw Exception('Domain not found. Please check your configuration.');
      }

      final userId = box.read(StorageTags.userId) ?? '';
      if (userId.isEmpty) {
        throw Exception('User ID not found. Please log in again.');
      }

      final results = await getCustomerList(
        endPoint: "$domain/api/PresalesMobile/GetCustomer",
        userId: userId,
        isPagination: "0",
        pageSize: "0",
        pageNumber: "0",
        q: query,
      );

      searchResults.assignAll(results);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to search customers. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      searchResults.clear();
    } finally {
      isSearchingCustomer.value = false;
    }
  }

  Future<List<CustomerResponseModel>> getCustomerList({
    required String endPoint,
    required String userId,
    required String isPagination,
    required String pageSize,
    required String pageNumber,
    required String q,
  }) async {
    try {
      final dio = Dio();

      // Set timeout
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.receiveTimeout = const Duration(seconds: 10);

      final response = await dio.post(
        endPoint,
        queryParameters: {
          'userId': userId,
          'IsPagination': isPagination,
          'PageSize': pageSize,
          'Pagenumber': pageNumber,
          'filter': q,
        },
      );

      if (response.statusCode == 200) {
        // Ensure we handle response data properly
        final Map<String, dynamic> responseData =
            response.data is String ? jsonDecode(response.data) : response.data;

        // Check if 'data' exists and is a list
        if (responseData['data'] != null && responseData['data'] is List) {
          return responseData['data']
              .map<CustomerResponseModel>(
                  (item) => CustomerResponseModel.fromJson(item))
              .toList();
        } else {
          throw Exception(
              "Unexpected response structure: 'data' is not a list.");
        }
      } else {
        throw Exception(
            "Failed to load customer list. Status Code: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            "Connection timeout. Please check your internet connection.");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            "Server taking too long to respond. Please try again later.");
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Error fetching customers: $e");
    }
  }

  void selectCustomer(CustomerResponseModel customer) {
    selectedCustomer.value = customer;
    searchResults.clear();
    searchController.clear();
  }

  void clearSelectedCustomer() {
    selectedCustomer.value = null;
    searchResults.clear();
    searchController.clear();
  }

  // Quotation Processing
  Future<List<Map<String, dynamic>>> prepareQuotationData() async {
    try {
      if (selectedCustomer.value == null) {
        throw Exception(
            'No customer selected. Please select a customer before creating a quotation.');
      }

      if (selectedProducts.isEmpty) {
        throw Exception(
            'No products selected. Please add products before creating a quotation.');
      }

      List<Map<String, dynamic>> quotationItems = [];
      double rawTotal = 0.0;

      // Calculate raw total
      for (var product in selectedProducts) {
        double price = double.tryParse(product.rate1) ?? 0;
        int quantity = product.qty.value;
        rawTotal += price * quantity;
      }

      // Create quotation items
      for (var product in selectedProducts) {
        // Calculate values
        double price = double.tryParse(product.rate1) ?? 0;
        int quantity = product.qty.value;
        double discount = product.discount.value;
        double itemTotal = price * quantity;
        double discountAmount = (itemTotal * discount) / 100;
        double itemSubtotal = itemTotal - discountAmount;
        double gstRate = double.tryParse(product.stax) ?? 0;
        double gstAmount = (itemSubtotal * gstRate) / 100;

        Map<String, dynamic> quotationItem = {
          "Itemid": product.id,
          "iCode": product.icode ?? "",
          "Custid": selectedCustomer.value?.id ?? "",
          "Sgstamt": selectedCustomer.value!.customerType == "Local"
              ? (gstAmount / 2).toStringAsFixed(2)
              : "0",
          "Cgstamt": selectedCustomer.value!.customerType == "Local"
              ? (gstAmount / 2).toStringAsFixed(2)
              : "0",
          "Igstamt": selectedCustomer.value!.customerType != "Local"
              ? gstAmount.toStringAsFixed(2)
              : "0",
          "Stotal": rawTotal.toString(),
          "Bamt": grandTotal.value.toString(),
          "Mrid": "0",
          "Other": "0",
          "Userid": box.read(StorageTags.userId) ?? "",
          "Total": itemTotal.toString(),
          "Qnty": quantity.toString(),
          "Deliveryaddressid": "",
          "Rate": price.toString(),
          "Disc": discount.toString(),
          "taxablevalue": itemSubtotal.toString(),
          "Gst": gstRate.toString(),
          "Remark": additionalNotes.value,
          "ValidityPeriod": validityPeriod.value,
          "PaymentTerms": paymentTerms.value,
          "TermsAndConditions": termsAndConditions.value,
          "Mobile": selectedCustomer.value?.mobile ?? "",
          "INAME1": product.iname,
          "TaxableAmt": itemSubtotal.toString(),
          "Disc_Amt": discountAmount.toString(),
        };

        quotationItems.add(quotationItem);
      }

      return quotationItems;
    } catch (e) {
      _handleError('Failed to prepare quotation data', e);
      return [];
    }
  }

  Future<void> submitQuotation(BuildContext context) async {
    // Validate requirements first
    if (selectedCustomer.value == null) {
      Get.snackbar(
        'Error',
        'Please select a customer before creating a quotation',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return;
    }

    if (selectedProducts.isEmpty) {
      Get.snackbar(
        'Error',
        'No products selected. Please add products before creating a quotation',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return;
    }

    try {
      // Show loading dialog
      _showLoadingDialog('Processing Quotation...');

      // Prepare quotation data
      List<Map<String, dynamic>> quotationData = await prepareQuotationData();

      if (quotationData.isEmpty) {
        // Close loading dialog
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        Get.snackbar(
          'Error',
          'Failed to prepare quotation items',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
        );
        return;
      }

      String jsonQuotationData = jsonEncode(quotationData);

      final response = await _apiProvider.postg(
        ApiEndpoints.SAVEQUOTATION,
        data: jsonQuotationData,
      );

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      List<dynamic> responseData = response;

      if (responseData.isNotEmpty && responseData[0]['success'] == "1") {
        String quotationNo = responseData[0]['uno'] ?? "Unknown";
        String quotationId = responseData[0]['id'] ?? "00";

        // Show success dialog
        _showQuotationSuccessDialog(context, quotationNo, quotationId);

        // Clear selections after successful submission
        clearSelections();
      } else {
        String errorMessage = responseData.isNotEmpty
            ? responseData[0]['message'] ?? 'Unknown error'
            : 'Failed to submit quotation';

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
        );
      }
    } catch (e) {
      // Close loading dialog if there's an error
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      _handleError('Failed to submit quotation', e);
    }
  }

  void clearSelections() {
    // Clear selected products
    for (var product in productList) {
      product.isSelected.value = false;
      product.qty.value = 1;
      product.discount.value = 0;
      product.qtyController.text = "1";
      product.discountController.text = "0";
    }
    selectedProducts.clear();

    // Clear selected customer
    clearSelectedCustomer();

    // Reset additional info
    additionalNotes.value = "";
    advanceAmount.value = 0.0;
    validityPeriod.value = "30 days";
    paymentTerms.value = "Advance 50%, Balance before shipping";
    termsAndConditions.value = "Standard terms apply";
  }

  // UI Helpers
  void _showLoadingDialog(String message) {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showQuotationSuccessDialog(
      BuildContext context, String quotationNo, String quotationId) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green[400]),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Quotation Created',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quotation #$quotationNo has been created successfully.'),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Quotation ID: $quotationId'),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: quotationId));
                    Get.snackbar(
                      'Copied',
                      'Quotation ID copied to clipboard',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green[100],
                      duration: const Duration(seconds: 1),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Get.back(); // Close the dialog
              // Optionally navigate back or to a quotation list
              Get.back(); // Return to previous screen
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[400],
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back(); // Close the dialog
              // Generate and share the quotation
              generateAndSharePDF();
            },
            child: const Text('Generate PDF'),
          ),
        ],
      ),
    );
  }

  // Error handling
  void _handleError(String message, dynamic error, {bool showSnackbar = true}) {
    print('$message: $error');
    if (showSnackbar) {
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    }
  }

  // PDF Generation
  Future<void> generateAndSharePDF() async {
    try {
      final pdf = pw.Document();
      final now = DateTime.now();
      final date = "${now.day}/${now.month}/${now.year}";

      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('QUOTATION',
                          style: pw.TextStyle(
                              fontSize: 24, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text('Date: $date'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(box.read('companyName') ?? 'Company Name',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text(box.read('companyAddress') ?? 'Company Address'),
                      pw.Text(
                          'Phone: ${box.read('companyPhone') ?? 'Phone Number'}'),
                      pw.Text('Email: ${box.read('companyEmail') ?? 'Email'}'),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // Customer details
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('TO:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(selectedCustomer.value?.name ?? ''),
                    pw.Text(
                        '${selectedCustomer.value?.address1 ?? ''}, ${selectedCustomer.value?.city ?? ''}, ${selectedCustomer.value?.state ?? ''}'),
                    pw.Text('Mobile: ${selectedCustomer.value?.mobile ?? ''}'),
                    pw.Text('Email: ${selectedCustomer.value?.email ?? ''}'),
                  ],
                ),
              ),

              pw.SizedBox(height: 15),

              // Table header
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FractionColumnWidth(0.05), // Sr.
                  1: const pw.FractionColumnWidth(0.35), // Description
                  2: const pw.FractionColumnWidth(0.10), // Qty
                  3: const pw.FractionColumnWidth(0.15), // Unit Price
                  4: const pw.FractionColumnWidth(0.10), // Disc%
                  5: const pw.FractionColumnWidth(0.10), // GST%
                  6: const pw.FractionColumnWidth(0.15), // Amount
                },
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Sr.',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Description',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Qty',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Unit Price',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Disc%',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('GST%',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Amount',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  ...List.generate(selectedProducts.length, (index) {
                    var product = selectedProducts[index];
                    double price = double.tryParse(product.rate1) ?? 0;
                    int quantity = product.qty.value;
                    double discount = product.discount.value;
                    double itemTotal = price * quantity;
                    double discountAmount = (itemTotal * discount) / 100;
                    double afterDiscount = itemTotal - discountAmount;
                    double gstRate = double.tryParse(product.stax) ?? 0;
                    double gstAmount = (afterDiscount * gstRate) / 100;
                    double finalAmount = afterDiscount + gstAmount;

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('${index + 1}')),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(product.iname)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('$quantity')),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('₹${price.toStringAsFixed(2)}')),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('${discount.toStringAsFixed(2)}%')),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('${gstRate.toStringAsFixed(2)}%')),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child:
                                pw.Text('₹${finalAmount.toStringAsFixed(2)}')),
                      ],
                    );
                  }),
                ],
              ),

              pw.SizedBox(height: 10),

              // Summary
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                          width: 150,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Subtotal:'),
                        ),
                        pw.Container(
                          width: 100,
                          padding: const pw.EdgeInsets.all(5),
                          child:
                              pw.Text('₹${subtotal.value.toStringAsFixed(2)}'),
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                          width: 150,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('GST:'),
                        ),
                        pw.Container(
                          width: 100,
                          padding: const pw.EdgeInsets.all(5),
                          child:
                              pw.Text('₹${totalGST.value.toStringAsFixed(2)}'),
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                          width: 150,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey300,
                          ),
                          child: pw.Text('Total Amount:'),
                        ),
                        pw.Container(
                          width: 100,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey300,
                          ),
                          child: pw.Text('₹${grandTotal.toStringAsFixed(2)}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Terms and conditions
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                padding: const pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('TERMS AND CONDITIONS:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Text('- Validity: ${validityPeriod.value}'),
                    pw.Text('- Payment Terms: ${paymentTerms.value}'),
                    pw.Text('- ${termsAndConditions.value}'),
                    if (additionalNotes.value.isNotEmpty)
                      pw.Text('- Note: ${additionalNotes.value}'),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Signature
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.SizedBox(height: 25), // Space for signature
                      pw.Container(
                        width: 150,
                        height: 1,
                        color: PdfColors.black,
                      ),
                      pw.Text('Customer Signature'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.SizedBox(height: 25), // Space for signature
                      pw.Container(
                        width: 150,
                        height: 1,
                        color: PdfColors.black,
                      ),
                      pw.Text('Authorized Signature'),
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
        "Failed to generate or share quotation. Error: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    }
  }
}
