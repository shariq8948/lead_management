import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../widgets/custom_field.dart';
import '../../widgets/floatingbutton.dart';
import 'add_category.dart';
import 'category_controller.dart';
import 'category_details.dart';

class CategoryListPage extends StatelessWidget {
  CategoryListPage({super.key});
  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Categories",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: Obx(() => Icon(
                    controller.showSearch.value ? Icons.close : Icons.search,
                    color: Colors.black,
                  )),
              onPressed: () => controller.showSearch.toggle(),
            ),
          ],
        ),
        floatingActionButton: CustomFloatingActionButton(
          onPressed: () {
            controller.resetForm();
            Get.to(AddCategoryPage());
          },
          icon: Icons.add,
          tooltip: 'Add Category',
          backgroundColor: Colors.teal,
          iconColor: Colors.white,
          iconSize: 28,
        ),
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value && controller.categories.isEmpty) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  size: 60,
                  color: Colors.teal,
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => controller.fetchCategories(),
              child: Column(
                children: [
                  if (controller.showSearch.value)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomField(
                              labelText: "Search categories",
                              hintText: "Enter category name",
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.search,
                              withShadow: false,
                              editingController: controller.searchController,
                              onChange: (val) {
                                if (controller.debounce?.isActive ?? false) {
                                  controller.debounce?.cancel();
                                }
                                controller.debounce = Timer(
                                  const Duration(
                                      milliseconds: 300), // Debounce time
                                  () {
                                    // Call the searchCategories method when the text changes
                                    controller.searchCategories(val!);
                                  },
                                );
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              controller.searchController.clear();
                              controller.searchVal.value = "";
                              controller.fetchCategories();
                            },
                            child: const Text(
                              "Clear",
                              style: TextStyle(color: Colors.teal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          return categoryCard(
                            code: category.code,
                            categoryName: category.name,
                            underCategory: category.ucategory ?? "N/A",
                            onEdit: () {
                              controller.resetForm();
                              Get.to(AddCategoryPage(catId: category.id));
                            },
                            onDelete: () => showDeleteConfirmation(
                                context, controller, category.id),
                            onView: () => Get.to(() => CategoryDetailPage(),
                                arguments: {'categoryId': category.id}),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget categoryCard({
    required String code,
    required String categoryName,
    required String underCategory,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onView,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onView,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      categoryName.isNotEmpty
                          ? categoryName[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        underCategory,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'Edit') onEdit();
                    if (value == 'Delete') onDelete();
                    if (value == 'View') onView();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'Edit',
                      child: Row(
                        children: const [
                          Icon(Icons.edit, color: Colors.teal, size: 20),
                          SizedBox(width: 12),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Delete',
                      child: Row(
                        children: const [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 12),
                          Text('Delete'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'View',
                      child: Row(
                        children: const [
                          Icon(Icons.visibility, color: Colors.teal, size: 20),
                          SizedBox(width: 12),
                          Text('View'),
                        ],
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showDeleteConfirmation(
    BuildContext context,
    CategoryController controller,
    String categoryId,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Delete Category",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text(
            "Are you sure you want to delete this category? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.deleteCategory(categoryId);
                Navigator.of(context).pop();
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
