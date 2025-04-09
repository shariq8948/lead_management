import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leads/utils/constants.dart';
import 'package:leads/widgets/custom_states.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'controller.dart';

class OrdersDashboard extends GetView<OrdersController> {
  const OrdersDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Orders Dashboard',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Date filter action
          Tooltip(
            message: 'Date Filter',
            child: IconButton(
              icon: const Icon(Icons.calendar_today, size: 20),
              onPressed: () => _showDateFilterBottomSheet(context),
            ),
          ),
          // Category filter action
          Tooltip(
            message: 'Category Filter',
            child: IconButton(
              icon: const Icon(Icons.category, size: 20),
              onPressed: () => _showCategoryFilterBottomSheet(context),
            ),
          ),
          // Refresh action
          Tooltip(
            message: 'Refresh',
            child: IconButton(
              icon: const Icon(Icons.refresh, size: 22),
              onPressed: () => controller.fetchOrders(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSummaryHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => controller.fetchOrders(),
                color: primary1Color,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _buildSearchBar()),
                    SliverToBoxAdapter(child: _buildStats()),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order List',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            Obx(() => Text(
                                  '${controller.filteredOrders.length} items',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const SliverFillRemaining(
                          child: Center(child: CustomLoader()),
                        );
                      }
                      return controller.filteredOrders.isEmpty
                          ? SliverFillRemaining(child: _buildEmptyState())
                          : SliverPadding(
                              padding: const EdgeInsets.all(16),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return _buildOrderCard(
                                        controller.filteredOrders[index]);
                                  },
                                  childCount: controller.filteredOrders.length,
                                ),
                              ),
                            );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show date filter bottom sheet
  void _showDateFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bottom sheet header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter by Date',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Predefined date ranges
                      _buildDateRangeOption(
                        title: 'Today',
                        icon: Icons.today,
                        onTap: () {
                          _applyDateFilter('Today');
                          Navigator.of(context).pop();
                        },
                      ),
                      _buildDateRangeOption(
                        title: 'Yesterday',
                        icon: Icons.history,
                        onTap: () {
                          _applyDateFilter('Yesterday');
                          Navigator.of(context).pop();
                        },
                      ),
                      _buildDateRangeOption(
                        title: 'Last 7 days',
                        icon: Icons.calendar_view_week,
                        onTap: () {
                          _applyDateFilter('Last 7 days');
                          Navigator.of(context).pop();
                        },
                      ),
                      _buildDateRangeOption(
                        title: 'Last 30 days',
                        icon: Icons.calendar_view_month,
                        onTap: () {
                          _applyDateFilter('Last 30 days');
                          Navigator.of(context).pop();
                        },
                      ),
                      _buildDateRangeOption(
                        title: 'This month',
                        icon: Icons.event_note,
                        onTap: () {
                          _applyDateFilter('This month');
                          Navigator.of(context).pop();
                        },
                      ),
                      _buildDateRangeOption(
                        title: 'Last month',
                        icon: Icons.event,
                        onTap: () {
                          _applyDateFilter('Last month');
                          Navigator.of(context).pop();
                        },
                      ),
                      const Divider(height: 32),
                      // Custom date range picker
                      Text(
                        'Custom Date Range',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: const Text('Select Custom Range'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          final DateTimeRange? picked =
                              await showDateRangePicker(
                            context: Get.context!,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            initialDateRange: DateTimeRange(
                              start: DateTime.now()
                                  .subtract(const Duration(days: 7)),
                              end: DateTime.now(),
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Colors.blue[400]!,
                                    onPrimary: Colors.white,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blue[400],
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null) {
                            _applyCustomDateFilter(picked);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show category filter bottom sheet
  void _showCategoryFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bottom sheet header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter by Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: .5),
            // Search categories
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildCategorySearch(),
            ),
            // Selected category indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => Text(
                    'Selected: ${controller.selectedCategory.value}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                    ),
                  )),
            ),
            // Reset button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextButton.icon(
                onPressed: () {
                  controller.setSelectedCategory('All');
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.clear_all, size: 16, color: Colors.blue[400]),
                label: Text(
                  'Clear filters',
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Divider(height: .5),
            // Category list
            Expanded(
              child: Obx(() {
                return controller.filteredCategories.isEmpty
                    ? Center(
                        child: Text(
                          'No categories found',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: controller.filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = controller.filteredCategories[index];
                          final isSelected =
                              controller.selectedCategory.value == category;
                          return Card(
                            elevation: isSelected ? 1 : 0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 2),
                            color: isSelected
                                ? Colors.blue[50]
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: isSelected
                                  ? BorderSide(color: Colors.blue[100]!)
                                  : BorderSide.none,
                            ),
                            child: ListTile(
                              title: Text(category),
                              leading: Icon(
                                Icons.category,
                                color: isSelected
                                    ? Colors.blue[400]
                                    : Colors.grey[400],
                                size: 20,
                              ),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle,
                                      color: Colors.blue[400])
                                  : null,
                              onTap: () {
                                controller.setSelectedCategory(category);
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeOption({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue[400]),
        ),
        trailing: const Icon(Icons.chevron_right),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
      ),
    );
  }

  void _applyDateFilter(String filterName) {
    // Apply selected date filter
    // In a real app, you would update the controller with the selected date range
    Get.snackbar(
      'Date Filter',
      'Filter applied: $filterName',
      backgroundColor: Colors.blue[50],
      colorText: Colors.blue[800],
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      icon: Icon(Icons.date_range, color: Colors.blue[400]),
    );
  }

  void _applyCustomDateFilter(DateTimeRange dateRange) {
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    final String start = formatter.format(dateRange.start);
    final String end = formatter.format(dateRange.end);

    Get.snackbar(
      'Custom Date Range',
      'Filter applied: $start to $end',
      backgroundColor: Colors.blue[50],
      colorText: Colors.blue[800],
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      icon: Icon(Icons.date_range, color: Colors.blue[400]),
    );
  }

  Widget _buildSummaryHeader() {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.teal.shade300,
            boxShadow: [
              BoxShadow(
                color: Colors.blue[300]!.withOpacity(0.3),
                offset: const Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.insights_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Dashboard Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  // Active status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '${controller.orders.length} Orders',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Current filter indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.filter_list,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Filters: Last 7 days, ${controller.selectedCategory.value}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildSearchBar() {
    final _speech = stt.SpeechToText();
    // Create a TextEditingController to control the TextField content
    final TextEditingController _searchController = TextEditingController();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      color: Colors.white,
      child: GetBuilder<OrdersController>(
        builder: (_) => TextField(
          controller: _searchController, // Add the controller here
          onChanged: controller.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Search products, companies or IDs...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
            prefixIcon: Icon(Icons.search, color: Colors.blue[300], size: 22),
            suffixIcon: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () async {
                bool available = await _speech.initialize();
                if (available) {
                  await _speech.listen(
                    onResult: (result) {
                      String recognizedText = result.recognizedWords;
                      controller.setSearchQuery(recognizedText);
                      // Update the TextField value
                      _searchController.text = recognizedText;
                    },
                  );

                  Get.snackbar(
                    'Voice Search',
                    'Listening...',
                    backgroundColor: Colors.blue[50],
                    colorText: Colors.blue[800],
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                    icon: Icon(Icons.mic, color: Colors.blue[400]),
                  );

                  Future.delayed(const Duration(seconds: 5), () {
                    if (_speech.isListening) {
                      _speech.stop();
                    }
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mic, color: Colors.blue[400], size: 22),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[300]!),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySearch() {
    return TextField(
      onChanged: controller.setCategorySearchQuery,
      decoration: InputDecoration(
        hintText: 'Search categories...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: Icon(Icons.category, color: Colors.blue[300], size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildStats() {
    return Obx(() => Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dashboard Metrics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Icon(Icons.insights, color: Colors.blue[300], size: 20),
                  ],
                ),
              ),
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStatCard(
                      title: 'Total Orders',
                      value: controller.orders.length.toString(),
                      icon: Icons.inventory_2,
                      color: Colors.blue[400]!,
                      trend: '+4.5%',
                      trendUp: true,
                      width: 160,
                    ),
                    _buildStatCard(
                      title: 'Categories',
                      value: (controller.categories.length - 1)
                          .toString(), // Minus 'All'
                      icon: Icons.category,
                      color: Colors.green[400]!,
                      trend: '+2.1%',
                      trendUp: true,
                      width: 160,
                    ),
                    _buildStatCard(
                      title: 'Companies',
                      value: controller.orders
                          .map((o) => o.company)
                          .toSet()
                          .length
                          .toString(),
                      icon: Icons.business,
                      color: Colors.amber[400]!,
                      trend: '-1.3%',
                      trendUp: false,
                      width: 160,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required bool trendUp,
    required double width,
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[100]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  //   decoration: BoxDecoration(
                  //     color: trendUp ? Colors.green[50] : Colors.red[50],
                  //     borderRadius: BorderRadius.circular(6),
                  //   ),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Icon(
                  //         trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                  //         color: trendUp ? Colors.green[600] : Colors.red[600],
                  //         size: 12,
                  //       ),
                  //       const SizedBox(width: 2),
                  //       Text(
                  //         trend,
                  //         style: TextStyle(
                  //           fontSize: 10,
                  //           fontWeight: FontWeight.w500,
                  //           color:
                  //               trendUp ? Colors.green[600] : Colors.red[600],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[100]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inventory_2_outlined,
                  size: 60, color: Colors.blue[400]),
            ),
            const SizedBox(height: 24),
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try changing your search criteria or category filters',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.fetchOrders(),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Data', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                // Completion of the ElevatedButton.styleFrom in _buildEmptyState
                backgroundColor: Colors.blue[400],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderList order) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Order ID and Badge
                Row(
                  children: [
                    Text(
                      'ID: ${order.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                // Options menu
                PopupMenuButton(
                  icon:
                      Icon(Icons.more_vert, color: Colors.grey[600], size: 20),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'details',
                      child: Text('View Details'),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit Order'),
                    ),
                    const PopupMenuItem(
                      value: 'track',
                      child: Text('Track Order'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                  onSelected: (value) {
                    // Handle menu actions
                    if (value == 'details') {
                      Get.snackbar(
                        'Order Details',
                        'Viewing details for order ${order.id}',
                        backgroundColor: Colors.blue[50],
                        colorText: Colors.blue[800],
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                        icon: Icon(Icons.info_outline, color: Colors.blue[400]),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Product Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.inventory_2,
                      size: 24,
                      color: Colors.blue[400],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.iName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Code: ${order.iCode}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Order details in a grid
            Row(
              children: [
                Expanded(
                  child: _buildOrderDetailItem(
                    label: 'Category',
                    value: order.category,
                    icon: Icons.category,
                  ),
                ),
                Expanded(
                  child: _buildOrderDetailItem(
                    label: 'Company',
                    value: order.company,
                    icon: Icons.business,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildOrderDetailItem(
                    label: 'Unit',
                    value: order.unit,
                    icon: Icons.inventory,
                  ),
                ),
                Expanded(
                  child: _buildOrderDetailItem(
                    label: 'Rate',
                    value: '\$${order.rate}',
                    icon: Icons.attach_money,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                // Expanded(
                //   child: OutlinedButton.icon(
                //     onPressed: () {},
                //     icon: Icon(Icons.visibility,
                //         size: 16, color: Colors.blue[400]),
                //     label:
                //         Text('View', style: TextStyle(color: Colors.blue[400])),
                //     style: OutlinedButton.styleFrom(
                //       side: BorderSide(color: Colors.blue[200]!),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       padding: const EdgeInsets.symmetric(vertical: 12),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('View'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildOrderDetailItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: Colors.grey[600]),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
