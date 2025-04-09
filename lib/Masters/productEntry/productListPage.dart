import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Masters/productEntry/productListController.dart';
import 'package:leads/Masters/productEntry/product_details_page.dart';
import 'package:leads/utils/tags.dart';
import 'package:leads/widgets/floatingbutton.dart';

import '../../data/models/product.dart';
import '../../utils/routes.dart';

class ProductListPage extends StatelessWidget {
  final controller = Get.find<Productlistcontroller>();
  final ScrollController _scrollController = ScrollController();

  ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (controller.hasMoreLeads.value && !controller.isFetchingMore.value) {
          controller.fetchProducts(isInitialFetch: false);
        }
      }
    });

    return Scaffold(
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     controller.clearform();
      //     controller.isEdit.value = false;
      //     Get.toNamed(Routes.addProduct, arguments: {'isEdit': false});
      //   },
      //   backgroundColor: Colors.teal,
      //   icon: const Icon(Icons.add, color: Colors.white),
      //   label: const Text('Add Product', style: TextStyle(color: Colors.white)),
      // ),
      floatingActionButton: CustomFloatingActionButton(
          onPressed: () {
            controller.clearform();
            controller.isEdit.value = false;
            Get.toNamed(Routes.addProduct, arguments: {'isEdit': false});
          },
          icon: Icons.add),
      body: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [Colors.blue.shade50, Colors.grey.shade200],
            // ),
            ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAppBar(context),
            _buildSearchAndFilter(context),
            _buildActiveFilters(),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(context) {
    return SliverAppBar(
      expandedHeight: 100.0,
      floating: true,
      pinned: true,
      elevation: 2,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Product Catalog',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(.2)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade400),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => controller.searchProducts(value),
                        decoration: const InputDecoration(
                          hintText: 'Search products...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.tune, color: Colors.grey.shade600),
                      onPressed: () => _showFilterBottomSheet(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Obx(() {
      if (!controller.hasActiveFilters.value)
        return const SliverToBoxAdapter(child: SizedBox.shrink());

      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Active Filters',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => controller.clearFilters(),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (controller.selectedCategory.value.isNotEmpty)
                      _buildFilterChip(
                        label: controller.selectedCategory.value,
                        onDelete: () => controller.clearCategoryFilter(),
                      ),
                    if (controller.hasPriceFilter.value)
                      _buildFilterChip(
                        label:
                            '₹${controller.minPrice.value} - ₹${controller.maxPrice.value}',
                        onDelete: () => controller.clearPriceFilter(),
                      ),
                    if (controller.selectedGst.value.isNotEmpty)
                      _buildFilterChip(
                        label: 'GST: ${controller.selectedGst.value}%',
                        onDelete: () => controller.clearGstFilter(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFilterChip(
      {required String label, required VoidCallback onDelete}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onDelete,
        backgroundColor: Colors.teal.shade50,
        deleteIconColor: Colors.teal.shade700,
        labelStyle: TextStyle(color: Colors.teal.shade700),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => FilterBottomSheet(
          controller: controller,
          scrollController: scrollController,
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.filteredProducts.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No products found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.all(16.0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: .55,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == controller.filteredProducts.length) {
                return controller.isFetchingMore.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }
              final product = controller.filteredProducts[index];
              return ProductCard(product: product, controller: controller);
            },
            childCount: controller.filteredProducts.length + 1,
          ),
        ),
      );
    });
  }
}

class FilterBottomSheet extends StatelessWidget {
  final Productlistcontroller controller;
  final ScrollController scrollController;

  const FilterBottomSheet({
    Key? key,
    required this.controller,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  controller.clearFilters();
                  Navigator.pop(context);
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              _buildCategoryFilter(),
              const Divider(height: 32),
              _buildPriceRangeFilter(),
              const Divider(height: 32),
              _buildGSTFilter(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  controller.applyFilters();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.categories.map((category) {
                final isSelected =
                    controller.selectedCategory.value == category;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    controller.selectedCategory.value =
                        selected ? category : '';
                  },
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: Colors.blue.shade100,
                  checkmarkColor: Colors.blue.shade700,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.blue.shade700 : Colors.black87,
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Range',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '₹${controller.currentPriceRange.value.start.toInt()}'),
                    Text('₹${controller.currentPriceRange.value.end.toInt()}'),
                  ],
                ),
                RangeSlider(
                  values: controller.currentPriceRange.value,
                  min: controller.minAvailablePrice.value,
                  max: controller.maxAvailablePrice.value,
                  divisions: 100,
                  labels: RangeLabels(
                    '₹${controller.currentPriceRange.value.start.toInt()}',
                    '₹${controller.currentPriceRange.value.end.toInt()}',
                  ),
                  onChanged: (RangeValues values) {
                    controller.currentPriceRange.value = values;
                  },
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildGSTFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GST Rate',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.gstRates.map((rate) {
                final isSelected = controller.selectedGst.value == rate;
                return FilterChip(
                  label: Text('$rate%'),
                  selected: isSelected,
                  onSelected: (selected) {
                    controller.selectedGst.value = selected ? rate : '';
                  },
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: Colors.blue.shade100,
                  checkmarkColor: Colors.blue.shade700,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.blue.shade700 : Colors.black87,
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Products1 product;
  final Productlistcontroller controller;

  const ProductCard({
    Key? key,
    required this.product,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => Get.to(
        () => ProductDetailPage(),
        arguments: {'productId': product.id},
      ),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              // Product Image
              // ClipRRect(
              //   borderRadius:
              //       const BorderRadius.vertical(top: Radius.circular(12)),
              //   child: AspectRatio(
              //     aspectRatio: 1.3,
              //     child: product.Imagepath != null
              //         ? Image.network(
              //             "https://lead.mumbaicrm.com/${product.Imagepath}",
              //             fit: BoxFit.cover,
              //             width: double.infinity,
              //             errorBuilder: (context, error, stackTrace) {
              //               return _buildPlaceholder();
              //             },
              //           )
              //         : _buildPlaceholder(),
              //   ),
              // ),

              // Product Details with Expanded to push buttons down
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.iname,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Category & GST
                      Text(
                        "${product.igroup} • GST ${double.tryParse(product.stax) ?? 0.0}%",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Pricing Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPriceColumn('Price', product.rate1,
                              isBold: true),
                          _buildPriceColumn('MRP', product.mrp ?? "0",
                              isStrikethrough: true),
                        ],
                      ),

                      const Spacer(), // Pushes buttons to the bottom
                    ],
                  ),
                ),
              ),

              // Action Buttons - Always at the Bottom
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.edit,
                      label: 'Edit',
                      onTap: () => _handleEdit(context),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    _buildActionButton(
                      icon: Icons.delete,
                      label: 'Delete',
                      onTap: () => _handleDelete(context),
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: product.Imagepath != null && product.Imagepath!.isNotEmpty
            ? Image.network(
                product.Imagepath!.startsWith('http')
                    ? product.Imagepath!
                    : "https://lead.mumbaicrm.com/${product.Imagepath}",
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return _buildPlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: 40,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildPriceColumn(String title, String price,
      {bool isBold = false, bool isStrikethrough = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          "₹${(double.tryParse(price) ?? 0.0).toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            decoration: isStrikethrough
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: isStrikethrough ? Colors.grey.shade600 : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color:
                    isDestructive ? Colors.red.shade400 : Colors.grey.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isDestructive
                      ? Colors.red.shade400
                      : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context) async {
    controller.clearform();
    controller.isEdit.value = true;
    await controller.initializeEditMode(product.id.toString());
    Get.toNamed(
      Routes.addProduct,
      arguments: {
        'isEdit': true,
        'productId': product.id.toString(),
      },
    );
  }

  void _handleDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteProducts(product.id.toString());
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );
  }
}
