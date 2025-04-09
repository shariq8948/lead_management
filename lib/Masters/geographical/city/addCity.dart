import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:leads/widgets/custom_button.dart';
import 'package:leads/widgets/custom_field.dart';

import '../../../widgets/custom_select.dart';
import '../states/stateController.dart';
import 'cityListController.dart';

class AddCityPage extends StatelessWidget {
  AddCityPage({super.key});
  final cityListController controller = Get.put(cityListController());
  final stateController statecontroller = Get.put(stateController());

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
                mainList: statecontroller.states
                    .map(
                      (element) => CustomSelectItem(
                        id: element.id ?? "",
                        value: element.state ?? "",
                      ),
                    )
                    .toList(),
                onSelect: (val) async {
                  controller.stateedt.text = val.id;
                  controller.showstateedt.text = val.value;
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
            CustomField(
                hintText: "Enter City",
                labelText: "City",
                inputAction: TextInputAction.next,
                inputType: TextInputType.text),
            SizedBox(
              height: 20,
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
