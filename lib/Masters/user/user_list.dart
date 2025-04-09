import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leads/Masters/user/userlistController.dart';
import 'package:leads/widgets/custom_field.dart';
import 'package:leads/widgets/custom_loader.dart';

import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_select.dart';

class AddUsers extends StatefulWidget {
  AddUsers({super.key});

  @override
  State<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  final UserListController controller = Get.put(UserListController());
  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> arguments = Get.arguments;
    controller.isEdit.value = arguments['isEdit'] ?? false;
    final String id = arguments['id'] ?? "0";

    if (controller.isEdit.value) {
      _fetchUserDetails(id);
    } else {
      controller.clearForm();
    }
  }

  Future<void> _fetchUserDetails(String id) async {
    controller.isLoading.value = false;

    try {
      await controller.fetchUserDetails(id);

      if (controller.userDetail.isNotEmpty) {
        controller.titleController.text =
            controller.userDetail[0].title?.toString() ?? '';
        controller.idController.text =
            controller.userDetail[0].id?.toString() ?? '';
        controller.firstnameController.text =
            controller.userDetail[0].firstName?.toString() ?? '';
        controller.lastnameController.text =
            controller.userDetail[0].lastName?.toString() ?? '';
        controller.mobileController.text =
            controller.userDetail[0].mobile?.toString() ?? '';
        controller.emailController.text =
            controller.userDetail[0].email?.toString() ?? '';
        controller.dobController.text =
            controller.userDetail[0].dob?.toString() ?? '';
        controller.stateController.text =
            controller.userDetail[0].stateID?.toString() ?? '';
        controller.showStateController.text =
            controller.userDetail[0].state?.toString() ?? '';
        controller.cityController.text =
            controller.userDetail[0].city?.toString() ?? '';
        controller.addressController.text =
            controller.userDetail[0].address?.toString() ?? '';
        controller.joiningDateController.text =
            controller.userDetail[0].joiningDate?.toString() ?? '';
        controller.loginController.text =
            controller.userDetail[0].login?.toString() ?? '';
        controller.passwordController.text =
            controller.userDetail[0].password?.toString() ?? '';
        controller.userTypeController.text =
            controller.userDetail[0].userType?.toString() ?? '';
        controller.showcompanyController.text =
            controller.userDetail[0].companyName?.toString() ?? '';
        controller.companyController.text =
            controller.userDetail[0].syscompanyid?.toString() ?? '';
        controller.branchController.text =
            controller.userDetail[0].sysbranchid?.toString() ?? '';
      } else {
        // Handle the case when user details are not available yet
        print('User details not available');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    } finally {
      controller.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: controller.isLoading.value
                ? CustomLoader()
                : buildUserEntryForm(),
          ),
        ),
      )),
    );
  }

  Widget buildUserEntryForm() {
    // State for the selected image in base64 format
    ValueNotifier<String?> base64Image = ValueNotifier<String?>(null);
    ValueNotifier<String> userStatus =
        ValueNotifier<String>("Active"); // State for radio buttons

    Future<void> pickImage(ImageSource source) async {
      try {
        final pickedFile = await ImagePicker().pickImage(source: source);
        if (pickedFile != null) {
          final bytes = await File(pickedFile.path).readAsBytes();
          base64Image.value = "data:image/jpeg;base64," + base64Encode(bytes);
          controller.image.value =
              "data:image/jpeg;base64," + base64Encode(bytes);
        }
      } catch (e) {
        print("Error picking image: $e");
      }
    }

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture Placeholder with Image Picker
          ValueListenableBuilder<String?>(
            valueListenable: base64Image,
            builder: (context, base64String, child) {
              return GestureDetector(
                onTap: () async {
                  await pickImage(ImageSource.gallery);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: base64String != null
                          ? MemoryImage(
                              base64Decode(base64String.split(',').last))
                          : null,
                      child: base64String == null
                          ? const Icon(Icons.person,
                              size: 40, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.edit,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            "EMP344A",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Rest of the form fields (same as before)
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomSelect(
                  mainList: controller.titleItems,
                  onSelect: (selectedItem) {
                    controller.titleController.text = selectedItem.value;
                  },
                  placeholder: 'Select Title',
                  label: 'Title',
                  textEditCtlr: controller.titleController,
                  showLabel: false,
                  filledColor: Colors.white,
                  labelColor: Colors.black,
                  withShadow: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select title";
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: CustomField(
                  hintText: "First Name",
                  labelText: "First name",
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  editingController: controller.firstnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter name";
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: CustomField(
                  hintText: "Last Name",
                  labelText: "Last Name",
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  editingController: controller.lastnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter name";
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomField(
            hintText: "Mobile",
            labelText: "Mobile",
            inputAction: TextInputAction.next,
            inputType: TextInputType.number,
            editingController: controller.mobileController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter valid mobile number";
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomField(
            hintText: "Email",
            labelText: "Email",
            inputAction: TextInputAction.next,
            inputType: TextInputType.emailAddress,
            editingController: controller.emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter Email";
              }

              return null;
            },
          ),
          const SizedBox(height: 16),

          CustomField(
            withShadow: true,
            showIcon: true,
            labelText: "Birt Date",
            hintText: "Birthday",
            customIcon: Icon(Icons.calendar_month),
            inputAction: TextInputAction.done,
            inputType: TextInputType.datetime,
            showLabel: false,
            bgColor: Colors.white,
            enabled: true,
            readOnly: true,
            editingController: controller.dobController,
            // editingController: controller.fromDateController,
            validator: (val) {
              if (val!.isEmpty) {
                return "This field is required";
              }
              return null;
            },
            onFieldTap: () {
              Get.bottomSheet(
                CustomDatePicker(
                  pastAllow: true,
                  confirmHandler: (date) async {
                    controller.dobController.text = date!;
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Obx(
                  () => CustomSelect(
                    label: "Select State",
                    placeholder: "Please select a State",
                    mainList: controller.stateList
                        .map(
                          (element) => CustomSelectItem(
                            id: element.id ?? "",
                            value: element.state ?? "",
                          ),
                        )
                        .toList(),
                    onSelect: (val) async {
                      controller.stateController.text = val.id;
                      controller.showStateController.text = val.value;
                      await controller.fetchCity();
                    },
                    textEditCtlr: controller.showStateController,
                    showLabel: false,
                    onTapField: () {
                      controller.stateController.clear();
                      controller.showStateController.clear();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a state";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Obx(() {
                  return CustomSelect(
                    label: "Select City",
                    placeholder: "Please select city",
                    mainList: controller.cityList
                        .map(
                          (element) => CustomSelectItem(
                            id: element.cityID ?? "",
                            value: element.city ?? "",
                          ),
                        )
                        .toList(),
                    onSelect: (val) async {
                      controller.cityController.text = val.id;
                      controller.showCityController.text = val.value;
                    },
                    textEditCtlr: controller.showCityController,
                    showLabel: false,
                    onTapField: () {
                      controller.cityController.clear();
                      controller.showCityController.clear();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a city";
                      }
                      return null;
                    },
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomField(
            hintText: "Address",
            labelText: "Address",
            inputAction: TextInputAction.next,
            inputType: TextInputType.streetAddress,
            minLines: 2,
            editingController: controller.addressController,
          ),
          const SizedBox(height: 16),
          CustomField(
            withShadow: true,
            showIcon: true,
            labelText: "Date of Joining",
            hintText: "Date Of Joining",
            customIcon: Icon(Icons.calendar_month),
            inputAction: TextInputAction.done,
            inputType: TextInputType.datetime,
            showLabel: false,
            bgColor: Colors.white,
            enabled: true,
            readOnly: true,
            editingController: controller.joiningDateController,
            // editingController: controller.fromDateController,
            validator: (val) {
              if (val!.isEmpty) {
                return "This field is required";
              }
              return null;
            },
            onFieldTap: () {
              Get.bottomSheet(
                CustomDatePicker(
                  pastAllow: true,
                  confirmHandler: (date) async {
                    controller.joiningDateController.text = date!;
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Obx(() {
            return CustomSelect(
              label: "User Type",
              placeholder: " Select User type",
              mainList: controller.usertypeList
                  .map(
                    (element) => CustomSelectItem(
                      id: element.id ?? "",
                      value: element.userType ?? "",
                    ),
                  )
                  .toList(),
              onSelect: (val) async {
                controller.userTypeController.text = val.id;
                controller.showuserTypeController.text = val.value;
              },
              textEditCtlr: controller.showuserTypeController,
              showLabel: false,
              onTapField: () {
                controller.userTypeController.clear();
                controller.showuserTypeController.clear();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select a User Type";
                }
                return null;
              },
            );
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: CustomField(
                  hintText: "Login",
                  labelText: "Login",
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  editingController: controller.loginController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "The Value Is required";
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: CustomField(
                  hintText: "Password",
                  labelText: "Password",
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.visiblePassword,
                  editingController: controller.passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Valid Password";
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            return CustomSelect(
              label: "User Type",
              placeholder: " Select Company",
              mainList: controller.companyList
                  .map(
                    (element) => CustomSelectItem(
                      id: element.id ?? "",
                      value: element.companyName ?? "",
                    ),
                  )
                  .toList(),
              onSelect: (val) async {
                controller.companyController.text = val.id;
                controller.showcompanyController.text = val.value;
              },
              textEditCtlr: controller.showcompanyController,
              showLabel: false,
              onTapField: () {
                controller.companyController.clear();
                controller.showcompanyController.clear();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select company";
                }
                return null;
              },
            );
          }),
          const SizedBox(height: 16),
          Obx(() {
            return CustomSelect(
              label: "User Type",
              placeholder: " Select Branch",
              mainList: controller.branchList
                  .map(
                    (element) => CustomSelectItem(
                      id: element.id ?? "",
                      value: element.branchName ?? "",
                    ),
                  )
                  .toList(),
              onSelect: (val) async {
                controller.branchController.text = val.id;
                controller.showbranchController.text = val.value;
              },
              textEditCtlr: controller.showbranchController,
              showLabel: false,
              onTapField: () {
                controller.branchController.clear();
                controller.showbranchController.clear();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select branch";
                }
                return null;
              },
            );
          }),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: userStatus,
                builder: (context, selectedStatus, child) {
                  return Row(
                    children: [
                      Row(
                        children: [
                          const Text("Active"),
                          Radio<String>(
                            value: "Active",
                            groupValue: selectedStatus,
                            activeColor: Colors.orange,
                            onChanged: (value) {
                              if (value != null) {
                                userStatus.value = value;
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Deactive"),
                          Radio<String>(
                            value: "Deactive",
                            activeColor: Colors.orange,
                            groupValue: selectedStatus,
                            onChanged: (value) {
                              if (value != null) {
                                userStatus.value = value;
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Save Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Save button color
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: controller.isLoading.value
                ? null // Disable the button while loading
                : () async {
                    if (userStatus.value == "Active") {
                      controller.isActive.value = 1;
                    }
                    if (userStatus.value == "Deactive") {
                      controller.isActive.value = 0;
                    }
                    if (controller.formKey.currentState!.validate()) {
                      (controller.isEdit.value)
                          ? await controller.editUser()
                          : await controller.addUser();
                      // Ensure the loading state is managed within addUser
                    }
                    // Perform save operation here
                    print("Saving user data...");
                    print("Selected Status: ${userStatus.value}");
                    print("Profile Image (Base64): ${base64Image.value}");
                  },
            child: Obx(
              () => controller.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    )
                  : const Text(
                      "Save",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          // (Continue the form fields as before)
        ],
      ),
    );
  }
}
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:leads/Masters/user/userlistController.dart';
// import '../../widgets/custom_field.dart';
// import '../../widgets/custom_loader.dart';
// import '../../widgets/custom_date_picker.dart';
// import '../../widgets/custom_select.dart';
//
// class AddUsers extends StatefulWidget {
//   AddUsers({super.key});
//
//   @override
//   State<AddUsers> createState() => _AddUsersState();
// }
//
// class _AddUsersState extends State<AddUsers> {
//   final UserListController controller = Get.put(UserListController());
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//     final Map<String, dynamic> arguments = Get.arguments;
//     controller.isEdit.value = arguments['isEdit'] ?? false;
//     final String id = arguments['id'] ?? "0";
//
//     if (controller.isEdit.value) {
//       _fetchUserDetails(id);
//     } else {
//       controller.clearForm();
//     }
//   }
//
//   Future<void> _fetchUserDetails(String id) async {
//     // ... (keep existing _fetchUserDetails implementation)
//   }
//
//   void _showHelpSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.7,
//         maxChildSize: 0.9,
//         minChildSize: 0.5,
//         builder: (_, controller) => Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           padding: EdgeInsets.all(20),
//           child: ListView(
//             controller: controller,
//             children: [
//               Text(
//                 'Help Guide',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               _buildHelpSection(
//                 'Profile Picture',
//                 'Tap the camera icon to take a photo or choose from gallery',
//                 Icons.camera_alt,
//               ),
//               _buildHelpSection(
//                 'Personal Information',
//                 'Fill in your basic details like name, contact, and address',
//                 Icons.person,
//               ),
//               _buildHelpSection(
//                 'Account Details',
//                 'Set up your login credentials and user type',
//                 Icons.lock,
//               ),
//               _buildHelpSection(
//                 'Company Information',
//                 'Select your company and branch details',
//                 Icons.business,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHelpSection(String title, String description, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.orange.withOpacity(0.2),
//             child: Icon(icon, color: Colors.orange),
//           ),
//           SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final pickedFile = await ImagePicker().pickImage(
//         source: source,
//         imageQuality: 80,
//       );
//       if (pickedFile != null) {
//         final bytes = await File(pickedFile.path).readAsBytes();
//         controller.image.value =
//             "data:image/jpeg;base64," + base64Encode(bytes);
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }
//
//   void _showImagePickerOptions() {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.camera_alt, color: Colors.orange),
//               title: Text('Take a photo'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library, color: Colors.orange),
//               title: Text('Choose from gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Text(
//           controller.isEdit.value ? "Edit User" : "Add New User",
//           style: TextStyle(color: Colors.black87),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.help_outline, color: Colors.orange),
//             onPressed: _showHelpSheet,
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Obx(
//           () => controller.isLoading.value
//               ? CustomLoader()
//               : SingleChildScrollView(
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     child: _buildModernForm(),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildModernForm() {
//     return Form(
//       key: controller.formKey,
//       child: Column(
//         children: [
//           _buildProfileSection(),
//           SizedBox(height: 24),
//           _buildPersonalInfoSection(),
//           SizedBox(height: 24),
//           _buildContactSection(),
//           SizedBox(height: 24),
//           _buildLocationSection(),
//           SizedBox(height: 24),
//           _buildAccountSection(),
//           SizedBox(height: 24),
//           _buildCompanySection(),
//           SizedBox(height: 32),
//           _buildSubmitButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileSection() {
//     return Column(
//       children: [
//         Obx(() => GestureDetector(
//               onTap: _showImagePickerOptions,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: 120,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.grey[200],
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: controller.image.value.isEmpty
//                         ? Icon(Icons.person, size: 50, color: Colors.grey)
//                         : ClipOval(
//                             child: Image.memory(
//                               base64Decode(
//                                 controller.image.value.split(',').last,
//                               ),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.orange,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.camera_alt,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//         SizedBox(height: 12),
//         Text(
//           "EMP344A",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[800],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPersonalInfoSection() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Personal Information',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: CustomSelect(
//                     mainList: controller.titleItems,
//                     onSelect: (selectedItem) {
//                       controller.titleController.text = selectedItem.value;
//                     },
//                     placeholder: 'Title',
//                     label: 'Title',
//                     textEditCtlr: controller.titleController,
//                     showLabel: false,
//                     filledColor: Colors.grey.withOpacity(0.2),
//                     labelColor: Colors.black,
//                     withShadow: false,
//                     validator: (value) =>
//                         value?.isEmpty ?? true ? "Required" : null,
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   flex: 4,
//                   child: _buildModernTextField(
//                     controller: controller.firstnameController,
//                     label: "First Name",
//                     validator: (value) =>
//                         value?.isEmpty ?? true ? "Required" : null,
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   flex: 4,
//                   child: _buildModernTextField(
//                     controller: controller.lastnameController,
//                     label: "Last Name",
//                     validator: (value) =>
//                         value?.isEmpty ?? true ? "Required" : null,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             _buildDateField(
//               controller: controller.dobController,
//               label: "Date of Birth",
//               onTap: () {
//                 Get.bottomSheet(
//                   CustomDatePicker(
//                     pastAllow: true,
//                     confirmHandler: (date) {
//                       controller.dobController.text = date!;
//                     },
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContactSection() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Contact Information',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//             SizedBox(height: 16),
//             _buildModernTextField(
//               controller: controller.mobileController,
//               label: "Mobile Number",
//               keyboardType: TextInputType.phone,
//               prefixIcon: Icons.phone,
//               validator: (value) => value?.isEmpty ?? true ? "Required" : null,
//             ),
//             SizedBox(height: 16),
//             _buildModernTextField(
//               controller: controller.emailController,
//               label: "Email Address",
//               keyboardType: TextInputType.emailAddress,
//               prefixIcon: Icons.email,
//               validator: (value) => value?.isEmpty ?? true ? "Required" : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLocationSection() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Location Details',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: Obx(
//                     () => CustomSelect(
//                       label: "State",
//                       placeholder: "Select State",
//                       mainList: controller.stateList
//                           .map((element) => CustomSelectItem(
//                                 id: element.id ?? "",
//                                 value: element.state ?? "",
//                               ))
//                           .toList(),
//                       onSelect: (val) async {
//                         controller.stateController.text = val.id;
//                         controller.showStateController.text = val.value;
//                         await controller.fetchCity();
//                       },
//                       textEditCtlr: controller.showStateController,
//                       showLabel: false,
//                       filledColor: Colors.grey.withOpacity(0.2),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Obx(
//                     () => CustomSelect(
//                       label: "City",
//                       placeholder: "Select City",
//                       mainList: controller.cityList
//                           .map((element) => CustomSelectItem(
//                                 id: element.cityID ?? "",
//                                 value: element.city ?? "",
//                               ))
//                           .toList(),
//                       onSelect: (val) {
//                         controller.cityController.text = val.id;
//                         controller.showCityController.text = val.value;
//                       },
//                       textEditCtlr: controller.showCityController,
//                       showLabel: false,
//                       filledColor: Colors.grey.withOpacity(0.2),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             _buildModernTextField(
//               controller: controller.addressController,
//               label: "Address",
//               maxLines: 3,
//               prefixIcon: Icons.location_on,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAccountSection() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Account Details',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildModernTextField(
//                     controller: controller.loginController,
//                     label: "Username",
//                     prefixIcon: Icons.person_outline,
//                     validator: (value) =>
//                         value?.isEmpty ?? true ? "Required" : null,
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: _buildModernTextField(
//                     controller: controller.passwordController,
//                     label: "Password",
//                     isPassword: true,
//                     prefixIcon: Icons.lock_outline,
//                     validator: (value) =>
//                         value?.isEmpty ?? true ? "Required" : null,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             _buildDateField(
//               controller: controller.joiningDateController,
//               label: "Joining Date",
//               onTap: () {
//                 Get.bottomSheet(
//                   CustomDatePicker(
//                     pastAllow: true,
//                     confirmHandler: (date) {
//                       controller.joiningDateController.text = date!;
//                     },
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 16),
//             Obx(() => CustomSelect(
//                   label: "User Type",
//                   placeholder: "Select User Type",
//                   mainList: controller.usertypeList
//                       .map((element) => CustomSelectItem(
//                             id: element.id ?? "",
//                             value: element.userType ?? "",
//                           ))
//                       .toList(),
//                   onSelect: (val) {
//                     controller.userTypeController.text = val.id;
//                     controller.showuserTypeController.text = val.value;
//                   },
//                   textEditCtlr: controller.showuserTypeController,
//                   showLabel: false,
//                   filledColor: Colors.grey.withOpacity(0.2),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCompanySection() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Company Information',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//             SizedBox(height: 16),
//             Obx(() => CustomSelect(
//                   label: "Company",
//                   placeholder: "Select Company",
//                   mainList: controller.companyList
//                       .map((element) => CustomSelectItem(
//                             id: element.id ?? "",
//                             value: element.companyName ?? "",
//                           ))
//                       .toList(),
//                   onSelect: (val) {
//                     controller.companyController.text = val.id;
//                     controller.showcompanyController.text = val.value;
//                   },
//                   textEditCtlr: controller.showcompanyController,
//                   showLabel: false,
//                   filledColor: Colors.grey.withOpacity(0.2),
//                 )),
//             SizedBox(height: 16),
//             Obx(() => CustomSelect(
//                   label: "Branch",
//                   placeholder: "Select Branch",
//                   mainList: controller.branchList
//                       .map((element) => CustomSelectItem(
//                             id: element.id ?? "",
//                             value: element.branchName ?? "",
//                           ))
//                       .toList(),
//                   onSelect: (val) {
//                     controller.branchController.text = val.id;
//                     controller.showbranchController.text = val.value;
//                   },
//                   textEditCtlr: controller.showbranchController,
//                   showLabel: false,
//                   filledColor: Colors.grey.withOpacity(0.2),
//                 )),
//             SizedBox(height: 16),
//             _buildStatusToggle(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusToggle() {
//     return Obx(() => Container(
//           padding: EdgeInsets.symmetric(vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Status:',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[700],
//                 ),
//               ),
//               SizedBox(width: 16),
//               ChoiceChip(
//                 label: Text('Active'),
//                 selected: controller.isActive.value == 1,
//                 selectedColor: Colors.green[100],
//                 onSelected: (bool selected) {
//                   if (selected) controller.isActive.value = 1;
//                 },
//               ),
//               SizedBox(width: 8),
//               ChoiceChip(
//                 label: Text('Inactive'),
//                 selected: controller.isActive.value == 0,
//                 selectedColor: Colors.red[100],
//                 onSelected: (bool selected) {
//                   if (selected) controller.isActive.value = 0;
//                 },
//               ),
//             ],
//           ),
//         ));
//   }
//
//   Widget _buildSubmitButton() {
//     return Container(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.orange,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(25),
//           ),
//           elevation: 4,
//         ),
//         onPressed: controller.isLoading.value
//             ? null
//             : () async {
//                 if (controller.formKey.currentState!.validate()) {
//                   controller.isEdit.value
//                       ? await controller.editUser()
//                       : await controller.addUser();
//                 }
//               },
//         child: Obx(
//           () => controller.isLoading.value
//               ? SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2.0,
//                   ),
//                 )
//               : Text(
//                   controller.isEdit.value ? "Update" : "Create Account",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildModernTextField({
//     required TextEditingController controller,
//     required String label,
//     IconData? prefixIcon,
//     bool isPassword = false,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon:
//             prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
//         filled: true,
//         fillColor: Colors.grey[50],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.orange, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.red, width: 1),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.red, width: 2),
//         ),
//       ),
//       validator: validator,
//     );
//   }
//
//   Widget _buildDateField({
//     required TextEditingController controller,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return TextFormField(
//       controller: controller,
//       readOnly: true,
//       onTap: onTap,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(Icons.calendar_today, color: Colors.grey),
//         filled: true,
//         fillColor: Colors.grey[50],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.orange, width: 2),
//         ),
//       ),
//     );
//   }
// }
