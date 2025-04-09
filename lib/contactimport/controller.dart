import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

import '../data/api/api_client.dart';
import '../data/models/lead_list.dart';
import '../utils/api_endpoints.dart';

class ContactImportController extends GetxController {
  // Reactive variables
  final RxList<Contact> allContacts = <Contact>[].obs;
  final RxList<Contact> filteredContacts = <Contact>[].obs;
  final RxList<Contact> selectedContacts = <Contact>[].obs;
  final RxList<LeadList> leads = <LeadList>[].obs;
  final RxList<Contact> existingLeadContacts = <Contact>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPermissionGranted = false.obs;
  final RxBool isPermissionDeniedPermanently = false.obs;
  final RxString searchQuery = ''.obs;

  // Non-reactive variables
  final TextEditingController searchController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  // Constants
  static const String userId = "4";
  static const String tokenId = "65c9f919-f778-46ef-a2ec-31db7c417d4f";

  @override
  void onInit() {
    super.onInit();
    // Listen to search controller changes
    searchController.addListener(_onSearchChanged);
    _initialize();
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
    _filterContacts();
  }

  Future<void> _initialize() async {
    await checkPermission();
    await fetchLeads();
  }

  Future<void> checkPermission() async {
    try {
      isLoading.value = true;
      final permission = await FlutterContacts.requestPermission();
      isPermissionGranted.value = permission;
      isPermissionDeniedPermanently.value = !permission;

      if (permission) {
        await fetchContacts();
      }
    } catch (e) {
      _handleError('Error checking permission: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchContacts() async {
    try {
      isLoading.value = true;
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      allContacts.assignAll(contacts);
      _filterContacts();
      _markExistingLeadContacts();
    } catch (e) {
      _handleError('Error fetching contacts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _filterContacts() {
    if (searchQuery.value.isEmpty) {
      filteredContacts.assignAll(allContacts);
      return;
    }

    final query = searchQuery.value.toLowerCase();
    final filtered = allContacts.where((contact) {
      final nameLower = contact.displayName.toLowerCase();
      final phoneLower = contact.phones.isNotEmpty
          ? contact.phones.first.number.toLowerCase()
          : '';
      return nameLower.contains(query) || phoneLower.contains(query);
    }).toList();

    filteredContacts.assignAll(filtered);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _filterContacts();
  }

  void toggleContactSelection(Contact contact) {
    if (existingLeadContacts.contains(contact)) return;

    if (selectedContacts.contains(contact)) {
      selectedContacts.remove(contact);
    } else {
      selectedContacts.add(contact);
    }
  }

  Future<void> fetchLeads() async {
    try {
      isLoading.value = true;
      final newLeads = await _apiClient.getLeadList(
        endPoint: ApiEndpoints.leadList,
        userId: userId,
        datatype: "LeadReport",
        tokenid: tokenId,
        IsPagination: "0",
        state: "",
        lead: "",
        cityId: "",
        areaId: "",
        queryParams: {},
        PageSize: '0',
        Pagenumber: '0',
      );

      if (newLeads.isNotEmpty) {
        leads.assignAll(newLeads);
        _markExistingLeadContacts();
      }
    } catch (e) {
      _handleError('Error fetching leads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _markExistingLeadContacts() {
    final existingContacts = <Map<String, dynamic>>[]; // Store contact + leadId

    for (final contact in allContacts) {
      if (contact.phones.isEmpty) continue;

      final contactPhone =
          contact.phones.first.normalizedNumber.replaceAll(RegExp(r'\D'), '');
      if (contactPhone.isEmpty) continue;

      final matchingLead = leads.firstWhereOrNull((lead) {
        final leadPhone = lead.mobile.replaceAll(RegExp(r'\D'), '');
        return leadPhone == contactPhone;
      });

      if (matchingLead != null) {
        existingContacts.add({
          'contact': contact,
          'leadId': matchingLead.leadId,
        });
      }
    }

    existingLeadContacts
        .assignAll(existingContacts.map((e) => e['contact'] as Contact));
  }

  String getLeadId(Contact contact) {
    final contactPhone = contact.phones.isNotEmpty
        ? contact.phones.first.normalizedNumber.replaceAll(RegExp(r'\D'), '')
        : '';

    final lead = leads.firstWhereOrNull((lead) {
      final leadPhone = lead.mobile.replaceAll(RegExp(r'\D'), '');
      return leadPhone == contactPhone;
    });

    return lead?.leadId ?? 'Unknown';
  }

  Future<void> createLead() async {
    if (selectedContacts.isEmpty) return;

    try {
      isLoading.value = true;
      int successCount = 0;

      for (final contact in selectedContacts) {
        if (!contact.phones.isNotEmpty) continue;

        try {
          await _apiClient.postLeadData(
            endPoint: ApiEndpoints.saveLead,
            userId: userId,
            AssignTo: "0",
            company: "",
            dealSize: "",
            name: contact.displayName,
            mobileNumber: contact.phones.first.normalizedNumber,
            productId: "",
            address: "",
            Description: "",
            email: "",
            source: "0",
            owner: "",
            industry: "",
          );
          successCount++;
        } catch (e) {
          _handleError('Error creating lead for ${contact.displayName}: $e');
        }
      }

      if (successCount > 0) {
        Get.snackbar(
          'Success',
          '$successCount leads created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Refresh leads list and clear selection
        await fetchLeads();
        selectedContacts.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
    );
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }
}
