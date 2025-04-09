import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'grid_report_controller.dart';

class SubcategoriesController extends GetxController {
  final searchController = TextEditingController();
  final isSearching = false.obs;
  final subcategories = <Subcategory>[].obs;
  final filteredSubcategories = <Subcategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with passed subcategories
    subcategories.value = List<Subcategory>.from(Get.arguments as List);
    filteredSubcategories.value = subcategories;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      filteredSubcategories.value = subcategories;
    }
  }

  void filterSubcategories(String query) {
    if (query.isEmpty) {
      filteredSubcategories.value = subcategories;
    } else {
      filteredSubcategories.value = subcategories
          .where((subcategory) =>
              subcategory.label.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}

class SubcategoriesPage extends StatelessWidget {
  final controller = Get.put(SubcategoriesController());

  SubcategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Obx(() => controller.isSearching.value
            ? _buildSearchField()
            : const Text(
                'Subcategories',
                style: TextStyle(fontWeight: FontWeight.w600),
              )),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                controller.isSearching.value ? Icons.close : Icons.search)),
            onPressed: () {
              controller.toggleSearch();
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (String value) {
              // Implement sorting functionality
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'name',
                child: Text('Sort by Name'),
              ),
              const PopupMenuItem(
                value: 'recent',
                child: Text('Sort by Recent'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Category Summary
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.folder_open,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Items',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Obx(() => Text(
                                '${controller.filteredSubcategories.length} Subcategories',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grid View
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(
                  () => controller.filteredSubcategories.isEmpty
                      ? _buildNoResultsFound()
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: controller.filteredSubcategories.length,
                          itemBuilder: (context, index) {
                            final subcategory =
                                controller.filteredSubcategories[index];
                            return _buildSubcategoryCard(context, subcategory);
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: controller.searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search subcategories...',
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        controller.filterSubcategories(value);
      },
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoryCard(BuildContext context, Subcategory subcategory) {
    return InkWell(
      onTap: subcategory.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    subcategory.icon,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subcategory.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
