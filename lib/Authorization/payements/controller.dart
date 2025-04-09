import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentsController extends GetxController {
  final RxList<Map<String, dynamic>> payments = <Map<String, dynamic>>[].obs;
  final RxBool isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Mock data
    payments.addAll([
      {
        "id": DateTime.now().millisecondsSinceEpoch,
        "Customer": "Suyog SS",
        "Date": "21/04/2024",
        "Amount": "430",
        "Mode of Payment": "Cash",
        "isSelected": false.obs
      },
      // Add more entries
    ]);
  }

  void toggleEditMode() {
    isEditing.toggle();
    if (!isEditing.value) {
      // Deselect all when exiting edit mode
      for (var payment in payments) {
        payment['isSelected'].value = false;
      }
    }
  }

  void togglePaymentSelection(int index) {
    if (isEditing.value) {
      payments[index]['isSelected'].value =
          !payments[index]['isSelected'].value;
    }
  }

  void deleteSelectedPayments() {
    payments.removeWhere((payment) => payment['isSelected'].value);
    if (payments.isEmpty) {
      isEditing.value = false;
    }
  }

  void approvePayment(int index) {
    Get.snackbar(
      'Payment Approved',
      'Payment for ${payments[index]["Customer"]} processed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
    );
  }
}
