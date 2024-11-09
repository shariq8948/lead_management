import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/leadlist/lead_list_page.dart';



class CustomDrawer extends StatelessWidget {
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
                  Text("MR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Rajasthan Aushdhalayas Pvt. Ltd.", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            DrawerItem(icon: Icons.home, label: "Home", onTap: () => _navigateToHome(context)),
            _buildDivider(),
            // Masters Section
            ExpandableDrawerItem(
              icon: Icons.people,
              label: "Masters",
              duration: Duration(milliseconds: 1000),
              children: [
                ExpandableDrawerItem(
                  icon: Icons.public,
                  label: "Geographical",
                  children: [
                    DrawerSubItem(label: "Category Entry", onTap: () {}, icon: Icons.category),
                    DrawerSubItem(label: "Customer Entry", onTap: () {}, icon: Icons.person_add),
                  ],
                ),
                DrawerSubItem(label: "Category Entry", onTap: () => _navigateToSubItem1(context), icon: Icons.list),
                DrawerSubItem(label: "Customer Entry", onTap: () => _navigateToSubItem2(context), icon: Icons.group_add),
                DrawerSubItem(label: "Payment Mode", onTap: () => _navigateToSubItem2(context), icon: Icons.payment),
                DrawerSubItem(label: "Product Entry", onTap: () => _navigateToSubItem2(context), icon: Icons.add_shopping_cart),
                DrawerSubItem(label: "Add User Type", onTap: () => _navigateToSubItem2(context), icon: Icons.person_add_alt),
                DrawerSubItem(label: "Users", onTap: () => _navigateToSubItem2(context), icon: Icons.supervised_user_circle),
                DrawerSubItem(label: "User Mapping", onTap: () => _navigateToSubItem2(context), icon: Icons.map),
                DrawerSubItem(label: "Manager/Coordinator Mapping", onTap: () => _navigateToSubItem2(context), icon: Icons.admin_panel_settings),
                DrawerSubItem(label: "Monthly Target", onTap: () => _navigateToSubItem2(context), icon: Icons.tablet),
                DrawerSubItem(label: "Product Target", onTap: () => _navigateToSubItem2(context), icon: Icons.local_offer),
                DrawerSubItem(label: "Access Manager", onTap: () => _navigateToSubItem2(context), icon: Icons.lock),
                DrawerSubItem(label: "Expense Type", onTap: () => _navigateToSubItem2(context), icon: Icons.money),
                DrawerSubItem(label: "Incomplete Customers", onTap: () => _navigateToSubItem2(context), icon: Icons.error),
              ],
            ),
            _buildDivider(),
            // Sales Section
            ExpandableDrawerItem(
              icon: Icons.shopping_cart,
              label: "Sales",
              children: [
                DrawerSubItem(label: "Quotation", onTap: () => _navigateToSubItem1(context), icon: Icons.picture_as_pdf),
                DrawerSubItem(label: "Quotation Follow Up", onTap: () => _navigateToSubItem2(context), icon: Icons.follow_the_signs),
                DrawerSubItem(label: "Order List", onTap: () => _navigateToSubItem2(context), icon: Icons.list_alt),
                DrawerSubItem(label: "Order Now", onTap: () => _navigateToSubItem2(context), icon: Icons.add_shopping_cart),
              ],
            ),
            _buildDivider(),
            // Other Drawer Items
            DrawerItem(icon: Icons.contact_phone, label: "Contacts", onTap: () => _navigateToAttendance(context)),
            _buildDivider(),
            DrawerItem(icon: Icons.assessment, label: "Lead List", onTap: () => Get.to(LeadListPage())),
            _buildDivider(),
            DrawerItem(icon: Icons.campaign, label: "Campaign", onTap: () => _navigateToAttendance(context)),
            _buildDivider(),
            DrawerItem(icon: Icons.task, label: "My Task", onTap: () => _navigateToAttendance(context)),
            _buildDivider(),
            ExpandableDrawerItem(
              icon: Icons.security,
              label: "Authorization",
              children: [
                DrawerSubItem(label: "Expenses", onTap: () => _navigateToSubItem1(context), icon: Icons.attach_money),
                DrawerSubItem(label: "Payment", onTap: () => _navigateToSubItem2(context), icon: Icons.payment),
                DrawerSubItem(label: "Planner", onTap: () => _navigateToSubItem2(context), icon: Icons.calendar_today),
                DrawerSubItem(label: "Pending Order for Approval", onTap: () => _navigateToSubItem2(context), icon: Icons.pending),
              ],
            ),
            _buildDivider(),
            ExpandableDrawerItem(
              icon: Icons.more_horiz,
              label: "More",
              children: [
                DrawerSubItem(label: "Client History", onTap: () => _navigateToSubItemA(context), icon: Icons.history),
                DrawerSubItem(label: "Expenses", onTap: () => _navigateToSubItemB(context), icon: Icons.attach_money),
                DrawerSubItem(label: "Payment Collection", onTap: () => _navigateToSubItemB(context), icon: Icons.payment),
              ],
            ),
            _buildDivider(),
            DrawerItem(icon: Icons.analytics, label: "Lead Center", onTap: () => _navigateToAttendance(context)),
            _buildDivider(),
            ExpandableDrawerItem(
              icon: Icons.report,
              label: "Reports",
              children: [
                ExpandableDrawerItem(label: 'Payment Reports', icon: Icons.money, children: [
                  DrawerSubItem(label: "Sub-item A", onTap: () => _navigateToSubItemA(context), icon: Icons.description),
                ]),
                _buildDivider(),
                ExpandableDrawerItem(label: 'Expense Reports', icon: Icons.money_off, children: [
                  DrawerSubItem(label: "Sub-item A", onTap: () => _navigateToSubItemA(context), icon: Icons.description),
                ]),
                _buildDivider(),
                ExpandableDrawerItem(label: 'Marketing Reports', icon: Icons.trending_up, children: [
                  DrawerSubItem(label: "Sub-item A", onTap: () => _navigateToSubItemA(context), icon: Icons.description),
                ]),
                _buildDivider(),
                ExpandableDrawerItem(label: 'Order Reports', icon: Icons.receipt, children: [
                  DrawerSubItem(label: "Sub-item A", onTap: () => _navigateToSubItemA(context), icon: Icons.description),
                ]),
                _buildDivider(),
                DrawerSubItem(label: "Daily Attendance", onTap: () => _navigateToSubItemA(context), icon: Icons.access_time),
                DrawerSubItem(label: "Pipeline Report", onTap: () => _navigateToSubItemB(context), icon: Icons.timeline),
                DrawerSubItem(label: "Performance Report", onTap: () => _navigateToSubItemB(context), icon: Icons.assessment),
                DrawerSubItem(label: "Login History", onTap: () => _navigateToSubItemB(context), icon: Icons.history),
              ],
            ),
            _buildDivider(),
            DrawerItem(icon: Icons.analytics, label: "Lead Center", onTap: () => _navigateToAttendance(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: Get.size.width * 0.031, right: Get.size.width * 0.031),
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
   Get.toNamed("leadlist");
  }

  void _navigateToSubItem1(BuildContext context) {
    Navigator.pop(context);
    // Navigate to Sub-item 1
  }

  void _navigateToSubItem2(BuildContext context) {
    Navigator.pop(context);
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

  const DrawerItem({required this.icon, required this.label, required this.onTap});

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
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.teal),
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

  const DrawerSubItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal, size: 20), // Smaller icon for sub-items
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
