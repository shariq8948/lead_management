import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/widgets/custom_button.dart';
import 'package:leads/widgets/custom_field.dart';

import '../../../widgets/custom_select.dart';
import 'areaController.dart';

class AddAreaPage extends StatelessWidget {
  AddAreaPage({super.key});
  final areaController controller = Get.put(areaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add District"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Obx(
              () => CustomSelect(
                label: "Select State",
                placeholder: "Please select a State",
                mainList: controller.states
                    .map(
                      (element) => CustomSelectItem(
                        id: element!.id ?? "",
                        value: element?.state ?? "",
                      ),
                    )
                    .toList(),
                onSelect: (val) async {
                  controller.stateedt.text = val.id;
                  controller.showstateedt.text = val.value;
                  await controller.fetchCity(controller.stateedt.text);
                },
                textEditCtlr: controller.showstateedt,
                showLabel: true,
                onTapField: () {
                  controller.stateedt.clear();
                  controller.showstateedt.clear();
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() {
              // Reactively observing changes
              return CustomSelect(
                label: "Select city",
                placeholder: "Please select city",
                mainList: controller.city
                    .map(
                      (element) => CustomSelectItem(
                        id: element.cityID ?? "",
                        value: element.city ?? "",
                      ),
                    )
                    .toList(),
                onSelect: (val) async {
                  controller.cityedt.text = val.id;
                  controller.showcityeedt.text = val.value;
                },
                textEditCtlr: controller.showcityeedt,
                showLabel: true,
                onTapField: () {
                  controller.cityedt.clear();
                  controller.showcityeedt.clear();
                },
              );
            }),
            SizedBox(
              height: 20,
            ),
            CustomField(
                hintText: "Enter Area",
                labelText: "Area",
                inputAction: TextInputAction.next,
                inputType: TextInputType.text),
            SizedBox(
              height: 20,
            ),
            CustomField(
                hintText: "Locality",
                labelText: "Locality",
                inputAction: TextInputAction.next,
                inputType: TextInputType.text),
            SizedBox(
              height: 20,
            ),
            CustomField(
                hintText: "Pincode",
                labelText: "pincode",
                inputAction: TextInputAction.next,
                inputType: TextInputType.number),
            SizedBox(
              height: 40,
            ),
            CustomButton(
              onPressed: () {},
              buttonType: ButtonTypes.primary,
              width: Get.size.width * .9,
              text: "Save",
            )
          ],
        ),
      ),
    );
  }
}
