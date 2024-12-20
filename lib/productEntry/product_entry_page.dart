import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/productEntry/product_entry_controller.dart';
import 'package:leads/widgets/custom_field.dart';
import 'package:leads/widgets/custom_select.dart';

class ProductEntryPage extends StatelessWidget {
  ProductEntryPage({super.key});
  final ProductEntryController controller = Get.put(ProductEntryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Entry"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE1FFED), // Start color
              Color(0xFFE6E6E6), // End color
            ],
          ),
        ),
        child: _buildProductEntryForm(),
      ),
    );
  }

  Widget _buildProductEntryForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomField(
              hintText: "Enter Product Name",
              labelText: "Product",
              inputAction: TextInputAction.next,
              inputType: TextInputType.text
          )
          ,
          CustomSelect(
            label: "Select Product",
            placeholder: "Please select a product",
            mainList: controller.products
                .map(
                  (element) => CustomSelectItem(
                    id: element.id ?? "",
                    value: element.product ?? "",
                  ),
                )
                .toList(),
            onSelect: (val) async {
              controller.jobEdtCtlr.text = val.value;
            },
            textEditCtlr: controller.jobEdtCtlr,
            showLabel: true,
            onTapField: () {
              controller.jobEdtCtlr.clear();
            },
            onTapOutsideField: (pointerDownEvent) {
              if (controller.selectedProduct.value?.product != null) {
                controller.jobEdtCtlr.text =
                    controller.selectedProduct.value?.product ?? "";
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a product";
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}
