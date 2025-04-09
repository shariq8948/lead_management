import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Authorization/expenses/expenseList.dart';
import 'package:leads/Authorization/payements/payementListPage.dart';
import 'package:leads/Masters/PayementMode/payement_mode_list.dart';
import 'package:leads/More/expenses.dart';
import 'package:leads/More/payementApproval.dart';
import 'package:leads/auth/login/login_controller.dart';
import 'package:leads/contactimport/importpage.dart';
import 'package:leads/contacts/contactspage.dart';

import '../Authorization/pendingpayements/pendingList.dart';
import '../Masters/Target/monthlyTarget/target_list_page.dart';
import '../Masters/Target/productTarget/product_target_list.dart';
import '../Masters/category/category_list_page.dart';
import '../Masters/customerList/customer_list_page.dart';
import '../Masters/user/Users_List.dart';
import '../Quotation/QuotationEntry/quotation_entry_page.dart';
import '../Quotation/QuotationFollowUp/followuppage.dart';
import '../Reports/reports_grid/reports_grid_page.dart';
import '../attendance/attendance_page.dart';
import '../chats/users/screen.dart';
import '../help/help_page.dart';
import '../lead_center/lead_center_page.dart';
import '../leads/leadlist/lead_list_page.dart';
import '../master-reports/constants/main_dashboard/views/main_dashboard.dart';
import '../mytask/mytaskpage.dart';
import '../profilePage/profile_page.dart';
import '../utils/map_demo.dart';
import '../utils/routes.dart';

class CustomDrawer extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFE1FFED)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("MR",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Rajasthan Aushdhalayas Pvt. Ltd.",
                      style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            DrawerItem(
                icon: Icons.home,
                label: "Home",
                onTap: () => _navigateToHome(context)),
            _buildDivider(),
            // Masters Section
            ExpandableDrawerItem(
              icon: Icons.people,
              label: "Masters",
              duration: Duration(milliseconds: 800),
              children: [
                DrawerSubItem(
                    label: "Category Entry",
                    onTap: () {
                      Get.to(() => CategoryListPage());
                    },
                    // onTap: () => Get.to(CategoryListPage()),
                    icon: Icons.list),
                DrawerSubItem(
                    label: "Customer Entry",
                    onTap: () => _navigatoCustomerEntry(),
                    icon: Icons.group_add),
                DrawerSubItem(
                    label: "Payment Mode",
                    onTap: () => Get.to(PaymentModePage()),
                    icon: Icons.payment),
                DrawerSubItem(
                    label: "Product Entry",
                    onTap: () => _navigatoProductEntry(),
                    icon: Icons.add_shopping_cart),
                DrawerSubItem(
                    label: "Add User Type",
                    onTap: () => Get.to(UsersListPage()),
                    icon: Icons.person_add_alt),
                DrawerSubItem(
                    label: "Monthly Target",
                    onTap: () => Get.to(TargetListPage()),
                    icon: Icons.tablet),
                DrawerSubItem(
                    label: "Product Target",
                    onTap: () => Get.to(ProductTargetList()),
                    icon: Icons.local_offer),
              ],
            ),
            _buildDivider(),
            // Sales Section
            ExpandableDrawerItem(
              icon: Icons.shopping_cart,
              label: "Sales",
              children: [
                DrawerSubItem(
                    label: "Quotation",
                    onTap: () => _navigatoQuotationEntry(),
                    icon: Icons.picture_as_pdf),
                DrawerSubItem(
                    label: "Quotation Follow Up",
                    onTap: () => _navigateToSubItem2(context),
                    icon: Icons.follow_the_signs),
                DrawerSubItem(
                    label: "Order List",
                    onTap: () => Get.toNamed(Routes.ORDERS_LIST),
                    icon: Icons.list_alt),
                DrawerSubItem(
                    label: "Order Now",
                    onTap: () => navigateToOrderNow(context),
                    icon: Icons.add_shopping_cart),
              ],
            ),
            _buildDivider(),
            // Other Drawer Items
            DrawerItem(
                icon: Icons.contact_phone,
                label: "Contacts",
                onTap: () => _navigateToAttendance(context)),
            _buildDivider(),
            DrawerItem(
                icon: Icons.assessment,
                label: "Lead List",
                onTap: () => Get.toNamed('/lead-list')),
            _buildDivider(),
            DrawerItem(
                icon: Icons.campaign,
                label: "Attendance",
                onTap: () => navigateToCampaign(context)),
            _buildDivider(),
            DrawerItem(
                icon: Icons.task,
                label: "My Task",
                onTap: () => Get.to(CalendarPage())),
            _buildDivider(),
            ExpandableDrawerItem(
              icon: Icons.security,
              label: "Authorization",
              children: [
                DrawerSubItem(
                    label: "Expenses",
                    onTap: () => navigateToExpenseAuthorization(context),
                    icon: Icons.attach_money),
                DrawerSubItem(
                    label: "Payment",
                    onTap: () => navigateToPayementAuthorization(context),
                    icon: Icons.payment),
                DrawerSubItem(
                    label: "Planner",
                    onTap: () => _navigateToSubItem2(context),
                    icon: Icons.calendar_today),
                DrawerSubItem(
                    label: "Pending Order for Approval",
                    onTap: () => _navigatePendingOrder(context),
                    icon: Icons.pending),
              ],
            ),
            _buildDivider(),
            ExpandableDrawerItem(
              icon: Icons.more_horiz,
              label: "More",
              children: [
                DrawerSubItem(
                    label: "Client History",
                    onTap: () => _navigateToSubItemA(context),
                    icon: Icons.history),
                DrawerSubItem(
                    label: "Expenses",
                    onTap: () => _navigateExpenseEntry(),
                    icon: Icons.attach_money),
                DrawerSubItem(
                    label: "Payment Collection",
                    onTap: () => navigateTopayementCollection(context),
                    icon: Icons.payment),
              ],
            ),
            _buildDivider(),
            DrawerItem(
                icon: Icons.analytics,
                label: "Lead Center",
                onTap: () => Get.to(() => LeadCenterPage())),
            _buildDivider(),
            DrawerItem(
                icon: Icons.analytics,
                label: "Maps",
                onTap: () => Get.to(LiveMapScreen())),
            _buildDivider(),

            DrawerItem(
                icon: Icons.analytics,
                label: "Reports",
                onTap: () => Get.to(ReportsDashboardScreen())),
            _buildDivider(),

            DrawerItem(
                icon: Icons.analytics,
                label: "Profile",
                onTap: () => Get.to(ProfilePage())),
            DrawerItem(
                icon: Icons.login_outlined,
                label: "Log Out",
                onTap: () => controller.logout()),
            DrawerItem(
                icon: Icons.help_center_outlined,
                label: "Help",
                onTap: () => Get.to(HelpPage())),
            DrawerItem(
                icon: Icons.contact_mail_outlined,
                label: "Import Contact",
                onTap: () => Get.toNamed(Routes.CONTACT_IMPORT)),
            DrawerItem(
                icon: Icons.contact_mail_outlined,
                label: "Import Excel",
                onTap: () => Get.toNamed(Routes.EXCEL_IMPORT)),
            DrawerItem(
                icon: Icons.contact_mail_outlined,
                label: "Chat",
                onTap: () => Get.to(CustomersScreen())),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.only(
          left: Get.size.width * 0.031, right: Get.size.width * 0.031),
      child: Divider(
        color: Colors.teal.withOpacity(0.3),
        thickness: 1,
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pop(context); // Close the drawer
    // Add navigation logic to Home page
  }

  void _navigateToAttendance(BuildContext context) {
    Get.to(ContactsPage());
  }

  void _navigateExpenseEntry() {
    Get.to(AddExpense());
  }

  void _navigatoCustomerEntry() {
    Get.to(CustomerListPage());
  }

  void _navigatoProductEntry() {
    Get.toNamed(
      Routes.productList,
    );
  }

  void _navigatoQuotationEntry() {
    Get.to(QuotationEntryPage());
  }

  void _navigateToSubItem2(BuildContext context) {
    Get.to(QuotationFollowUpPage());
    // Navigate to Sub-item 2
  }

  void _navigatePendingOrder(BuildContext context) {
    Get.to(PendingOrdersPage());
    // Navigate to Sub-item 2
  }

  void navigateToOrderNow(BuildContext context) {
    Get.toNamed(Routes.PRODUCT_ORDERS);
    // Navigate to Sub-item 2
  }

  void navigateTopayementCollection(BuildContext context) {
    Get.to(Payementapproval());
    // Navigate to Sub-item 2
  }

  void navigateToCampaign(BuildContext context) {
    Get.to(AttendancePage());
    // Navigate to Sub-item 2
  }

  void navigateToExpenseAuthorization(BuildContext context) {
    Get.to(ExpenseListPage());
    // Navigate to Sub-item 2
  }

  void navigateToPayementAuthorization(BuildContext context) {
    Get.to(PaymentsView());
    // Navigate to Sub-item 2
  }

  void _navigateToSubItemA(BuildContext context) {
    Navigator.pop(context);
    // Navigate to Sub-item A
  }

  void _navigateToSubItemB(BuildContext context) {
    Navigator.pop(context);
    // Navigate to Sub-item B
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DrawerItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(label, style: TextStyle(color: Colors.black)),
      onTap: onTap,
    );
  }
}

class ExpandableDrawerItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<Widget> children;
  final Duration duration; // New parameter for duration

  const ExpandableDrawerItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.children,
    this.duration = const Duration(milliseconds: 600), // Default duration
  }) : super(key: key);

  @override
  _ExpandableDrawerItemState createState() => _ExpandableDrawerItemState();
}

class _ExpandableDrawerItemState extends State<ExpandableDrawerItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration, // Use the provided duration
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.teal),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(widget.icon, color: Colors.teal),
              title: Text(
                widget.label,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Icon(
                _isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                color: Colors.teal,
              ),
              onTap: _toggle,
            ),
            SizeTransition(
              sizeFactor: _animation,
              child: Column(
                children: [
                  Divider(color: Colors.teal.withOpacity(0.3), thickness: 1),
                  ...widget.children,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerSubItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DrawerSubItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListTile(
        leading: Icon(icon,
            color: Colors.teal, size: 20), // Smaller icon for sub-items
        title: Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Colors.grey.shade200,
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        visualDensity: VisualDensity.compact, // Adjust spacing
      ),
    );
  }
}
