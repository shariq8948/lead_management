import 'package:flutter/material.dart';
import 'package:leads/create_lead/create_lead_controller.dart';
import 'package:get/get.dart';

import '../widgets/custom_field.dart';
import '../widgets/custom_select.dart';

class CreateLeadPage extends StatelessWidget {
   CreateLeadPage({super.key});
final CreateLeadController controller=Get.put((CreateLeadController()));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("New Lead"),
      ),
      body: SafeArea(

            child: SingleChildScrollView(
                child: IntrinsicHeight(
                    child: Column(
                        children: [
                          buildLeadForm(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size.fromHeight(50), // NEW
                              ),
                              onPressed: () {
                                print(controller.leadOwnerController.text);
                                print(controller.leadSourceController.text);
                                print(controller.leadIndustryController.text);
                                print(controller.leadAssignToController.text);
                                print(controller.leadNameController.text);
                                controller.save();
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(fontSize: 24,color: Colors.white),
                              ),
                            ),
                          ),

                        ]
                    ))
            ),
      ),
    );
  }
  Widget buildLeadForm(){
    return Form(
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0,right: 18,top: 10),
        child: Column(

          children: [
            // buildCustomTextField(Icons.search, "Lead source"),

            Obx(
                  () =>
                  CustomSelect(
                    withIcon: true,
                    withShadow: false,
                    customIcon: Icon(Icons.search,size: 28,),
                    label: "Select Lead Source",
                    placeholder: "Please select  Lead Source",
                    mainList: controller.leadSource.map(
                          (element) =>
                          CustomSelectItem(
                            id: element.id ?? "",
                            // Extract the productId as id
                            value: element.name ??
                                "", // Extract the productName as value
                          ),
                    ).toList(),
                    onSelect: (val) async {
                      controller.leadSourceController.text = val.id;
                      controller.showLeadSourceController.text =
                          val.value;
                    },
                    textEditCtlr: controller
                        .showLeadSourceController,
                    showLabel: false,
                    onTapField: () {
                      controller.leadSourceController.clear();
                      controller.showLeadSourceController.clear();
                    },

                  ),
            ),
            SizedBox(height: 18,),

            Obx(
                  () =>
                  CustomSelect(
                    label: "Lead Owner",

                    withShadow: false,
                    withIcon: true,
                    customIcon: Icon(Icons.handshake_outlined,size: 28,),
                    placeholder: "Please select Lewd Owner",
                    mainList: controller.leadOwner.map(
                          (element) =>
                          CustomSelectItem(
                            id: element.id ?? "",
                            // Extract the productId as id
                            value: element.name ??
                                "", // Extract the productName as value
                          ),
                    ).toList(),
                    onSelect: (val) async {
                      controller.leadOwnerController.text = val.id;
                      controller.showLeadOwnerController.text =
                          val.value;
                    },
                    textEditCtlr: controller
                        .showLeadOwnerController,
                    showLabel: false,
                    onTapField: () {
                      controller.leadOwnerController.clear();
                      controller.showLeadOwnerController .clear();
                    },

                  ),
            ),
            SizedBox(height: 18,),
            CustomField(

              labelText:"Lead Name",
              hintText: 'Enter Lead Name',
              editingController:controller.leadNameController,
              inputAction: TextInputAction.next,
              inputType: TextInputType.text,
              showIcon: true,
              withShadow: false,
              customIcon: Icon(Icons.star_border_purple500_sharp,size: 28,),



            ),
            SizedBox(height: 18,),
            CustomField(
              showIcon: true,
              withShadow: false,
              customIcon: Icon(Icons.phone_android_outlined,size: 28,),
              labelText:"Mobile",
              hintText: 'Enter Mobile Number',
              editingController:controller.leadMobileController,
              inputAction: TextInputAction.next,
              inputType: TextInputType.number,

            ),
            SizedBox(height: 18,),
            CustomField(
              showIcon: true,
              withShadow: false,
              customIcon: Icon(Icons.mail_outline_outlined,size: 28,),
              labelText:"Email",
              hintText: 'Enter Email',
              editingController:controller.leadEmailController,
              inputAction: TextInputAction.next,
              inputType: TextInputType.emailAddress,

            ),
            SizedBox(height: 18,),
            CustomField(
              showIcon: true,
              withShadow: false,
              customIcon: Icon(Icons.map_outlined,size: 28,),
              labelText:"Address",
              hintText: 'Enter Address',
              editingController:controller.leadAddressController,
              inputAction: TextInputAction.next,
              inputType: TextInputType.streetAddress,

            ),
            SizedBox(height: 18,),

            Obx(
                  () =>
                  CustomSelect(
                    label: "Select Industry",
                    withShadow: false,
                    withIcon: true,
                    customIcon: Icon(Icons.factory_outlined,size: 28,),
                    placeholder: "Please select Industry",
                    mainList: controller.industryList.map(
                          (element) =>
                          CustomSelectItem(
                            id: element.id ?? "",
                            // Extract the productId as id
                            value: element.name ??
                                "", // Extract the productName as value
                          ),
                    ).toList(),
                    onSelect: (val) async {
                      controller.leadIndustryController.text = val.id;
                      controller.showLeadIndustryController.text =
                          val.value;
                    },
                    textEditCtlr: controller
                        .showLeadIndustryController,
                    showLabel: false,
                    onTapField: () {
                      controller.leadIndustryController.clear();
                      controller.showLeadIndustryController.clear();
                    },

                  ),
            ),


            SizedBox(height: 18,),
            CustomField(
              showIcon: true,
              withShadow: false,
              customIcon: Icon(Icons.view_compact_alt_sharp,size: 28,),
              labelText:"Company",
              hintText: 'Enter Company Name',
              editingController:controller.leadComapnyController,
              inputAction: TextInputAction.next,
              inputType: TextInputType.text,

            ),
            SizedBox(height: 18,),
            Obx(
                  () =>
                  CustomSelect(
                    label: "Assign to",
                    withShadow: false,
                    withIcon: true,
                    customIcon: Icon(Icons.supervised_user_circle_outlined,size: 28,),
                    placeholder: "Assign To",
                    mainList: controller.leadAssignToList.map(
                          (element) =>
                          CustomSelectItem(
                            id: element.id ?? "",
                            // Extract the productId as id
                            value: element.name ??
                                "", // Extract the productName as value
                          ),
                    ).toList(),
                    onSelect: (val) async {
                      controller.leadAssignToController.text = val.id;
                      controller.showLeadAssignToController.text =
                          val.value;
                    },
                    textEditCtlr: controller
                        .showLeadAssignToController,
                    showLabel: false,
                    onTapField: () {
                      controller.leadAssignToController.clear();
                      controller.showLeadAssignToController.clear();
                    },

                  ),
            ),
            SizedBox(height: 18,),

            CustomField(
              showIcon: true,
              withShadow: false,
              customIcon: Icon(Icons.currency_rupee_outlined,size: 28,),
              labelText:"Deal Size",
              hintText: 'Enter Deal Size',
              editingController:controller.leadDealSizeController,
              inputAction: TextInputAction.next,
              inputType: TextInputType.number,

            ),
            SizedBox(height: 18,),
            CustomField(
              withShadow: false,

              labelText:"Description",
              hintText: 'Enter Lead Description',
              editingController:controller.leadDescriptionontroller,
              inputAction: TextInputAction.next,
              inputType: TextInputType.text,
              minLines: 4,

            ),
            SizedBox(height: 18,),

          ],
        ),
      ),
    );
  }

}
