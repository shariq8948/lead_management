import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:leads/master-reports/customers/lifetime-value/views/transaction_details.dart';
import 'dart:math' as math;
import '../../../widgets/page_wrapper.dart';
import 'all_transactions.dart';

// Customer model class
class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String industry;
  final String leadSource;
  final double lifetimeSales;
  final int totalDeals;
  final DateTime acquisitionDate;
  final String status;
  final List<Map<String, dynamic>> transactions;
  final String assignedTo;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.industry,
    required this.leadSource,
    required this.lifetimeSales,
    required this.totalDeals,
    required this.acquisitionDate,
    required this.status,
    required this.transactions,
    required this.assignedTo,
  });
}

// Controller for All Customers
class AllCustomersController extends GetxController {
  // Date range selection
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 365)),
      end: DateTime.now(),
    ),
  );

  // Customers data
  final RxList<Customer> customers = <Customer>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'lifetimeSales'.obs;
  final RxBool sortAscending = false.obs;

  // Filter options
  final RxString selectedIndustry = 'All'.obs;
  final RxString selectedStatus = 'All'.obs;
  final RxList<String> industries = <String>[
    'All',
    'IT',
    'Manufacturing',
    'Healthcare',
    'Education',
    'Retail',
    'Finance'
  ].obs;
  final RxList<String> statuses =
      <String>['All', 'Active', 'Inactive', 'Pending', 'Lead'].obs;

  // Format currency (Indian Rupee)
  final currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  @override
  void onInit() {
    super.onInit();
    loadCustomers();
  }

  // Update data when date range changes
  void updateDateRange(DateTimeRange? range) {
    if (range != null) {
      selectedDateRange.value = range;
      loadCustomers();
    }
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    loadCustomers();
  }

  // Update sort options
  void updateSort(String field) {
    if (sortBy.value == field) {
      sortAscending.value = !sortAscending.value;
    } else {
      sortBy.value = field;
      sortAscending.value = false;
    }
    sortCustomers();
  }

  // Update filters
  void updateIndustry(String industry) {
    selectedIndustry.value = industry;
    loadCustomers();
  }

  void updateStatus(String status) {
    selectedStatus.value = status;
    loadCustomers();
  }

  // Load customers data (simulated data for now)
  Future<void> loadCustomers() async {
    isLoading.value = true;

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));

      // In a real app, you would call your API here with the filters
      // For now, we'll generate dummy data
      _generateDummyCustomers();

      // Apply search filter
      if (searchQuery.value.isNotEmpty) {
        customers.value = customers
            .where((customer) =>
                customer.name
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase()) ||
                customer.email
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase()) ||
                customer.phone.contains(searchQuery.value))
            .toList();
      }

      // Apply industry filter
      if (selectedIndustry.value != 'All') {
        customers.value = customers
            .where((customer) => customer.industry == selectedIndustry.value)
            .toList();
      }

      // Apply status filter
      if (selectedStatus.value != 'All') {
        customers.value = customers
            .where((customer) => customer.status == selectedStatus.value)
            .toList();
      }

      // Sort the list
      sortCustomers();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load customers: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sort customers based on selected field
  void sortCustomers() {
    switch (sortBy.value) {
      case 'name':
        customers.sort((a, b) => sortAscending.value
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
        break;
      case 'lifetimeSales':
        customers.sort((a, b) => sortAscending.value
            ? a.lifetimeSales.compareTo(b.lifetimeSales)
            : b.lifetimeSales.compareTo(a.lifetimeSales));
        break;
      case 'totalDeals':
        customers.sort((a, b) => sortAscending.value
            ? a.totalDeals.compareTo(b.totalDeals)
            : b.totalDeals.compareTo(a.totalDeals));
        break;
      case 'acquisitionDate':
        customers.sort((a, b) => sortAscending.value
            ? a.acquisitionDate.compareTo(b.acquisitionDate)
            : b.acquisitionDate.compareTo(a.acquisitionDate));
        break;
    }
  }

  // Generate dummy customers data for demonstration
  void _generateDummyCustomers() {
    // Random generator with seed for consistent results during demo
    final random = math.Random(42);

    // List of possible customer names
    final companyNames = [
      'Reliance Industries',
      'Tata Consultancy',
      'Infosys Limited',
      'HCL Technologies',
      'Wipro Limited',
      'Bharti Airtel',
      'Tech Mahindra',
      'Larsen & Toubro',
      'Axis Solutions',
      'Global Innovators',
      'SoftVision India',
      'Datacraft Systems',
      'Nexus Solutions',
      'Paramount Tech',
      'Inspire Infotech',
      'ValueFirst Digital',
      'Eastern Systems',
      'Pioneer Analytics',
      'Zenith Consulting',
      'Quantum Networks',
      'Bluechip Technologies',
      'Spectrum IT Solutions',
      'Pinnacle Systems',
      'MetricLabs',
      'CoreTech Solutions'
    ];

    final leadSources = [
      'Website',
      'Referral',
      'Direct',
      'Social Media',
      'Email Campaign',
      'Trade Show',
      'Cold Call'
    ];
    final statuses = ['Active', 'Inactive', 'Pending', 'Lead'];
    final assignedToNames = [
      'Rahul Sharma',
      'Priya Patel',
      'Amit Singh',
      'Deepa Gupta',
      'Vijay Kumar'
    ];

    // Clear previous data
    customers.clear();

    // Generate customer data
    for (int i = 0; i < 25; i++) {
      final name = companyNames[i % companyNames.length];
      final email = '${name.toLowerCase().replaceAll(' ', '.')}@example.com';
      final phone = '+91 ${8000000000 + random.nextInt(1999999999)}';
      final industry =
          industries[random.nextInt(industries.length - 1) + 1]; // Skip 'All'
      final leadSource = leadSources[random.nextInt(leadSources.length)];
      final lifetimeSales = 100000.0 + random.nextInt(9900000);
      final totalDeals = 1 + random.nextInt(20);
      final acquisitionDate =
          DateTime.now().subtract(Duration(days: random.nextInt(1000)));
      final status = statuses[random.nextInt(statuses.length)];
      final assignedTo =
          assignedToNames[random.nextInt(assignedToNames.length)];

      // Generate transactions
      final transactions = <Map<String, dynamic>>[];
      final transactionCount = 1 + random.nextInt(8);

      for (int j = 0; j < transactionCount; j++) {
        final transactionDate =
            acquisitionDate.add(Duration(days: 15 + random.nextInt(500)));
        final amount = 10000.0 + random.nextInt(990000);
        final productName = [
          'Software License',
          'IT Services',
          'Hardware',
          'Consulting',
          'Support Package',
          'Training'
        ][random.nextInt(6)];

        transactions.add({
          'date': transactionDate,
          'amount': amount,
          'product': productName,
          'status': ['Completed', 'Pending', 'Processing'][random.nextInt(3)],
        });
      }

      // Sort transactions by date (most recent first)
      transactions.sort(
          (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

      customers.add(Customer(
        id: 'CUST${10000 + i}',
        name: name,
        email: email,
        phone: phone,
        industry: industry,
        leadSource: leadSource,
        lifetimeSales: lifetimeSales,
        totalDeals: totalDeals,
        acquisitionDate: acquisitionDate,
        status: status,
        transactions: transactions,
        assignedTo: assignedTo,
      ));
    }
  }
}

// All Customers Page
class AllCustomersPage extends StatelessWidget {
  const AllCustomersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(AllCustomersController());

    return ReportPageWrapper(
      title: 'All Customers',
      showFilterIcon: true,
      onFilterTap: () => _showFilterModal(context, controller),
      onDateRangeSelected: (range) => controller.updateDateRange(range),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 100),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(controller),
            const SizedBox(height: 16),
            _buildCustomerStats(controller),
            const SizedBox(height: 24),
            _buildSortHeader(controller),
            const SizedBox(height: 16),
            _buildCustomersList(controller),
          ],
        );
      }),
    );
  }

  // Search bar for customers
  Widget _buildSearchBar(AllCustomersController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search customers...',
          hintStyle: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.black54,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  // Customer statistics cards
  Widget _buildCustomerStats(AllCustomersController controller) {
    // Calculate totals
    final totalCustomers = controller.customers.length;
    final totalSales = controller.customers
        .fold(0.0, (sum, customer) => sum + customer.lifetimeSales);
    final totalDeals = controller.customers
        .fold(0, (sum, customer) => sum + customer.totalDeals);
    final avgSalePerCustomer =
        totalCustomers > 0 ? totalSales / totalCustomers : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(
            label: 'Total Customers',
            value: totalCustomers.toString(),
            icon: Icons.people,
            color: Colors.blue.shade700,
          ),
          _buildStatItem(
            label: 'Total Sales',
            value: controller.currencyFormat.format(totalSales),
            icon: Icons.currency_rupee,
            color: Colors.green.shade700,
          ),
          _buildStatItem(
            label: 'Total Deals',
            value: totalDeals.toString(),
            icon: Icons.handshake,
            color: Colors.purple.shade700,
          ),
          _buildStatItem(
            label: 'Avg. Sale',
            value: controller.currencyFormat.format(avgSalePerCustomer),
            icon: Icons.trending_up,
            color: Colors.orange.shade700,
          ),
        ],
      ),
    );
  }

  // Individual stat item
  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // Sort header
  Widget _buildSortHeader(AllCustomersController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(
            'Sort by:',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 12),
          _buildSortButton(
            controller: controller,
            label: 'Customer Name',
            value: 'name',
          ),
          const SizedBox(width: 8),
          _buildSortButton(
            controller: controller,
            label: 'Sales',
            value: 'lifetimeSales',
          ),
          const SizedBox(width: 8),
          _buildSortButton(
            controller: controller,
            label: 'Deals',
            value: 'totalDeals',
          ),
          const SizedBox(width: 8),
          _buildSortButton(
            controller: controller,
            label: 'Date',
            value: 'acquisitionDate',
          ),
        ],
      ),
    );
  }

  // Sort button
  Widget _buildSortButton({
    required AllCustomersController controller,
    required String label,
    required String value,
  }) {
    return Obx(() {
      final isSelected = controller.sortBy.value == value;
      return GestureDetector(
        onTap: () => controller.updateSort(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.blue.shade800 : Colors.black87,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 4),
                Icon(
                  controller.sortAscending.value
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 14,
                  color: Colors.blue.shade800,
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  // Customers list
  Widget _buildCustomersList(AllCustomersController controller) {
    if (controller.customers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No customers found',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search or filters',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.customers.length,
      itemBuilder: (context, index) {
        final customer = controller.customers[index];
        return GestureDetector(
          onTap: () => Get.to(() => CustomerDetailPage(customer: customer)),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        radius: 24,
                        child: Text(
                          customer.name.substring(0, 1),
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              customer.industry,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              _getStatusColor(customer.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          customer.status,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _getStatusColor(customer.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn(
                        label: 'Lifetime Sales',
                        value: controller.currencyFormat
                            .format(customer.lifetimeSales),
                        isHighlighted: true,
                      ),
                      _buildInfoColumn(
                        label: 'Total Deals',
                        value: customer.totalDeals.toString(),
                      ),
                      _buildInfoColumn(
                        label: 'Avg. Deal Value',
                        value: controller.currencyFormat.format(
                          customer.totalDeals > 0
                              ? customer.lifetimeSales / customer.totalDeals
                              : 0,
                        ),
                      ),
                      _buildInfoColumn(
                        label: 'Customer Since',
                        value: DateFormat('MMM yyyy')
                            .format(customer.acquisitionDate),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Information column for customer card
  Widget _buildInfoColumn({
    required String label,
    required String value,
    bool isHighlighted = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isHighlighted ? Colors.blue.shade700 : Colors.black87,
          ),
        ),
      ],
    );
  }

  // Get color based on customer status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green.shade700;
      case 'Inactive':
        return Colors.red.shade700;
      case 'Pending':
        return Colors.orange.shade700;
      case 'Lead':
        return Colors.purple.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  // Filter modal
  void _showFilterModal(
      BuildContext context, AllCustomersController controller) {
    CustomFilterModal.show(
      context,
      filterWidgets: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Industry',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.industries.map((industry) {
                    final isSelected =
                        controller.selectedIndustry.value == industry;
                    return GestureDetector(
                      onTap: () => controller.updateIndustry(industry),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.shade600
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue.shade600
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          industry,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Status',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.statuses.map((status) {
                    final isSelected =
                        controller.selectedStatus.value == status;
                    return GestureDetector(
                      onTap: () => controller.updateStatus(status),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.shade600
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue.shade600
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.loadCustomers();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Customer Detail Page
class CustomerDetailPage extends StatelessWidget {
  final Customer customer;

  const CustomerDetailPage({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Customer Details',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {
              // Show options menu
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildOptionsBottomSheet(context),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomerHeader(currencyFormat),
              const SizedBox(height: 24),
              _buildCustomerInfo(),
              const SizedBox(height: 24),
              _buildSalesSummary(currencyFormat),
              const SizedBox(height: 24),
              _buildSalesChart(currencyFormat),
              const SizedBox(height: 24),
              _buildRecentTransactions(currencyFormat),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, -2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Add new deal functionality
                  Get.snackbar(
                    'Action',
                    'Create new deal for ${customer.name}',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: Text(
                  'Create New Deal',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.blue.shade700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Contact customer functionality
                  Get.bottomSheet(
                    _buildContactOptionsSheet(context),
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Contact Customer',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Customer header with avatar and status
  Widget _buildCustomerHeader(NumberFormat currencyFormat) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          radius: 32,
          child: Text(
            customer.name.substring(0, 1),
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.blue.shade800,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer.name,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                customer.industry,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(customer.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  customer.status,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(customer.status),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lifetime Value: ${currencyFormat.format(customer.lifetimeSales)}',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Customer info section
  Widget _buildCustomerInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Information',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.email_outlined,
                  'Email',
                  customer.email,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  Icons.phone_outlined,
                  'Phone',
                  customer.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.source_outlined,
                  'Lead Source',
                  customer.leadSource,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  Icons.person_outline,
                  'Assigned To',
                  customer.assignedTo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            Icons.calendar_today_outlined,
            'Customer Since',
            DateFormat('dd MMM, yyyy').format(customer.acquisitionDate),
          ),
        ],
      ),
    );
  }

  // Information item with icon
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.blue.shade700,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Sales summary cards
  Widget _buildSalesSummary(NumberFormat currencyFormat) {
    // Calculate average deal value
    final avgDealValue = customer.totalDeals > 0
        ? customer.lifetimeSales / customer.totalDeals
        : 0;

    // Calculate days as customer
    final daysSinceAcquisition =
        DateTime.now().difference(customer.acquisitionDate).inDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sales Summary',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Deals',
                customer.totalDeals.toString(),
                Icons.handshake_outlined,
                Colors.purple.shade700,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Avg. Deal Value',
                currencyFormat.format(avgDealValue),
                Icons.monetization_on_outlined,
                Colors.green.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Customer for',
                '$daysSinceAcquisition days',
                Icons.access_time,
                Colors.orange.shade700,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Last Purchase',
                customer.transactions.isNotEmpty
                    ? DateFormat('dd MMM, yyyy')
                        .format(customer.transactions.first['date'])
                    : 'No purchases',
                Icons.calendar_today_outlined,
                Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Summary card
  Widget _buildSummaryCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Sales chart
  Widget _buildSalesChart(NumberFormat currencyFormat) {
    // Extract transaction data for chart
    final transactionData = <Map<String, dynamic>>[];

    // Group transactions by month
    final transactionsByMonth = <String, double>{};

    for (var transaction in customer.transactions) {
      final date = transaction['date'] as DateTime;
      final month = DateFormat('MMM yyyy').format(date);
      final amount = transaction['amount'] as double;

      if (transactionsByMonth.containsKey(month)) {
        transactionsByMonth[month] = transactionsByMonth[month]! + amount;
      } else {
        transactionsByMonth[month] = amount;
      }
    }

    // Convert to list for chart
    transactionsByMonth.forEach((month, amount) {
      transactionData.add({
        'month': month,
        'amount': amount,
      });
    });

    // Sort by date
    transactionData.sort((a, b) {
      final aDate = DateFormat('MMM yyyy').parse(a['month'] as String);
      final bDate = DateFormat('MMM yyyy').parse(b['month'] as String);
      return aDate.compareTo(bDate);
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales History',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (transactionData.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.bar_chart_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No transaction data available',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: transactionData
                          .map((e) => e['amount'] as double)
                          .reduce((a, b) => a > b ? a : b) *
                      1.2,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final amount =
                            transactionData[groupIndex]['amount'] as double;
                        return BarTooltipItem(
                          '${transactionData[groupIndex]['month']}\n${currencyFormat.format(amount)}',
                          GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, barTouchResponse) {},
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < transactionData.length) {
                            final month = transactionData[value.toInt()]
                                    ['month']
                                .toString()
                                .split(' ')[0];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                month,
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              currencyFormat.format(value).split('.')[0],
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          );
                        },
                        reservedSize: 56,
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    transactionData.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: transactionData[index]['amount'] as double,
                          color: Colors.blue.shade600,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Lifetime Sales List
  Widget _buildRecentTransactions(NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lifetime Sales',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Total: ${currencyFormat.format(customer.lifetimeSales)}',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (customer.transactions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No transactions available',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customer.transactions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final transaction = customer.transactions[index];
                final date = transaction['date'] as DateTime;
                final amount = transaction['amount'] as double;
                final product = transaction['product'] as String;
                final status = transaction['status'] as String;

                return GestureDetector(
                  onTap: () {
                    // Show transaction details
                    Get.to(() => TransactionDetailPage(
                          transaction: transaction,
                          customer: customer,
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.receipt_outlined,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('dd MMM, yyyy').format(date),
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              currencyFormat.format(amount),
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getTransactionStatusColor(status)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status,
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: _getTransactionStatusColor(status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          if (customer.transactions.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.blue.shade700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // View all transactions
                  Get.to(() => AllTransactionsPage(customer: customer));
                },
                child: Text(
                  'View All Transactions',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Options bottom sheet
  Widget _buildOptionsBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOptionItem(
            context,
            'Edit Customer',
            Icons.edit_outlined,
            Colors.blue.shade700,
            () {
              Navigator.pop(context);
              Get.snackbar(
                'Action',
                'Edit ${customer.name}',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const SizedBox(height: 16),
          _buildOptionItem(
            context,
            'Share Customer Info',
            Icons.share_outlined,
            Colors.green.shade700,
            () {
              Navigator.pop(context);
              Get.snackbar(
                'Action',
                'Share ${customer.name} details',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const SizedBox(height: 16),
          _buildOptionItem(
            context,
            'Delete Customer',
            Icons.delete_outline,
            Colors.red.shade700,
            () {
              Navigator.pop(context);
              _showDeleteConfirmation(context);
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Option item
  Widget _buildOptionItem(BuildContext context, String label, IconData icon,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Contact options sheet
  Widget _buildContactOptionsSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Contact Options',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          _buildContactOption(
            context,
            'Call',
            Icons.call_outlined,
            Colors.green.shade700,
            () {
              Navigator.pop(context);
              Get.snackbar(
                'Action',
                'Calling ${customer.phone}',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            context,
            'Email',
            Icons.email_outlined,
            Colors.blue.shade700,
            () {
              Navigator.pop(context);
              Get.snackbar(
                'Action',
                'Emailing ${customer.email}',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            context,
            'Message',
            Icons.message_outlined,
            Colors.orange.shade700,
            () {
              Navigator.pop(context);
              Get.snackbar(
                'Action',
                'Messaging ${customer.phone}',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Contact option item
  Widget _buildContactOption(BuildContext context, String label, IconData icon,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Customer',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${customer.name}? This action cannot be undone.',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.back();
              Get.snackbar(
                'Success',
                '${customer.name} deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.shade100,
                colorText: Colors.red.shade900,
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Get color based on customer status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green.shade700;
      case 'Inactive':
        return Colors.red.shade700;
      case 'Pending':
        return Colors.orange.shade700;
      case 'Lead':
        return Colors.purple.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  // Get color based on transaction status
  Color _getTransactionStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green.shade700;
      case 'Pending':
        return Colors.orange.shade700;
      case 'Processing':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}

// All Transactions Page
