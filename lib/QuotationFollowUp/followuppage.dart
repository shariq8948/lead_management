import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/utils/constants.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_select.dart';
import 'followupController.dart';

class QuotationFollowUpPage extends StatefulWidget {
  @override
  State<QuotationFollowUpPage> createState() => _QuotationFollowUpPageState();
}

class _QuotationFollowUpPageState extends State<QuotationFollowUpPage> {
  final QuotationFollowUp controller = Get.put(QuotationFollowUp());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchQuotations(isInitialFetch: true);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
        controller.hasMoreLeads.value &&
        !controller.isFetchingMore.value) {
      controller.fetchQuotations();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quotation List")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
          ),
        ),
        child: Column(
          children: [
            _buildHeaderButtons(),
            Expanded(
              child: Obx(() => RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchQuotations(isInitialFetch: true);
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: controller.quotationList.length +
                          1, // Add 1 for the loader
                      itemBuilder: (context, index) {
                        if (index < controller.quotationList.length) {
                          final quotation = controller.quotationList[index];
                          return _buildQuotationCard(
                              quotation.custName ?? "Unknown",
                              quotation.bAmt ?? "0",
                              quotation.custMobile ?? "N/A",
                              quotation.custAddress ?? "No Address",
                              quotation.quotDate ?? "No Date",
                              index);
                        } else {
                          return controller.isFetchingMore.value
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox();
                        }
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButtons() {
    return Container(
      // margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          _buildHeaderButton("Filter", onPressed: () {}),
          // const SizedBox(width: 8),
          _buildHeaderButton("Export", onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(String text, {VoidCallback? onPressed}) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildQuotationCard(String name, String amount, String mobile,
      String address, String date, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (index % 2 == 0) ? quotation1 : quotation2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹ $amount',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                color: Colors.white,
                icon: const Icon(Icons.more_vert, color: Colors.grey),
// onSelected: (value) => print(value),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: "view",
                      child: buildMenuButtons(
                          Icons.compass_calibration_outlined, "View")),
                  PopupMenuItem(
                      value: "edit",
                      child: buildMenuButtons(Icons.edit, "Edit")),
                  PopupMenuItem(
                      value: "attachment",
                      child: buildMenuButtons(Icons.attach_file, "Attachment")),
                  PopupMenuItem(
                      value: "export",
                      child: buildMenuButtons(Icons.import_export, "Export")),
                  PopupMenuItem(
                      value: "sample",
                      child: buildMenuButtons(Icons.thermostat, "Sample")),
                  PopupMenuItem(
                      value: "revise",
                      child: buildMenuButtons(
                          Icons.rate_review_outlined, "Revise")),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(
                  Icons.phone,
                  color: Colors.white,
                  size: 16,
                ),
                label: Text(
                  mobile,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return FollowUpDialog(); // Wrap the dialog here
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(
                  Icons.sync,
                  color: Colors.white,
                  size: 16,
                ),
                label: const Text(
                  "Follow Up",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMenuButtons(IconData icon, String label) {
    return Container(
      child: Row(
        spacing: 2,
        children: [Icon(icon), Text(label)],
      ),
    );
  }
}

class FollowUpDialog extends StatelessWidget {
  final QuotationFollowUp controller = Get.put(QuotationFollowUp());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.size.height * .2),
      child: Container(
        decoration: BoxDecoration(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context)
              .unfocus(), // Dismiss keyboard on tap outside
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // Adjust for the keyboard
                  ),
                  child: Container(
                    child: Dialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Quotation Follow Up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 26),
                            CustomField(
                              withShadow: true,
                              labelText: "Date",
                              hintText: "Select date",
                              inputAction: TextInputAction.done,
                              inputType: TextInputType.datetime,
                              showLabel: false,
                              bgColor: Colors.white,
                              enabled: true,
                              readOnly: true,
                              editingController: controller.DateCtlr,
                              onFieldTap: () {
                                Get.bottomSheet(
                                  CustomDatePicker(
                                    pastAllow: true,
                                    confirmHandler: (date) async {
                                      controller.DateCtlr.text = date ?? "";
                                      controller.Date.value = date ?? "";
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomField(
                              editingController:
                                  controller.conversationWithController,
                              hintText: "Conversation With",
                              labelText: "Conversation with",
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            CustomField(
                              editingController:
                                  controller.followUpByController,
                              hintText: "Follow Up By",
                              labelText: "Follow Up By",
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            CustomField(
                              editingController:
                                  controller.followUpStatusController,
                              hintText: "Status",
                              labelText: "Status",
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            CustomField(
                              editingController: controller.remarkcontroller,
                              hintText: "Enter Remark",
                              labelText: "Remark",
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              minLines: 3,
                            ),
                            const SizedBox(height: 32),
                            Center(
                              child: SizedBox(
                                height: Get.size.height * .05,
                                width: Get.size.width *
                                    .7, // Adjust the width as needed
                                child: ElevatedButton(
                                  onPressed: () {
                                    print("Date: ${controller.Date}");
                                    print(
                                        "Conversation With: ${controller.conversationWithController.text}");
                                    print(
                                        "Follow-Up By: ${controller.followUpByController.text}");
                                    print(
                                        "Follow-Up Status: ${controller.followUpStatusController}");
                                    print(
                                        "Remarks: ${controller.remarkcontroller.text}");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
