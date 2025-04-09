import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/api/api_client.dart';
import 'package:leads/utils/tags.dart';

import 'package:sqflite/sqflite.dart';

import '../../data/models/dropdown_list.model.dart';
import '../../utils/api_endpoints.dart';
import '../db/db_helper.dart';
import '../invoice/invoice_generator.dart';
import '../model/order_item.dart';
import '../model/product.dart';

class CartController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final box = GetStorage();
  final ApiClient _apiProvider = ApiClient();
  // Observable lists
  RxList<Products> cartItems = <Products>[].obs;
  RxList<CustomerResponseModel> searchResults = <CustomerResponseModel>[].obs;
  RxList<String> paymentModes =
      <String>['Cash', 'UPI', 'Bank Transfer', 'Card'].obs;

  // Observable values
  RxDouble totalAmount = 0.0.obs;
  RxDouble totalGST = 0.0.obs;
  RxDouble grandTotal = 0.0.obs;
  RxDouble sTotal = 0.0.obs;
  RxDouble advanceAmount = 0.0.obs;
  RxString paymentMode = 'Cash'.obs;
  RxString utrNumber = ''.obs;
  RxBool isSearching = false.obs;
  Rx<CustomerResponseModel?> selectedCustomer =
      Rx<CustomerResponseModel?>(null);

  // UI controllers
  final searchController = TextEditingController(text: "Name");

  // GST breakdown map
  Map<String, RxDouble> gstBreakdown = <String, RxDouble>{}.obs;

  static const Map<String, String> searchFields = {
    "Name": "name",
    "Mobile": "MOBILE",
    "Email": "EMAIL"
  };

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Cart CRUD Operations
  Future<void> loadCartItems() async {
    try {
      final List<Map<String, dynamic>> maps =
          await _databaseHelper.getCartItems();
      cartItems.assignAll(maps.map((e) => Products.fromJson(e)).toList());
      calculateTotal();
    } catch (e) {
      _handleError('Error loading cart items', e);
    }
  }

  Future<void> addToCart(
      Products product, int quantity, double discount) async {
    try {
      if (quantity <= 0) {
        throw Exception('Quantity must be greater than zero');
      }

      if (discount < 0 || discount > 100) {
        throw Exception('Discount must be between 0 and 100');
      }

      product.qty.value = quantity;
      product.discount.value = discount;

      final existingIndex =
          cartItems.indexWhere((item) => item.id == product.id);
      if (existingIndex != -1) {
        cartItems[existingIndex] = product;
      } else {
        cartItems.add(product);
      }

      await _databaseHelper.insertOrUpdateCartItem(product);
      calculateTotal();
    } catch (e) {
      _handleError('Failed to add item to cart', e);
    }
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        throw Exception('Quantity must be greater than zero');
      }

      final index = cartItems.indexWhere((item) => item.id == productId);
      if (index != -1) {
        cartItems[index].qty.value = newQuantity;
        await _databaseHelper.updateQuantity(productId, newQuantity);
        calculateTotal();
      } else {
        throw Exception('Product not found in cart');
      }
    } catch (e) {
      _handleError('Failed to update quantity', e);
    }
  }

  Future<void> updateDiscount(String productId, double newDiscount) async {
    try {
      if (newDiscount < 0 || newDiscount > 100) {
        throw Exception('Discount must be between 0 and 100');
      }

      final index = cartItems.indexWhere((item) => item.id == productId);
      if (index != -1) {
        cartItems[index].discount.value = newDiscount;
        await _databaseHelper.updateDiscount(productId, newDiscount);
        calculateTotal();
      } else {
        throw Exception('Product not found in cart');
      }
    } catch (e) {
      _handleError('Failed to update discount', e);
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      final index = cartItems.indexWhere((item) => item.id == productId);
      if (index == -1) {
        throw Exception('Product not found in cart');
      }

      final productName = cartItems[index].itemName;
      cartItems.removeAt(index);
      await _databaseHelper.deleteCartItem(productId);
      calculateTotal();
    } catch (e) {
      _handleError('Failed to remove item from cart', e);
    }
  }

  Future<void> clearCart() async {
    try {
      cartItems.clear();
      await _databaseHelper.clearCart();
      totalAmount.value = 0.0;
      totalGST.value = 0.0;
      grandTotal.value = 0.0;
      sTotal.value = 0.0;
      gstBreakdown.clear();
    } catch (e) {
      _handleError('Failed to clear cart', e);
    }
  }

  // Calculation Methods
  void calculateTotal() {
    try {
      double subtotal = 0;
      double subTotalWithoutDiscount = 0;
      double totalGSTAmount = 0;
      Map<String, double> gstRateWiseAmount = {};

      for (var item in cartItems) {
        double price = double.tryParse(item.saleRate) ?? 0;
        double itemTotal = price * item.qty.value;
        double discountAmount = (itemTotal * item.discount.value) / 100;
        double itemSubtotal = itemTotal - discountAmount;

        // Add to subtotal without discount for display purposes
        subTotalWithoutDiscount += itemTotal;

        // GST calculations
        double gstRate = double.tryParse(item.gst) ?? 0;
        double gstAmount = (itemSubtotal * gstRate) / 100;

        // Add to GST breakdown
        String gstKey = "${gstRate.toStringAsFixed(0)}%";
        gstRateWiseAmount[gstKey] =
            (gstRateWiseAmount[gstKey] ?? 0) + gstAmount;

        subtotal += itemSubtotal;
        totalGSTAmount += gstAmount;
      }

      // Update observable values
      totalAmount.value = subtotal;
      sTotal.value = subTotalWithoutDiscount;
      totalGST.value = totalGSTAmount;
      grandTotal.value = subtotal + totalGSTAmount;

      // Update GST breakdown
      gstBreakdown.clear();
      gstRateWiseAmount.forEach((key, value) {
        gstBreakdown[key] = value.obs;
      });
    } catch (e) {
      _handleError('Error calculating totals', e);
    }
  }

  double calculateSubtotal(Map<String, dynamic> item) {
    try {
      double price = double.tryParse((item['saleRate'] ?? "0").toString()) ?? 0;
      int quantity = item['qty'] ?? 1;
      return price * quantity;
    } catch (e) {
      _handleError('Error calculating subtotal', e, showSnackbar: false);
      return 0.0;
    }
  }

  double calculateDiscountAmount(Map<String, dynamic> item) {
    try {
      double subtotal = calculateSubtotal(item);
      double discount =
          double.tryParse((item['Discount'] ?? "0").toString()) ?? 0;
      return (subtotal * discount) / 100;
    } catch (e) {
      _handleError('Error calculating discount', e, showSnackbar: false);
      return 0.0;
    }
  }

  double calculateFinalAmount(Map<String, dynamic> item) {
    try {
      double subtotal = calculateSubtotal(item);
      double discountAmount = calculateDiscountAmount(item);
      return subtotal - discountAmount;
    } catch (e) {
      _handleError('Error calculating final amount', e, showSnackbar: false);
      return 0.0;
    }
  }

  double calculateGst(Map<String, dynamic> item) {
    try {
      double finalAmount = calculateFinalAmount(item);
      double gstRate = double.tryParse((item['gst'] ?? "0").toString()) ?? 0;
      return (finalAmount * gstRate) / 100;
    } catch (e) {
      _handleError('Error calculating GST', e, showSnackbar: false);
      return 0.0;
    }
  }

  double calculateSgst(Map<String, dynamic> item) {
    return calculateGst(item) / 2;
  }

  double calculateCgst(Map<String, dynamic> item) {
    return calculateGst(item) / 2;
  }

  Map<String, String> getGSTSummary() {
    Map<String, String> summary = {};
    gstBreakdown.forEach((rate, amount) {
      summary[rate] = amount.value.toStringAsFixed(2);
    });
    return summary;
  }

  // Customer Search Methods
  Future<void> searchCustomers(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      final domain = box.read(StorageTags.baseUrl) ?? '';
      print(box.read(StorageTags.baseUrl));
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
      print(results);
      searchResults.assignAll(results);
    } catch (e) {
      _handleError('Failed to search customers', e);
      searchResults.clear();
    } finally {
      isSearching.value = false;
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
  }

  void clearSelectedCustomer() {
    selectedCustomer.value = null;
    searchResults.clear();
  }

  // Order Processing Methods
  Future<List<Map<String, dynamic>>> saveOrder() async {
    try {
      if (selectedCustomer.value == null) {
        throw Exception(
            'No customer selected. Please select a customer before placing an order.');
      }

      final List<Map<String, dynamic>> rawCartItems =
          await _databaseHelper.getCartItems();
      if (rawCartItems.isEmpty) {
        throw Exception(
            'Cart is empty. Please add items before placing an order.');
      }

      List<Map<String, dynamic>> orderCollection = [];
      double rawTotal = 0.0;

      // Calculate raw total
      for (var item in rawCartItems) {
        double price =
            double.tryParse((item['saleRate'] ?? "0").toString()) ?? 0;
        int quantity = item['qty'] ?? 1;
        rawTotal += price * quantity;
      }

      // Create order items
      for (var item in rawCartItems) {
        // Validate product data
        if (item['id'] == null ||
            item['itemCode'] == null ||
            item['itemName'] == null) {
          throw Exception(
              'Invalid product data found in cart. Please try again.');
        }

        Map<String, dynamic> orderItem = {
          "Itemid": item['id']?.toString() ?? "",
          "iCode": item['itemCode']?.toString() ?? "",
          "Custid": selectedCustomer.value?.id ?? "",
          "Sgstamt": selectedCustomer.value!.customerType == "Local"
              ? calculateSgst(item).toStringAsFixed(1)
              : "0",
          "Cgstamt": selectedCustomer.value!.customerType == "Local"
              ? calculateCgst(item).toStringAsFixed(1)
              : "0",
          "Igstamt": selectedCustomer.value!.customerType != "Local"
              ? calculateGst(item).toStringAsFixed(1)
              : "0",
          "Stotal": rawTotal.toString(),
          "Bamt": grandTotal.toString(),
          "paymentgatewayorderid": "0",
          "Mrid": "0",
          "Other": "0",
          "Userid": box.read(StorageTags.userId) ?? "",
          "Orderby": "",
          "Total": calculateSubtotal(item),
          "Qnty": (item['qty'] ?? 1).toString(),
          "Paymentstatus": "Pending",
          "Paymenttransationid": "0",
          "Deliveryaddressid": "",
          "Fright": "0",
          "Free": "0",
          "Rate": (item['saleRate'] ?? 0).toString(),
          "Disc": (item['Discount'] ?? 0).toStringAsFixed(1),
          "taxablevalue": (item['saleRate'] ?? 0).toString(),
          "Gst": (item['gst'] ?? 0).toString(),
          "Remark": "",
          "IBatchid": "0",
          "Vehicalno": "",
          "Mobile": selectedCustomer.value?.mobile ?? "",
          "INAME1": item['itemName'] ?? "",
          "INAME2": "",
          "INAME3": "",
          "INAME4": "",
          "INAME5": "",
          "INAME6": "",
          "INAME7": "",
          "INAME8": "",
          "INAME9": "",
          "INAME11": "",
          "INAME12": "",
          "TaxableAmt": (item['saleRate'] ?? 0).toString(),
          "Disc_Amt": calculateDiscountAmount(item).toString(),
          "Roundoff": "0",
          "Size": "0",
          "sldid": "0",
          "Id": "0"
        };

        orderCollection.add(orderItem);
      }

      return orderCollection;
    } catch (e) {
      _handleError('Failed to save order', e);
      return [];
    }
  }

  Future<bool> checkStockAvailability() async {
    try {
      final List<Map<String, dynamic>> rawCartItems =
          await _databaseHelper.getCartItems();
      if (rawCartItems.isEmpty) {
        throw Exception(
            'Cart is empty. Please add items before checking stock.');
      }

      List<Map<String, dynamic>> outOfStockItems = [];

      // Check each item individually
      for (var cartItem in rawCartItems) {
        String? itemId = cartItem['id']?.toString();
        print(itemId);
        if (itemId == null || itemId.isEmpty) {
          throw Exception('Invalid item found in cart. Please try again.');
        }

        int requestedQty = cartItem['qty'] ?? 1;

        // Make API call for this specific item
        try {
          final response = await _apiProvider.getR(
            ApiEndpoints.PENDINGSTOCK,
            queryParameters: {'itemId': itemId},
          );

          // The response is already the list of stock data
          final List<dynamic> stockData = response;

          // Check if item is out of stock or has insufficient quantity
          if (stockData.isNotEmpty) {
            var stockItem = stockData[0];
            int balance =
                int.tryParse(stockItem['balance']?.toString() ?? "0") ?? 0;

            // If balance is negative or less than requested quantity, flag it
            if (balance <= 0 || balance < requestedQty) {
              outOfStockItems.add({
                'itemId': stockItem['itemid'],
                'name': stockItem['iname'] ?? 'Unknown Item',
                'availableStock': stockItem['balance'] ?? '0',
                'requestedQty': requestedQty
              });
            }
          } else {
            // Item not found in stock data
            outOfStockItems.add({
              'itemId': itemId,
              'name': cartItem['itemName'] ?? 'Unknown Item',
              'availableStock': '0',
              'requestedQty': requestedQty
            });
          }
        } catch (apiError) {
          // Handle API error for individual item
          _handleError('Error checking stock for item', apiError,
              showSnackbar: false);

          // Add the item to out of stock list to be safe
          outOfStockItems.add({
            'itemId': itemId,
            'name': cartItem['itemName'] ?? 'Unknown Item',
            'availableStock': 'Error',
            'requestedQty': requestedQty,
            'error': 'Failed to check stock'
          });
        }
      }

      // If there are out of stock items, show alert
      if (outOfStockItems.isNotEmpty) {
        // Close loading dialog if it's open
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        String outOfStockMessage =
            "The following items have insufficient stock:\n\n";
        for (var item in outOfStockItems) {
          outOfStockMessage +=
              "• ${item['name']} (Available: ${item['availableStock']}, Requested: ${item['requestedQty']})\n";
        }

        Get.dialog(
          CupertinoAlertDialog(
            title: const Text('Stock Not Available'),
            content: Text(outOfStockMessage),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        return false;
      }

      return true;
    } catch (e) {
      // Close loading dialog if there's an error
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      _handleError('Failed to check stock availability', e);
      return false;
    }
  }

  Future<void> submitOrder(BuildContext context) async {
    // Validate all requirements first
    if (selectedCustomer.value == null) {
      Get.snackbar(
        'Error',
        'Please select a customer before placing an order',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return;
    }

    if (cartItems.isEmpty) {
      Get.snackbar(
        'Error',
        'Cart is empty. Please add items before placing an order',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return;
    }

    try {
      // Show loading dialog when starting to save order
      _showLoadingDialog('Processing Order...');

      // First check if stock is available
      bool stockAvailable = await checkStockAvailability();

      // Close loading dialog if stock check failed
      if (!stockAvailable) {
        return; // The dialog is already closed in checkStockAvailability
      }

      // Create the order collection
      List<Map<String, dynamic>> orderCollection = await saveOrder();
      print(orderCollection);
      if (orderCollection.isEmpty) {
        // Close loading dialog
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        Get.snackbar(
          'Error',
          'Failed to prepare order items',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
        );
        return;
      }

      // Convert the collection to JSON
      String jsonOrderCollection = jsonEncode(orderCollection);

      // Submit the order
      final response = await _apiProvider.postg(
        ApiEndpoints.SAVEORDER,
        data: jsonOrderCollection,
      );

      // Close loading dialog before showing any other dialogs
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // The response is directly the list from the API
      List<dynamic> responseData = response;

      if (responseData.isNotEmpty && responseData[0]['success'] == "1") {
        String orderNo = responseData[0]['uno'] ?? "Unknown";
        String orderId = responseData[0]['id'] ?? "00";

        // Show success dialog with ability to copy order number
        _showOrderSuccessDialog(context, orderNo, orderId);

        // Clear the cart after successful submission
        await clearCart();

        // Clear selected customer
        clearSelectedCustomer();
      } else {
        String errorMessage = responseData.isNotEmpty
            ? responseData[0]['message'] ?? 'Unknown error'
            : 'Failed to submit order';

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

      _handleError('Failed to submit order', e);
    }
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

  void _showOrderSuccessDialog(
      BuildContext context, String orderNo, String id) {
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
                'Order Placed',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your order has been placed successfully.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Order Number: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    orderNo,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: orderNo));
                    Get.snackbar(
                      'Copied',
                      'Order number copied to clipboard',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Get.isDialogOpen ?? false) {
                Get.back();
              }
              // Navigate to orders list
              Get.offAndToNamed("/common/details/${id}");
            },
            child: const Text('View Orders'),
          ),
          TextButton(
            onPressed: () {
              if (id.isNotEmpty && id != "00") {
                // Close the dialog first
                if (Get.isDialogOpen ?? false) {
                  Get.back();
                }
                // Navigate to invoice
                Get.toNamed('/orders/invoice/$id');
              } else {
                Get.snackbar(
                  'Error',
                  'Invalid order ID',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red[100],
                );
              }
            },
            child: const Text('View Invoice'),
          ),
        ],
      ),
    );
  }

  // Error Handling
  void _handleError(String message, dynamic error, {bool showSnackbar = true}) {
    // Log the error
    String errorDetails = error.toString();
    print('$message: $errorDetails');

    // Only show snackbar if requested (default is true)
    if (showSnackbar) {
      Get.snackbar(
        'Error',
        '$message: ${errorDetails.length > 100 ? errorDetails.substring(0, 100) + '...' : errorDetails}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        duration: const Duration(seconds: 3),
      );
    }
  }
}
