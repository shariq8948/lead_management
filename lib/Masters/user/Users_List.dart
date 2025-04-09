import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';
import 'package:leads/Masters/user/user_list.dart';
import 'package:leads/Masters/user/userlistController.dart';
import 'package:leads/widgets/floatingbutton.dart';

class UsersListPage extends StatelessWidget {
  final UserListController controller = Get.put(UserListController());
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Management",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: Colors.black),
            onPressed: () => _showFilterDialog(Get.context!),
          ),
        ],
      ),
      // backgroundColor: Color(0xFFF4F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: Obx(() => controller.isLoading.value
                  ? Center(child: CircularProgressIndicator(color: Colors.teal))
                  : _buildUsersList()),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
          onPressed: () =>
              Get.to(() => AddUsers(), arguments: {'isEdit': false}),
          icon: Icons.add),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Users Management',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.teal,
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: Colors.teal),
            onPressed: () => _showFilterDialog(Get.context!),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => controller.searchUsers(value),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search users...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.teal),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.teal),
            onPressed: () {
              searchController.clear();
              controller.searchUsers('');
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.filteredUsers.length,
        itemBuilder: (context, index) {
          final user = controller.filteredUsers[index];
          return OpenContainer(
            closedBuilder: (context, action) => UserCard(
              name: user.username,
              email: user.email,
              phone: user.mobile,
              role: user.login,
              id: user.id,
            ),
            openBuilder: (context, action) => UserDetailView(user.id),
            transitionType: ContainerTransitionType.fadeThrough,
          );
        },
      ),
    );
  }

  // Widget _buildAddUserButton() {
  //   return FloatingActionButton.extended(
  //     onPressed: () => Get.to(() => AddUsers(), arguments: {'isEdit': false}),
  //     backgroundColor: Colors.teal,
  //     icon: Icon(Icons.add, color: Colors.white),
  //     label: Text(
  //       'Add User',
  //       style: GoogleFonts.poppins(
  //         fontWeight: FontWeight.w600,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Users',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('All Users', style: GoogleFonts.poppins()),
              leading: Icon(Icons.people, color: Colors.teal),
              onTap: () {
                controller.filterByRole('all');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Admins', style: GoogleFonts.poppins()),
              leading: Icon(Icons.admin_panel_settings, color: Colors.teal),
              onTap: () {
                controller.filterByRole('Admin');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Regular Users', style: GoogleFonts.poppins()),
              leading: Icon(Icons.person, color: Colors.teal),
              onTap: () {
                controller.filterByRole('User');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget UserDetailView(String id) {
    controller.fetchUserDetails(id);
    return Scaffold(
      backgroundColor: Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.teal),
            onPressed: () => Get.to(() => AddUsers(),
                arguments: {'isEdit': true, 'id': controller.userDetail[0].id}),
          ),
        ],
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: controller.userDetail[0].login == "Admin"
                      ? Colors.teal
                      : Colors.teal,
                  child: Text(
                    controller.userDetail[0].username![0].toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  controller.userDetail[0].username!,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.teal,
                  ),
                ),
                Text(
                  controller.userDetail[0].login!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 30),
                _buildDetailRow(
                  icon: Icons.email,
                  title: 'Email',
                  subtitle: controller.userDetail[0].email!,
                ),
                _buildDetailRow(
                  icon: Icons.phone,
                  title: 'Phone',
                  subtitle: controller.userDetail[0].mobile!,
                ),
                SizedBox(height: 30),
                _buildDetailRow(
                  icon: Icons.man,
                  title: 'First Name',
                  subtitle: controller.userDetail[0].firstName ?? "",
                ),
                SizedBox(height: 30),
                _buildDetailRow(
                  icon: Icons.man,
                  title: 'Last  Name',
                  subtitle: controller.userDetail[0].lastName ?? "",
                ),
                SizedBox(height: 30),
                _buildDetailRow(
                  icon: Icons.person,
                  title: 'Title',
                  subtitle: controller.userDetail[0].title ?? "",
                ),
                SizedBox(height: 30),
                _buildDetailRow(
                  icon: Icons.calendar_month_outlined,
                  title: 'Date Of Joining',
                  subtitle: controller.userDetail[0].joiningDate ?? "",
                ),
                SizedBox(height: 30),
                _buildDetailRow(
                  icon: Icons.supervised_user_circle_outlined,
                  title: 'User Type',
                  subtitle: controller.userDetail[0].usertypename ?? "",
                ),
                SizedBox(height: 30),
                _buildDetailRow(
                  icon: Icons.location_city,
                  title: 'State',
                  subtitle: controller.userDetail[0].state ?? "",
                ),
                SizedBox(height: 30),
                _buildDetailRow(
                  icon: Icons.factory_outlined,
                  title: 'City',
                  subtitle: controller.userDetail[0].city ?? "",
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String role;
  final String id;

  const UserCard({
    Key? key,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: role == "Admin" ? Colors.teal : Colors.teal,
          child: Text(
            name[0].toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          email,
          style: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: role == "Admin"
                ? Colors.teal.withOpacity(0.1)
                : Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            role,
            style: GoogleFonts.poppins(
              color: role == "Admin" ? Colors.teal : Colors.teal,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
