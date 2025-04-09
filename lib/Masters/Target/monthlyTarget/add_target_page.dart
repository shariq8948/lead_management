import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Masters/Target/monthlyTarget/add_product_controller.dart';
import 'package:leads/widgets/custom_field.dart';
import '../../../widgets/custom_select.dart';

class AddTargetPage extends StatelessWidget {
  AddTargetPage({super.key});
  final TargetController controller = Get.put(TargetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Add Target",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.05),
                Colors.white,
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Obx(() => !controller.isEdit.value
                      ? _buildRoleSelector()
                      : const SizedBox.shrink()),
                  const SizedBox(height: 24),
                  Obx(() => controller.selectedRole.value == "MR"
                      ? _buildMRForm()
                      : _buildCordinatorForm()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Role",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRoleOption("MR", Icons.person),
              _buildRoleOption("Cordinator", Icons.supervisor_account),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleOption(String role, IconData icon) {
    return Obx(() {
      final isSelected = controller.selectedRole.value == role;
      return GestureDetector(
        onTap: () {
          controller.selectedRole.value = role;
          Future.microtask(() {
            controller.clearFormMonthly();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFA726) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? const Color(0xFFFFA726) : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                role,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required TextInputAction textInputAction,
    String? Function(String?)? validator,
    bool isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label + (isRequired ? " *" : ""),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          CustomField(
            hintText: "Enter $label",
            labelText: label,
            inputAction: textInputAction,
            inputType: keyboardType,
            editingController: controller,
            validator: validator ??
                (val) {
                  if (isRequired && (val == null || val.trim().isEmpty)) {
                    return "Please enter $label";
                  }
                  return null;
                },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(void Function()? onPressed) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFA726),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Text(
          (controller.isEdit.value) ? "Edit" : "Save",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectField({
    required String label,
    required CustomSelect selectWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label *",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          selectWidget,
        ],
      ),
    );
  }

  Widget _buildCordinatorForm() {
    final formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSelectField(
              label: "Coordinator",
              selectWidget: CustomSelect(
                label: "Select Coordinator",
                withShadow: true,
                placeholder: "Select Coordinator",
                mainList: controller.cordinators
                    .map((e) => CustomSelectItem(
                          id: e.userId ?? "",
                          value: e.username ?? "",
                        ))
                    .toList(),
                onSelect: (val) {
                  controller.cordinatorController.text = val.id;
                  controller.showCordinatorController.text = val.value;
                },
                textEditCtlr: controller.showCordinatorController,
                showLabel: false,
                onTapField: () {
                  controller.cordinatorController.clear();
                  controller.showCordinatorController.clear();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildSelectField(
                    label: "Year",
                    selectWidget: CustomSelect(
                      label: "Select Year",
                      withShadow: true,
                      withIcon: true,
                      customIcon: const Icon(Icons.calendar_today, size: 24),
                      placeholder: "Select Year",
                      mainList: controller.years,
                      onSelect: (val) {
                        controller.yearController.text = val.value;
                      },
                      textEditCtlr: controller.yearController,
                      showLabel: false,
                      onTapField: () {
                        controller.yearController.clear();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSelectField(
                    label: "Month",
                    selectWidget: CustomSelect(
                      label: "Select Month",
                      withShadow: true,
                      withIcon: true,
                      customIcon: const Icon(Icons.event, size: 24),
                      placeholder: "Select Month",
                      mainList: controller.monthsList
                          .map((e) => CustomSelectItem(
                                id: e.value,
                                value: e.month,
                              ))
                          .toList(),
                      onSelect: (val) {
                        controller.monthController.text = val.id;
                        controller.showMonthController.text = val.value;
                      },
                      textEditCtlr: controller.showMonthController,
                      showLabel: false,
                      onTapField: () {
                        controller.monthController.clear();
                        controller.showMonthController.clear();
                      },
                    ),
                  ),
                ),
              ],
            ),
            _buildFormField(
              label: "New Leads",
              controller: controller.leadsController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            _buildFormField(
              label: "Collection Target",
              controller: controller.collectionController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            _buildFormField(
              label: "Calls",
              controller: controller.callsController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            _buildFormField(
              label: "Set Salary",
              controller: controller.setSalaryExController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter a salary";
                }
                if (double.tryParse(val) == null || double.parse(val) <= 0) {
                  return "Please enter a valid salary amount";
                }
                return null;
              },
            ),
            _buildSaveButton(() {
              if (formKey.currentState!.validate()) {
                if (controller.isEdit.value) {
                  controller.updateMonthlyTarget(controller.id.value);
                } else {
                  controller.addMonthlyTarget();
                }
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMRForm() {
    final formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSelectField(
              label: "MR",
              selectWidget: CustomSelect(
                label: "Select MR",
                withShadow: true,
                placeholder: "Select MR",
                mainList: controller.mr
                    .map((e) => CustomSelectItem(
                          id: e.id ?? "",
                          value: e.username ?? "",
                        ))
                    .toList(),
                onSelect: (val) {
                  controller.MrController.text = val.id;
                  controller.showMrController.text = val.value;
                },
                textEditCtlr: controller.showMrController,
                showLabel: false,
                onTapField: () {
                  controller.MrController.clear();
                  controller.showMrController.clear();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildSelectField(
                    label: "Year",
                    selectWidget: CustomSelect(
                      label: "Select Year",
                      withShadow: true,
                      withIcon: true,
                      customIcon: const Icon(Icons.calendar_today, size: 24),
                      placeholder: "Select Year",
                      mainList: controller.years,
                      onSelect: (val) {
                        controller.yearController.text = val.value;
                      },
                      textEditCtlr: controller.yearController,
                      showLabel: false,
                      onTapField: () {
                        controller.yearController.clear();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSelectField(
                    label: "Month",
                    selectWidget: CustomSelect(
                      label: "Select Month",
                      withShadow: true,
                      withIcon: true,
                      customIcon: const Icon(Icons.event, size: 24),
                      placeholder: "Select Month",
                      mainList: controller.monthsList
                          .map((e) => CustomSelectItem(
                                id: e.value,
                                value: e.month,
                              ))
                          .toList(),
                      onSelect: (val) {
                        controller.monthController.text = val.id;
                        controller.showMonthController.text = val.value;
                      },
                      textEditCtlr: controller.showMonthController,
                      showLabel: false,
                      onTapField: () {
                        controller.monthController.clear();
                        controller.showMonthController.clear();
                      },
                    ),
                  ),
                ),
              ],
            ),
            _buildFormField(
              label: "New Leads",
              controller: controller.leadsController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            _buildFormField(
              label: "Collection Target",
              controller: controller.collectionController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            _buildFormField(
              label: "Calls",
              controller: controller.callsController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            _buildFormField(
              label: "Local Expenses",
              controller: controller.localExController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            _buildFormField(
              label: "Night Halt",
              controller: controller.nightHaultExController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            _buildFormField(
              label: "Extra HQ",
              controller: controller.extraHqExController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            _buildFormField(
              label: "Set Salary",
              controller: controller.setSalaryExController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter a salary";
                }
                if (double.tryParse(val) == null || double.parse(val) <= 0) {
                  return "Please enter a valid salary amount";
                }
                return null;
              },
            ),
            _buildSaveButton(() {
              if (formKey.currentState!.validate()) {
                if (controller.isEdit.value) {
                  controller.updateMonthlyTarget(controller.id.value);
                } else {
                  controller.addMonthlyTarget();
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}

// Loading Indicator Widget
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFA726)),
        ),
      ),
    );
  }
}

// Custom Theme Data
final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFFFFA726),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFFA726),
    primary: const Color(0xFFFFA726),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[50],
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
      borderSide: const BorderSide(color: Color(0xFFFFA726)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFA726),
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  ),
);
