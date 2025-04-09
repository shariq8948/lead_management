import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import 'controller.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.teal.shade700,
                          Colors.teal.shade300,
                        ],
                      ),
                    ),
                    child: Center(
                      child: ElasticIn(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 100,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              backgroundImage: controller.profileImage.value !=
                                      null
                                  ? FileImage(controller.profileImage.value!)
                                  : NetworkImage(
                                      'https://ui-avatars.com/api/?name=${controller.profileData['name']?.replaceAll(' ', '+')}',
                                    ) as ImageProvider,
                            ),
                            if (controller.isEditing.value)
                              Positioned(
                                bottom: 0,
                                right: 100,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt,
                                        color: Colors.blue.shade700, size: 30),
                                    onPressed: controller.pickImage,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Obx(() => IconButton(
                        icon: Icon(
                          controller.isEditing.value ? Icons.save : Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: controller.isEditing.value
                            ? controller.saveProfile
                            : controller.toggleEditMode,
                      )),
                ],
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Profile Name and Email
                    if (!controller.isEditing.value) ...[
                      FadeInUp(
                        child: Center(
                          child: Text(
                            controller.profileData['name'] ?? '',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      FadeInUp(
                        delay: Duration(milliseconds: 200),
                        child: Center(
                          child: Text(
                            controller.profileData['email'] ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      _buildEditTextField(
                        controller: controller.nameController,
                        labelText: 'Name',
                      ),
                      SizedBox(height: 16),
                      _buildEditTextField(
                        controller: controller.emailController,
                        labelText: 'Email',
                      ),
                    ],

                    SizedBox(height: 24),

                    // Skills Section
                    if (!controller.isEditing.value) ...[
                      _buildSkillsChips(),
                    ] else ...[
                      _buildEditTextField(
                        controller: controller.skillsController,
                        labelText: 'Skills',
                        maxLines: 2,
                      ),
                      SizedBox(height: 16),
                    ],

                    // Profile Details
                    if (!controller.isEditing.value) ...[
                      _buildInfoCard(
                        icon: Icons.phone,
                        title: 'Phone',
                        subtitle: controller.profileData['phone'] ?? '',
                      ),
                      _buildInfoCard(
                        icon: Icons.location_on,
                        title: 'Location',
                        subtitle: controller.profileData['location'] ?? '',
                      ),
                      _buildInfoCard(
                        icon: Icons.description,
                        title: 'Bio',
                        subtitle: controller.profileData['bio'] ?? '',
                      ),
                    ] else ...[
                      _buildEditTextField(
                        controller: controller.phoneController,
                        labelText: 'Phone',
                      ),
                      SizedBox(height: 16),
                      _buildEditTextField(
                        controller: controller.locationController,
                        labelText: 'Location',
                      ),
                      SizedBox(height: 16),
                      _buildEditTextField(
                        controller: controller.bioController,
                        labelText: 'Bio',
                        maxLines: 3,
                      ),
                    ],
                  ]),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildSkillsChips() {
    List<String> skills = controller.profileData['skills']?.split(',') ?? [];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills
          .map((skill) => Chip(
                label: Text(skill.trim()),
                backgroundColor: Colors.blue.shade100,
                labelStyle: TextStyle(color: Colors.blue.shade700),
              ))
          .toList(),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return FadeInUp(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 15,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.blue.shade700, size: 30),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ),
    );
  }

  Widget _buildEditTextField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.blue.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
