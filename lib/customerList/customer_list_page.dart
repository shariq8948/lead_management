import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:leads/Customer_entry/customer_entry_page.dart';
import 'package:leads/customerList/customer_list_controller.dart';

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final CustomerListController controller = Get.put(CustomerListController());
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    // Initially fetch the first set of customers
    controller.fetchCustomers(isInitialFetch: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
        // backgroundColor: Colors.teal.shade700,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(() {
            return RefreshIndicator(
              onRefresh: () async {
                // Reset pagination and fetch the customers again
                controller.currentPage.value = 0;
                controller.hasMoreLeads.value = true;
                await controller.fetchCustomers(isInitialFetch: true);
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: controller.customerList.length +
                    1, // Add 1 for loading indicator
                itemBuilder: (context, index) {
                  if (index == controller.customerList.length) {
                    return Obx(() => controller.isFetchingMore.value
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox());
                  }

                  final customer = controller.customerList[index];

                  return CustomerCard(
                    id: customer.id,
                    name: customer.name ?? "No Name",
                    mobile: customer.mobile,
                    email: customer.email ?? "Email not found",
                    state: customer.state,
                    city: customer.city,
                    onUpdate: () => Get.to(
                      CustomerEntryForm(),
                      arguments: {
                        'isUpdate': true,
                        'customer': customer,
                      },
                    ),
                    onDelete: () async {
                      // Call the deleteCustomer method
                      controller.deleteCustomer(customer.id);

                      // Reload the controller to trigger a full UI update
                      await controller.fetchCustomers();
                      Get.back();
                      // Optionally, you could also show a snackbar or confirmation of deletion
                      Get.snackbar('Success', 'Customer deleted successfully');
                    },
                  );
                },
              ),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(CustomerEntryForm());
        },
        backgroundColor: Colors.teal.shade700,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget CustomerCard({
    required String name,
    required String id,
    required String mobile,
    required String email,
    required String state,
    required String city,
    VoidCallback? onUpdate,
    VoidCallback? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(color: Colors.blue.withOpacity(.5), width: 2),
          left: BorderSide(color: Colors.blue.withOpacity(.5), width: 1),
          right: BorderSide(color: Colors.blue.withOpacity(.5), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Align items horizontally
                          children: [
                            const Icon(
                              Icons.delete,
                              size: 20,
                            ),
                            const SizedBox(
                                width: 18), // Space between icon and text
                            const Text("Delete"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Align items horizontally
                          children: [
                            const Icon(
                              Icons.update,
                              size: 20,
                            ),
                            const SizedBox(
                                width: 18), // Space between icon and text
                            const Text("Edit"),
                          ],
                        ),
                      ),
                    ],
                    icon: const Icon(Icons.more_horiz), // Icon for the button
                    offset: const Offset(0, 50), // Adjusts the popup position
                    color: Colors.white, // Background color of the popup menu
                    elevation: 4, // Elevation for shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onSelected: (value) {
                      if (value == 1) {
                        print("Get The App clicked");
                      } else if (value == 2) {
                        onUpdate!();
                        print("About clicked");
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    city,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    state,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: buildInputFieldWithIcon(
                      iconPath: 'assets/icons/call.svg',
                      value: mobile,
                    ),
                  ),
                  Expanded(
                    child: buildInputFieldWithIcon(
                      iconPath: 'assets/icons/mail.svg',
                      value: email,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputFieldWithIcon(
      {required String iconPath, required String value}) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
