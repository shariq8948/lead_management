// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../../core/theme/app_button.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../data/models/common/order_models.dart';
// import '../../invoice/order_repo.dart';
// import '../model.dart';
//
// class OrderDetailsController extends GetxController {
//   final String orderId;
//   OrderDetailsController({required this.orderId});
//
//   final orderData = Rx<OrderDetailModel?>(null);
//   final OrderProvider orderProvider = Get.find<OrderProvider>();
//   @override
//   void onInit() {
//     super.onInit();
//     fetchOrderDetails();
//   }
//
//   final isLoading = true.obs; // Start with loading state
//
//   Future<void> fetchOrderDetails() async {
//     try {
//       isLoading.value = true;
//       final result = await orderProvider.getOrderById(orderId);
//       orderData.value = result;
//
//       print(result.discount);
//     } catch (e) {
//       print(e);
//       Get.snackbar(
//         'Error',
//         'Failed to fetch order details: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void generateInvoice() {
//     Get.toNamed('/orders/invoice/${orderData.value?.id}', arguments: orderData);
//   }
//
//   Future<void> refreshOrderData() async {
//     final String orderId = Get.parameters['id'] ?? '';
//     if (orderId.isNotEmpty) {
//       // await fetchOrderDetails(orderId);
//     }
//   }
//
//   Color getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Colors.orange;
//       case 'processing':
//         return Colors.blue;
//       case 'shipped':
//         return Colors.indigo;
//       case 'delivered':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   void callCustomer(String phoneNumber) async {
//     if (phoneNumber.isEmpty) {
//       Get.snackbar('Error', 'Phone number not available');
//       return;
//     }
//
//     final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
//
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       // Handle case where calling is not supported
//       Get.snackbar(
//         'Error',
//         'Could not make the call. Please dial manually: $phoneNumber',
//         duration: const Duration(seconds: 4),
//         mainButton: TextButton(
//           onPressed: () {
//             Clipboard.setData(ClipboardData(text: phoneNumber));
//             Get.snackbar('Success', 'Phone number copied to clipboard');
//           },
//           child: const Text('Copy', style: TextStyle(color: Colors.white)),
//         ),
//       );
//     }
//   }
//
//   // Email customer method
//   void emailCustomer(String email) async {
//     if (email.isEmpty) {
//       Get.snackbar('Error', 'Email address not available');
//       return;
//     }
//
//     final Uri uri = Uri(
//       scheme: 'mailto',
//       path: email,
//       query: 'subject=Regarding your order ${orderData.value?.orderNo}',
//     );
//
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       // Handle case where email app is not available
//       Get.snackbar(
//         'Error',
//         'Could not open email app. Email address: $email',
//         duration: const Duration(seconds: 4),
//         mainButton: TextButton(
//           onPressed: () {
//             Clipboard.setData(ClipboardData(text: email));
//             Get.snackbar('Success', 'Email address copied to clipboard');
//           },
//           child: const Text('Copy', style: TextStyle(color: Colors.white)),
//         ),
//       );
//     }
//   }
//
//   // Open map method
//   void openMap(String address) async {
//     if (address.isEmpty) {
//       Get.snackbar('Error', 'Address not available');
//       return;
//     }
//
//     // Encode the address for the URL
//     final encodedAddress = Uri.encodeComponent(address);
//     Uri uri;
//
//     if (Platform.isIOS) {
//       // For iOS devices, use Apple Maps
//       uri = Uri.parse('https://maps.apple.com/?q=$encodedAddress');
//     } else {
//       // For other devices, use Google Maps
//       uri = Uri.parse(
//           'https://www.google.com/maps/search/?api=1&query=$encodedAddress');
//     }
//
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       Get.snackbar(
//         'Error',
//         'Could not open maps application',
//         duration: const Duration(seconds: 3),
//       );
//     }
//   }
//
//   void viewItemDetails(OrderItem item) {
//     Get.toNamed('/product-details/${item.itemId}');
//   }
//
//   // Edit customer details method
//   void editCustomerDetails(OrderModel order) {
//     Get.toNamed(
//       '/edit-customer',
//       arguments: {
//         'customer': {
//           'id': order.customerId,
//           'name': order.customerName,
//         },
//         'orderId': order.id,
//       },
//     );
//   }
//
//   // Contact customer support method
//   void contactCustomerSupport(OrderDetailModel order) async {
//     final supportPhone = "8948731278";
//     final supportEmail = "psmsofttechpvtltd496@gmail.com";
//
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Contact Support',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (supportPhone.isNotEmpty)
//               ListTile(
//                 leading: const Icon(Icons.phone),
//                 title: const Text('Call Support'),
//                 subtitle: Text(supportPhone),
//                 onTap: () {
//                   Get.back();
//                   callCustomer(supportPhone);
//                 },
//               ),
//             if (supportEmail.isNotEmpty)
//               ListTile(
//                 leading: const Icon(Icons.email),
//                 title: const Text('Email Support'),
//                 subtitle: Text(supportEmail),
//                 onTap: () {
//                   Get.back();
//                   final Uri uri = Uri(
//                     scheme: 'mailto',
//                     path: supportEmail,
//                     query: 'subject=Support Request: Order ${order.orderNo}',
//                   );
//                   launchUrl(uri);
//                 },
//               ),
//             ListTile(
//               leading: const Icon(Icons.chat_bubble_outline),
//               title: const Text('Live Chat'),
//               onTap: () {
//                 Get.back();
//                 Get.toNamed('/support-chat', arguments: {'orderId': order.id});
//               },
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Cancel order method
//   void cancelOrder(OrderDetailModel order) {
//     Get.dialog(
//       AlertDialog(
//         title: const Text('Cancel Order'),
//         content: const Text(
//             'Are you sure you want to cancel this order? This action cannot be undone.'),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text('No, Keep Order'),
//           ),
//           ElevatedButton(
//             onPressed: () => _processCancelOrder(order.id),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Yes, Cancel Order'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Process order cancellation
//   Future<void> _processCancelOrder(String orderId) async {
//     Get.back(); // Close dialog
//
//     try {
//       Get.dialog(
//         const Center(
//           child: CircularProgressIndicator(),
//         ),
//         barrierDismissible: false,
//       );
//
//       final result = true;
//
//       Get.back(); // Close loading dialog
//
//       if (result) {
//         Get.snackbar(
//           'Success',
//           'Order cancelled successfully',
//           backgroundColor: Colors.green.withOpacity(0.1),
//           colorText: Colors.green,
//         );
//         await refreshOrderData(); // Refresh order data to show updated status
//       } else {
//         Get.snackbar(
//           'Error',
//           'Failed to cancel order',
//           backgroundColor: Colors.red.withOpacity(0.1),
//           colorText: Colors.red,
//         );
//       }
//     } catch (e) {
//       Get.back(); // Close loading dialog
//       Get.snackbar(
//         'Error',
//         'Failed to cancel order: ${e.toString()}',
//         backgroundColor: Colors.red.withOpacity(0.1),
//         colorText: Colors.red,
//       );
//     }
//   }
// }
