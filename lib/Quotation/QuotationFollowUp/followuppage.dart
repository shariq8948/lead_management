import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leads/Quotation/QuotationFollowUp/pdfview/pdf.dart';
import 'package:leads/utils/constants.dart';
import 'package:leads/widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_field.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_select.dart';
import '../../widgets/pdf_view.dart';
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Quotation List",
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            _buildHeaderButtons(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.quotationList.isEmpty) {
                  return CustomLoader();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchQuotations(isInitialFetch: true);
                  },
                  child: controller.quotationList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder_open,
                                  size: 80, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                "No quotations found",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          itemCount: controller.hasMoreLeads.value
                              ? controller.quotationList.length + 1
                              : controller.quotationList.length,
                          itemBuilder: (context, index) {
                            if (index < controller.quotationList.length) {
                              final quotation = controller.quotationList[index];
                              return _buildQuotationCard(
                                quotation.custName ?? "Unknown",
                                quotation.bAmt ?? "0",
                                quotation.custMobile ?? "N/A",
                                quotation.custAddress ?? "No Address",
                                quotation.quotDate ?? "No Date",
                                index,
                                quotation.id ?? "0",
                              );
                            } else {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CustomLoader(),
                                ),
                              );
                            }
                          },
                        ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildHeaderButton(
            "Filter",
            Icons.filter_list,
            onPressed: () {
              // Implement filter functionality
            },
          ),
          const SizedBox(width: 12),
          _buildHeaderButton(
            "Export",
            Icons.download,
            onPressed: () {
              // Implement export functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(String text, IconData icon,
      {VoidCallback? onPressed}) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal[700],
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildQuotationCard(String name, String amount, String mobile,
      String address, String date, int index, String id) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 4),
          ),
        ],
        // border: Border(
        //   bottom: BorderSide(color: Colors.teal.withOpacity(.6), width: 3),
        //   left: BorderSide(color: Colors.teal.withOpacity(.5), width: 1),
        //   right: BorderSide(color: Colors.teal.withOpacity(.5), width: 1),
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with customer details
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
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
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
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
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '₹ $amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "view",
                      child:
                          buildMenuButtons(Icons.visibility_outlined, "View"),
                      onTap: () {
                        generateSalesQuotationPdf(
                          fromCompany: "PSM Softtech",
                          fromCall: "9876875898",
                          fromEmail: "ho@example.com",
                          fromContactPerson: "John Doe",
                          toPhone: "5554654687",
                          toEmail: "email@gmail.com",
                          quotationNo: "132",
                          dateTime: "12/12/2024",
                          clientType: "Customer",
                          products: [
                            {
                              "sr": 1,
                              "code": "7125",
                              "name": "1 BHK BR",
                              "qty": 1,
                              "exportedQty": 0,
                              "pendingQty": 1,
                              "rate": 0.00,
                              "discount": 0,
                              "gst": 12,
                              "total": 0.00,
                            },
                            {
                              "sr": 1,
                              "code": "7125",
                              "name": "1 BHK BR",
                              "qty": 1,
                              "exportedQty": 0,
                              "pendingQty": 1,
                              "rate": 0.00,
                              "discount": 0,
                              "gst": 12,
                              "total": 0.00,
                            },
                          ],
                          status: "Approved",
                          approvedBy: "ho",
                          approvalDateTime: "12/31/2024 2:56:33 PM",
                          remarks: "Approved",
                          grandTotal: 0.00,
                        );
                      },
                    ),
                    PopupMenuItem(
                        value: "edit",
                        child: buildMenuButtons(Icons.edit_outlined, "Edit")),
                    PopupMenuItem(
                      value: "attachment",
                      child: buildMenuButtons(
                          Icons.attach_file_outlined, "Attachments"),
                      onTap: () {
                        buildAttachmentsDialog(context, id);
                      },
                    ),
                    PopupMenuItem(
                        value: "export",
                        child: buildMenuButtons(
                            Icons.import_export_outlined, "Export")),
                    PopupMenuItem(
                        value: "sample",
                        child: buildMenuButtons(
                            Icons.format_paint_outlined, "Sample")),
                    PopupMenuItem(
                        value: "revise",
                        child: buildMenuButtons(
                            Icons.rate_review_outlined, "Revise")),
                  ],
                ),
              ],
            ),
          ),

          // Bottom action buttons
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.phone,
                  label: mobile,
                  color: Colors.green,
                  onPressed: () {
                    // Handle call action
                  },
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.sync,
                  label: "Follow Up",
                  color: Colors.blue,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return buildDialog(context, id);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }

  Widget buildMenuButtons(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(color: Colors.grey[800]),
        ),
      ],
    );
  }

  Widget buildDialog(BuildContext context, String id) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[700],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Quotation Follow Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                // Form content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormLabel("Follow Up Date"),
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

                          _buildFormLabel("Conversation With"),
                          CustomField(
                            editingController:
                                controller.conversationWithController,
                            hintText: "Enter name",
                            labelText: "Conversation with",
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),

                          _buildFormLabel("Follow Up By"),
                          CustomField(
                            editingController: controller.followUpByController,
                            hintText: "Enter name",
                            labelText: "Follow Up By",
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),

                          _buildFormLabel("Status"),
                          Obx(
                            () => CustomSelect(
                              label: "Select Status",
                              placeholder: "Please select a Status",
                              mainList: controller.status
                                  .map(
                                    (element) => CustomSelectItem(
                                      id: element!.id ?? "",
                                      value: element?.status ?? "",
                                    ),
                                  )
                                  .toList(),
                              onSelect: (val) async {
                                controller.followUpStatusController.text =
                                    val.id;
                                controller.showfollowUpStatusController.text =
                                    val.value;
                              },
                              textEditCtlr:
                                  controller.showfollowUpStatusController,
                              showLabel: false,
                              onTapField: () {
                                controller.followUpStatusController.clear();
                                controller.showfollowUpStatusController.clear();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a status';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildFormLabel("Remarks"),
                          CustomField(
                            editingController: controller.remarkcontroller,
                            hintText: "Enter your remarks here",
                            labelText: "Remark",
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.none,
                            minLines: 3,
                          ),
                          const SizedBox(height: 24),

                          // Submit button
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.addFollowUp(id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal[700],
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Save Follow Up",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Future buildAttachmentsDialog(
      BuildContext context, String quotationId) async {
    // Fetch attachments when dialog opens
    controller.fetchAttachments(quotationId);

    return Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      Container(
        height: Get.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Attachments",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.clearAttachmentForm();
                      Get.back();
                    },
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Content area (scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Document name input
                    Text(
                      "Document Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomField(
                      hintText: "Enter document name",
                      labelText: "Document Name",
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      editingController: controller.documentController,
                      showLabel: false,
                    ),

                    const SizedBox(height: 24),

                    // File upload area
                    Obx(() => _buildFileUploadArea()),

                    const SizedBox(height: 24),

                    // Attachments list title
                    Row(
                      children: [
                        Icon(Icons.attachment,
                            size: 20, color: Colors.teal[700]),
                        const SizedBox(width: 8),
                        Text(
                          "Uploaded Attachments",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Attachments list
                    Obx(() => _buildAttachmentsList()),
                  ],
                ),
              ),
            ),

            // Bottom action button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isUploading.value
                      ? null
                      : () => controller.uploadAttachment(quotationId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    controller.isUploading.value
                        ? "Uploading..."
                        : controller.isEdit.value
                            ? "Update Attachment"
                            : "Save Attachment",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileUploadArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Attachment File",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        if (controller.bannerImageBase64.isEmpty)
          // Upload button when no file is selected
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade50,
            ),
            child: InkWell(
              onTap: () => _showFileSourceDialog(),
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: Colors.teal[600],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Tap to upload a file",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "JPG, PNG, PDF supported",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          // Preview when file is selected
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal.shade300),
              borderRadius: BorderRadius.circular(10),
              color: Colors.teal.withOpacity(0.05),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image preview
                _buildImageWidget(controller.bannerImageBase64.value),

                // File actions
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // File information
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "File attached",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.teal[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getFileTypeFromBase64(
                                      controller.bannerImageBase64.value) +
                                  " file",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Action buttons
                      Row(
                        children: [
                          // Replace button
                          OutlinedButton.icon(
                            onPressed: () => _showFileSourceDialog(),
                            icon: Icon(Icons.refresh, size: 16),
                            label: Text("Replace"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.teal[700],
                              side: BorderSide(color: Colors.teal.shade300),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Remove button
                          IconButton(
                            onPressed: () =>
                                controller.bannerImageBase64.value = "",
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            tooltip: "Remove file",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _getFileTypeFromBase64(String base64String) {
    if (base64String.contains("data:image/jpeg")) {
      return "JPEG";
    } else if (base64String.contains("data:image/png")) {
      return "PNG";
    } else if (base64String.contains("data:application/pdf")) {
      return "PDF";
    }
    return "Image";
  }

  void _showFileSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select File Source",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 20),
              _buildSourceOption(
                icon: Icons.photo_library,
                title: "Gallery",
                subtitle: "Select from your photo gallery",
                onTap: () {
                  Get.back();
                  controller.pickAttachment(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 16),
              _buildSourceOption(
                icon: Icons.camera_alt,
                title: "Camera",
                subtitle: "Take a new photo",
                onTap: () {
                  Get.back();
                  controller.pickAttachment(ImageSource.camera);
                },
              ),
              const SizedBox(height: 16),
              _buildSourceOption(
                icon: Icons.file_present,
                title: "File",
                subtitle: "Choose a document or PDF file",
                onTap: () {
                  Get.back();
                  controller.pickDocument();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.teal[700], size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String base64String) {
    // If we're in edit mode and have an image URL, show the network image
    if (controller.isImageUrl.value && controller.imageUrl.value.isNotEmpty) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.network(
              controller.imageUrl.value,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                );
              },
            ),
          ),
          // Add a button or indication that this is the original image
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8),
            color: Colors.teal.withOpacity(0.1),
            child: Center(
              child: Text(
                "Original Image (Tap to change)",
                style: TextStyle(
                  color: Colors.teal[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Handle base64 images or empty state
    if (base64String.isEmpty) {
      return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                size: 40,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                "Tap to add an image or document",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (base64String.contains("data:application/pdf")) {
      return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.picture_as_pdf,
                size: 40,
                color: Colors.red[700],
              ),
              const SizedBox(height: 8),
              Text(
                "PDF Document",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      try {
        final String base64Image = base64String.split(',')[1];
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: Image.memory(
            base64Decode(base64Image),
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      } catch (e) {
        return Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
        );
      }
    }
  }

  Widget _buildAttachmentsList() {
    if (controller.isLoadingAttachments.value) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
        ),
      );
    }

    if (controller.attachments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 40,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No attachments found",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Upload documents or images for this quotation",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.attachments.length,
      itemBuilder: (context, index) {
        final attachment = controller.attachments[index];
        final imageExtensions = [
          'png',
          'jpeg',
          'jpg',
          'webp',
          'gif',
          'bmp',
          'tiff'
        ];
        final fileType = attachment.fileType?.toLowerCase() ?? '';
        final isImage = imageExtensions.any((ext) => fileType.contains(ext));
        // final isImage =
        //     attachment.fileType?.toLowerCase().contains('png') ?? false;
        final isPdf =
            attachment.fileType?.toLowerCase().contains('pdf') ?? false;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (isPdf) {
                // Get.dialog(
                //   Dialog(
                //     child: Container(
                //       width: Get.width * 0.9,
                //       height: Get.height * 0.8,
                //       child: PdfView(
                //         pdfPath:
                //             "https://lead.mumbaicrm.com/${attachment.eDocketPath}",
                //       ),
                //     ),
                //   ),
                // );
              } else if (isImage) {
                Get.dialog(
                  Dialog(
                    child: Container(
                      width: Get.width * 0.9,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppBar(
                            title: Text(attachment.eDocketName ?? "Image"),
                            centerTitle: true,
                            backgroundColor: Colors.teal[700],
                            actions: [
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Get.back(),
                              ),
                            ],
                          ),
                          Image.network(
                            "https://lead.mumbaicrm.com/${attachment.eDocketPath}",
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                child: Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isImage
                        ? Colors.blue.withOpacity(0.1)
                        : isPdf
                            ? Colors.red.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isImage
                          ? Icons.image
                          : isPdf
                              ? Icons.picture_as_pdf
                              : Icons.insert_drive_file,
                      color: isImage
                          ? Colors.blue[700]
                          : isPdf
                              ? Colors.red[700]
                              : Colors.grey[700],
                      size: 28,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attachment.eDocketName ?? "Untitled Document",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                // Edit button
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                  onPressed: () {
                    // Set up edit mode
                    controller.isEdit.value = true;
                    controller.selectedAttachmentId.value = attachment.id ?? "";
                    controller.documentController.text =
                        attachment.eDocketName ?? "";

                    if (attachment.fileType?.toLowerCase().contains('pdf') ??
                        false) {
                      // Handle PDF
                      controller.bannerImageBase64.value =
                          "data:application/pdf;base64,placeholder";
                      controller.isImageUrl.value = false;
                    } else if (isImage) {
                      // For images, load the image from URL
                      controller.loadImageForEdit(attachment.eDocketPath ?? "");
                    } else {
                      // Other file types
                      controller.bannerImageBase64.value =
                          "data:application/octet-stream;base64,placeholder";
                      controller.isImageUrl.value = false;
                    }

                    // Show the edit form
                    Get.to(() => EditAttachmentScreen(controller: controller));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    // Show delete confirmation
                    Get.defaultDialog(
                      title: "Delete Attachment",
                      titleStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      middleText:
                          "Are you sure you want to delete this attachment?",
                      textConfirm: "Delete",
                      textCancel: "Cancel",
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.red,
                      cancelTextColor: Colors.grey[700],
                      onConfirm: () {
                        Get.back();
                        controller.deleteAttachment(attachment.id ?? "");
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void generateSalesQuotationPdf({
    required String fromCompany,
    required String fromCall,
    required String fromEmail,
    required String fromContactPerson,
    required String toPhone,
    required String toEmail,
    required String quotationNo,
    required String dateTime,
    required String clientType,
    required List<Map<String, dynamic>> products,
    required String status,
    required String approvedBy,
    required String approvalDateTime,
    required String remarks,
    required double grandTotal,
  }) {
    // Get.to(() => PdfView(
    //   // pdfUrl: "$baseUrl/quotation-pdf/$quotationNo", pdfPath: '',
    // ));
  }
}

class EditAttachmentScreen extends StatelessWidget {
  final QuotationFollowUp controller;

  const EditAttachmentScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Attachment"),
        backgroundColor: Colors.teal[700],
        actions: [
          TextButton(
            onPressed: () {
              controller.clearAttachmentForm();
              Get.back();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Obx(() => SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image preview - tappable to change
                InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Choose Image Source",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildSourceOption(
                                  context,
                                  Icons.camera_alt,
                                  "Camera",
                                  () {
                                    Get.back();
                                    controller.pickImage(ImageSource.camera,
                                        controller.bannerImageBase64);
                                    // When picking a new image, ensure we reset the URL flag
                                    controller.isImageUrl.value = false;
                                  },
                                ),
                                _buildSourceOption(
                                  context,
                                  Icons.photo_library,
                                  "Gallery",
                                  () {
                                    Get.back();
                                    controller.pickImage(ImageSource.gallery,
                                        controller.bannerImageBase64);
                                    // When picking a new image, ensure we reset the URL flag
                                    controller.isImageUrl.value = false;
                                  },
                                ),
                                _buildSourceOption(
                                  context,
                                  Icons.picture_as_pdf,
                                  "Document",
                                  () {
                                    Get.back();
                                    controller.pickDocument();
                                    // When picking a new document, ensure we reset the URL flag
                                    controller.isImageUrl.value = false;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: _buildImageWidget(controller.bannerImageBase64.value),
                ),
                SizedBox(height: 20),
                // Document name field
                Text(
                  "Document Name",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: controller.documentController,
                  decoration: InputDecoration(
                    hintText: "Enter document name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                SizedBox(height: 30),
                // Save button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        controller.isUploading.value ? null : () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isUploading.value
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        : Text(
                            "Okay",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildImageWidget(String base64String) {
    // If we're in edit mode and have an image URL, show the network image
    if (controller.isImageUrl.value && controller.imageUrl.value.isNotEmpty) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.network(
              controller.imageUrl.value,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                );
              },
            ),
          ),
          // Add a button or indication that this is the original image
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8),
            color: Colors.teal.withOpacity(0.1),
            child: Center(
              child: Text(
                "Original Image (Tap to change)",
                style: TextStyle(
                  color: Colors.teal[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Handle base64 images or empty state
    if (base64String.isEmpty) {
      return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                size: 40,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                "Tap to add an image or document",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (base64String.contains("data:application/pdf")) {
      return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.picture_as_pdf,
                size: 40,
                color: Colors.red[700],
              ),
              const SizedBox(height: 8),
              Text(
                "PDF Document",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      try {
        final String base64Image = base64String.split(',')[1];
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: Image.memory(
            base64Decode(base64Image),
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      } catch (e) {
        return Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
        );
      }
    }
  }

  Widget _buildSourceOption(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.teal[700],
              size: 28,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
