// leads_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dp;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leads/profile_pages/details/allleads/controller.dart';

class LeadsPage extends StatelessWidget {
  final LeadsController controller = Get.put(LeadsController());
  final currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeaderStats(),
          _buildSearchBar(),
          _buildFilters(),
          Expanded(
            child: _buildLeadsList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      // backgroundColor: Colors.white,
      title: Text(
        'Leads',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list, color: Colors.black87),
          onPressed: () => _showAdvancedFilters(),
        ),
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.black87),
          onPressed: controller.fetchLeads,
        ),
      ],
    );
  }

  Widget _buildHeaderStats() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Obx(() => Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Leads',
                  controller.totalLeads.toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  'Total Value',
                  currencyFormat.format(controller.totalValue.value),
                  Icons.attach_money,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  'Active Leads',
                  controller.leads
                      .where((l) => l.status == 'active')
                      .length
                      .toString(),
                  Icons.trending_up,
                  Colors.orange,
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => controller.searchQuery.value = value,
        decoration: InputDecoration(
          hintText: 'Search leads...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        _buildDateFilters(),
        SizedBox(height: 16),
        Container(
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip('Recent', 'recent', controller.sortBy),
              _buildFilterChip('Highest Value', 'value', controller.sortBy),
              _buildFilterChip('Most Tasks', 'tasks', controller.sortBy),
              SizedBox(width: 8),
              Container(
                height: 24,
                width: 1,
                color: Colors.grey[300],
                margin: EdgeInsets.symmetric(horizontal: 8),
              ),
              _buildFilterChip('All Status', 'all', controller.selectedStatus),
              _buildFilterChip('Active', 'active', controller.selectedStatus),
              _buildFilterChip('Cold', 'cold', controller.selectedStatus),
              _buildFilterChip('Won', 'won', controller.selectedStatus),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilters() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Obx(() => _buildDateField(
                      'From Date',
                      controller.fromDate.value,
                      (date) => controller.updateDateRange(
                          date, controller.toDate.value),
                    )),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Obx(() => _buildDateField(
                      'To Date',
                      controller.toDate.value,
                      (date) => controller.updateDateRange(
                          controller.fromDate.value, date),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
      String label, DateTime? value, Function(DateTime?) onChanged) {
    return GestureDetector(
      onTap: () {
        dp.DatePicker.showDatePicker(
          Get.context!,
          showTitleActions: true,
          minTime: DateTime(2020),
          maxTime: DateTime(2025),
          onConfirm: (date) => onChanged(date),
          currentTime: value ?? DateTime.now(),
          theme: dp.DatePickerTheme(
            headerColor: Theme.of(Get.context!).primaryColor,
            backgroundColor: Colors.white,
            itemStyle: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            doneStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today,
                size: 20, color: Theme.of(Get.context!).primaryColor),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                value != null
                    ? DateFormat('MMM dd, yyyy').format(value)
                    : label,
                style: TextStyle(
                  color: value != null ? Colors.black87 : Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, RxString controller) {
    return Obx(() {
      final isSelected = controller.value == value;
      return Padding(
        padding: EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => controller.value = value,
          backgroundColor: Colors.white,
          selectedColor: Theme.of(Get.context!).primaryColor.withOpacity(0.2),
          labelStyle: TextStyle(
            color: isSelected
                ? Theme.of(Get.context!).primaryColor
                : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected
                  ? Theme.of(Get.context!).primaryColor
                  : Colors.grey[300]!,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLeadsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final leads = controller.filteredLeads;
      if (leads.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'No leads found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: leads.length,
        itemBuilder: (context, index) {
          final lead = leads[index];
          return _buildLeadCard(lead);
        },
      );
    });
  }

  Widget _buildLeadCard(Lead lead) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Handle lead tap
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[200],
                        child: Text(
                          lead.name[0],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lead.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              lead.company,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currencyFormat.format(lead.value),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            '${lead.tasksCount} tasks',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(Icons.email, lead.email),
                      SizedBox(width: 8),
                      _buildInfoChip(Icons.phone, lead.phone),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatusChip(lead.status),
                      SizedBox(width: 8),
                      _buildPriorityChip(lead.priority),
                      SizedBox(width: 8),
                      _buildSourceChip(lead.source),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Created ${DateFormat.yMMMd().format(lead.createdAt)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      if (lead.lastContact != null)
                        Text(
                          'Last contact ${DateFormat.yMMMd().format(lead.lastContact!)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
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

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'cold':
        color = Colors.blue;
        break;
      case 'won':
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.capitalizeFirst!,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority.capitalizeFirst!,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSourceChip(String source) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        source.capitalizeFirst!,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showAdvancedFilters() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Advanced Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Industry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAdvancedFilterChip(
                    'All', 'all', controller.selectedIndustry),
                _buildAdvancedFilterChip(
                    'Technology', 'technology', controller.selectedIndustry),
                _buildAdvancedFilterChip(
                    'Healthcare', 'healthcare', controller.selectedIndustry),
                _buildAdvancedFilterChip(
                    'Finance', 'finance', controller.selectedIndustry),
                _buildAdvancedFilterChip(
                    'Retail', 'retail', controller.selectedIndustry),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Source',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAdvancedFilterChip(
                    'All', 'all', controller.selectedSource),
                _buildAdvancedFilterChip(
                    'Referral', 'referral', controller.selectedSource),
                _buildAdvancedFilterChip(
                    'Website', 'website', controller.selectedSource),
                _buildAdvancedFilterChip(
                    'Social', 'social', controller.selectedSource),
                _buildAdvancedFilterChip(
                    'Event', 'event', controller.selectedSource),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
                controller.fetchLeads();
              },
              child: Text('Apply Filters'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFilterChip(
      String label, String value, RxString controller) {
    return Obx(() {
      final isSelected = controller.value == value;
      return FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => controller.value = value,
        backgroundColor: Colors.white,
        selectedColor: Theme.of(Get.context!).primaryColor.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(Get.context!).primaryColor
              : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected
                ? Theme.of(Get.context!).primaryColor
                : Colors.grey[300]!,
          ),
        ),
      );
    });
  }
}
