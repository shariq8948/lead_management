import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/utils/routes.dart';
import 'package:leads/widgets/custom_date_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:leads/widgets/floatingbutton.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../data/models/lead_list.dart';
import '../../widgets/custom_field.dart';
import '../../widgets/custom_select.dart';
import 'lead_list_controller.dart';

class LeadListPage extends StatelessWidget {
  final leadListController = Get.find<LeadListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal.shade400, Colors.teal.shade700],
            ),
          ),
        ),
        title: AnimatedSearchBar(
          label: "Search Leads",
          onChanged: (value) {
            leadListController.updateSearchQuery(value);
          },
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          searchStyle: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          textInputAction: TextInputAction.search,
          searchDecoration: InputDecoration(
            hintText: "Search by name, phone number",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE1FFED), Color(0xFFF5F5F5)],
          ),
        ),
        child: Column(
          children: [
            _buildActionButtons(),
            SizedBox(height: 10),
            _buildActiveFilters(),
            _buildLeadsList(),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: leadListController.scrollController,
        builder: (context, child) {
          return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              transform: Matrix4.translationValues(
                0,
                leadListController.isScrollingDown.value ? 100 : 0,
                0,
              ),
              child: CustomFloatingActionButton(
                onPressed: () {
                  Get.to(
                    Get.toNamed('/create-lead', arguments: {'isEdit': false}),
                    transition: Transition.zoom,
                  )!
                      .then((_) {
                    leadListController.fetchLeads();
                  });
                },
                icon: Icons.add,
              ));
        },
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Obx(() {
      if (!leadListController.filtered.value) return SizedBox.shrink();

      return Container(
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            if (leadListController.showLeadSourceController.text.isNotEmpty)
              (leadListController.sourceFilter.value)
                  ? _buildFilterChip(
                      "Source: ${leadListController.showLeadSourceController.text}",
                      () {
                        leadListController.sourceFilter.value = false;
                        leadListController.leadSourceController.clear();
                        leadListController.showLeadSourceController.clear();
                        leadListController.fetchLeads();
                      },
                    )
                  : SizedBox.shrink(),
            if (leadListController.showStateController.text.isNotEmpty)
              (leadListController.stateFilter.value)
                  ? _buildFilterChip(
                      "State: ${leadListController.showStateController.text}",
                      () {
                        leadListController.stateFilter.value = false;
                        leadListController.stateController.clear();
                        leadListController.showStateController.clear();
                        leadListController.fetchLeads();
                      },
                    )
                  : SizedBox.shrink(),
            if (leadListController.showCityController.text.isNotEmpty)
              (leadListController.cityFilter.value)
                  ? _buildFilterChip(
                      "City: ${leadListController.showCityController.text}",
                      () {
                        leadListController.cityFilter.value = false;
                        leadListController.cityController.clear();
                        leadListController.showCityController.clear();
                        leadListController.fetchLeads();
                      },
                    )
                  : SizedBox.shrink(),
            if (leadListController.fromDateCtlr.text.isNotEmpty)
              (leadListController.fromFilter.value)
                  ? _buildFilterChip(
                      "From: ${leadListController.fromDateCtlr.text}",
                      () {
                        leadListController.fromFilter.value = false;
                        leadListController.fromDateCtlr.clear();
                        leadListController.fetchLeads();
                      },
                    )
                  : SizedBox.shrink(),
            if (leadListController.toDateCtlr.text.isNotEmpty)
              (leadListController.toFilter.value)
                  ? _buildFilterChip(
                      "To: ${leadListController.toDateCtlr.text}",
                      () {
                        leadListController.toFilter.value = false;
                        leadListController.toDateCtlr.clear();
                        leadListController.fetchLeads();
                      },
                    )
                  : SizedBox.shrink()
          ],
        ),
      );
    });
  }

  Widget _buildFilterChip(String label, VoidCallback onDelete) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade600,
        deleteIcon: Icon(Icons.close, size: 18, color: Colors.white),
        onDeleted: onDelete,
      ),
    );
  }

  Future _filterSheet() {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: _buildFilterForm(),
                ),
              ),
            ),
            _buildFilterActions(),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Filter Leads",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterSection(
          title: "Lead Source",
          child: Obx(
            () => _buildAnimatedSelect(
              label: "Select Lead Source",
              placeholder: "Choose a lead source",
              items: leadListController.leadSource
                  .map((e) => CustomSelectItem(
                        id: e.id ?? "",
                        value: e.name ?? "",
                      ))
                  .toList(),
              controller: leadListController.showLeadSourceController,
              onSelect: (val) {
                leadListController.sourceFilter.value = true;
                leadListController.leadSourceController.text = val.id;
                leadListController.showLeadSourceController.text = val.value;
              },
              onClear: () {
                leadListController.sourceFilter.value = false;
                leadListController.leadSourceController.clear();
                leadListController.showLeadSourceController.clear();
              },
            ),
          ),
        ),
        _buildFilterSection(
          title: "Location",
          child: Column(
            children: [
              Obx(
                () => _buildAnimatedSelect(
                  label: "Select State",
                  placeholder: "Choose a state",
                  items: leadListController.stateList
                      .map((e) => CustomSelectItem(
                            id: e.id ?? "",
                            value: e.state ?? "",
                          ))
                      .toList(),
                  controller: leadListController.showStateController,
                  onSelect: (val) async {
                    leadListController.stateFilter.value = true;

                    leadListController.stateController.text = val.id;
                    leadListController.showStateController.text = val.value;
                    await leadListController.fetchLeadCity();
                  },
                  onClear: () {
                    leadListController.stateFilter.value = false;

                    leadListController.stateController.clear();
                    leadListController.showStateController.clear();
                  },
                ),
              ),
              SizedBox(height: 16),
              Obx(
                () => leadListController.stateText.value.isNotEmpty
                    ? _buildAnimatedSelect(
                        label: "Select City",
                        placeholder: "Choose a city",
                        items: leadListController.cityList
                            .map((e) => CustomSelectItem(
                                  id: e.cityID ?? "",
                                  value: e.city ?? "",
                                ))
                            .toList(),
                        controller: leadListController.showCityController,
                        onSelect: (val) async {
                          leadListController.cityFilter.value = true;

                          leadListController.cityController.text = val.id;
                          leadListController.showCityController.text =
                              val.value;
                          await leadListController.fetchLeadArea();
                        },
                        onClear: () {
                          leadListController.cityFilter.value = false;

                          leadListController.cityController.clear();
                          leadListController.showCityController.clear();
                        },
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
        _buildFilterSection(
          title: "Date Range",
          child: Column(
            children: [
              _buildDateField(
                label: "From Date",
                controller: leadListController.fromDateCtlr,
                onSelect: (date) {
                  leadListController.fromFilter.value = true;

                  leadListController.fromDateCtlr.text = date ?? "";
                  leadListController.fromDate.value = date ?? "";
                },
              ),
              SizedBox(height: 16),
              _buildDateField(
                label: "To Date",
                controller: leadListController.toDateCtlr,
                onSelect: (date) {
                  leadListController.toFilter.value = true;

                  leadListController.toDateCtlr.text = date ?? "";
                  leadListController.toDate.value = date ?? "";
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 16),
        child,
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAnimatedSelect({
    required String label,
    required String placeholder,
    required List<CustomSelectItem> items,
    required TextEditingController controller,
    required Function(CustomSelectItem) onSelect,
    required VoidCallback onClear,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: CustomSelect(
        label: label,
        placeholder: placeholder,
        mainList: items,
        textEditCtlr: controller,
        onSelect: onSelect,
        onTapField: onClear,
        showLabel: true,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required Function(String?) onSelect,
  }) {
    return CustomField(
      labelText: label,
      hintText: "Select date",
      inputAction: TextInputAction.done,
      inputType: TextInputType.datetime,
      showLabel: true,
      bgColor: Colors.white,
      enabled: true,
      readOnly: true,
      editingController: controller,
      onFieldTap: () {
        Get.bottomSheet(
          CustomDatePicker(
            pastAllow: true,
            confirmHandler: onSelect,
          ),
        );
      },
    );
  }

  Widget _buildLeadsList() {
    return Expanded(
      child: Obx(() {
        if (leadListController.isLoading.value &&
            leadListController.currentPage.value == 0) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.teal,
              size: 50,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => leadListController.fetchLeads(),
          child: ListView.builder(
            controller: leadListController.scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: leadListController.leads.length +
                (leadListController.hasMoreLeads.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == leadListController.leads.length) {
                return _buildLoadingIndicator();
              }
              return _buildLeadCard(leadListController.leads[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _filterSheet(),
              icon: Icon(Icons.filter_list),
              label: Obx(() => Text(
                    leadListController.filtered.value
                        ? "Filters Applied"
                        : "Filter",
                    style: TextStyle(fontSize: 16),
                  )),
              style: ElevatedButton.styleFrom(
                backgroundColor: leadListController.filtered.value
                    ? Colors.teal
                    : Colors.white,
                foregroundColor: leadListController.filtered.value
                    ? Colors.white
                    : Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.teal),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Implement sort functionality
                Get.bottomSheet(
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sort By",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ListTile(
                          leading: Icon(Icons.calendar_today),
                          title: Text("Date"),
                          onTap: () {
                            // leadListController.sortByDate();
                            Get.back();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.sort_by_alpha),
                          title: Text("Name"),
                          onTap: () {
                            // leadListController.sortByName();
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(Icons.sort),
              label: Text("Sort", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.teal),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Obx(() => leadListController.isLoading.value
            ? LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.teal,
                size: 40,
              )
            : SizedBox.shrink()),
      ),
    );
  }

  Widget _buildLeadCard(LeadList lead) {
    return Hero(
      tag: 'lead-${lead.leadId}',
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                print(lead.leadId);
                Get.toNamed(Routes.CREATE_LEAD,
                    arguments: {'isEdit': true, 'id': lead.leadId})?.then((_) {
                  leadListController.fetchLeads(isInitialFetch: true);
                  // Perform action when the dialog is closed
                  print("Dialog closed, perform action here");
                });
                // Get.toNamed(Routes.CREATE_LEAD, arguments: lead.leadId);
                // Implement edit action
              },
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () => Get.toNamed(
              Routes.leadDetail,
              arguments: lead.leadId,
            ),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.teal.shade50.withOpacity(0.3),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLeadAvatar(lead),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lead.leadName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.teal.shade700,
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  _buildContactInfo(lead),
                                ],
                              ),
                            ),
                            _buildDateContainer(lead),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildBottomSection(lead),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadAvatar(LeadList lead) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal.shade300, Colors.teal.shade500],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade200.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          (lead.leadName == "")
              ? "?"
              : lead.leadName.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(LeadList lead) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.phone_outlined,
            size: 14,
            color: Colors.teal.shade700,
          ),
          SizedBox(width: 4),
          Text(
            lead.mobile,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateContainer(LeadList lead) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.teal.shade50,
            Colors.teal.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade100.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            leadListController.formatDate(lead.vdate),
            style: TextStyle(
              color: Colors.teal.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 2),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              lead.leadSource,
              style: TextStyle(
                fontSize: 11,
                color: Colors.teal.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(LeadList lead) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoChip(
              icon: Icons.location_on_outlined,
              label: '${lead.city ?? "Unknown"}, ${lead.state ?? ""}',
            ),
          ),
          if (lead.leadStatus != "") ...[
            SizedBox(width: 8),
            _buildStatusChip(lead.leadStatus),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade100],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color getStatusColor() {
      switch (status.toLowerCase()) {
        case 'new':
          return Colors.blue;
        case 'in progress':
          return Colors.orange;
        case 'converted':
          return Colors.green;
        case 'lost':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    final color = getStatusColor();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 13,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFilterActions() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                leadListController.clearFilters();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                foregroundColor: Colors.grey.shade800,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Clear All"),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                leadListController.applyFilters();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Apply Filters"),
            ),
          ),
        ],
      ),
    );
  }
}
