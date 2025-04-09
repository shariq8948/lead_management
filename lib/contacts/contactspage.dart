import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:leads/utils/routes.dart';
import 'package:leads/widgets/customActionbutton.dart';
import 'package:leads/widgets/custom_field.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Masters/Customer_entry/customer_entry_page.dart';
import '../data/models/dropdown_list.model.dart';
import '../widgets/custom_states.dart';
import 'Detailspage.dart';
import 'contactsController.dart';

class ContactsPage extends StatelessWidget {
  ContactsPage({Key? key}) : super(key: key);

  final ScrollController _customerScrollController = ScrollController();
  final ScrollController _prospectScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final ContactController controller = Get.put(ContactController());
    _initializeScrollListeners(controller);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                ],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildCustomerSection(controller),
                      _buildProspectSection(controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Contacts",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          letterSpacing: 0.5,
        ),
      ),
      bottom: TabBar(
        indicatorColor: Theme.of(context).colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        tabs: [
          Tab(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people),
                  SizedBox(width: 8),
                  Text("Customers"),
                ],
              ),
            ),
          ),
          Tab(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up),
                  SizedBox(width: 8),
                  Text("Prospects"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(String hintText, void Function(String) onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCustomerSection(ContactController controller) {
    return Column(
      children: [
        _buildSearchBar(
          'Search customers by name, city or contact...',
          (value) => controller.searchCustomers(value),
        ),
        Expanded(
          child: _buildCustomerTab(controller),
        ),
      ],
    );
  }

  Widget _buildProspectSection(ContactController controller) {
    return Column(
      children: [
        _buildSearchBar(
          'Search prospects by name, city or contact...',
          (value) => controller.searchProspects(value),
        ),
        Expanded(
          child: _buildProspectTab(controller),
        ),
      ],
    );
  }

  Widget _buildCustomerTab(ContactController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshCustomers(),
      child: Obx(() {
        if (controller.isError.value) {
          return ErrorState(
            message: controller.errorMessage.value,
            onRetry: () => controller.fetchCustomers(),
          );
        }

        if (controller.isLoading.value && controller.customerData.isEmpty) {
          return Center(child: CustomLoader());
        }

        if (controller.customerData.isEmpty) {
          return EmptyState(
            icon: Icons.people_outline,
            message: "No customers found",
            buttonText: "Add Customer",
            onAction: () => _addNewContact(Get.context!),
          );
        }

        return ListView.builder(
          controller: _customerScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.customerData.length +
              (controller.hasMoreCustomers.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.customerData.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CustomLoader()),
              );
            }

            final customer = controller.customerData[index];
            return _buildContactCard(customer, controller, context);
          },
        );
      }),
    );
  }

  Widget _buildProspectTab(ContactController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshProspects(),
      child: Obx(() {
        if (controller.isError.value) {
          return ErrorState(
            message: controller.errorMessage.value,
            onRetry: () => controller.fetchProspect(),
          );
        }

        if (controller.isLoading.value && controller.prospectData.isEmpty) {
          return Center(child: CustomLoader());
        }

        if (controller.prospectData.isEmpty) {
          return EmptyState(
            icon: Icons.people_outline,
            message: "No prospects found",
            buttonText: "Add Prospect",
            onAction: () => _addNewContact(Get.context!),
          );
        }

        return ListView.builder(
          controller: _prospectScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.prospectData.length +
              (controller.hasMoreProspects.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.prospectData.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CustomLoader()),
              );
            }

            final prospect = controller.prospectData[index];
            return _buildContactCard(prospect, controller, context);
          },
        );
      }),
    );
  }

  Widget _buildContactCard(
    CustomerResponseModel contact,
    ContactController controller,
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            print("this is id ${contact.id}");
            Get.to(() => Detailspage(), arguments: contact.id);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      child: Text(
                        contact.name?[0] ?? "?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.name ?? "Unknown",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                          ),
                          if (contact.city != null || contact.state != null)
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      size: 14, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    [contact.city, contact.state]
                                        .where((e) => e != null)
                                        .join(", "),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildContactInfo(contact, context),
                SizedBox(height: 16),
                _buildContactActions(contact, context, controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(dynamic contact, BuildContext context) {
    return Column(
      children: [
        if (contact.mobile != null)
          _buildInfoRow(
            icon: 'assets/icons/phone.svg',
            value: contact.mobile,
            context: context,
          ),
        if (contact.email != null)
          _buildInfoRow(
            icon: 'assets/icons/mails.svg',
            value: contact.email,
            context: context,
          ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String icon,
    required String value,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 16,
            height: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[800],
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactActions(
    dynamic contact,
    BuildContext context,
    ContactController controller,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.call,
            label: 'Call',
            color: Colors.blue,
            onPressed: () => _handleCall(contact, context, controller),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            icon: Icons.message,
            label: 'WhatsApp',
            color: Colors.green,
            onPressed: () => _handleWhatsApp(contact, context, controller),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            icon: Icons.email,
            label: 'Email',
            color: Colors.purple,
            onPressed: () => _handleEmail(contact, context, controller),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _addNewContact(context),
      icon: Icon(Icons.add),
      label: Text('Add Contact'),
      elevation: 4,
    );
  }

  void _initializeScrollListeners(ContactController controller) {
    _customerScrollController.addListener(() {
      if (_customerScrollController.position.pixels >=
          _customerScrollController.position.maxScrollExtent - 200) {
        controller.fetchCustomers(isInitialFetch: false);
      }
    });

    _prospectScrollController.addListener(() {
      if (_prospectScrollController.position.pixels >=
          _prospectScrollController.position.maxScrollExtent - 200) {
        controller.fetchProspect(isInitialFetch: false);
      }
    });
  }

  void _addNewContact(BuildContext context) {
    Get.toNamed(Routes.CUSTOMER_ENTRY);
    // Get.to(() => CustomerEntryForm());
  }

  Future<void> _handleCall(
    dynamic contact,
    BuildContext context,
    ContactController controller,
  ) async {
    if (contact.mobile == null || contact.mobile.isEmpty) {
      _showUpdateDialog(
        context: context,
        title: "No Phone Number",
        message: "No phone number found. Would you like to add one?",
        contact: contact,
        controller: controller,
      );
      return;
    }

    try {
      final url = 'tel:${contact.mobile}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch phone';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not make the call. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _handleWhatsApp(
    dynamic contact,
    BuildContext context,
    ContactController controller,
  ) async {
    if (contact.mobile == null || contact.mobile.isEmpty) {
      _showUpdateDialog(
        context: context,
        title: "No Phone Number",
        message: "No phone number found. Would you like to add one?",
        contact: contact,
        controller: controller,
      );
      return;
    }

    try {
      // Format phone number for WhatsApp (remove spaces and add country code if needed)
      String phoneNumber = contact.mobile.replaceAll(RegExp(r'\s+'), '');
      if (!phoneNumber.startsWith('+')) {
        phoneNumber =
            '+91$phoneNumber'; // Assuming Indian numbers, adjust as needed
      }

      final url = 'https://wa.me/$phoneNumber';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open WhatsApp. Please make sure it is installed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _handleEmail(
    dynamic contact,
    BuildContext context,
    ContactController controller,
  ) async {
    if (contact.email == null || contact.email.isEmpty) {
      _showUpdateDialog(
        context: context,
        title: "No Email Address",
        message: "No email address found. Would you like to add one?",
        contact: contact,
        controller: controller,
      );
      return;
    }

    try {
      final url = 'mailto:${contact.email}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch email';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open email app. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showUpdateDialog({
    required BuildContext context,
    required String title,
    required String message,
    required dynamic contact,
    required ContactController controller,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Get.dialog(
                  Dialog(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize
                              .min, // Ensures it takes only needed space
                          children: [
                            CustomField(
                              hintText: "Enter Mobile Number",
                              labelText: "Mobile Number",
                              inputAction: TextInputAction.next,
                              inputType: TextInputType.text,
                              editingController: controller.mobileController,
                            ),
                            SizedBox(height: 16), // Adds spacing
                            CustomActionButton(
                              type: CustomButtonType.save,
                              onPressed: () {
                                print(contact.id);
                              },
                              label: "Save",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
