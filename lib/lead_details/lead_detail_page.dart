import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_select.dart';
import 'lead_detail_controller.dart';

class LeadDetailPage extends StatelessWidget {
  final LeadDetailController controller = Get.put(LeadDetailController());

  @override
  Widget build(BuildContext context) {
    final String id = Get.arguments;
    controller.fetchLead(id);
    return Scaffold(
      backgroundColor: Color(0xFFE6FFF6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text('Lead Detail', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: Obx(() {
              switch (controller.currentTabIndex.value) {
                case 0:
                  return ListView(children: [_buildActivitySection()]);
                case 1:
                  return _buildTaskSection();
                case 2:
                  return _buildDetailsSection(context);
                default:
                  return Container();
              }
            }),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildExpandableFAB(),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Obx(() {
      return Form(
        key: controller.formKey,
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green, // Color of the active step
              onSurface: Colors.grey, // Color of the inactive step
            ),
          ),
          child: Stepper(
            currentStep: controller.currentStep.value,
            // connectorColor: Colors.tealAccent,
            onStepTapped: (step) => controller.changeStep(step),
            onStepContinue: () {
              if (controller.currentStep.value < 2) {
                controller.changeStep(controller.currentStep.value + 1);
              } else {
                // Handle form submission here
              }
            },
            onStepCancel: () {
              if (controller.currentStep.value > 0) {
                controller.changeStep(controller.currentStep.value - 1);
              }
            },
            steps: [
              Step(
                title: Text('Step 1: Customer Details'),
                content: _buildStep1Form(),
                isActive: controller.currentStep.value >= 0,
                state: controller.currentStep.value == 0
                    ? StepState.editing
                    : StepState.complete,
              ),
              Step(
                title: Text('Step 2: Company Details'),
                content: _buildStep2Form(),
                isActive: controller.currentStep.value >= 1,
                state: controller.currentStep.value == 1
                    ? StepState.editing
                    : StepState.complete,
              ),
              Step(
                title: Text('Step 3: Final Details'),
                content: _buildStep3Form(),
                isActive: controller.currentStep.value >= 2,
                state: controller.currentStep.value == 2
                    ? StepState.editing
                    : StepState.complete,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStep1Form() {
    controller.leadOwnerController.text = controller.details[0].ownerName;
    controller.leadPriorityController.text = controller.details[0].priority;
    controller.leadAssignController.text = controller.details[0].assignToName;
    controller.nameController.text = controller.details[0].name!;
    controller.mobileController.text = controller.details[0].mobile;
    controller.emailController.text = controller.details[0].email!;
    controller.ledgerController.text = controller.details[0].leadid!;
    controller.customerTypeController.text =
        controller.details[0].custProsType!;
    controller.customerTypeController.text =
        controller.details[0].custProsType!;
    return Column(
      children: [
        //lead owner
        Obx(
          () => CustomSelect(
            label: "Lead Owner",
            placeholder: "Please select lead owner",
            mainList: controller.leadOwner
                .map(
                  (element) => CustomSelectItem(
                    id: element ?? "",
                    value: element ?? "",
                  ),
                )
                .toList(),
            onSelect: (val) async {
              controller.leadOwnerController.text = val.value;
            },
            textEditCtlr: controller.leadOwnerController,
            showLabel: true,
            onTapField: () {
              controller.leadOwnerController.clear();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a product";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
        //lead priority
        Obx(
          () => CustomSelect(
            label: "Lead Priority",
            filledColor: Colors.white,
            placeholder: "Please select a lead priority",
            mainList: controller.leadPriority
                .map(
                  (element) => CustomSelectItem(
                    id: element ?? "",
                    value: element ?? "",
                  ),
                )
                .toList(),
            onSelect: (val) async {
              controller.leadPriorityController.text = val.value;
            },
            textEditCtlr: controller.leadPriorityController,
            showLabel: true,
            onTapField: () {
              controller.leadPriorityController.clear();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a product";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
        //assign to
        Obx(
          () => CustomSelect(
            label: "Assign to",
            placeholder: "Assign to",
            mainList: controller.leadAssign
                .map(
                  (element) => CustomSelectItem(
                    id: element ?? "",
                    value: element ?? "",
                  ),
                )
                .toList(),
            onSelect: (val) async {
              controller.leadAssignController.text = val.value;
            },
            textEditCtlr: controller.leadAssignController,
            showLabel: true,
            onTapField: () {
              controller.leadAssignController.clear();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a product";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
        //name
        CustomField(
          withShadow: true,
          labelText: "Customer Name",
          hintText: "Enter Customer Name",
          inputAction: TextInputAction.done,
          inputType: TextInputType.text,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.nameController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        //mobile
        CustomField(
          withShadow: true,
          labelText: "Mobile Number",
          hintText: "Mobile Number",
          inputAction: TextInputAction.done,
          inputType: TextInputType.number,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.mobileController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        //email
        CustomField(
          withShadow: true,
          labelText: "Customer Email",
          hintText: "Enter Customer Email",
          inputAction: TextInputAction.done,
          inputType: TextInputType.emailAddress,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.emailController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        //ledger id
        CustomField(
          withShadow: true,
          labelText: "Ledger Id",
          hintText: "Enter Ledger Id",
          inputAction: TextInputAction.done,
          inputType: TextInputType.text,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.ledgerController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        //customer type
        const SizedBox(height: 10),
        Obx(
          () => CustomSelect(
            label: "Customer type",
            placeholder: "Customer",
            mainList: controller.customerType
                .map(
                  (element) => CustomSelectItem(
                    id: element ?? "",
                    value: element ?? "",
                  ),
                )
                .toList(),
            onSelect: (val) async {
              controller.customerTypeController.text = val.value;
            },
            textEditCtlr: controller.customerTypeController,
            showLabel: true,
            onTapField: () {
              controller.customerTypeController.clear();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a product";
              }
              return null;
            },
          ),
        ),
        //Registration Type
        const SizedBox(height: 10),
        Obx(
          () => CustomSelect(
            label: "Registration type",
            placeholder: "Registration",
            mainList: controller.registrationType
                .map(
                  (element) => CustomSelectItem(
                    id: element ?? "",
                    value: element ?? "",
                  ),
                )
                .toList(),
            onSelect: (val) async {
              controller.registrationTypeController.text = val.value;
            },
            textEditCtlr: controller.registrationTypeController,
            showLabel: true,
            onTapField: () {
              controller.registrationTypeController.clear();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a product";
              }
              return null;
            },
          ),
        ),
        //Party type
        const SizedBox(height: 10),
        Obx(
          () => CustomSelect(
            label: "Party type",
            placeholder: "Party",
            mainList: controller.partyType
                .map(
                  (element) => CustomSelectItem(
                    id: element ?? "",
                    value: element ?? "",
                  ),
                )
                .toList(),
            onSelect: (val) async {
              controller.partyTypeController.text = val.value;
            },
            textEditCtlr: controller.partyTypeController,
            showLabel: true,
            onTapField: () {
              controller.partyTypeController.clear();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a product";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Form() {
    controller.companyNameController.text = controller.details[0].company!;
    controller.addressController.text = controller.details[0].address!;
    controller.industryController.text = controller.details[0].industrytype!;
    controller.stateController.text = controller.details[0].state;
    return Column(
      children: [
        //comapny name
        CustomField(
          withShadow: true,
          labelText: "Company Name",
          hintText: "Enter Company Name",
          inputAction: TextInputAction.done,
          inputType: TextInputType.text,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.companyNameController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        //address
        CustomField(
          withShadow: true,
          labelText: "Address",
          hintText: "Enter Customer address",
          inputAction: TextInputAction.done,
          inputType: TextInputType.text,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.addressController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        //idustry
        const SizedBox(height: 10),
        Obx(
          () => CustomSelect(
            label: "Industry type",
            placeholder: "Industry",
            mainList: controller.industry
                .map(
                  (element) => CustomSelectItem(
                    id: element ?? "",
                    value: element ?? "",
                  ),
                )
                .toList(),
            onSelect: (val) async {
              controller.industryController.text = val.value;
            },
            textEditCtlr: controller.industryController,
            showLabel: true,
            onTapField: () {
              controller.industryController.clear();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a product";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
        //state
        Obx(
          () => CustomSelect(
            label: "state ",
            placeholder: "State",
            mainList: controller.state
                .map(
                  (element) => CustomSelectItem(
                    id: element ?? "",
                    value: element ?? "",
                  ),
                )
                .toList(),
            onSelect: (val) async {
              controller.stateController.text = val.value;
            },
            textEditCtlr: controller.stateController,
            showLabel: true,
            onTapField: () {
              controller.stateController.clear();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a product";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => CustomSelect(
            label: "Area ",
            placeholder: "area",
            mainList: controller.area
                .map(
                  (element) => CustomSelectItem(
                    id: element ?? "",
                    value: element ?? "",
                  ),
                )
                .toList(),
            onSelect: (val) async {
              controller.areaController.text = val.value;
            },
            textEditCtlr: controller.areaController,
            showLabel: true,
            onTapField: () {
              controller.areaController.clear();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a product";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
        //city
        Obx(
          () => CustomSelect(
            label: "city ",
            placeholder: "city",
            mainList: controller.city
                .map(
                  (element) => CustomSelectItem(
                    id: element ?? "",
                    value: element ?? "",
                  ),
                )
                .toList(),
            onSelect: (val) async {
              controller.cityController.text = val.value;
            },
            textEditCtlr: controller.cityController,
            showLabel: true,
            onTapField: () {
              controller.cityController.clear();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a product";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
        //pincode
        CustomField(
          withShadow: true,
          labelText: "Pin code",
          hintText: "pin",
          inputAction: TextInputAction.done,
          inputType: TextInputType.number,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.pinController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        //Annual revenue
        CustomField(
          withShadow: true,
          labelText: "Annual revenue",
          hintText: "Annual revenue",
          inputAction: TextInputAction.done,
          inputType: TextInputType.text,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.annualRevenueController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        //gst
        CustomField(
          withShadow: true,
          labelText: "Gst",
          hintText: "Gst",
          inputAction: TextInputAction.done,
          inputType: TextInputType.text,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.gstController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStep3Form() {
    return Column(
      children: [
        //phone number
        CustomField(
          withShadow: true,
          labelText: "Phone number",
          hintText: "Phone",
          inputAction: TextInputAction.done,
          inputType: TextInputType.text,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.phoneController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        //tcs
        CustomField(
          withShadow: true,
          labelText: "TCS rate",
          hintText: "Tcs",
          inputAction: TextInputAction.done,
          inputType: TextInputType.number,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.tcsController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        //freight
        CustomField(
          withShadow: true,
          labelText: "freight %",
          hintText: "Freight ",
          inputAction: TextInputAction.done,
          inputType: TextInputType.number,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.freightController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomField(
          withShadow: true,
          labelText: "Pan No",
          hintText: "Pan",
          inputAction: TextInputAction.done,
          inputType: TextInputType.text,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.panController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomField(
          withShadow: true,
          labelText: "Aadhar",
          hintText: "aadhar",
          inputAction: TextInputAction.done,
          inputType: TextInputType.number,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.aadharController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomField(
          withShadow: true,
          labelText: "Company Website",
          hintText: "Website",
          inputAction: TextInputAction.done,
          inputType: TextInputType.text,
          showLabel: true,
          bgColor: Colors.white,
          enabled: true,
          editingController: controller.annualRevenueController,
          validator: (val) {
            if (val!.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Obx(
        () => Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.details[0].name!,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(controller.details[0].company ?? "No Company",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Spacer(),
                Chip(
                  label: Text('Hot',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  backgroundColor: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    icon: Icon(Icons.call, color: Colors.teal),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.wallet, color: Colors.green),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.sms, color: Colors.red), onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.email, color: Colors.blue),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.share, color: Colors.purple),
                    onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Color(0xFF072227),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab('Activity', 0),
          _buildTab('Task', 1),
          _buildTab('Details', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return Obx(() => GestureDetector(
          onTap: () => controller.changeTab(index),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  title,
                  style: TextStyle(
                    color: controller.currentTabIndex.value == index
                        ? Colors.white
                        : Colors.grey[400],
                    fontWeight: controller.currentTabIndex.value == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (controller.currentTabIndex.value == index)
                Container(
                  height: 2,
                  width: 60,
                  color: Colors.white,
                )
            ],
          ),
        ));
  }

  Widget _buildTaskSection() {
    return Obx(() => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final task = controller.tasks[index];
            return _buildTaskCard(task);
          },
        ));
  }

// Function to build each activity card
  Widget _buildActivityCard({
    required String type,
    required String status,
    required String description,
    required String time,
    required Color backgroundColor,
    required Color typeColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: typeColor,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              time,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

// Main function to build the activity section
  Widget _buildActivitySection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),

          // List of activities
          ListView.builder(
            itemCount: controller.activities.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var activity = controller.activities[index];

              // Display date only if it's the start of a new date group
              // bool showDateLabel = index == 0 ||
              //     controller.activities[index - 1]['date'] != activity['date'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActivityCard(
                    type: activity['type']!,
                    status: activity['status'] ?? "",
                    description: activity['description']!,
                    time: activity['time']!,
                    backgroundColor: activity['type'] == "Lead status"
                        ? Colors.lightGreen.shade50
                        : Colors.red.shade50,
                    typeColor: activity['type'] == "Lead status"
                        ? Colors.green
                        : Colors.red,
                  ),
                ],
              );
            },
          ),

          // Divider and other sections
          SizedBox(height: 20),
          _buildTappableSection("Contact Info", Icons.contact_phone),
          _buildTappableSection("File & Attachment", Icons.attachment),
          _buildTappableSection("Invoices And Quotations", Icons.receipt),
        ],
      );
    });
  }

  Widget _buildTappableSection(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade100, // Border color
              width: 2, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              trailing:
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Implement navigation or action here based on the title
                Get.snackbar('Navigation', 'Tapped on $title');
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.status,
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'DealSize: 1200 Remark: ${task.remark}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.assignee,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    task.deadline,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableFAB() {
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.isFabOpen.value) ...[
              _buildMiniFab(Icons.call, Colors.teal, () {}),
              SizedBox(height: 8),
              _buildMiniFab(Icons.update, Colors.teal, () {}),
              SizedBox(height: 8),
              _buildMiniFab(Icons.meeting_room, Colors.teal, () {}),
            ],
            if (controller.currentTabIndex == 1)
              FloatingActionButton(
                onPressed: controller.toggleFab,
                backgroundColor: Colors.teal,
                child:
                    Icon(controller.isFabOpen.value ? Icons.close : Icons.add),
              ),
          ],
        ));
  }

  Widget _buildMiniFab(IconData icon, Color color, VoidCallback onPressed) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: FloatingActionButton(
        key: ValueKey(icon),
        mini: true,
        onPressed: onPressed,
        backgroundColor: color,
        child: Icon(icon, size: 20),
      ),
    );
  }
}
