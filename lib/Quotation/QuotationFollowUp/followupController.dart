import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leads/data/models/QuotationFollowUpModel.dart';
import 'package:leads/data/models/dropdown_list.model.dart';
import 'package:leads/widgets/custom_snckbar.dart';

import '../../data/api/api_client.dart';
import '../../utils/api_endpoints.dart';

class QuotationFollowUp extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await fetchQuotations();
  }

  RxBool isImageUrl = false.obs;
  RxString imageUrl = "".obs;
  RxBool isEdit = false.obs;
  TextEditingController DateCtlr = TextEditingController();
  TextEditingController conversationWithController = TextEditingController();
  TextEditingController followUpByController = TextEditingController();
  TextEditingController followUpStatusController = TextEditingController();
  TextEditingController showfollowUpStatusController = TextEditingController();
  TextEditingController remarkcontroller = TextEditingController();
  TextEditingController documentController = TextEditingController();
// Add these to your QuotationFollowUp class

// Properties to track attachments state
  RxList<AttachmentModel> attachments = <AttachmentModel>[].obs;
  RxBool isLoadingAttachments = false.obs;
  RxBool isUploading = false.obs;
  RxString selectedAttachmentId = "".obs;
  String baseUrl =
      "https://your-api-base-url.com"; // Replace with your actual base URL
  Future<void> loadImageForEdit(String path) async {
    try {
      isImageUrl.value = true;
      imageUrl.value = "https://lead.mumbaicrm.com/$path";

      // Don't set bannerImageBase64 to empty, as that would clear the form
      // Instead, we'll handle displaying either URL or base64 in the UI
    } catch (e) {
      print("Error loading image for edit: $e");
      CustomSnack.show(
        content: "Failed to load image",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
    }
  }

// Function to fetch attachments for a quotation
  Future<void> fetchAttachments(String quotationId) async {
    try {
      isLoadingAttachments.value = true;

      final response = await ApiClient().getAttachments(
        endPoint: ApiEndpoints.getAttachments,
        params: {
          "entryid": quotationId,
          "entrytype": "SalesQuotation",
          "userid": "4",
          "syscompanyid": "4",
          "sysbranchid": "4"
        },
      );

      if (response.isNotEmpty) {
        // Convert the raw response to a list of AttachmentModel objects
        List<AttachmentModel> attachmentsList = (response as List)
            .map((item) => AttachmentModel.fromJson(item))
            .toList();
        attachments.assignAll(attachmentsList);
      } else {
        attachments.clear();
      }
    } catch (e) {
      print("Error fetching attachments: $e");
      CustomSnack.show(
        content: "Failed to load attachments",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
      attachments.clear();
    } finally {
      isLoadingAttachments.value = false;
    }
  }

  Future<void> pickAttachment(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1000,
      );

      if (image != null) {
        final file = File(image.path);
        final bytes = await file.readAsBytes();

        // Convert to base64
        String base64Image = base64Encode(bytes);

        // Determine image type
        String mimeType = 'image/jpeg';
        if (image.path.toLowerCase().endsWith('.png')) {
          mimeType = 'image/png';
        }

        // Set the base64 string with MIME type
        bannerImageBase64.value = 'data:$mimeType;base64,$base64Image';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

// Method to pick PDF documents
  Future<void> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile platformFile = result.files.first;

        if (platformFile.path != null) {
          final file = File(platformFile.path!);
          final bytes = await file.readAsBytes();

          // Check if the file is too large (limit to 5MB for example)
          if (bytes.length > 5 * 1024 * 1024) {
            Get.snackbar(
              'File Too Large',
              'Please select a file smaller than 5MB',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.amber[100],
              colorText: Colors.amber[800],
            );
            return;
          }

          // Convert to base64
          String base64File = base64Encode(bytes);
          bannerImageBase64.value = 'data:application/pdf;base64,$base64File';
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick document: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

// Function to upload a new attachment
  Future<void> uploadAttachment(String entryid) async {
    if (documentController.text.isEmpty) {
      CustomSnack.show(
        content: "Please enter document name",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
      return;
    }

    if (bannerImageBase64.isEmpty) {
      CustomSnack.show(
        content: "Please select a file to upload",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
      return;
    }

    try {
      isUploading.value = true;

      // For update case
      if (isEdit.value && selectedAttachmentId.isNotEmpty) {
        await updateAttachment();
        return;
      }

      // Extract file extension from base64 string
      String fileType = "png"; // Default
      if (bannerImageBase64.contains("data:image/jpeg")) {
        fileType = "jpeg";
      } else if (bannerImageBase64.contains("data:image/png")) {
        fileType = "png";
      } else if (bannerImageBase64.contains("data:application/pdf")) {
        fileType = "pdf";
      }

      final Map<String, dynamic> data = {
        "Id": "0",
        "entryid": entryid,
        "entrytype": "SalesQuotation",
        "eDocketname": documentController.text,
        "entryPrefix": "Q",
        "filetype": fileType,
        "Edocketpath": bannerImageBase64.value,
      };

      final response = await ApiClient().uploadAttachment(
        endPoint: ApiEndpoints.uploadAttachment,
        data: data,
      );
      print(response);
      print(data);
      if (response != null && response['status'] == '1') {
        CustomSnack.show(
          content: "Attachment uploaded successfully",
          snackType: SnackType.success,
          behavior: SnackBarBehavior.fixed,
        );

        clearAttachmentForm();
        // Refresh the attachments list
        await fetchAttachments(
            quotationList.isNotEmpty ? quotationList[0].id! : "");
        Get.back();
      } else {
        throw Exception("Failed to upload attachment");
      }
    } catch (e) {
      print("Error uploading attachment: $e");
      CustomSnack.show(
        content: "Failed to upload attachment",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
    } finally {
      isUploading.value = false;
    }
  }

// Function to update an existing attachment
  Future<void> updateAttachment() async {
    try {
      final Map<String, dynamic> data = {
        "id": selectedAttachmentId.value,
        "eDocketname": documentController.text,
        "eDocket":
            bannerImageBase64.value.isNotEmpty ? bannerImageBase64.value : null,
      };

      final response = await ApiClient().updateAttachment(
        endPoint: ApiEndpoints.updateAttachment,
        data: data,
      );

      if (response != null && response['status'] == 'success') {
        CustomSnack.show(
          content: "Attachment updated successfully",
          snackType: SnackType.success,
          behavior: SnackBarBehavior.fixed,
        );

        clearAttachmentForm();
        // Refresh the attachments list
        await fetchAttachments(
            quotationList.isNotEmpty ? quotationList[0].id! : "");
        Get.back();
      } else {
        throw Exception("Failed to update attachment");
      }
    } catch (e) {
      print("Error updating attachment: $e");
      CustomSnack.show(
        content: "Failed to update attachment",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
    } finally {
      isUploading.value = false;
    }
  }

// Function to delete an attachment
  Future<void> deleteAttachment(String attachmentId) async {
    try {
      // Show confirmation dialog

      final response = await ApiClient().deleteAttachment(
          endPoint: ApiEndpoints.deleteAttachment, id: attachmentId);
      print(response);
      if (response != null && response['status'] == '1') {
        CustomSnack.show(
          content: "Attachment deleted successfully",
          snackType: SnackType.success,
          behavior: SnackBarBehavior.fixed,
        );

        // Refresh the attachments list
        await fetchAttachments(
            quotationList.isNotEmpty ? quotationList[0].id! : "");
      } else {
        throw Exception("Failed to delete attachment");
      }
    } catch (e) {
      print("Error deleting attachment: $e");
      CustomSnack.show(
        content: "Failed to delete attachment",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
    }
  }

// Function to edit an attachment
  void editAttachment(Map<String, dynamic> attachment) {
    isEdit.value = true;
    selectedAttachmentId.value = attachment['id'].toString();
    documentController.text = attachment['eDocketname'] ?? '';
    bannerImageBase64.value = ""; // Clear the current image
  }

// Function to get full URL for attachment
  String getAttachmentUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return "$baseUrl$path";
  }

// Function to download an attachment
  Future<void> downloadAttachment(
      String? path, String? name, String? fileType) async {
    if (path == null || path.isEmpty) {
      CustomSnack.show(
        content: "Invalid file path",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
      return;
    }

    try {
      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // This is a placeholder for the actual download functionality
      // You would need to use a package like dio or flutter_downloader
      // Example with dio:
      /*
    final dio = Dio();
    final savePath = await getFilePath(name ?? 'download', fileType ?? 'file');

    await dio.download(
      getAttachmentUrl(path),
      savePath,
      onReceiveProgress: (received, total) {
        // You can update progress here if needed
      },
    );
    */

      // For this example, we'll just simulate a download
      await Future.delayed(const Duration(seconds: 2));

      // Close loading dialog
      Get.back();

      CustomSnack.show(
        content: "File downloaded successfully",
        snackType: SnackType.success,
        behavior: SnackBarBehavior.fixed,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      print("Error downloading file: $e");
      CustomSnack.show(
        content: "Failed to download file",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
    }
  }

// Helper function to clear the attachment form
  void clearAttachmentForm() {
    documentController.clear();
    bannerImageBase64.value = "";
    isEdit.value = false;
    selectedAttachmentId.value = "";
  }

  RxList<Status> status = [
    Status.fromJson({"id": "0", "status": "closed"}),
    Status.fromJson({"id": "1", "status": "opened"}),
    Status.fromJson({"id": "2", "status": "abonded"}),
  ].obs;
  RxString Date = "".obs;
  RxList<QuotationFollowUpModel> quotationList = <QuotationFollowUpModel>[].obs;
  RxBool isFetchingMore = false.obs;
  RxInt currentPage = 0.obs; // Track the current page number
  var isLoading = false.obs;
  RxBool hasMoreLeads =
      true.obs; // Flag to track if there are more leads to load
  final box = GetStorage();
  var bannerImageBase64 = RxString(""); // To store banner image base64

  Future<void> fetchQuotations({bool isInitialFetch = true}) async {
    const String endpoint = ApiEndpoints.QuotationList;
    final String userId = box.read("userId");
    const String pageSize = "10";
    final String isPagination = "1";

    try {
      // Set the appropriate loading flag
      if (isInitialFetch) {
        isLoading.value = true;
        currentPage.value = 1; // Reset the page for initial fetch
        hasMoreLeads.value = true; // Reset the end-of-data flag
      } else {
        // Prevent fetching if no more leads
        if (!hasMoreLeads.value) return;
        isFetchingMore.value = true;
      }

      // Fetch data from API
      final newQuotations = await ApiClient().getQuotationList(
        endPoint: endpoint,
        userId: userId,
        isPagination: isPagination,
        pageSize: pageSize,
        pageNumber: currentPage.value.toString(),
      );

      // Process received data
      if (newQuotations.isNotEmpty) {
        if (isInitialFetch) {
          quotationList.assignAll(newQuotations);
        } else {
          quotationList.addAll(newQuotations);
        }

        // Increment page number if more data is available
        currentPage.value++;
        if (newQuotations.length < int.parse(pageSize)) {
          hasMoreLeads.value = false; // No more data
        }
      } else {
        hasMoreLeads.value = false; // No data received
      }
    } catch (e) {
      print("An error occurred while fetching quotations: $e");
      Get.snackbar("Error", "Failed to fetch quotations. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      // Ensure both flags are reset
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  Future<void> pickImage(ImageSource source, RxString target) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      target.value = "data:image/jpeg;base64," + base64Encode(bytes);
    }
  }

  Future<void> addFollowUp(String id) async {
    try {
      isLoading.value = true;
      final res = await ApiClient().postFollowUp(
        endPoint: ApiEndpoints.addFollowUp,
        quotationId: "45200021",
        followupDate: DateCtlr.text,
        conversationWith: conversationWithController.text,
        followUpBy: followUpByController.text,
        remark: remarkcontroller.text,
        followUpStatus: followUpStatusController.text,
      );
      print("Success");
      Get.back();
      CustomSnack.show(
          content: "Successfully Added Follow up",
          snackType: SnackType.success,
          behavior: SnackBarBehavior.fixed);
      clearForm();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    DateCtlr.clear();
    followUpByController.clear();
    followUpStatusController.clear();
    showfollowUpStatusController.clear();
    remarkcontroller.clear();
    conversationWithController.clear();
  }
}

class AttachmentModel {
  final String? id;
  final String? entryId;
  final String? entryType;
  final String? eDocketName;
  final String? entryPrefix;
  final String? fileType;
  final String? eDocketPath;
  final String? eDocket;
  final String? ext;
  final String? createdBy;
  final String? modifiedBy;

  AttachmentModel({
    this.id,
    this.entryId,
    this.entryType,
    this.eDocketName,
    this.entryPrefix,
    this.fileType,
    this.eDocketPath,
    this.eDocket,
    this.ext,
    this.createdBy,
    this.modifiedBy,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'],
      entryId: json['entryid'],
      entryType: json['entrytype'],
      eDocketName: json['eDocketname'],
      entryPrefix: json['entryPrefix'],
      fileType: json['filetype'],
      eDocketPath: json['edocketpath'],
      eDocket: json['eDocket'],
      ext: json['ext'],
      createdBy: json['createdby'],
      modifiedBy: json['modifiedby'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entryid': entryId,
      'entrytype': entryType,
      'eDocketname': eDocketName,
      'entryPrefix': entryPrefix,
      'filetype': fileType,
      'edocketpath': eDocketPath,
      'eDocket': eDocket,
      'ext': ext,
      'createdby': createdBy,
      'modifiedby': modifiedBy,
    };
  }
}
