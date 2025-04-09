// tasks_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dp;

import 'controller.dart';

class TasksPage extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeaderStats(),
          _buildFilters(),
          Expanded(
            child: _buildTasksList(),
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
        'My Tasks',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.black87),
          onPressed: controller.fetchTasks,
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.black87),
          onPressed: () {},
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                'Total Tasks',
                '${controller.tasks.length}',
                Icons.task,
                Colors.blue,
              ),
              _buildStatCard(
                'Pending',
                '${controller.tasks.where((t) => t.status == 'pending').length}',
                Icons.pending_actions,
                Colors.orange,
              ),
              _buildStatCard(
                'Completed',
                '${controller.tasks.where((t) => t.status == 'completed').length}',
                Icons.check_circle_outline,
                Colors.green,
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
            fontSize: 20,
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

  Widget _buildFilters() {
    return Container(
      margin: EdgeInsets.all(16),
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
            'Filter Tasks',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
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
          SizedBox(height: 16),
          _buildStatusFilter(),
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

  Widget _buildStatusFilter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Obx(() => Row(
            children: [
              Expanded(
                child: _buildFilterChip('All', 'all'),
              ),
              Expanded(
                child: _buildFilterChip('Pending', 'pending'),
              ),
              Expanded(
                child: _buildFilterChip('Completed', 'completed'),
              ),
            ],
          )),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = controller.selectedFilter.value == value;
    return GestureDetector(
      onTap: () => controller.selectedFilter.value = value,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(Get.context!).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final tasks = controller.filteredTasks;
      if (tasks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task_outlined, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'No tasks found',
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
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return _buildTaskCard(task);
        },
      );
    });
  }

  Widget _buildTaskCard(Task task) {
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
              // Handle task tap
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.more_vert,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    task.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _buildChip(
                        task.priority == 'high' ? Colors.red : Colors.green,
                        task.priority.capitalizeFirst!,
                      ),
                      SizedBox(width: 8),
                      _buildChip(
                        task.status == 'pending' ? Colors.orange : Colors.blue,
                        task.status.capitalizeFirst!,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey[200],
                            child: Text(
                              task.leadName[0],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            task.leadName,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(task.dueDate),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
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

  Widget _buildChip(Color color, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
