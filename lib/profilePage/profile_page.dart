import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:leads/utils/tags.dart';

import 'controller.dart';

class ProfilePage extends StatelessWidget {
  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
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
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: ClipOval(
                              child: controller.isUploadingImage.value
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : controller.profileImage.value != null
                                      ? Image.file(
                                          controller.profileImage.value!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return _buildFallbackAvatar(
                                                controller.getUserName());
                                          },
                                        )
                                      : controller.profileData
                                                      .value['imagePath'] !=
                                                  null &&
                                              controller.profileData
                                                  .value['imagePath']
                                                  .toString()
                                                  .isNotEmpty
                                          ? Image.network(
                                              '${controller.box.read(StorageTags.baseUrl)}${controller.profileData.value['imagePath']}',
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return _buildFallbackAvatar(
                                                    controller.getUserName());
                                              },
                                            )
                                          : _buildFallbackAvatar(
                                              controller.getUserName()),
                            ),
                          ),
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
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Profile Name and Email
                  FadeInUp(
                    child: Center(
                      child: Text(
                        controller.getUserName(),
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
                        controller.getUserEmail(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Profile Details
                  _buildInfoCard(
                    icon: Icons.phone,
                    title: 'Phone',
                    subtitle: controller.getUserMobile(),
                  ),
                  _buildInfoCard(
                    icon: Icons.business,
                    title: 'Company',
                    subtitle: controller.getCompanyName(),
                  ),
                  _buildInfoCard(
                    icon: Icons.category,
                    title: 'Industry',
                    subtitle: controller.getIndustry(),
                  ),
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    title: 'Member Since',
                    subtitle: controller.getJoiningDate(),
                  ),
                  _buildInfoCard(
                    icon: Icons.card_membership,
                    title: 'Subscription',
                    subtitle: controller.getSubscriptionInfo(),
                  ),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFallbackAvatar(String name) {
    return Image.network(
      'https://ui-avatars.com/api/?name=${name.replaceAll(' ', '+')}',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Final fallback if even the avatar generator fails
        return Center(
          child: Icon(
            Icons.account_circle,
            size: 100,
            color: Colors.white,
          ),
        );
      },
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
}
