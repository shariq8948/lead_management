import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ExcelImportPage extends GetView<ExcelImportController> {
  const ExcelImportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Import Leads from Excel',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        actions: [
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.selectedRows.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ElevatedButton.icon(
                          onPressed: controller.createLeads,
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          label: const Text('Create Leads'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade700,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              )),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingUI();
          }
          return _buildMainContent();
        }),
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  Widget _buildLoadingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
          ),
          const SizedBox(height: 16),
          Text(
            'Processing Excel File...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (controller.excelData.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildFileInfo(),
        _buildColumnMapping(),
        Expanded(
          child: _buildDataPreview(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_chart_outlined,
            size: 80,
            color: Colors.blue.shade700,
          ),
          const SizedBox(height: 24),
          Text(
            'Import Excel File',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select an Excel file to import leads.\nSupported columns: Name, Mobile, Email, Company',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: controller.pickExcelFile,
            icon: const Icon(Icons.upload_file),
            label: const Text('Choose Excel File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: controller.downloadSampleFile,
            icon: const Icon(Icons.download),
            label: const Text('Download Sample File'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.fileName.value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${controller.excelData.length} rows found',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: controller.pickExcelFile,
            icon: const Icon(Icons.change_circle_outlined),
            label: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnMapping() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Column Mapping',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Obx(() => controller.unmappedRequiredColumns.isNotEmpty
                    ? Text(
                        'Required: ${controller.unmappedRequiredColumns.join(", ")}',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: controller.columnDefinitions
                  .map((def) => _buildColumnMapDropdown(
                        def.displayName,
                        def.key,
                        def.required,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnMapDropdown(
    String label,
    String mappingKey,
    bool required,
  ) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: controller.mappingErrors.containsKey(mappingKey)
              ? Colors.red.shade300
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              if (required) ...[
                const SizedBox(width: 4),
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.columnMappings[mappingKey],
                hint: const Text('Select column'),
                isExpanded: true,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('None'),
                  ),
                  ...controller.unmappedColumns
                      .map((column) => DropdownMenuItem(
                            value: column,
                            child: Text(column),
                          ))
                      .toList(),
                  if (controller.columnMappings[mappingKey] != null)
                    DropdownMenuItem(
                      value: controller.columnMappings[mappingKey],
                      child: Text(controller.columnMappings[mappingKey]!),
                    ),
                ],
                onChanged: (newValue) =>
                    controller.updateColumnMapping(mappingKey, newValue),
              )),
          if (controller.mappingErrors.containsKey(mappingKey))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                controller.mappingErrors[mappingKey]!,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDataPreview() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Data Preview',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.isAllSelected.value,
                        onChanged: (_) => controller.toggleAllSelection(),
                        activeColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Text(
                        'Select All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
              const Spacer(),
              Obx(() => Text(
                    '${controller.selectedRows.length} rows selected',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  )),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: controller.excelData.length,
            itemBuilder: (context, index) {
              final row = controller.excelData[index];
              return Obx(() {
                final isSelected = controller.selectedRows.contains(index);
                final hasError = !controller.validateRow(row);

                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasError
                          ? Colors.red.shade200
                          : isSelected
                              ? Colors.blue.shade200
                              : Colors.grey.withOpacity(0.1),
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(
                        controller.getValueFromRow(
                                row, controller.columnMappings['name'] ?? '') ??
                            'N/A',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            controller.getValueFromRow(
                                    row,
                                    controller.columnMappings['mobile'] ??
                                        '') ??
                                'No mobile number',
                            style: TextStyle(
                              color: hasError ? Colors.red : null,
                            ),
                          ),
                          if (hasError) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Row contains invalid data',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: controller.columnMappings.entries
                                .map((entry) => _buildEditableField(
                                      index,
                                      controller.columnDefinitions
                                          .firstWhere(
                                              (def) => def.key == entry.key)
                                          .displayName,
                                      entry.value,
                                      row,
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(
    int index,
    String label,
    String column,
    Map<String, dynamic> row,
  ) {
    if (column.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: controller.getValueFromRow(row, column) ?? '',
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) => controller.updateRowValue(index, column, value),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    int index,
    Map<String, dynamic> row,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Row'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: controller.columnMappings.entries
                .map((entry) => _buildEditableField(
                      index,
                      controller.columnDefinitions
                          .firstWhere((def) => def.key == entry.key)
                          .displayName,
                      entry.value,
                      row,
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Obx(() {
      if (controller.selectedRows.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected ${controller.selectedRows.length} rows',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (controller.unmappedRequiredColumns.isNotEmpty)
                      Text(
                        'Missing required columns: ${controller.unmappedRequiredColumns.join(", ")}',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: controller.unmappedRequiredColumns.isEmpty
                    ? controller.createLeads
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Create Leads'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
