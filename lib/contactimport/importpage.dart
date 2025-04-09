import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/routes.dart';
import 'controller.dart';

class ImportContactsPage extends GetView<ContactImportController> {
  const ImportContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        if (!controller.isPermissionGranted.value) {
          return _buildPermissionRequestUI();
        }

        if (controller.isLoading.value) {
          return _buildLoadingUI();
        }

        return _buildMainContent();
      }),
      bottomSheet: _buildBottomSheet(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Import Contacts',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      backgroundColor: Colors.teal.shade700,
      elevation: 0,
      actions: [
        Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.selectedContacts.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ElevatedButton.icon(
                        onPressed: controller.createLead,
                        icon: const Icon(
                          Icons.add_circle_outline,
                          size: 20,
                          color: Colors.teal,
                        ),
                        label: const Text('Create Leads'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.teal.shade700,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            )),
      ],
    );
  }

  Widget _buildLoadingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade700),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading Contacts...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildSearchBar(),
        _buildSelectedCounter(),
        Expanded(
          child: _buildContactsList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Search contacts...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: Colors.teal.shade700),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: controller.clearSearch,
                )
              : const SizedBox.shrink()),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
        // Remove onChanged since we're now using a listener in the controller
      ),
    );
  }

  Widget _buildSelectedCounter() {
    return Obx(() {
      if (controller.selectedContacts.isEmpty) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          '${controller.selectedContacts.length} contacts selected',
          style: TextStyle(
            color: Colors.teal.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      );
    });
  }

  Widget _buildContactsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: controller.filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = controller.filteredContacts[index];
        final phoneNumber = contact.phones.isNotEmpty
            ? contact.phones.first.number
            : 'No Number';
        final isExistingLead =
            controller.existingLeadContacts.contains(contact);

        return Obx(() {
          final isSelected = controller.selectedContacts.contains(contact);
          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.teal.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Colors.teal.shade200
                    : Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: _buildAvatar(contact, isExistingLead),
              title: Text(
                contact.displayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isExistingLead
                      ? Colors.grey.shade400
                      : Colors.grey.shade800,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      color: isExistingLead
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  if (isExistingLead) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Lead ID: ${controller.getLeadId(contact)}',
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Already a lead',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: _buildCheckbox(contact, isSelected, isExistingLead),
              onTap: () {
                if (isExistingLead) {
                  final leadId = controller.getLeadId(contact);
                  Get.toNamed(Routes.leadDetail, arguments: leadId);
                } else {
                  controller.toggleContactSelection(contact);
                }
              },
            ),
          );
        });
      },
    );
  }

  Widget _buildAvatar(dynamic contact, bool isExistingLead) {
    return CircleAvatar(
      radius: 28,
      backgroundColor:
          isExistingLead ? Colors.grey.shade200 : Colors.teal.shade100,
      child: Text(
        contact.displayName.isNotEmpty
            ? contact.displayName[0].toUpperCase()
            : '?',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isExistingLead ? Colors.grey.shade400 : Colors.teal.shade700,
        ),
      ),
    );
  }

  Widget _buildCheckbox(dynamic contact, bool isSelected, bool isExistingLead) {
    return Checkbox(
      value: isSelected,
      onChanged: isExistingLead
          ? null
          : (_) => controller.toggleContactSelection(contact),
      activeColor: Colors.teal.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildPermissionRequestUI() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.contacts_rounded,
            size: 100,
            color: Colors.teal.shade700,
          ),
          const SizedBox(height: 24),
          Text(
            controller.isPermissionDeniedPermanently.value
                ? 'Permission Required'
                : 'Access Your Contacts',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            controller.isPermissionDeniedPermanently.value
                ? 'Please enable contact access in your device settings to continue.'
                : 'To help you import contacts quickly and easily, we need permission to access your contacts.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: controller.checkPermission,
            icon: Icon(
              controller.isPermissionDeniedPermanently.value
                  ? Icons.settings
                  : Icons.check_circle_outline,
              size: 24,
            ),
            label: Text(
              controller.isPermissionDeniedPermanently.value
                  ? 'Open Settings'
                  : 'Grant Permission',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade700,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Obx(() {
      if (controller.selectedContacts.isEmpty) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Selected ${controller.selectedContacts.length} contacts',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: controller.createLead,
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  'Create Leads',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
