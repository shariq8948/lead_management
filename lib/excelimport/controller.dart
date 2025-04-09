import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/api/api_client.dart';
import '../utils/api_endpoints.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class ExcelImportController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  // Reactive variables
  final RxList<Map<String, dynamic>> excelData = <Map<String, dynamic>>[].obs;
  final RxSet<int> selectedRows = <int>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString fileName = ''.obs;
  final RxBool isAllSelected = false.obs;

  void toggleAllSelection() {
    if (isAllSelected.value) {
      // If all are selected, deselect all
      selectedRows.clear();
      isAllSelected.value = false;
    } else {
      // Select all valid rows
      selectedRows.clear();
      for (var i = 0; i < excelData.length; i++) {
        if (!validateRow(excelData[i])) {
          selectedRows.add(i);
        }
      }
      isAllSelected.value = true;
    }
  }

  // Column mapping
  final RxString nameColumn = ''.obs;
  final RxString mobileColumn = ''.obs;
  final RxString emailColumn = ''.obs;
  final RxString companyColumn = ''.obs;
  final RxString sourceColumn = ''.obs;
  final RxString industryColumn = ''.obs;
  final RxString addressColumn = ''.obs;
  final RxString gstNoColumn = ''.obs;
  final RxString productColumn = ''.obs;
  final RxString descriptionColumn = ''.obs;
  final RxString stateCodeColumn = ''.obs;
  final RxString stateNameColumn = ''.obs;
  final RxString cityColumn = ''.obs;
  final RxString followUpdateColumn = ''.obs;
  final RxString followRemarkColumn = ''.obs;

  // Available columns from Excel
  final RxList<String> availableColumns = <String>[].obs;
  final List<ColumnMapping> columnDefinitions = [
    ColumnMapping(
      key: 'name',
      displayName: 'Name',
      required: true,
      validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
    ),
    ColumnMapping(
      key: 'mobile',
      displayName: 'Mobile',
      required: true,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Mobile is required';
        if (!RegExp(r'^\+?[0-9]{10,12}$')
            .hasMatch(value!.replaceAll(RegExp(r'\D'), ''))) {
          return 'Invalid mobile number format';
        }
        return null;
      },
    ),
    ColumnMapping(
      key: 'email',
      displayName: 'Email',
      validator: (value) {
        if (value?.isEmpty ?? false) return null;
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
          return 'Invalid email format';
        }
        return null;
      },
    ),
    ColumnMapping(
      key: 'company',
      displayName: 'Company',
    ),
    ColumnMapping(
      key: 'source',
      displayName: 'Lead Source',
    ),
    ColumnMapping(
      key: 'industry',
      displayName: 'Industry',
    ),
    ColumnMapping(
      key: 'address',
      displayName: 'Address',
    ),
    ColumnMapping(
      key: 'gstNo',
      displayName: 'GST Number',
      validator: (value) {
        if (value?.isEmpty ?? false) return null;
        if (!RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}$')
            .hasMatch(value!)) {
          return 'Invalid GST number format';
        }
        return null;
      },
    ),
    ColumnMapping(
      key: 'product',
      displayName: 'Product',
    ),
    ColumnMapping(
      key: 'description',
      displayName: 'Description',
    ),
    ColumnMapping(
      key: 'stateCode',
      displayName: 'State Code',
      validator: (value) {
        if (value?.isEmpty ?? false) return null;
        if (!RegExp(r'^\d{2}$').hasMatch(value!)) {
          return 'Invalid state code format';
        }
        return null;
      },
    ),
    ColumnMapping(
      key: 'stateName',
      displayName: 'State Name',
    ),
    ColumnMapping(
      key: 'city',
      displayName: 'City',
    ),
    ColumnMapping(
      key: 'followUpDate',
      displayName: 'Follow-up Date',
      validator: (value) {
        if (value?.isEmpty ?? false) return null;
        try {
          DateTime.parse(value!);
          return null;
        } catch (_) {
          return 'Invalid date format';
        }
      },
    ),
    ColumnMapping(
      key: 'followUpRemark',
      displayName: 'Follow-up Remark',
    ),
  ];
  // Constants
  static const String userId = "4";
  static const String mobileRegex = r'^\+?[0-9]{10,12}$';
  final RxMap<String, String> columnMappings = <String, String>{}.obs;

  // Available columns from Excel

  // Unmapped required columns
  final RxList<String> unmappedRequiredColumns = <String>[].obs;
// Get unmapped columns
  List<String> get unmappedColumns {
    return availableColumns
        .where((col) => !columnMappings.values.contains(col))
        .toList();
  }

  void updateColumnMapping(String key, String? excelColumn) {
    // Remove previous mapping if it exists
    if (columnMappings.containsKey(key)) {
      columnMappings.remove(key);
    }

    // Add new mapping if a column is selected
    if (excelColumn != null && excelColumn.isNotEmpty) {
      // Check if the column is already mapped to another key
      final existingKey = columnMappings.keys.firstWhere(
          (k) => columnMappings[k] == excelColumn,
          orElse: () => '');

      if (existingKey.isNotEmpty) {
        // Show error that column is already mapped
        Get.snackbar(
          'Mapping Error',
          'Column "$excelColumn" is already mapped to "${_getDisplayName(existingKey)}"',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      columnMappings[key] = excelColumn;
    }

    // Update unmapped required columns
    _updateUnmappedRequired();

    // Validate mappings
    _validateMappings();
  }

  String _getDisplayName(String key) {
    return columnDefinitions.firstWhere((def) => def.key == key).displayName;
  }

  // Update list of unmapped required columns
  void _updateUnmappedRequired() {
    unmappedRequiredColumns.value = columnDefinitions
        .where((def) => def.required && !columnMappings.containsKey(def.key))
        .map((def) => def.displayName)
        .toList();
  }

  void _validateMappings() {
    mappingErrors.clear();

    for (var mapping in columnMappings.entries) {
      final definition =
          columnDefinitions.firstWhere((def) => def.key == mapping.key);

      if (definition.validator != null) {
        // Check first row as sample data
        final sampleValue = excelData.isNotEmpty
            ? getValueFromRow(excelData.first, mapping.value)
            : '';

        final error = definition.validator!(sampleValue);
        if (error != null) {
          mappingErrors[mapping.key] = error;
        }
      }
    }
  }

  final RxMap<String, String> mappingErrors = <String, String>{}.obs;
  Future<void> pickExcelFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true, // Ensure we get the file data
      );

      if (result == null) {
        print('No file selected');
        return;
      }

      isLoading.value = true;
      fileName.value = result.files.first.name;
      print('File selected: ${fileName.value}');

      final bytes = result.files.first.bytes;
      if (bytes == null) {
        throw 'Failed to read file bytes';
      }
      print('File size: ${bytes.length} bytes');

      // Add try-catch specifically for Excel decoding
      Excel? excel;
      try {
        excel = Excel.decodeBytes(bytes);
        print('Excel decoded successfully');
      } catch (e) {
        print('Excel decode error: $e');
        throw 'Failed to decode Excel file: $e';
      }

      if (excel.tables.isEmpty) {
        print('No tables found in Excel file');
        throw 'Excel file contains no sheets';
      }

      final sheetName = excel.tables.keys.first;
      final sheet = excel.tables[sheetName];
      print('Processing sheet: $sheetName');

      if (sheet == null || sheet.rows.isEmpty) {
        print('Sheet is empty');
        throw 'Selected sheet contains no data';
      }

      // Get headers with detailed logging
      final headers = sheet.rows.first
          .map((cell) {
            final value = cell?.value.toString().trim() ?? '';
            print('Found header: $value');
            return value;
          })
          .where((value) => value.isNotEmpty)
          .toList();

      if (headers.isEmpty) {
        throw 'No valid headers found in the Excel file';
      }
      print('Found ${headers.length} valid headers');

      availableColumns.assignAll(headers);
      _autoMapColumns(headers);

      // Parse data rows with validation
      final data = <Map<String, dynamic>>[];
      var rowErrors = <String>[];

      for (var i = 1; i < sheet.rows.length; i++) {
        try {
          final row = sheet.rows[i];
          final rowData = <String, dynamic>{};
          bool hasValue = false;

          for (var j = 0; j < headers.length; j++) {
            final cell = row[j];
            final value = cell?.value.toString().trim() ?? '';
            rowData[headers[j]] = value;
            if (value.isNotEmpty) hasValue = true;
          }

          if (hasValue) {
            data.add(rowData);
          }
        } catch (e) {
          rowErrors.add('Row ${i + 1}: $e');
        }
      }

      print('Processed ${data.length} valid data rows');
      if (rowErrors.isNotEmpty) {
        print('Found ${rowErrors.length} row errors: ${rowErrors.join(', ')}');
      }

      if (data.isEmpty) {
        throw 'No valid data rows found in the Excel file';
      }

      excelData.assignAll(data);
      selectedRows.clear();

      // Show success message
      Get.snackbar(
        'Success',
        'Excel file processed successfully: ${data.length} rows loaded',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Excel processing error: $e');
      _handleError('Error processing Excel file: $e');
      excelData.clear();
      fileName.value = '';
      availableColumns.clear();
      _resetColumnMapping();
    } finally {
      isLoading.value = false;
    }
  }

  void updateRowValue(int index, String column, String newValue) {
    if (index >= 0 && index < excelData.length) {
      final updatedRow = Map<String, dynamic>.from(excelData[index]);
      updatedRow[column] = newValue;
      excelData[index] = updatedRow;
    }
  }

  void _autoMapColumns(List<String> headers) {
    columnMappings.clear();

    for (var def in columnDefinitions) {
      for (var header in headers) {
        final lowerHeader = header.toLowerCase();
        final lowerDisplay = def.displayName.toLowerCase();

        if (lowerHeader.contains(lowerDisplay) ||
            lowerDisplay.contains(lowerHeader)) {
          // Only map if column isn't already mapped
          if (!columnMappings.values.contains(header)) {
            columnMappings[def.key] = header;
            break;
          }
        }
      }
    }

    _updateUnmappedRequired();
    _validateMappings();
  }

  String? getValueFromRow(Map<String, dynamic> row, String column) {
    if (column.isEmpty) return null;
    return row[column]?.toString().trim() ?? '';
  }

  void _resetColumnMapping() {
    nameColumn.value = '';
    mobileColumn.value = '';
    emailColumn.value = '';
    companyColumn.value = '';
  }

  bool get isMappingComplete {
    return columnDefinitions
        .where((def) => def.required)
        .every((def) => columnMappings.containsKey(def.key));
  }

  bool validateRow(Map<String, dynamic> row) {
    if (mobileColumn.isEmpty) return true;

    final mobileValue = getValueFromRow(row, mobileColumn.value);
    if (mobileValue == null || mobileValue.isEmpty) return true;

    return !RegExp(mobileRegex)
        .hasMatch(mobileValue.replaceAll(RegExp(r'\D'), ''));
  }

  void toggleRowSelection(int index) {
    if (selectedRows.contains(index)) {
      selectedRows.remove(index);
      isAllSelected.value = false;
    } else {
      selectedRows.add(index);
      // Check if all valid rows are now selected
      bool allValidRowsSelected = true;
      for (var i = 0; i < excelData.length; i++) {
        if (!validateRow(excelData[i]) && !selectedRows.contains(i)) {
          allValidRowsSelected = false;
          break;
        }
      }
      isAllSelected.value = allValidRowsSelected;
    }
  }

  Future<void> createLeads() async {
    if (!isMappingComplete) {
      _handleError(
          'Please map all required columns: ${unmappedRequiredColumns.join(", ")}');
      return;
    }

    if (selectedRows.isEmpty) {
      _handleError('Please select rows to import');
      return;
    }

    try {
      isLoading.value = true;
      int successCount = 0;
      final errors = <String>[];

      for (final index in selectedRows) {
        final row = excelData[index];

        // Validate row before creating lead
        if (!validateRow(row)) {
          errors.add('Row ${index + 1}: Validation failed');
          continue;
        }

        try {
          await _apiClient.postLeadData(
            endPoint: ApiEndpoints.saveLead,
            userId: "4",
            AssignTo: "0",
            company:
                getValueFromRow(row, columnMappings['company'] ?? '') ?? '',
            dealSize: "",
            name: getValueFromRow(row, columnMappings['name'] ?? '') ?? '',
            mobileNumber:
                getValueFromRow(row, columnMappings['mobile'] ?? '') ?? '',
            productId:
                getValueFromRow(row, columnMappings['product'] ?? '') ?? '',
            address:
                getValueFromRow(row, columnMappings['address'] ?? '') ?? '',
            Description:
                getValueFromRow(row, columnMappings['description'] ?? '') ?? '',
            email: getValueFromRow(row, columnMappings['email'] ?? '') ?? '',
            source: getValueFromRow(row, columnMappings['source'] ?? '') ?? '0',
            owner: "",
            industry:
                getValueFromRow(row, columnMappings['industry'] ?? '') ?? '',
          );
          successCount++;
        } catch (e) {
          errors.add('Row ${index + 1}: ${e.toString()}');
        }
      }

      if (successCount > 0) {
        Get.snackbar(
          'Success',
          '$successCount leads created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      if (errors.isNotEmpty) {
        _showErrorDialog('Import Errors', errors.join('\n'));
      }

      if (errors.isEmpty) {
        selectedRows.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadSampleFile() async {
    try {
      isLoading.value = true;

      // Create Excel file
      final excel = Excel.createExcel();
      final sheet = excel.sheets[excel.getDefaultSheet()];
      if (sheet == null) {
        throw Exception('Failed to create Excel sheet');
      }

      // Add headers with styling
      final headers = ['Name', 'Mobile', 'Email', 'Company'];
      for (var i = 0; i < headers.length; i++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: i,
          rowIndex: 0,
        ));
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
        );
      }

      // Add sample data
      // final sampleData = [
      //   ['John Doe', '1234567890', 'john@example.com', 'ABC Corp'],
      //   ['Jane Smith', '9876543210', 'jane@example.com', 'XYZ Ltd'],
      // ];
      final firstNames = [
        'James',
        'John',
        'Robert',
        'Michael',
        'William',
        'David',
        'Richard',
        'Joseph',
        'Thomas',
        'Charles',
        'Mary',
        'Patricia',
        'Jennifer',
        'Linda',
        'Elizabeth',
        'Barbara',
        'Susan',
        'Jessica',
        'Sarah',
        'Karen',
        'Emma',
        'Olivia',
        'Ava',
        'Isabella',
        'Sophia',
        'Charlotte',
        'Mia',
        'Amelia',
        'Harper',
        'Evelyn',
        'Daniel',
        'Matthew',
        'Anthony',
        'Donald',
        'Mark',
        'Paul',
        'Steven',
        'Andrew',
        'Kenneth',
        'Joshua',
        'Helen',
        'Sandra',
        'Donna',
        'Carol',
        'Ruth',
        'Sharon',
        'Michelle',
        'Laura',
        'Rachel',
        'Amanda'
      ];

      final lastNames = [
        'Smith',
        'Johnson',
        'Williams',
        'Brown',
        'Jones',
        'Garcia',
        'Miller',
        'Davis',
        'Rodriguez',
        'Martinez',
        'Hernandez',
        'Lopez',
        'Gonzalez',
        'Wilson',
        'Anderson',
        'Thomas',
        'Taylor',
        'Moore',
        'Jackson',
        'Martin',
        'Lee',
        'Thompson',
        'White',
        'Harris',
        'Clark',
        'Lewis',
        'Robinson',
        'Walker',
        'Hall',
        'Young',
        'Allen',
        'King',
        'Wright',
        'Scott',
        'Green',
        'Baker',
        'Adams',
        'Nelson',
        'Carter',
        'Mitchell',
        'Parker',
        'Collins',
        'Edwards',
        'Stewart',
        'Morris',
        'Murphy'
      ];

      // Lists for generating company names
      final companyPrefixes = [
        'Tech',
        'Global',
        'Digital',
        'Smart',
        'Blue',
        'Red',
        'Green',
        'Silver',
        'Golden',
        'Alpha',
        'Beta',
        'Nova',
        'Mega',
        'Ultra',
        'Pro',
        'Advanced',
        'Future',
        'Modern',
        'Elite',
        'Prime',
        'Peak',
        'First',
        'Next',
        'Best',
        'Bright'
      ];

      final companySuffixes = [
        'Corp',
        'Inc',
        'Ltd',
        'Solutions',
        'Systems',
        'Technologies',
        'Group',
        'Dynamics',
        'Innovations',
        'Networks',
        'Services',
        'Industries',
        'Partners',
        'International',
        'Enterprises',
        'Associates',
        'Company',
        'Labs',
        'Works',
        'Logic'
      ];

      // Function to generate sample data
      List<List<String>> generateSampleData(int count) {
        final random = Random();
        final data = <List<String>>[];

        String generatePhoneNumber() {
          return List.generate(10, (index) => random.nextInt(10).toString())
              .join();
        }

        String generateEmail(String firstName, String lastName) {
          final domains = [
            'gmail.com',
            'yahoo.com',
            'outlook.com',
            'company.com',
            'business.net'
          ];
          final domain = domains[random.nextInt(domains.length)];
          return '${firstName.toLowerCase()}.${lastName.toLowerCase()}@$domain';
        }

        String generateCompanyName() {
          final prefix =
              companyPrefixes[random.nextInt(companyPrefixes.length)];
          final suffix =
              companySuffixes[random.nextInt(companySuffixes.length)];
          return '$prefix $suffix';
        }

        for (var i = 0; i < count; i++) {
          final firstName = firstNames[random.nextInt(firstNames.length)];
          final lastName = lastNames[random.nextInt(lastNames.length)];
          final fullName = '$firstName $lastName';
          final phone = generatePhoneNumber();
          final email = generateEmail(firstName, lastName);
          final company = generateCompanyName();

          data.add([fullName, phone, email, company]);
        }

        return data;
      }

      final sampleData = generateSampleData(5);

      for (var i = 0; i < sampleData.length; i++) {
        for (var j = 0; j < sampleData[i].length; j++) {
          sheet
              .cell(CellIndex.indexByColumnRow(
                columnIndex: j,
                rowIndex: i + 1,
              ))
              .value = TextCellValue(sampleData[i][j]);
        }
      }

      // Generate the Excel bytes
      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception('Failed to encode Excel file');
      }

      if (Platform.isAndroid) {
        // For Android, first save to temporary file then use share dialog
        final tempDir = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final tempPath = '${tempDir.path}/sample_leads_$timestamp.xlsx';

        final tempFile = File(tempPath);
        await tempFile.writeAsBytes(bytes);

        try {
          final xFile = XFile(tempPath,
              mimeType:
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
          final result = await Share.shareXFiles(
            [xFile],
            subject: 'Sample Leads Excel',
          );

          // Check if share was successful
          if (result.status == ShareResultStatus.success) {
            Get.snackbar(
              'Success',
              'File saved successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
        } catch (e) {
          throw Exception('Failed to share file: $e');
        } finally {
          // Clean up temp file
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        }
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final path = '${directory.path}/sample_leads_$timestamp.xlsx';
        final file = File(path);
        await file.writeAsBytes(bytes);

        // Share the file on iOS
        final xFile = XFile(path);
        await Share.shareXFiles(
          [xFile],
          subject: 'Sample Leads Excel',
        );
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        final fileName =
            'sample_leads_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        final result = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Excel File',
          fileName: fileName,
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
        );

        if (result != null) {
          final file = File(result);
          await file.writeAsBytes(bytes);

          Get.snackbar(
            'Success',
            'File saved successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        } else {
          Get.snackbar(
            'Cancelled',
            'File save was cancelled',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      print('Error creating sample file: $e');
      Get.snackbar(
        'Error',
        'Failed to create sample file: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
    );
  }

  void _showErrorDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    excelData.clear();
    selectedRows.clear();
    columnMappings.clear();
    mappingErrors.clear();
    super.onClose();
  }
}

class ColumnMapping {
  final String key;
  final String displayName;
  final bool required;
  final String? Function(String?)? validator;

  ColumnMapping({
    required this.key,
    required this.displayName,
    this.required = false,
    this.validator,
  });
}
