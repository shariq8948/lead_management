import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../data/models/dropdown_list.model.dart';

class ExpenseEntryController extends GetxController {
  final dateEdtCtlr = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final expenseDescriptionController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final travelController = TextEditingController();
  final travelKmController = TextEditingController();
  final expenseTypeController = TextEditingController();

  Rx<DropdownListModel?> assignedState = (null as DropdownListModel?).obs;
  Rx<DropdownListModel?> assignedCity = (null as DropdownListModel?).obs;
  Rx<DropdownListModel?> assignedArea = (null as DropdownListModel?).obs;
  Rx<DropdownListModel?> expense = (null as DropdownListModel?).obs;
  var expandedSections = <String, RxBool>{}.obs;

  // Toggle the expansion of a section
  void toggleExpansion(String title) {
    // Initialize the section if it doesn't exist yet
    if (!expandedSections.containsKey(title)) {
      expandedSections[title] = false.obs;  // Default to collapsed
    }
    expandedSections[title]!.value = !expandedSections[title]!.value;  // Toggle the value
  }

  // Check if a section is expanded
  bool isExpanded(String title) {
    return expandedSections[title]?.value ?? false;  // Return the expansion state, or false if not found
  }
  // Adding sample data to stateList, cityList, and areaList
  RxList<DropdownListModel> stateList = <DropdownListModel>[
    DropdownListModel(
      id: '1',
      name: 'State 1',
      mobileNo: '1234567890',
      jobCount: '10',
      totalunseenforZerojob: '5',
    ),
    DropdownListModel(
      id: '2',
      name: 'State 2',
      mobileNo: '0987654321',
      jobCount: '15',
      totalunseenforZerojob: '3',
    ),
  ].obs;
  RxList<DropdownListModel> expenseList = <DropdownListModel>[
    DropdownListModel(
      id: '1',
      name: 'Expense 1',
      mobileNo: '1234567890',
      jobCount: '10',
      totalunseenforZerojob: '5',
    ),
    DropdownListModel(
      id: '2',
      name: 'Expense 2',
      mobileNo: '0987654321',
      jobCount: '15',
      totalunseenforZerojob: '3',
    ),
  ].obs;

  RxList<DropdownListModel> cityList = <DropdownListModel>[
    DropdownListModel(
      id: '1',
      name: 'City 1',
      mobileNo: '1234567890',
      jobCount: '5',
      totalunseenforZerojob: '1',
    ),
    DropdownListModel(
      id: '2',
      name: 'City 2',
      mobileNo: '0987654321',
      jobCount: '8',
      totalunseenforZerojob: '2',
    ),
  ].obs;

  RxList<DropdownListModel> areaList = <DropdownListModel>[
    DropdownListModel(
      id: '1',
      name: 'Area 1',
      mobileNo: '1234567890',
      jobCount: '2',
      totalunseenforZerojob: '0',
    ),
    DropdownListModel(
      id: '2',
      name: 'Area 2',
      mobileNo: '0987654321',
      jobCount: '3',
      totalunseenforZerojob: '1',
    ),
  ].obs;
}
