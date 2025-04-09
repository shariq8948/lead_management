import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:leads/Masters/Target/monthlyTarget/add_product_controller.dart';
import 'package:leads/widgets/floatingbutton.dart';
import 'add_product_target_page.dart';
import 'controller.dart';

class ProductTargetList extends StatefulWidget {
  const ProductTargetList({super.key});

  @override
  State<ProductTargetList> createState() => _ProductTargetListState();
}

class _ProductTargetListState extends State<ProductTargetList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showAnalytics = false;
  final ScrollController _scrollController = ScrollController();
  final controller = Get.put(ProductTargetController());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Targets",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _showAnalytics ? Icons.analytics : Icons.analytics_outlined,
              color: Colors.black87,
            ),
            onPressed: () => setState(() => _showAnalytics = !_showAnalytics),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Colors.black87),
            onPressed: () => _showExportOptions(),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => Get.to(AddProductTargetPage()),
        icon: Icons.add,
        backgroundColor: Colors.teal[600]!,
      ),
      body: Column(
        children: [
          if (_showAnalytics) ...[
            _buildAnalyticsHeader(),
            const SizedBox(height: 16),
          ],
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => _buildEnhancedTargetCard(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          _buildMetricsRow(),
          const SizedBox(height: 24),
          TabBar(
            controller: _tabController,
            labelColor: Colors.teal[700],
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: Colors.teal[700],
            tabs: const [
              Tab(text: "Monthly Progress"),
              Tab(text: "Product Distribution"),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300, // Fixed height for the tab content
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMonthlyProgressTab(),
                _buildProductDistributionTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        _buildMetricCard(
          "Total Targets",
          "28",
          Icons.track_changes,
          Colors.blue,
        ),
        const SizedBox(width: 12),
        _buildMetricCard(
          "Completed",
          "12",
          Icons.check_circle,
          Colors.green,
        ),
        const SizedBox(width: 12),
        _buildMetricCard(
          "In Progress",
          "16",
          Icons.pending,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, MaterialColor color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color[700], size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTargetCard(int index) {
    return Hero(
      tag: 'target_card_$index',
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showTargetDetails(index),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCardHeader(index),
                  const SizedBox(height: 16),
                  _buildCardDetails(),
                  const SizedBox(height: 16),
                  _buildProgressIndicator(0.7),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(int index) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'AP',
              style: TextStyle(
                color: Colors.teal[700],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Akanksha Purbi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'UI Designer',
                  style: TextStyle(
                    color: Colors.teal[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            if (value == 'edit') {
              // Handle edit
            } else if (value == 'delete') {
              _showDeleteConfirmation();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: const [
                  Icon(Icons.edit_outlined, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.red[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Delete',
                    style: TextStyle(color: Colors.red[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardDetails() {
    return Column(
      children: [
        _buildDetailRow(
          "Product",
          "Samsung Galaxy S4",
          Icons.smartphone,
        ),
        _buildDetailRow(
          "Target Quantity",
          "5",
          Icons.inventory_2,
        ),
        _buildDetailRow(
          "Period",
          "January 2024",
          Icons.calendar_today,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.teal[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.teal[600]!,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final double height =
        MediaQuery.of(context).size.height * 0.5; // Responsive height

    Get.bottomSheet(
      Container(
        height: height, // Make it adaptive to different screen sizes
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Targets',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Status Filter
            _buildFilterSection(
              title: 'Status',
              options: ['All', 'In Progress', 'Completed', 'Pending'],
              selectedValue: controller.selectedStatus,
            ),
            const SizedBox(height: 10),

            // Time Period Filter
            _buildFilterSection(
              title: 'Time Period',
              options: ['All Time', 'This Month', 'Last Month', 'Custom Range'],
              selectedValue: controller.selectedTimePeriod,
            ),
            const SizedBox(height: 10),

            // Product Category Filter
            _buildFilterSection(
              title: 'Product Category',
              options: [
                'All Categories',
                'Smartphones',
                'Laptops',
                'Accessories'
              ],
              selectedValue: controller.selectedCategory,
            ),
            const Spacer(),

            // Buttons (Reset & Apply)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.resetFilters();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Apply Action
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[600],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Apply',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true, // Allows full-screen behavior on small devices
    );
  }

// Reusable Dropdown Section
  Widget _buildFilterSection({
    required String title,
    required List<String> options,
    required RxString selectedValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Obx(
          () => DropdownButtonFormField<String>(
            value: selectedValue.value,
            onChanged: (value) => selectedValue.value = value!,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: options
                .map((option) =>
                    DropdownMenuItem(value: option, child: Text(option)))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyProgressTab() {
    final List<BarChartGroupData> barGroups = [
      _makeGroupData(0, 35, 28, 20),
      _makeGroupData(1, 40, 32, 25),
      _makeGroupData(2, 38, 30, 22),
      _makeGroupData(3, 42, 35, 28),
      _makeGroupData(4, 45, 38, 30),
      _makeGroupData(5, 43, 36, 29),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 50,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String category;
                switch (rodIndex) {
                  case 0:
                    category = 'Smartphones';
                    break;
                  case 1:
                    category = 'Laptops';
                    break;
                  default:
                    category = 'Accessories';
                }
                return BarTooltipItem(
                  '$category\n${rod.toY.round()}',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(fontSize: 12);
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = 'Jan';
                      break;
                    case 1:
                      text = 'Feb';
                      break;
                    case 2:
                      text = 'Mar';
                      break;
                    case 3:
                      text = 'Apr';
                      break;
                    case 4:
                      text = 'May';
                      break;
                    case 5:
                      text = 'Jun';
                      break;
                    default:
                      text = '';
                  }
                  return Text(text, style: style);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
        ),
      ),
    );
  }

  Widget _buildProductDistributionTab() {
    final List<PieChartSectionData> sections = [
      PieChartSectionData(
        value: 45,
        title: 'Smartphones\n45%',
        color: Colors.blue,
        radius: 100,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      PieChartSectionData(
        value: 30,
        title: 'Laptops\n30%',
        color: Colors.teal,
        radius: 100,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      PieChartSectionData(
        value: 25,
        title: 'Accessories\n25%',
        color: Colors.amber,
        radius: 100,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 0,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              // Handle touch events if needed
            },
          ),
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.blue,
          width: 8,
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.teal,
          width: 8,
        ),
        BarChartRodData(
          toY: y3,
          color: Colors.amber,
          width: 8,
        ),
      ],
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Export Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildExportOption(
              'PDF Report',
              Icons.picture_as_pdf,
              Colors.red,
              () => Navigator.pop(context),
            ),
            _buildExportOption(
              'Excel Spreadsheet',
              Icons.table_chart,
              Colors.green,
              () => Navigator.pop(context),
            ),
            _buildExportOption(
              'CSV File',
              Icons.insert_drive_file,
              Colors.blue,
              () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption(
    String title,
    IconData icon,
    MaterialColor color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color[700]),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete Target'),
        content: const Text(
          'Are you sure you want to delete this target? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle delete
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red[600]),
            ),
          ),
        ],
      ),
    );
  }

  void _showTargetDetails(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailHeader(),
              const SizedBox(height: 24),
              _buildDetailSection(),
              const SizedBox(height: 24),
              _buildHistorySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'AP',
                  style: TextStyle(
                    color: Colors.teal[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Akanksha Purbi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'UI Designer',
                      style: TextStyle(
                        color: Colors.teal[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildDetailItem(
            'Product',
            'Samsung Galaxy S4',
            Icons.smartphone,
          ),
          const Divider(height: 24),
          _buildDetailItem(
            'Target Quantity',
            '5 units',
            Icons.inventory_2,
          ),
          const Divider(height: 24),
          _buildDetailItem(
            'Period',
            'January 2024',
            Icons.calendar_today,
          ),
          const Divider(height: 24),
          _buildDetailItem(
            'Current Progress',
            '70%',
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.teal[600]),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildHistoryItem(
          'Target Updated',
          'Quantity changed from 3 to 5 units',
          '2 days ago',
        ),
        _buildHistoryItem(
          'Progress Updated',
          'Achieved 70% of the target',
          '1 week ago',
        ),
        _buildHistoryItem(
          'Target Created',
          'New target assigned',
          '2 weeks ago',
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String description, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.history,
              color: Colors.teal[600],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
