import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/constants.dart';
import '../../widgets/custom_field.dart';
import '../../widgets/custom_select.dart';
import '../../widgets/forms/location/location.dart';
import 'controller.dart';
import 'metting_card.dart';
import 'model.dart';

class ScheduleScreen extends StatelessWidget {
  final ScheduleController controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'My Schedule',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue),
            onPressed: () => controller.fetchMeetings(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading your meetings...',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (controller.error.value.isNotEmpty) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Oops! Something went wrong',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${controller.error.value}',
                          style: TextStyle(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: controller.fetchMeetings,
                          icon: Icon(Icons.refresh),
                          label: Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.filteredMeetings.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.fetchMeetings,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount:
                      controller.filteredMeetings.length + 1, // +1 for header
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildHeader();
                    }

                    final meeting = controller.filteredMeetings[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MeetingCard(
                        meeting: meeting,
                        hasActiveMeeting: controller.hasActiveMeeting(),
                        isActive: meeting.checkin == "1" &&
                            (meeting.checkout == "0" || meeting.checkout == ""),
                        onCheckIn: () => controller.checkIn(meeting),
                        onCheckOut: () => _showCheckoutForm(meeting),
                        onNavigate: () => controller.navigateToMeeting(meeting),
                        onCall: () => controller.callContact(meeting),
                        onReschedule: () => controller.reschedule(meeting),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action to create a new meeting
          Get.toNamed('/create-meeting');
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      final count = controller.filteredMeetings.length;

      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Row(
          children: [
            Text(
              _getFilterTitle(controller.currentFilter.value),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String _getFilterTitle(FilterType type) {
    switch (type) {
      case FilterType.today:
        return 'Today\'s Meetings';
      case FilterType.upcoming:
        return 'Upcoming Meetings';
      case FilterType.overdue:
        return 'Overdue Meetings';
      case FilterType.all:
      default:
        return 'All Meetings';
    }
  }

  void _showCheckoutForm(Meeting meeting) {
    controller.fetchCustomerData(meeting.mobile);

    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Obx(() => Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        SizedBox(height: 24),
                        Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBasicInfoSection(),
                              _buildLocationSection(),
                              SizedBox(height: 32),
                              _buildSubmitButton(meeting),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Overlay loading indicator when fetching customer data
                if (controller.isLoading.value) _buildLoadingOverlay(),
              ],
            )),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: primary3Color,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  "Basic Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primary3Color,
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[300], thickness: 1, height: 24),
            SizedBox(height: 8),
            _buildField(
              controller: controller.mobileController,
              label: "Mobile Number",
              hint: "Enter 10-digit mobile number",
              icon: Icons.phone_android,
              keyboardType: TextInputType.number,
              required: true,
              onChanged: (value) {
                // Handle null safety by checking if value is not null
                if (value != null &&
                    value.length == 10 &&
                    RegExp(r'^[0-9]+$').hasMatch(value)) {
                  controller.fetchCustomerData(value);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter mobile number";
                }
                if (value.length != 10) {
                  return "Mobile number must be 10 digits";
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return "Please enter only numbers";
                }
                return null;
              },
            ),
            _buildField(
              controller: controller.budgetController,
              label: "Budget",
              hint: "Enter Budget",
              icon: Icons.money,
              keyboardType: TextInputType.number,
            ),
            _buildField(
              controller: controller.productController,
              label: "Product",
              hint: "Enter product",
              icon: Icons.insert_invitation,
              keyboardType: TextInputType.text,
            ),
            _buildField(
              controller: controller.remarkController,
              label: "Remark",
              hint: "Enter Remark",
              icon: Icons.home_outlined,
              required: true,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a remark";
                }
                if (value.length < 5) {
                  return "Please enter a complete remark";
                }
                return null;
              },
            ),
            _buildField(
              controller: controller.emailController,
              label: "Email Address",
              hint: "Enter email address",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!GetUtils.isEmail(value)) {
                    return "Please enter a valid email address";
                  }
                }
                return null;
              },
            ),
            _buildField(
              controller: controller.customerNameController,
              label: "Customer Name",
              hint: "Enter full name",
              icon: Icons.badge_outlined,
              required: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter customer name";
                }
                if (value.length < 2) {
                  return "Name must be at least 2 characters";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: primary3Color,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  "Location Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primary3Color,
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[300], thickness: 1, height: 24),
            SizedBox(height: 8),
            Obx(() => _buildCustomSelect(
                  label: "State",
                  hint: "Select state",
                  icon: Icons.map_outlined,
                  required: true,
                  items: controller.stateList
                      .map((element) => CustomSelectItem(
                            id: element.id ?? "",
                            value: element.state ?? "",
                          ))
                      .toList(),
                  controller: controller.stateController,
                  showController: controller.showStateController,
                  isPlus: true,
                  onplus: () {
                    CustomFormDialogs.showAddStateDialog().then((_) {
                      controller.fetchLState();
                    });
                  },
                  onSelect: (val) async {
                    controller.stateController.text = val.id;
                    controller.showStateController.text = val.value;
                    controller.cityController.clear();
                    controller.showCityController.clear();
                    controller.areaController.clear();
                    controller.showAreaController.clear();
                    await controller.fetchLeadCity();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a state";
                    }
                    return null;
                  },
                )),
            Obx(() => _buildCustomSelect(
                  label: "City",
                  hint: "Select city",
                  icon: Icons.location_city_outlined,
                  required: true,
                  isPlus: true,
                  onplus: () {
                    CustomFormDialogs.showAddCityDialog().then((_) {
                      controller.fetchLeadCity();
                    });
                  },
                  items: controller.cityList
                      .map((element) => CustomSelectItem(
                            id: element.cityID ?? "",
                            value: element.city ?? "",
                          ))
                      .toList(),
                  controller: controller.cityController,
                  showController: controller.showCityController,
                  onSelect: (val) async {
                    controller.cityController.text = val.id;
                    controller.showCityController.text = val.value;
                    controller.areaController.clear();
                    controller.showAreaController.clear();
                    await controller.fetchLeadArea();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a city";
                    }
                    return null;
                  },
                )),
            Obx(() => _buildCustomSelect(
                  label: "Area",
                  hint: "Select area",
                  icon: Icons.map_outlined,
                  required: true,
                  isPlus: true,
                  onplus: () {
                    CustomFormDialogs.showAddAreaDialog().then((_) {
                      controller.fetchLeadArea();
                    });
                  },
                  items: controller.areaList
                      .map((element) => CustomSelectItem(
                            id: element.areaID ?? "",
                            value: element.area ?? "",
                          ))
                      .toList(),
                  controller: controller.areaController,
                  showController: controller.showAreaController,
                  onSelect: (val) async {
                    controller.areaController.text = val.id;
                    controller.showAreaController.text = val.value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select an area";
                    }
                    return null;
                  },
                )),
            _buildField(
              controller: controller.lane1Controller,
              label: "Address",
              hint: "Enter complete address",
              icon: Icons.home_outlined,
              required: true,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter an address";
                }
                if (value.length < 5) {
                  return "Please enter a complete address";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(Meeting meeting) {
    return ElevatedButton(
      onPressed: () {
        if (controller.formKey.currentState!.validate()) {
          controller.checkOut(meeting.id);
          Get.back();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primary3Color,
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 22),
          SizedBox(width: 8),
          Text(
            "Complete Checkout",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primary3Color),
                strokeWidth: 3,
              ),
              SizedBox(height: 16),
              Text(
                "Loading customer data...",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? onChanged,
    String? Function(String?)? validator,
    int? maxLines,
    bool required = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: Colors.grey[700]),
                SizedBox(width: 8),
                Text(
                  label + (required ? " *" : ""),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          CustomField(
            showLabel: false,
            hintText: hint,
            labelText: "",
            minLines: maxLines ?? 1,
            inputAction: TextInputAction.next,
            inputType: keyboardType ?? TextInputType.text,
            editingController: controller,
            validator: validator,
            onChange: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSelect({
    required String label,
    required String hint,
    required IconData icon,
    required List<CustomSelectItem> items,
    required TextEditingController controller,
    required TextEditingController showController,
    required Function(CustomSelectItem) onSelect,
    VoidCallback? onplus,
    VoidCallback? ontap,
    bool? isPlus,
    bool required = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: Colors.grey[700]),
                SizedBox(width: 8),
                Text(
                  label + (required ? " *" : ""),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          CustomSelect(
            label: "",
            placeholder: hint,
            mainList: items,
            onSelect: onSelect,
            textEditCtlr: showController,
            showLabel: false,
            showPlusIcon: isPlus ?? false,
            onPlusPressed: () {
              onplus?.call();
            },
            onTapField: () {
              ontap?.call();
            },
            labelColor: primary3Color,
            withShadow: false,
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Obx(() {
      String message = '';
      IconData icon = Icons.event_busy;

      switch (controller.currentFilter.value) {
        case FilterType.today:
          message = 'No meetings scheduled for today';
          break;
        case FilterType.upcoming:
          message = 'No upcoming meetings scheduled';
          break;
        case FilterType.overdue:
          message = 'No overdue meetings';
          icon = Icons.check_circle_outline;
          break;
        case FilterType.all:
        default:
          message = 'Your schedule is clear';
          break;
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            if (controller.currentFilter.value != FilterType.all)
              ElevatedButton.icon(
                onPressed: () => controller.applyFilter(FilterType.all),
                icon: Icon(Icons.calendar_month),
                label: Text('View All Meetings'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterTabs() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _filterButton('Today', FilterType.today),
                _filterButton('Upcoming', FilterType.upcoming),
                _filterButton('Overdue', FilterType.overdue),
                _filterButton('All', FilterType.all),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String label, FilterType type) {
    return Obx(() {
      final isSelected = controller.currentFilter.value == type;

      return Padding(
        padding: EdgeInsets.only(right: 12),
        child: InkWell(
          onTap: () => controller.applyFilter(type),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    });
  }
}
