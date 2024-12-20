import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Masters/states/stateController.dart';
import 'package:leads/widgets/custom_button.dart';
import 'package:leads/widgets/custom_field.dart';

class Addstatepage extends StatelessWidget {
  Addstatepage({super.key});
  final stateController controller = Get.put(stateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add State"),
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
            CustomField(
                hintText: "Enter Code",
                labelText: "Code",
                inputAction: TextInputAction.next,
                inputType: TextInputType.number),
            SizedBox(
              height: 20,
            ),
            CustomField(
                hintText: "Enter Code",
                labelText: "Code",
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
