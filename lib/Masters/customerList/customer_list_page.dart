import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/utils/routes.dart';
import 'package:leads/widgets/floatingbutton.dart';

import '../../widgets/snacks.dart';
import '../Customer_entry/customer_entry_controller.dart';

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final CustomerEntryController controller = Get.put(CustomerEntryController());
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    controller.fetchCustomers(isInitialFetch: true);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // This will trigger when coming back to this page after popping
    await controller.fetchCustomers(isInitialFetch: true);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // If we have reached the bottom, fetch more customers
      if (controller.hasMoreLeads.value && !controller.isFetchingMore.value) {
        controller.fetchCustomers(isInitialFetch: false);
      }
    }
  }
  // ... keeping existing lifecycle methods ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.tealAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top bar with title and actions
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                        onPressed: () => Get.back(),
                      ),
                      Text(
                        'Customers',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                // Search bar
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        onChanged: controller.handleSearch,
                        decoration: InputDecoration(
                          hintText: 'Search customers...',
                          prefixIcon: Icon(Icons.search, color: Colors.teal),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isFetchingInitial.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          );
        }

        if (controller.customerList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_search, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No customers found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Pull to refresh or add a new customer',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.currentPage.value = 0;
            controller.hasMoreLeads.value = true;
            await controller.fetchCustomers(isInitialFetch: true);
          },
          child: Obx(
            () => ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              // Only add +1 to itemCount if there might be more items to load
              itemCount: controller.customerList.length +
                  (controller.hasMoreLeads.value ? 1 : 0),
              itemBuilder: (context, index) {
                // Check if this is the last item and we're still loading
                if (index == controller.customerList.length) {
                  if (!controller.hasMoreLeads.value) {
                    return SizedBox
                        .shrink(); // Return empty widget if no more data
                  }
                  return Obx(() => controller.isFetchingMore.value
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.teal),
                            ),
                          ),
                        )
                      : SizedBox.shrink());
                }

                final customer = controller.customerList[index];
                return EnhancedCustomerCard(
                  customer: customer,
                  onUpdate: () => Get.toNamed(
                    Routes.CUSTOMER_ENTRY,
                    arguments: {
                      'isUpdate': true,
                      'customer': customer,
                    },
                  ),
                  onDelete: () async {
                    final result = await _confirmDelete(context);
                    if (result == true) {
                      await controller.deleteCustomer(customer.id);

                      // showSuccessSnackbar(
                      //     'Success', 'Customer deleted successfully');
                    }
                  },
                );
              },
            ),
          ),
        );
      }),
      floatingActionButton: CustomFloatingActionButton(
          onPressed: () {
            controller.clearFields();
            Get.toNamed(Routes.CUSTOMER_ENTRY);
            // Get.to(CustomerEntryForm());
          },
          icon: Icons.add),
      // floatingActionButton: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       colors: [Colors.teal, Colors.teal.shade700],
      //     ),
      //     borderRadius: BorderRadius.circular(16),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.teal.withOpacity(0.3),
      //         blurRadius: 8,
      //         offset: Offset(0, 4),
      //       ),
      //     ],
      //   ),
      //   child: FloatingActionButton.extended(
      //     onPressed: () {
      //       controller.clearFields();
      //       Get.to(CustomerEntryForm());
      //     },
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //     label: Row(
      //       children: [
      //         Icon(Icons.add),
      //         SizedBox(width: 8),
      //         Text('Add Customer'),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this customer?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}

class EnhancedCustomerCard extends StatelessWidget {
  final dynamic customer;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const EnhancedCustomerCard({
    required this.customer,
    required this.onUpdate,
    required this.onDelete,
  });
  String _getInitial() {
    final name = customer?.name as String?;
    if (name == null || name.isEmpty) return '#';
    return name[0].toUpperCase();
  }

  String _getLocationText() {
    final city = customer?.city as String?;
    final state = customer?.state as String?;

    if (city == null && state == null) return 'Location not available';
    if (city == null) return state!;
    if (state == null) return city;
    return '$city, $state';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onUpdate,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.teal.withOpacity(0.1),
                        child: Text(
                          _getInitial(),
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name ?? 'No Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              _getLocationText(),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            onUpdate();
                          } else if (value == 'delete') {
                            onDelete();
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _buildContactInfo(
                        icon: Icons.phone,
                        value: customer.mobile ?? 'No Number',
                        color: Colors.green,
                      ),
                      SizedBox(width: 16),
                      _buildContactInfo(
                        icon: Icons.email,
                        value: customer.email ?? 'No Email',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
