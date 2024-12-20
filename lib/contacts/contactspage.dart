import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Customer_entry/customer_entry_page.dart';
import 'package:leads/QuotationEntry/quotation_entry_controller.dart';
import '../widgets/custom_search_field.dart';
import 'Detailspage.dart';

class ContactsPage extends StatelessWidget {
  ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuotationEntryController controller =
        Get.put(QuotationEntryController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Contacts"),
          bottom: const TabBar(
            indicatorColor: Colors.teal,
            tabs: [
              Tab(text: "Customer"),
              Tab(text: "Prospect"),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
            ),
          ),
          child: TabBarView(
            children: [
              _buildCustomerTab(controller),
              const Center(child: Text("Prospect data")),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the Customer Tab with search functionality and paginated list.
  Widget _buildCustomerTab(QuotationEntryController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Field
          Row(
            children: [
              Expanded(
                child: CustomSearchField(
                  hintText: "Search customer...",
                  controller: controller.customerSearchController,
                  onSearch: (query) => controller.filterCustomerData(query),
                  onClear: controller.clearCustomerSearch,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Customer List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.customerData.isEmpty) {
                return const Center(child: Text("No customers found"));
              }

              return ListView.builder(
                itemCount: controller.customerData.length +
                    (controller.hasMoreCustomers.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.customerData.length &&
                      controller.hasMoreCustomers.value) {
                    controller.fetchCustomers(isInitialFetch: false);
                    return const Center(child: CircularProgressIndicator());
                  }

                  final customer = controller.customerData[index];
                  return CustomerCard(
                    name: customer.name ?? "No Name",
                    city: customer.city,
                    state: customer.state,
                    onTap: () {
                      Get.to(() => Detailspage(), arguments: customer.id);
                    },
                    onCall: () {
                      if ((customer.mobile == "") ||
                          (customer.mobile == null)) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                title: "Alert",
                                message: "There =",
                                onCancel: () {
                                  Get.back();
                                },
                                onUpdate: () {
                                  Navigator.of(context).pop();
                                  Get.to(() => CustomerEntryForm(), arguments: {
                                    'isUpdate': true,
                                    'customer': customer,
                                  })!
                                      .then((value) {
                                    if (value == true) {
                                      controller.fetchCustomers();
                                    }
                                  });
                                },
                              );
                            });
                      }
                    },
                    onWhatsApp: () {
                      print("Opening WhatsApp for ${customer.name}");
                    },
                    onEmail: () {
                      print("Emailing ${customer.name}");
                    },
                    address1: customer.address1 ?? "",
                    address2: customer.address2 ?? "",
                    address3: customer.address3,
                    mobile: customer.mobile,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onCancel;
  final VoidCallback onUpdate;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onCancel,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: onUpdate,
          child: const Text('Update'),
        ),
      ],
    );
  }
}

/// A reusable Customer Card widget

class CustomerCard extends StatelessWidget {
  final String name;
  final String address1;
  final String address2;
  final String address3;
  final String city;
  final String state;
  final String mobile;
  final VoidCallback onCall;
  final VoidCallback onTap;
  final VoidCallback onWhatsApp;
  final VoidCallback onEmail;

  const CustomerCard({
    Key? key,
    required this.name,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.city,
    required this.state,
    required this.onCall,
    required this.onWhatsApp,
    required this.onEmail,
    required this.onTap,
    required this.mobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and Address Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name with icon
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.teal,
                        child: Text(
                          name[0].toUpperCase(), // First letter of name
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Address with icon
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address1,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              address2,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              address3,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // City and State
                  Row(
                    children: [
                      Text(
                        "$city, ",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        state,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text(mobile)
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Popup Menu Button (Three Dots)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black54),
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onSelected: (String value) {
                switch (value) {
                  case 'Call':
                    onCall();
                    break;
                  case 'WhatsApp':
                    onWhatsApp();
                    break;
                  case 'Email':
                    onEmail();
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                _buildDecoratedPopupMenuItem('Call', Icons.call, Colors.blue),
                _buildDecoratedPopupMenuItem(
                    'WhatsApp', Icons.message, Colors.green),
                _buildDecoratedPopupMenuItem(
                    'Email', Icons.email, Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper function to build a popup menu item
  PopupMenuItem<String> _buildDecoratedPopupMenuItem(
      String value, IconData icon, Color iconColor) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
