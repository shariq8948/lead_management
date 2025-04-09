import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/widgets/customActionbutton.dart';
import '../../widgets/custom_field.dart';
import '../../widgets/custom_select.dart';
import '../../widgets/custom_snckbar.dart';
import 'create_lead_controller.dart';

class CreateLeadPage extends StatelessWidget {
  CreateLeadPage({super.key});
  final controller = Get.find<CreateLeadController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                buildLeadForm(context),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Obx(() => Text(
            controller.isEdit.value ? "Edit Lead" : "Create New Lead",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          )),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_center_outlined, color: Colors.black87),
          onPressed: () => _showHelpDialog(context),
          tooltip: 'Help',
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget buildLeadForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildFormSection(
              icon: Icons.source_outlined,
              title: "Lead Source & Owner",
              children: [
                _buildSourceField(),
                _buildSpacing(),
                _buildOwnerField(),
              ],
            ),
            _buildDivider(),
            _buildFormSection(
              icon: Icons.person_outline,
              title: "Basic Information",
              children: _buildBasicInfoFields(),
            ),
            _buildDivider(),
            _buildFormSection(
              icon: Icons.business_outlined,
              title: "Company Details",
              children: _buildCompanyFields(),
            ),
            _buildDivider(),
            _buildFormSection(
              icon: Icons.description_outlined,
              title: "Additional Information",
              children: [_buildDescriptionField()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.blue[700], size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSourceField() {
    return Obx(
      () => CustomSelect(
        withIcon: true,
        withShadow: false,
        customIcon: const Icon(Icons.source_outlined, size: 24),
        label: "Lead Source",
        placeholder: "Select Lead Source",
        mainList: controller.leadSource
            .map((element) => CustomSelectItem(
                  id: element.id ?? "",
                  value: element.name ?? "",
                ))
            .toList(),
        onSelect: (val) {
          controller.leadSourceController.text = val.id;
          controller.showLeadSourceController.text = val.value;
        },
        textEditCtlr: controller.showLeadSourceController,
        showLabel: true,
        onTapField: () {
          controller.leadSourceController.clear();
          controller.showLeadSourceController.clear();
        },
        validator: (value) =>
            value?.isEmpty ?? true ? 'Please select Lead Source' : null,
      ),
    );
  }

  Widget _buildOwnerField() {
    return Obx(
      () => CustomSelect(
        withIcon: true,
        withShadow: false,
        customIcon: const Icon(Icons.person_outline, size: 24),
        label: "Lead Owner",
        placeholder: "Select Lead Owner",
        mainList: controller.leadOwner
            .map((element) => CustomSelectItem(
                  id: element.id ?? "",
                  value: element.name ?? "",
                ))
            .toList(),
        onSelect: (val) {
          controller.leadOwnerController.text = val.id;
          controller.showLeadOwnerController.text = val.value;
        },
        textEditCtlr: controller.showLeadOwnerController,
        showLabel: true,
        onTapField: () {
          controller.leadOwnerController.clear();
          controller.showLeadOwnerController.clear();
        },
        validator: (value) =>
            value?.isEmpty ?? true ? 'Please select Lead Owner' : null,
      ),
    );
  }

  List<Widget> _buildBasicInfoFields() {
    return [
      CustomField(
        labelText: "Lead Name",
        hintText: 'Enter Lead Name',
        editingController: controller.leadNameController,
        inputAction: TextInputAction.next,
        inputType: TextInputType.text,
        showIcon: true,
        withShadow: false,
        customIcon: const Icon(Icons.person_outline, size: 24),
        validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter Lead Name' : null,
      ),
      _buildSpacing(),
      CustomField(
        showIcon: true,
        withShadow: false,
        customIcon: const Icon(Icons.phone_android_outlined, size: 24),
        labelText: "Mobile",
        hintText: 'Enter Mobile Number',
        editingController: controller.leadMobileController,
        inputAction: TextInputAction.next,
        inputType: TextInputType.phone,
        validator: (value) => _validatePhone(value),
      ),
      _buildSpacing(),
      CustomField(
        showIcon: true,
        withShadow: false,
        customIcon: const Icon(Icons.email_outlined, size: 24),
        labelText: "Email",
        hintText: 'Enter Email',
        editingController: controller.leadEmailController,
        inputAction: TextInputAction.next,
        inputType: TextInputType.emailAddress,
        validator: (value) => _validateEmail(value),
      ),
    ];
  }

  List<Widget> _buildCompanyFields() {
    return [
      CustomField(
        showIcon: true,
        withShadow: false,
        customIcon: const Icon(Icons.business_outlined, size: 24),
        labelText: "Company",
        hintText: 'Enter Company Name',
        editingController: controller.leadComapnyController,
        inputAction: TextInputAction.next,
        inputType: TextInputType.text,
        validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter Company Name' : null,
      ),
      _buildSpacing(),
      Obx(
        () => CustomSelect(
          label: "Industry",
          withShadow: false,
          withIcon: true,
          customIcon: const Icon(Icons.category_outlined, size: 24),
          placeholder: "Select Industry",
          mainList: controller.industryList
              .map((element) => CustomSelectItem(
                    id: element.id ?? "",
                    value: element.name ?? "",
                  ))
              .toList(),
          onSelect: (val) {
            controller.leadIndustryController.text = val.id;
            controller.showLeadIndustryController.text = val.value;
          },
          textEditCtlr: controller.showLeadIndustryController,
          showLabel: true,
          onTapField: () {
            controller.leadIndustryController.clear();
            controller.showLeadIndustryController.clear();
          },
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please select Industry' : null,
        ),
      ),
      _buildSpacing(),
      CustomField(
        showIcon: true,
        withShadow: false,
        customIcon: const Icon(Icons.attach_money_outlined, size: 24),
        labelText: "Deal Size",
        hintText: 'Enter Deal Size',
        editingController: controller.leadDealSizeController,
        inputAction: TextInputAction.next,
        inputType: TextInputType.number,
        validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter Deal Size' : null,
      ),
    ];
  }

  Widget _buildDescriptionField() {
    return CustomField(
      withShadow: false,
      labelText: "Description",
      hintText: 'Enter Lead Description',
      editingController: controller.leadDescriptionontroller,
      inputAction: TextInputAction.done,
      inputType: TextInputType.multiline,
      minLines: 4,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
    );
  }

  Widget _buildSpacing() => const SizedBox(height: 16);

  Widget _buildHelpFAB(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blue[700],
      child: const Icon(Icons.help_outline),
      onPressed: () => _showHelpDialog(context),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Colors.blue[700]),
            const SizedBox(width: 8),
            const Text('Help Guide'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection(
                'Lead Source & Owner',
                'Select where the lead came from and who will be responsible for following up.',
              ),
              _buildHelpSection(
                'Basic Information',
                'Enter the lead\'s contact details. Make sure to provide valid email and phone number.',
              ),
              _buildHelpSection(
                'Company Details',
                'Provide information about the lead\'s company, industry, and potential deal size.',
              ),
              _buildHelpSection(
                'Additional Information',
                'Add any relevant notes or details that might help in converting this lead.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(color: Colors.blue[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Obx(
        () => (controller.isLoading.value)
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed:
                    controller.isLoading.value ? null : () => _handleSubmit(),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline),
                          const SizedBox(width: 8),
                          Text(
                            controller.isEdit.value
                                ? 'Update Lead'
                                : 'Create Lead',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              )
            : CustomActionButton(
                type: CustomButtonType.save,
                onPressed: _handleSubmit,
                label: controller.isEdit.value ? "Update Lead" : "Create Lead"),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      controller.isLoading.value = true;

      try {
        final response = controller.isEdit.value
            ? await controller.updateLead() // Call update() for edit mode
            : await controller.save(); // Call save() for create mode

        if (response.status == "1") {
          CustomSnack.show(
            content: response.message ??
                (controller.isEdit.value
                    ? "Lead updated successfully"
                    : "Lead created successfully"),
            snackType: SnackType.success,
            behavior: SnackBarBehavior.floating,
          );
          Get.back(result: true);
        } else {
          CustomSnack.show(
            content: response.error ??
                (controller.isEdit.value
                    ? "Failed to update lead"
                    : "Failed to create lead"),
            snackType: SnackType.error,
            behavior: SnackBarBehavior.floating,
          );
        }
      } catch (e) {
        CustomSnack.show(
          content:
              "An error occurred while ${controller.isEdit.value ? 'updating' : 'creating'} the lead",
          snackType: SnackType.error,
          behavior: SnackBarBehavior.floating,
        );
      } finally {
        controller.isLoading.value = false;
      }
    } else {
      CustomSnack.show(
        content: "Please fill all required fields correctly",
        snackType: SnackType.warning,
        behavior: SnackBarBehavior.floating,
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value?.isNotEmpty ?? false) {
      if (!GetUtils.isEmail(value!)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter Mobile Number';
    }
    if (!GetUtils.isPhoneNumber(value!)) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600]),
            const SizedBox(width: 8),
            const Text('Success'),
          ],
        ),
        content: const Text('Lead has been created successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Return to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[600]),
            const SizedBox(width: 8),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Creating Lead...'),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
