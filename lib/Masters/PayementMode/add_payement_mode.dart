import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Masters/PayementMode/payement_mode_controller.dart';
import 'package:leads/widgets/custom_field.dart';
import '../../widgets/custom_select.dart';
import '../../widgets/save_button.dart';
import 'package:leads/widgets/custom_loader.dart';

class AddPayementModePage extends StatelessWidget {
  AddPayementModePage({super.key});
  final PayementModeController controller = Get.put(PayementModeController());

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments;
    final bool isEdit = arguments['isEdit'] ?? false;
    final String id = arguments['id'] ?? "0";

    if (isEdit) {
      controller.payementTypeController.text = arguments['paymentType'];
      controller.modeController.text = arguments['paymentMode'];
    } else {
      controller.payementTypeController.clear();
      controller.modeController.clear();
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: _buildAppBar(isEdit),
      body: SafeArea(
        child: Obx(() {
          if (controller.isAddingProduct.value) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomLoader(),
                    SizedBox(height: 16),
                    Text(
                      isEdit ? "Updating..." : "Saving...",
                      style: TextStyle(
                        color: Color(0xFF2C3E50),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(isEdit),
                _buildForm(isEdit, id),
              ],
            ),
          );
        }),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isEdit) {
    return AppBar(
      elevation: 0,
      backgroundColor: Color(0xFF2C3E50),
      title: Text(
        isEdit ? "Edit Payment Mode" : "Add Payment Mode",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.help_outline, color: Colors.white),
          onPressed: () => _showHelp(),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isEdit) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF2C3E50),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            isEdit ? Icons.edit_note : Icons.payments_outlined,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 8),
          Text(
            isEdit ? "Update Payment Mode Details" : "Create New Payment Mode",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isEdit, String id) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Payment Details", Icons.payment),
              SizedBox(height: 20),
              Obx(
                () => _buildCustomSelect(),
              ),
              SizedBox(height: 20),
              _buildPaymentModeField(),
              SizedBox(height: 30),
              _buildActionButtons(isEdit, id),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF2C3E50), size: 24),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Category",
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        CustomSelect(
          label: "Category",
          placeholder: "Select Payment Category",
          mainList: controller.type
              .map(
                (element) => CustomSelectItem(
                  id: "",
                  value: element.paymentType ?? "",
                ),
              )
              .toList(),
          onSelect: (val) async {
            controller.payementTypeController.text = val.value;
          },
          textEditCtlr: controller.payementTypeController,
          showLabel: false,
          onTapField: () {
            controller.payementTypeController.clear();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a payment category';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPaymentModeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Mode",
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        CustomField(
          hintText: "Enter Payment Mode",
          labelText: "Payment Mode",
          inputAction: TextInputAction.next,
          inputType: TextInputType.text,
          editingController: controller.modeController,
          onChange: (e) {},
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a payment mode';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isEdit, String id) {
    return Column(
      children: [
        CustomSaveButton(
          buttonText: isEdit ? "Update Payment Mode" : "Save Payment Mode",
          onPressed: () {
            isEdit ? updateForm(id) : saveForm();
          },
        ),
        SizedBox(height: 12),
        TextButton(
          onPressed: () {
            controller.payementTypeController.clear();
            controller.modeController.clear();
          },
          child: Text(
            "Clear Form",
            style: TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showHelp() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF2C3E50)),
            SizedBox(width: 8),
            Text("Help Guide"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
              "Payment Category",
              "Select the type of payment from the available categories",
              Icons.category,
            ),
            _buildHelpItem(
              "Payment Mode",
              "Enter the specific mode of payment (e.g., Cash, Card, UPI)",
              Icons.payments,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2C3E50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Got it!", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Color(0xFF2C3E50)),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void saveForm() {
    if (controller.formKey.currentState?.validate() ?? false) {
      _showConfirmationDialog(false, "0");
    } else {
      Get.snackbar(
        "Validation Failed",
        "Please fill in all required fields correctly.",
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(8),
        borderRadius: 10,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }

  void updateForm(String id) {
    if (controller.formKey.currentState?.validate() ?? false) {
      _showConfirmationDialog(true, id);
    } else {
      Get.snackbar(
        "Validation Failed",
        "Please fill in all required fields correctly.",
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(8),
        borderRadius: 10,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }

  void _showConfirmationDialog(bool isEdit, String id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(
              isEdit ? Icons.edit : Icons.save,
              color: Color(0xFF2C3E50),
            ),
            SizedBox(width: 8),
            Text(isEdit ? "Update Payment Mode" : "Save Payment Mode"),
          ],
        ),
        content: Text(
          isEdit
              ? "Are you sure you want to update this payment mode?"
              : "Are you sure you want to save this payment mode?",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              isEdit ? controller.updateForm(id) : controller.save();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2C3E50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isEdit ? "Update" : "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
