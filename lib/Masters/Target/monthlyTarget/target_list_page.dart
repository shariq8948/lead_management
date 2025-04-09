import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/widgets/custom_loader.dart';
import 'package:leads/widgets/floatingbutton.dart';
import 'package:intl/intl.dart';
import '../../../data/models/monthly_target.dart';
import '../../../widgets/custom_select.dart';
import 'add_product_controller.dart';
import 'add_target_page.dart';

class TargetListPage extends StatelessWidget {
  TargetListPage({super.key});
  final TargetController controller = Get.put(TargetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          controller.isEdit.value = false;
          Get.to(AddTargetPage());
        },
        icon: Icons.add,
      ),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildActionBar(context),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomLoader());
                }
                return _buildTargetList();
              }),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        "Sales Targets",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.analytics_outlined, color: Colors.teal[600]),
          onPressed: () {
            // Add analytics view
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildFilterButton(context)),
          const SizedBox(width: 12),
          Expanded(child: _buildExportButton()),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showFilterBottomSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.filter_list, size: 20, color: Colors.teal[600]),
              const SizedBox(width: 8),
              Text(
                'Filter',
                style: TextStyle(
                  color: Colors.teal[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showExportBottomSheet(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.download, size: 20, color: Colors.teal[600]),
              const SizedBox(width: 8),
              Text(
                'Export',
                style: TextStyle(
                  color: Colors.teal[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetList() {
    return ListView.builder(
      itemCount: controller.monthlyTargetList.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final target = controller.monthlyTargetList[index];
        return _buildTargetCard(target, context);
      },
    );
  }

  Widget _buildTargetCard(MonthlyTarget target, BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      locale: 'en_IN',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCardHeader(target, context),
          _buildCardBody(target, currencyFormat),
        ],
      ),
    );
  }

  Widget _buildCardHeader(MonthlyTarget target, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          _buildAvatar(target, context),
          const SizedBox(width: 12),
          Expanded(child: _buildHeaderInfo(target)),
          _buildOptionsMenu(target, context),
        ],
      ),
    );
  }

  Widget _buildAvatar(MonthlyTarget target, BuildContext context) {
    return Hero(
      tag: 'avatar_${target.id}',
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.teal.withOpacity(0.1),
        child: Text(
          target.mrName[0].toUpperCase(),
          style: TextStyle(
            color: Colors.teal[700],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(MonthlyTarget target) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          target.mrName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${target.month} ${target.year}',
            style: TextStyle(
              color: Colors.teal[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsMenu(MonthlyTarget target, BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'edit') {
          _handleEdit(target);
        } else if (value == 'delete') {
          _showDeleteConfirmation(context, target);
        }
      },
      itemBuilder: (BuildContext context) => [
        _buildPopupMenuItem(
            'edit', 'Edit', Icons.edit_outlined, Colors.blue[700]!),
        _buildPopupMenuItem(
            'delete', 'Delete', Icons.delete_outline, Colors.red[700]!),
      ],
    );
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
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _buildCardBody(MonthlyTarget target, NumberFormat currencyFormat) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMetricRow(
            icon: Icons.phone_outlined,
            label: 'Calls Target',
            value: target.calls,
            color: Colors.blue[700]!,
          ),
          _buildMetricRow(
            icon: Icons.shopping_cart_outlined,
            label: 'Orders Target',
            value: currencyFormat.format(int.parse(target.orders)),
            color: Colors.green[700]!,
          ),
          _buildMetricRow(
            icon: Icons.person_add_outlined,
            label: 'New Leads Target',
            value: target.newDoctor,
            color: Colors.purple[700]!,
          ),
          if (target.mrId.isNotEmpty) ...[
            const Divider(height: 32, thickness: 1),
            _buildExpensesSection(target, currencyFormat),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesSection(
      MonthlyTarget target, NumberFormat currencyFormat) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        colorScheme: ColorScheme.light(primary: Colors.teal[600]!),
      ),
      child: ExpansionTile(
        title: const Text(
          'Expenses',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          _buildExpenseRow(
              'Local', currencyFormat.format(int.parse(target.localHQ))),
          _buildExpenseRow('Night Halt',
              currencyFormat.format(int.parse(target.nightHault))),
          _buildExpenseRow(
              'Extra', currencyFormat.format(int.parse(target.exHQ))),
        ],
      ),
    );
  }

  Widget _buildExpenseRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      FilterBottomSheet(context),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
    );
  }

  void _showExportBottomSheet() {
    Get.bottomSheet(
      ExportBottomSheet(),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
    );
  }

  void _handleEdit(MonthlyTarget target) {
    if (target.userType == "4") {
      controller.showMrController.text = target.mrName;
      controller.MrController.text = target.mrId;
      controller.selectedRole.value = "MR";
    } else {
      controller.showCordinatorController.text = target.mrName;
      controller.cordinatorController.text = target.mrId;
      controller.selectedRole.value = "Cordinator";
    }

    controller.callsController.text = target.calls;
    controller.collectionController.text = target.orders;
    controller.showMonthController.text = target.month;
    controller.leadsController.text = target.newDoctor;
    controller.localExController.text = target.localHQ;
    controller.nightHaultExController.text = target.nightHault;
    controller.extraHqExController.text = target.exHQ;
    controller.setSalaryExController.text = target.salary ?? "";
    controller.yearController.text = target.year;
    controller.isEdit.value = true;
    controller.id.value = target.id;
    Get.to(AddTargetPage());
  }

  void _showDeleteConfirmation(BuildContext context, MonthlyTarget target) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Delete Target',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the target for ${target.mrName}?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteMonthlyTarget(target.id);
              Get.back();
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget FilterBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildFilterSection(
            title: 'Time Period',
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildMonthDropdown(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildYearDropdown(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildFilterSection(
            title: 'Role',
            children: [
              _buildChipGroup(),
            ],
          ),
          const SizedBox(height: 32),
          _buildActionButtons(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Filter Targets',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
          color: Colors.grey[600],
        ),
      ],
    );
  }

  Widget _buildMonthDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        final selectedMonth = controller.monthController.text;

        return DropdownButtonFormField<String>(
          value: selectedMonth.isNotEmpty ? selectedMonth : null,
          hint: Text('Select Month', style: TextStyle(color: Colors.grey[600])),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          items: controller.monthsList.map((MonthsModel month) {
            return DropdownMenuItem<String>(
              value: month.value,
              child: Text(
                month.month,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            if (value != null) {
              controller.monthController.text = value;
              controller.showMonthController.text = controller.monthsList
                  .firstWhere((m) => m.value == value)
                  .month;
            }
          },
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
        );
      }),
    );
  }

  Widget _buildYearDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        final selectedYear = controller.yearController.text;

        return DropdownButtonFormField<String>(
          value: selectedYear.isNotEmpty ? selectedYear : null,
          hint: Text('Select Year', style: TextStyle(color: Colors.grey[600])),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          items: controller.years.map((CustomSelectItem year) {
            return DropdownMenuItem<String>(
              value: year.id,
              child: Text(
                year.value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            if (value != null) {
              controller.yearController.text = value;
            }
          },
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
        );
      }),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildChipGroup() {
    return Obx(() => Wrap(
          spacing: 8,
          children: [
            _buildFilterChip(
              'MR',
              selected: controller.selectedRole.value == 'MR',
              onSelected: (selected) {
                if (selected) controller.selectedRole.value = 'MR';
              },
            ),
            _buildFilterChip(
              'Coordinator',
              selected: controller.selectedRole.value == 'Cordinator',
              onSelected: (selected) {
                if (selected) controller.selectedRole.value = 'Cordinator';
              },
            ),
            _buildFilterChip(
              'Manager',
              selected: controller.selectedRole.value == 'Manager',
              onSelected: (selected) {
                if (selected) controller.selectedRole.value = 'Manager';
              },
            ),
          ],
        ));
  }

  Widget _buildFilterChip(
    String label, {
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[100],
      selectedColor: Colors.teal[100],
      checkmarkColor: Colors.teal[600],
      labelStyle: TextStyle(
        color: selected ? Colors.teal[700] : Colors.grey[800],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              controller.clearFormMonthly();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Text(
              'Reset',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Apply filters and fetch data
              controller.fetchMonthlyTarget();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.teal[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Apply',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ExportBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
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
              const Text(
                'Export Options',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
                color: Colors.grey[600],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildExportOption(
            icon: Icons.picture_as_pdf,
            title: 'Export as PDF',
            subtitle: 'Download a PDF report of all targets',
            onTap: () {
              // Handle PDF export
              Get.back();
            },
          ),
          const Divider(height: 32),
          _buildExportOption(
            icon: Icons.table_chart,
            title: 'Export as Excel',
            subtitle: 'Download data in Excel format',
            onTap: () {
              // Handle Excel export
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.teal[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
