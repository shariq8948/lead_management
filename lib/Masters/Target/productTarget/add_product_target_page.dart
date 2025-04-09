import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Masters/Target/monthlyTarget/add_product_controller.dart';
import 'package:leads/widgets/custom_field.dart';

import '../../../widgets/custom_select.dart';

class AddProductTargetPage extends StatelessWidget {
  AddProductTargetPage({super.key});
  final TargetController controller = Get.put(TargetController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Target"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  child: Column(
                children: [
                  Obx(
                    () => CustomSelect(
                      label: "Select Mr",
                      withShadow: false,
                      withIcon: true,
                      customIcon: Icon(
                        Icons.supervised_user_circle_outlined,
                        size: 28,
                      ),
                      placeholder: "Select MR",
                      mainList: controller.leadAssignToList
                          .map(
                            (element) => CustomSelectItem(
                              id: element.id ?? "",
                              // Extract the productId as id
                              value: element.name ??
                                  "", // Extract the productName as value
                            ),
                          )
                          .toList(),
                      onSelect: (val) async {
                        controller.leadAssignToController.text = val.id;
                        controller.showLeadAssignToController.text = val.value;
                      },
                      textEditCtlr: controller.showLeadAssignToController,
                      showLabel: false,
                      onTapField: () {
                        controller.leadAssignToController.clear();
                        controller.showLeadAssignToController.clear();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Obx(
                    () => CustomSelect(
                      label: "Product",
                      withShadow: false,
                      withIcon: true,
                      customIcon: Icon(
                        Icons.supervised_user_circle_outlined,
                        size: 28,
                      ),
                      placeholder: "Select Product",
                      mainList: controller.leadAssignToList
                          .map(
                            (element) => CustomSelectItem(
                              id: element.id ?? "",
                              // Extract the productId as id
                              value: element.name ??
                                  "", // Extract the productName as value
                            ),
                          )
                          .toList(),
                      onSelect: (val) async {
                        controller.leadAssignToController.text = val.id;
                        controller.showLeadAssignToController.text = val.value;
                      },
                      textEditCtlr: controller.showLeadAssignToController,
                      showLabel: false,
                      onTapField: () {
                        controller.leadAssignToController.clear();
                        controller.showLeadAssignToController.clear();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Obx(
                          () => CustomSelect(
                            label: "Month",
                            withShadow: false,
                            withIcon: true,
                            customIcon: Icon(
                              Icons.calendar_month,
                              size: 28,
                            ),
                            placeholder: "Select Month",
                            mainList: controller.leadAssignToList
                                .map(
                                  (element) => CustomSelectItem(
                                    id: element.id ?? "",
                                    // Extract the productId as id
                                    value: element.name ??
                                        "", // Extract the productName as value
                                  ),
                                )
                                .toList(),
                            onSelect: (val) async {
                              controller.leadAssignToController.text = val.id;
                              controller.showLeadAssignToController.text =
                                  val.value;
                            },
                            textEditCtlr: controller.showLeadAssignToController,
                            showLabel: false,
                            onTapField: () {
                              controller.leadAssignToController.clear();
                              controller.showLeadAssignToController.clear();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: Obx(
                          () => CustomSelect(
                            label: "Select Year",
                            withShadow: false,
                            withIcon: true,
                            customIcon: Icon(
                              Icons.calendar_month_outlined,
                              size: 28,
                            ),
                            placeholder: "Select Year",
                            mainList: controller.leadAssignToList
                                .map(
                                  (element) => CustomSelectItem(
                                    id: element.id ?? "",
                                    // Extract the productId as id
                                    value: element.name ??
                                        "", // Extract the productName as value
                                  ),
                                )
                                .toList(),
                            onSelect: (val) async {
                              controller.leadAssignToController.text = val.id;
                              controller.showLeadAssignToController.text =
                                  val.value;
                            },
                            textEditCtlr: controller.showLeadAssignToController,
                            showLabel: false,
                            onTapField: () {
                              controller.leadAssignToController.clear();
                              controller.showLeadAssignToController.clear();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  CustomField(
                      hintText: "Quantity",
                      labelText: "labelText",
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.number),
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA726),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Save",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )),
            )
          ],
        ),
      )),
    );
  }
}
