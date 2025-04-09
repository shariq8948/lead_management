import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../chats.dart';
import '../../data/models/dropdown_list.model.dart';
import '../chatting/screen.dart';
import 'controller.dart';

class CustomerListTile extends StatelessWidget {
  final CustomerResponseModel customer;
  final String currentUserId;

  const CustomerListTile({
    Key? key,
    required this.customer,
    required this.currentUserId,
  }) : super(key: key);

  void _navigateToChat() {
    Get.to(() => ChatScreen(
          customerId: customer.id,
          customerName: customer.name ?? "0",
          currentUserId: currentUserId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: () => _navigateToChat(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            customer.displayName.isNotEmpty
                                ? customer.displayName
                                : 'Unnamed Customer',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(customer.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            customer.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          customer.mobile.isNotEmpty
                              ? customer.mobile
                              : 'No phone',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        if (customer.whatsapp.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.message,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            customer.whatsapp,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (customer.address1?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 4),
                      Text(
                        customer.address1!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chat_bubble_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final String displayName = customer.displayName.trim();
    final String avatarText =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '#';

    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.blue.shade100,
      child: Text(
        avatarText,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      case 'hold':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

// customers_screen.dart
class CustomersScreen extends StatelessWidget {
  final CustomerController controller = Get.put(CustomerController());
  final String currentUserId = GetStorage().read("userId");

  CustomersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: controller.searchController,
              hintText: 'Search customers...',
              leading: const Icon(Icons.search),
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: controller.refreshCustomers,
          child: controller.customerData.isEmpty &&
                  !controller.isLoadingMoreCustomers.value
              ? _buildEmptyState()
              : _buildCustomerList(),
        ),
      ),
    );
  }

  Widget _buildCustomerList() {
    return ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: controller.customerData.length + 1,
      itemBuilder: (context, index) {
        if (index == controller.customerData.length) {
          return Obx(() {
            if (controller.isLoadingMoreCustomers.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          });
        }

        return CustomerListTile(
          customer: controller.customerData[index],
          currentUserId: currentUserId,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No customers found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (controller.searchQuery.isNotEmpty)
            Text(
              'Try a different search term',
              style: TextStyle(color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }
}
