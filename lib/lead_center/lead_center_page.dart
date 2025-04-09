import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leads/data/models/lead_list.dart';
import 'package:leads/utils/routes.dart';
import 'package:leads/widgets/custom_app_bar.dart';
import '../leads/details/lead_details_page.dart';
import '../widgets/app_bar.dart';
import 'lead_center_controller.dart';

class LeadCenterPage extends StatelessWidget {
  final LeadCenterController controller = Get.put(LeadCenterController());

  LeadCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Lead Center"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildDateRangePicker(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                  ),
                );
              }

              if (controller.filteredLeads.isEmpty) {
                return _buildEmptyState();
              }

              return _buildLeadList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search leads...',
          prefixIcon: Icon(Icons.search, color: Colors.blue[700]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: controller.filterLeads,
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _pickDate('From Date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Obx(() => Text(
                    controller.fromDate.value != null
                        ? 'From: ${DateFormat('yyyy-MM-dd').format(controller.fromDate.value!)}'
                        : 'From Date',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _pickDate('To Date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Obx(() => Text(
                    controller.toDate.value != null
                        ? 'To: ${DateFormat('yyyy-MM-dd').format(controller.toDate.value!)}'
                        : 'To Date',
                    style: TextStyle(color: Colors.white),
                  )),
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
          Icon(Icons.inbox, size: 100, color: Colors.blue[200]),
          Text(
            "No Leads Found",
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadList() {
    return ListView.builder(
      itemCount: controller.filteredLeads.length,
      itemBuilder: (context, index) {
        final lead = controller.filteredLeads[index];
        return _buildLeadCard(lead);
      },
    );
  }

  Widget _buildLeadCard(LeadList lead) {
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'new':
          return Colors.blue[100]!;
        case 'contacted':
          return Colors.green[100]!;
        case 'opportunity':
          return Colors.orange[100]!;
        case 'negotiation':
          return Colors.purple[100]!;
        case 'qualified':
          return Colors.teal[100]!;
        case 'disqualified':
          return Colors.red[100]!;
        default:
          return Colors.grey[200]!;
      }
    }

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: getStatusColor(lead.leadStatus),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: () => Get.toNamed(Routes.leadDetail, arguments: lead.leadId),
          title: Text(
            lead.leadName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lead.email,
                style: TextStyle(color: Colors.blue[800]),
              ),
              Text(
                lead.phone,
                style: TextStyle(color: Colors.blue[800]),
              ),
            ],
          ),
          trailing: _buildStatusDropdown(lead),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(LeadList lead) {
    return DropdownButton<String>(
      value: lead.leadStatus,
      dropdownColor: Colors.white,
      items: controller.calltype
          .map((status) => DropdownMenuItem(
                value: status.status,
                child: Text(
                  status.status,
                  style: TextStyle(color: Colors.blue[900]),
                ),
              ))
          .toList(),
      onChanged: (newStatus) {
        if (newStatus != null) {
          print(
              "Status Updated for Lead ${lead.leadId} with new status ${newStatus}");
          // Implement status update logic
          // controller.updateLeadStatus(lead, newStatus);
        }
      },
    );
  }

  void _showFilterDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Filter Leads', style: TextStyle(color: Colors.blue[800])),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: controller.calltype
              .map((status) => ListTile(
                    title: Text(status.status),
                    onTap: () {
                      controller.filterByStatus(status.status);
                      Get.back();
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _pickDate(String label) async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      if (label == 'From Date') {
        controller.fromDate.value = pickedDate;
      } else {
        controller.toDate.value = pickedDate;
      }
      controller.filterByDateRange(
        controller.fromDate.value ?? DateTime(2024, 12, 24),
        controller.toDate.value ?? DateTime(2025, 1, 24),
      );
    }
  }
}
