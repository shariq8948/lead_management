import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shimmer/shimmer.dart';

import '../../utils/routes.dart';
import '../../widgets/app_colors.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../model/product.dart';
import '../widgets/qantity_chart.dart';
import 'cart_page.dart';
import 'details.dart';

class ProductListPageOrder extends StatefulWidget {
  const ProductListPageOrder({super.key});

  @override
  State<ProductListPageOrder> createState() => _ProductListPageOrderState();
}

class _ProductListPageOrderState extends State<ProductListPageOrder> {
  final ProductListController controller = Get.find();
  final CartController cartController = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500 &&
        controller.hasMoreProducts.value &&
        !controller.isLoading.value &&
        !controller.isLoadingMore.value) {
      controller.loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => controller.refreshProducts(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAppBar(),
            _buildSearchAndFilter(context),
            _buildActiveFilters(),
            _buildProductCount(),
            _buildProductGrid(context),
            _buildLoadMoreIndicator(),
            const SliverToBoxAdapter(child: SizedBox(height: 60))
          ],
        ),
      ),
    );
  }

  // Add a widget to show the total product count
  Widget _buildProductCount() {
    return Obx(() {
      if (!controller.isInitialLoading.value) {
        return SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.hasMoreProducts.value
                      ? 'Products Loaded: ${controller.allProducts.length}${controller.hasMoreProducts.value ? "+" : ""}'
                      : 'Total Products: ${controller.allProducts.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  controller.hasActiveFilters.value
                      ? 'Filtered: ${controller.filteredProducts.length}'
                      : 'Showing: ${controller.filteredProducts.length}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    });
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      floating: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Product Catalog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(.8),
                AppColors.primary.withOpacity(.5),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Obx(() => Badge(
              label: Text(
                cartController.cartItems.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Get.toNamed(Routes.CART_PAGE)?.then((_) {
                    controller.refreshProducts();
                  });
                },
              ),
            )),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        controller.isSearching.value
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary.withOpacity(.3),
                                ),
                              )
                            : Icon(Icons.search,
                                color: AppColors.primary.withOpacity(.3)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) =>
                                controller.searchProducts(value),
                          ),
                        ),
                        if (controller.searchQuery.value.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear,
                                color: AppColors.primary.withOpacity(.4)),
                            onPressed: () {
                              // Clear the text field
                              final currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              // This will trigger a new API call without the search filter
                              controller.searchProducts("");
                            },
                          ),
                        Container(
                          height: 32,
                          width: 1,
                          color: Colors.grey.shade300,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        IconButton(
                          icon: Icon(Icons.filter_list,
                              color: AppColors.primary.withOpacity(.4)),
                          onPressed: () => _showFilterBottomSheet(context),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(controller: controller),
    );
  }

  Widget _buildActiveFilters() {
    return Obx(() {
      if (!controller.hasActiveFilters.value) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }

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
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.withOpacity(.7),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: controller.clearAllFilters,
                    icon: const Icon(
                      Icons.clear_all,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    label: const Text('Clear All'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary.withOpacity(.7),
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
                        onDelete: controller.clearCategoryFilter,
                      ),
                    _buildFilterChip(
                      label:
                          '₹${controller.selectedPriceRange.value.start.toInt()} - ₹${controller.selectedPriceRange.value.end.toInt()}',
                      onDelete: controller.clearPriceFilter,
                    ),
                    if (controller.selectedGst.value.isNotEmpty)
                      _buildFilterChip(
                        label: 'GST: ${controller.selectedGst.value}%',
                        onDelete: controller.clearGstFilter,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
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
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDelete,
        backgroundColor: AppColors.primary.withOpacity(.1),
        labelStyle: TextStyle(color: AppColors.primary.withOpacity(.8)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.primary.withOpacity(.2)),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return Obx(() {
      if (controller.isInitialLoading.value || controller.isLoading.value) {
        return SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildShimmerCard(),
              childCount: 6,
            ),
          ),
        );
      }

      if (controller.filteredProducts.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No products found',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your search or filters',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.all(6.0),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(context),
            mainAxisSpacing: 5,
            crossAxisSpacing: 1,
            childAspectRatio: 0.54,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // Only show products that exist
              if (index < controller.filteredProducts.length) {
                final product = controller.filteredProducts[index];
                return ProductCard(
                  product: product,
                  onAddToCart: () => _showQuantityBottomSheet(product),
                );
              }
              return const SizedBox.shrink();
            },
            childCount: controller.filteredProducts.length,
          ),
        ),
      );
    });
  }

  Widget _buildLoadMoreIndicator() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      // Show a message when all products are loaded
      if (!controller.hasMoreProducts.value &&
          controller.allProducts.isNotEmpty &&
          !controller.hasActiveFilters.value) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'All products loaded',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        );
      }

      return const SliverToBoxAdapter(child: SizedBox.shrink());
    });
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 2;
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 80,
                    height: 24,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuantityBottomSheet(Products product) {
    final int initialQuantity = 1; // Or get from existing cart item if present
    final discountController = TextEditingController(text: '0');
    final int availableStock = int.tryParse(product.currentStock) ?? 0;
    RxInt selectedQuantity = initialQuantity.obs;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: 24 + MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.itemName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Price: ₹${product.saleRate}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stock warning if low stock
              if (availableStock < 5)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Colors.amber.shade800),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Low stock! Only $availableStock item${availableStock != 1 ? 's' : ''} available.',
                          style: TextStyle(color: Colors.amber.shade800),
                        ),
                      ),
                    ],
                  ),
                ),

              // Use our new GetX-based quantity selector
              ChartQuantitySelector(
                initialValue: initialQuantity,
                onChanged: (value) {
                  selectedQuantity.value = value;
                },
                primaryColor: AppColors.primary,
                availableStock: availableStock,
                maxValue: 30,
                // maxValue: availableStock, //  can be adjusted this as needed
              ),

              const SizedBox(height: 16),
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Discount',
                  suffixText: '%',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.discount_outlined),
                ),
              ),
              const SizedBox(height: 24),

              // Add to cart button

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  onPressed: availableStock > 0
                      ? () {
                          final quantity = selectedQuantity.value;
                          final discount =
                              double.tryParse(discountController.text) ?? 0;

                          if (quantity > 0 && quantity <= availableStock) {
                            cartController.addToCart(
                                product, quantity, discount);
                            Get.back();
                            Get.snackbar(
                              'Success',
                              'Added ${product.itemName} to cart',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              backgroundColor: Colors.green.shade100,
                              colorText: Colors.green.shade900,
                            );
                          } else if (quantity > availableStock) {
                            // Show error if trying to add more than available stock
                            Get.snackbar(
                              'Error',
                              'Cannot add more than available stock ($availableStock items)',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              backgroundColor: Colors.red.shade100,
                              colorText: Colors.red.shade900,
                            );
                          }
                        }
                      : () {
                          final quantity = selectedQuantity.value;
                          final discount =
                              double.tryParse(discountController.text) ?? 0;

                          if (quantity > 0 && quantity <= availableStock) {
                            cartController.addToCart(
                                product, quantity, discount);
                            Get.back();
                            Get.snackbar(
                              'Success',
                              'Added ${product.itemName} to cart',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              backgroundColor: Colors.green.shade100,
                              colorText: Colors.green.shade900,
                            );
                          } else if (quantity > availableStock) {
                            // Show error if trying to add more than available stock
                            Get.snackbar(
                              'Error',
                              'Cannot add more than available stock ($availableStock items)',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              backgroundColor: Colors.red.shade100,
                              colorText: Colors.red.shade900,
                            );
                          }
                        },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_cart),
                      const SizedBox(width: 8),
                      Text(
                        // availableStock > 0?
                        'Add to Cart (${selectedQuantity.value})',
                        // : 'Out of Stock'
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class ProductCard extends StatelessWidget {
  final Products product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final CartController cartController = Get.find<CartController>();

    // Get screen size for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // More detailed screen size detection
    final isExtraSmallScreen = screenWidth < 320;
    final isSmallScreen = screenWidth >= 320 && screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 400;
    final isLargeScreen = screenWidth >= 400;

    // Responsive font sizes
    final nameFontSize = isExtraSmallScreen
        ? 12.0
        : isSmallScreen
            ? 13.0
            : isMediumScreen
                ? 14.0
                : 16.0;

    final priceFontSize = isExtraSmallScreen
        ? 14.0
        : isSmallScreen
            ? 16.0
            : isMediumScreen
                ? 18.0
                : 20.0;

    // Responsive paddings
    final cardPadding = isExtraSmallScreen
        ? 6.0
        : isSmallScreen
            ? 8.0
            : isMediumScreen
                ? 10.0
                : 12.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Get available width for the card
        final availableWidth = constraints.maxWidth;

        // Adjust aspect ratio based on available width
        final imageAspectRatio = availableWidth < 150
            ? 1.0
            : availableWidth < 180
                ? 1.1
                : 1.2;

        return GestureDetector(
          onTap: () {
            // Navigate to product details page
            Get.to(() => ProductDetailsPage(productId: product.id));
          },
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDarkMode ? Colors.grey[850] : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Section with responsive Aspect Ratio
                  AspectRatio(
                    aspectRatio: imageAspectRatio,
                    child: _buildImageSection(
                        context, cartController, availableWidth),
                  ),

                  // Content wrapper with ConstrainedBox to ensure minimum heights
                  Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Product Name - with min height constraint
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 24.0 * textScaleFactor,
                            maxHeight: 50.0 * textScaleFactor,
                          ),
                          child: Text(
                            product.itemName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              fontSize: nameFontSize,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: availableWidth < 180 ? 4.0 : 8.0),

                        // Wrap chips in SingleChildScrollView with responsive height
                        SizedBox(
                          height: (isExtraSmallScreen ? 24.0 : 32.0) *
                              textScaleFactor,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCategoryChip(
                                    theme, availableWidth, textScaleFactor),
                                const SizedBox(width: 6),
                                _buildStockChip(
                                    theme, availableWidth, textScaleFactor),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: availableWidth < 180 ? 4.0 : 6.0),

                        // Price Section with min height
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 28.0 * textScaleFactor,
                            maxHeight: 50.0 * textScaleFactor,
                          ),
                          child: _buildPriceSection(theme, availableWidth,
                              priceFontSize, textScaleFactor),
                        ),

                        // Variable spacing based on available width
                        SizedBox(height: availableWidth < 180 ? 4.0 : 6.0),

                        // Add to Cart button with responsive height
                        SizedBox(
                          height: (availableWidth < 180 ? 32.0 : 38.0) *
                              textScaleFactor,
                          child: Obx(() {
                            final isInCart = cartController.cartItems
                                .any((item) => item.id == product.id);
                            return isInCart
                                ? _buildQuantityController(cartController,
                                    theme, availableWidth, textScaleFactor)
                                : (double.tryParse(product.currentStock!)! >
                                            0 ||
                                        double.tryParse(
                                                product.currentStock!)! <=
                                            0)
                                    ? _buildAddToCartButton(
                                        theme, availableWidth, textScaleFactor)
                                    : _buildOutOfStockButton(
                                        theme, availableWidth, textScaleFactor);
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(BuildContext context, CartController cartController,
      double availableWidth) {
    // Scale GST tag and cart status tag based on available width
    final tagScale = availableWidth < 180 ? 0.8 : 1.0;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Product Image with Hero animation
          Hero(
            tag: 'product-${product.itemCode}',
            child: _buildProductImage(),
          ),

          // Subtle overlay gradient
          _buildGradientOverlay(),

          // GST Tag if applicable
          if (int.tryParse(product.gst)! > 0)
            Positioned(
              top: 8 * tagScale,
              right: 8 * tagScale,
              child: Transform.scale(
                scale: tagScale,
                child: _buildGstTag(),
              ),
            ),

          // Cart Status Tag
          Obx(() => _buildCartStatusTag(cartController, tagScale)),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return product.imageUrl != null
        ? Image.network(
            "${product.imageUrl}",
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              return progress == null ? child : _buildLoadingPlaceholder();
            },
            errorBuilder: (_, __, ___) => _buildErrorPlaceholder(),
          )
        : _buildErrorPlaceholder();
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.1),
            Colors.transparent,
            Colors.black.withOpacity(0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildGstTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        'GST ${product.gst}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCartStatusTag(CartController cartController, double scale) {
    final isInCart =
        cartController.cartItems.any((item) => item.id == product.id);

    if (!isInCart) return const SizedBox();

    return Positioned(
      top: 12 * scale,
      left: -30 * scale,
      child: Transform.scale(
        scale: scale,
        child: Transform.rotate(
          angle: -0.895398, // -45 degrees in radians
          child: Container(
            width: 100,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.green.shade500,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'ADDED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection(ThemeData theme, double availableWidth,
      double fontSize, double textScaleFactor) {
    // Adjust font scaling to ensure prices don't overflow
    final adjustedLabelFontSize =
        (availableWidth < 180 ? 9.0 : 10.0) / textScaleFactor.clamp(1.0, 1.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Price',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.primary.withOpacity(0.6),
            fontSize: adjustedLabelFontSize,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '₹${product.saleRate}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            fontSize: fontSize,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(
      ThemeData theme, double availableWidth, double textScaleFactor) {
    // Scale button text based on available width and text scale factor
    final buttonFontSize =
        (availableWidth < 180 ? 11.0 : 13.0) / textScaleFactor.clamp(1.0, 1.3);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: availableWidth < 180 ? 6.0 : 10.0,
            vertical: 0.0,
          ),
        ),
        onPressed: onAddToCart,
        child: Text(
          'Add to Cart',
          style: TextStyle(
            fontSize: buttonFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildOutOfStockButton(
      ThemeData theme, double availableWidth, double textScaleFactor) {
    // Scale text based on available width and text scale factor
    final fontSize =
        (availableWidth < 180 ? 10.0 : 11.0) / textScaleFactor.clamp(1.0, 1.3);
    final iconSize = availableWidth < 180 ? 14.0 : 16.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(availableWidth < 180 ? 6.0 : 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.remove_shopping_cart,
            color: Colors.grey.shade700,
            size: iconSize,
          ),
          SizedBox(width: availableWidth < 180 ? 4.0 : 6.0),
          Text(
            'Out of Stock',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityController(CartController cartController,
      ThemeData theme, double availableWidth, double textScaleFactor) {
    final cartItem =
        cartController.cartItems.firstWhere((item) => item.id == product.id);

    final int currentStock = int.tryParse(product.currentStock) ?? 0;

    // Adjust quantity indicator size
    final qtyFontSize =
        (availableWidth < 180 ? 12.0 : 14.0) / textScaleFactor.clamp(1.0, 1.3);
    final buttonSize = availableWidth < 180 ? 4.0 : 6.0;
    final iconSize = availableWidth < 180 ? 12.0 : 14.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: () {
              if (cartItem.qty.value > 1) {
                cartController.addToCart(
                    cartItem, cartItem.qty.value - 1, cartItem.discount.value);
              } else {
                cartController.removeFromCart(cartItem.id);
              }
            },
            buttonSize: buttonSize,
            iconSize: iconSize,
            isDisabled: false,
          ),
          Text(
            '${cartItem.qty.value}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: qtyFontSize,
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: () {
              // Check if adding one more would exceed available stock
              if (cartItem.qty.value < currentStock) {
                cartController.addToCart(
                    cartItem, cartItem.qty.value + 1, cartItem.discount.value);
              } else {
                // Show stock limit notification
                Get.snackbar(
                  "Stock Limit",
                  "Sorry, only $currentStock items available in stock",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                  duration: Duration(seconds: 2),
                );
              }
            },
            buttonSize: buttonSize,
            iconSize: iconSize,
            isDisabled: cartItem.qty.value >= currentStock,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    required double buttonSize,
    required double iconSize,
    bool isDisabled = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(buttonSize),
          child: Icon(
            icon,
            size: iconSize,
            color: isDisabled ? Colors.white.withOpacity(0.5) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
      ThemeData theme, double availableWidth, double textScaleFactor) {
    // Adjust sizes based on available width and text scaling
    final chipHorizontalPadding = availableWidth < 180 ? 6.0 : 8.0;
    final chipVerticalPadding = availableWidth < 180 ? 3.0 : 5.0;
    final iconSize = availableWidth < 180 ? 10.0 : 12.0;
    final fontSize =
        (availableWidth < 180 ? 8.0 : 10.0) / textScaleFactor.clamp(1.0, 1.3);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: chipHorizontalPadding,
        vertical: chipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.category_outlined,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(width: availableWidth < 180 ? 3.0 : 4.0),
          Text(
            product.category,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStockChip(
      ThemeData theme, double availableWidth, double textScaleFactor) {
    Color chipColor;
    IconData stockIcon;
    String statusText;
    int goodStockThreshold = 20;
    int limitedStockThreshold = 05;

    if (int.tryParse(product.currentStock)! > goodStockThreshold) {
      chipColor = AppColors.primary;
      stockIcon = Icons.check_circle_outline;
      statusText = "${product.currentStock}";
    } else if (int.tryParse(product.currentStock)! > limitedStockThreshold) {
      chipColor = AppColors.warning;
      stockIcon = Icons.warning_amber_outlined;
      statusText = "${product.currentStock}";
    } else {
      chipColor = AppColors.danger;
      stockIcon = Icons.error_outline;
      statusText = "Low (${product.currentStock})";
    }

    // Adjust sizing based on available width and text scaling
    final chipHorizontalPadding = availableWidth < 180 ? 6.0 : 8.0;
    final chipVerticalPadding = availableWidth < 180 ? 3.0 : 5.0;
    final iconSize = availableWidth < 180 ? 10.0 : 12.0;
    final fontSize =
        (availableWidth < 180 ? 8.0 : 10.0) / textScaleFactor.clamp(1.0, 1.3);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: chipHorizontalPadding,
        vertical: chipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            stockIcon,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(width: availableWidth < 180 ? 3.0 : 4.0),
          Text(
            statusText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.white),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 32, color: Colors.grey[400]),
            const SizedBox(height: 4),
            Text(
              'Image not available',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatelessWidget {
  final ProductListController controller;

  const FilterBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                children: [
                  Row(
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // controller.clearAllFilters();
                          Get.back();
                        },
                        child: const Text('Reset All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildCategoryFilter(),
                  const Divider(height: 32),
                  _buildPriceFilter(),
                  const Divider(height: 32),
                  _buildGstFilter(),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      controller.applyFilters();
                      Get.back();
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.categories.map((category) {
                final isSelected =
                    controller.selectedCategory.value == category;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) => controller.selectedCategory.value =
                      selected ? category : '',
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: AppColors.primary.withOpacity(.2),
                  checkmarkColor: AppColors.primary.withOpacity(.7),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary.withOpacity(.7)
                        : Colors.black87,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary.withOpacity(.2)
                          : Colors.transparent,
                    ),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildPriceFilter() {
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
                RangeSlider(
                  values: controller.selectedPriceRange.value,
                  min: controller.minPrice.value,
                  max: controller.maxPrice.value,
                  divisions: 20,
                  activeColor: AppColors.primary.withOpacity(.7),
                  inactiveColor: Colors.grey.shade200,
                  labels: RangeLabels(
                    '₹${controller.selectedPriceRange.value.start.toInt()}',
                    '₹${controller.selectedPriceRange.value.end.toInt()}',
                  ),
                  onChanged: (values) =>
                      controller.selectedPriceRange.value = values,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${controller.selectedPriceRange.value.start.toInt()}',
                      style: TextStyle(color: Colors.grey.withOpacity(.7)),
                    ),
                    Text(
                      '₹${controller.selectedPriceRange.value.end.toInt()}',
                      style: TextStyle(color: Colors.grey.withOpacity(.7)),
                    ),
                  ],
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildGstFilter() {
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
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.gstRates.map((rate) {
                final isSelected = controller.selectedGst.value == rate;
                return FilterChip(
                  label: Text('$rate%'),
                  selected: isSelected,
                  onSelected: (selected) =>
                      controller.selectedGst.value = selected ? rate : '',
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: AppColors.primary.withOpacity(.1),
                  checkmarkColor: AppColors.primary.withOpacity(.7),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary.withOpacity(.7)
                        : Colors.black87,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary.withOpacity(.7)
                          : Colors.transparent,
                    ),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }
}
