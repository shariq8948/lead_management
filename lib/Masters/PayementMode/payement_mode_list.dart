import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:leads/Masters/PayementMode/add_payement_mode.dart';
import 'package:leads/Masters/PayementMode/payement_mode_controller.dart';
import 'package:leads/widgets/custom_loader.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:leads/widgets/floatingbutton.dart';

class PaymentModePage extends StatefulWidget {
  const PaymentModePage({Key? key}) : super(key: key);

  @override
  State<PaymentModePage> createState() => _PaymentModePageState();
}

class _PaymentModePageState extends State<PaymentModePage>
    with SingleTickerProviderStateMixin {
  final PayementModeController controller = Get.put(PayementModeController());
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();
  final RxBool _isSearching = false.obs;
  final RxString _searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    controller.fetchMode();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => _isSearching.value
            ? _buildSearchField()
            : const Text('Payment Modes')),
        backgroundColor: Colors.tealAccent,
        actions: [
          Obx(() => IconButton(
                icon: Icon(_isSearching.value ? Icons.close : Icons.search),
                onPressed: () {
                  _isSearching.value = !_isSearching.value;
                  if (!_isSearching.value) {
                    _searchQuery.value = '';
                    _searchController.clear();
                  }
                },
              )),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: CustomFloatingActionButton(
          onPressed: _addNewPaymentMode, icon: Icons.add),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller.searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
          hintText: 'Search payment modes...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onChanged: (value) {
          controller.updateSearch(value);
        },
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CustomLoader());
      }

      if (controller.payementModes.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        color: Colors.teal,
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          await controller.fetchMode();
        },
        child: Obx(
          () {
            if (controller.filteredModes.isEmpty) {
              return const Center(
                child: Text(
                  "No Payment Modes Available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return AnimatedList(
              initialItemCount: controller.filteredModes.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index, animation) {
                if (index < 0 || index >= controller.filteredModes.length) {
                  return const SizedBox.shrink();
                }

                final mode = controller.filteredModes[index];
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: _buildPaymentCard(
                    mode.paymentType,
                    mode.paymentMode,
                    mode.id,
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }

  void _showFilterDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Filter Payment Modes'),
            TextButton(
              onPressed: () {
                controller.resetFilters();
                Get.back();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
        content: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterTile(
                  'Cash',
                  FontAwesomeIcons.moneyBill,
                  controller.activeFilters['cash'] ?? true,
                  (value) => controller.toggleFilter('cash', value ?? true),
                ),
                _buildFilterTile(
                  'Online',
                  FontAwesomeIcons.moneyBillTransfer,
                  controller.activeFilters['online'] ?? true,
                  (value) => controller.toggleFilter('online', value ?? true),
                ),
                _buildFilterTile(
                  'Bank',
                  FontAwesomeIcons.buildingColumns,
                  controller.activeFilters['bank'] ?? true,
                  (value) => controller.toggleFilter('bank', value ?? true),
                ),
                _buildFilterTile(
                  'Other',
                  FontAwesomeIcons.buildingColumns,
                  controller.activeFilters['other'] ?? true,
                  (value) => controller.toggleFilter('other', value ?? true),
                ),
              ],
            )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              elevation: 0,
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTile(
      String title, IconData icon, bool value, Function(bool?) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: CheckboxListTile(
        title: Row(
          children: [
            FaIcon(icon, size: 18, color: value ? Colors.teal : Colors.grey),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: value ? Colors.black87 : Colors.grey,
              ),
            ),
          ],
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.teal,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(String type, String mode, String id) {
    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showPaymentDetails(type, mode, id),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: Colors.white),
            child: Row(
              children: [
                _buildPaymentIcon(type),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mode,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.teal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (value) =>
                      _handleMenuAction(value, id, type, mode),
                  itemBuilder: (context) => [
                    _buildPopupMenuItem(
                        'edit', 'Edit', Icons.edit, Colors.blue),
                    _buildPopupMenuItem(
                        'delete', 'Delete', Icons.delete, Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentIcon(String type) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: FaIcon(
        _getPaymentIcon(type),
        color: Colors.teal,
        size: 24,
      ),
    );
  }

  IconData _getPaymentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'cash':
        return FontAwesomeIcons.moneyBill;
      case 'online':
        return FontAwesomeIcons.moneyBillTransfer;
      case 'bank':
        return FontAwesomeIcons.buildingColumns;
      default:
        return FontAwesomeIcons.creditCard;
    }
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String value,
    String text,
    IconData icon,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FontAwesomeIcons.creditCard,
            size: 64,
            color: Colors.teal,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Payment Modes Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.value.isEmpty
                ? 'Add your first payment mode'
                : 'Try a different search term',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          if (_searchQuery.value.isEmpty)
            ElevatedButton.icon(
              onPressed: () => _addNewPaymentMode(),
              icon: const Icon(Icons.add),
              label: const Text('Add Payment Mode'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _addNewPaymentMode() {
    Get.to(
      () => AddPayementModePage(),
      arguments: {'isEdit': false},
      transition: Transition.zoom,
    );
  }

  void _handleMenuAction(String action, String id, String type, String mode) {
    switch (action) {
      case 'edit':
        Get.to(
          () => AddPayementModePage(),
          arguments: {
            'isEdit': true,
            'id': id,
            'paymentType': type,
            'paymentMode': mode,
          },
          transition: Transition.rightToLeft,
        );
        break;
      case 'delete':
        _confirmDelete(id);
        break;
    }
  }

  Future<bool> _confirmDelete(String id) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Payment Mode'),
        content:
            const Text('Are you sure you want to delete this payment mode?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
              controller.deletePayment(id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showPaymentDetails(String type, String mode, String id) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                FaIcon(_getPaymentIcon(type), size: 32, color: Colors.teal),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mode,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        type,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Add more payment details here
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _handleMenuAction('edit', id, type, mode),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
