import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shimmer/shimmer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../widgets/app_colors.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../model/product.dart';
import '../widgets/qantity_chart.dart';
import 'allproducts.dart';
import 'cart_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ProductListController controller = Get.find();
  final CartController cartController = Get.find();
  late PageController _pageController;
  late int currentIndex;
  late RxBool isLoadingProduct = false.obs;

  // For image carousel
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Find the index of the current product in the filtered products list
    currentIndex = controller.filteredProducts
        .indexWhere((product) => product.id == widget.productId);
    if (currentIndex < 0) currentIndex = 0;

    // Initialize the page controller with the current product index
    _pageController = PageController(initialPage: currentIndex);

    // Add listener to detect when we need to load more products
    _pageController.addListener(_onPageScroll);

    // Get current product and preload its video thumbnails
    if (controller.filteredProducts.isNotEmpty) {
      final currentProduct = controller.filteredProducts[currentIndex];
      final mediaUrls = _getProductImages(currentProduct);
      _preloadVideoThumbnails(mediaUrls);
    }

    // Also preload thumbnails for adjacent products for smoother navigation
    _preloadAdjacentProductThumbnails();
  }

// New method to preload thumbnails for products before and after the current one
  void _preloadAdjacentProductThumbnails() {
    if (controller.filteredProducts.isEmpty) return;

    // Preload previous product if available
    if (currentIndex > 0) {
      final prevProduct = controller.filteredProducts[currentIndex - 1];
      final prevMediaUrls = _getProductImages(prevProduct);
      _preloadVideoThumbnails(prevMediaUrls);
    }

    // Preload next product if available
    if (currentIndex < controller.filteredProducts.length - 1) {
      final nextProduct = controller.filteredProducts[currentIndex + 1];
      final nextMediaUrls = _getProductImages(nextProduct);
      _preloadVideoThumbnails(nextMediaUrls);
    }
  }

  Future<void> _preloadVideoThumbnails(List<String> mediaUrls) async {
    for (final url in mediaUrls) {
      if (MediaItem.getTypeFromUrl(url) == MediaType.video) {
        // Generate thumbnails in the background
        _getVideoThumbnail(url).then((thumbnail) {
          // Thumbnail is now cached
          print('Preloaded thumbnail for: $url');
        }).catchError((error) {
          print('Failed to preload thumbnail: $error');
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  // Check if we need to load more products
  void _onPageScroll() {
    if (!controller.isLoadingMore.value && controller.hasMoreProducts.value) {
      // If we're within 3 items of the end, load more items
      if (currentIndex >= controller.filteredProducts.length - 3) {
        controller.loadMoreProducts().then((_) {
          // Update the state with new products
          setState(() {});
        });
      }
    }
  }

  void _logMediaItems(List<String> mediaList) {
    print('Total media items: ${mediaList.length}');
    for (int i = 0; i < mediaList.length; i++) {
      print(
          '[$i] ${mediaList[i]} - Type: ${MediaItem.getTypeFromUrl(mediaList[i])}');
    }
  }

  // Get sample images for the carousel (replace with actual product images)
  List<String> _getProductImages(Products product) {
    Set<String> uniqueUrls = {}; // Use a Set to avoid duplicates
    List<String> mediaList = [];

    // Helper function to normalize URLs
    String normalizeUrl(String url) {
      // You might need to adjust this based on your URL patterns
      // This removes query parameters which might differ but point to the same resource
      Uri uri = Uri.parse(url);
      return '${uri.scheme}://${uri.host}${uri.path}';
    }

    // Add image URLs from the images list

    // Add the main image if not already included
    if (product.imageUrl.isNotEmpty) {
      String normalizedMainUrl = normalizeUrl(product.imageUrl);
      if (!uniqueUrls.contains(normalizedMainUrl)) {
        uniqueUrls.add(normalizedMainUrl);
        mediaList.add(product.imageUrl);
      }
    }

    // Add the small image if available and not already included
    if (product.smallImageUrl.isNotEmpty) {
      String normalizedSmallUrl = normalizeUrl(product.smallImageUrl);
      if (!uniqueUrls.contains(normalizedSmallUrl)) {
        uniqueUrls.add(normalizedSmallUrl);
        mediaList.add(product.smallImageUrl);
      }
    }
    if (product.images.isNotEmpty) {
      print("${product.id}this is lenght");
      for (var img in product.images) {
        print("${img.imageUrl}this is lenght");

        String normalizedUrl = normalizeUrl(img.imageUrl);
        if (!uniqueUrls.contains(normalizedUrl)) {
          uniqueUrls.add(normalizedUrl);
          mediaList.add(img.imageUrl);
        }
      }
    }

    // Log the final list for debugging
    _logMediaItems(mediaList);

    return mediaList;
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilding");
    return Scaffold(
      body: Obx(() {
        if (controller.filteredProducts.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return Stack(
          children: [
            // Page view for swipeable products
            PageView.builder(
              controller: _pageController,
              itemCount: controller.filteredProducts.length +
                  (controller.hasMoreProducts.value ? 1 : 0),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                  // Reset image carousel index when changing products
                  _currentImageIndex = 0;
                  // Check if we need to load more products
                  _onPageScroll();
                });
              },
              itemBuilder: (context, index) {
                // If we've reached the loading page
                if (index >= controller.filteredProducts.length) {
                  return _buildLoadingPage();
                }

                final product = controller.filteredProducts[index];
                return _buildProductDetailsContent(product);
              },
            ),

            // Back button and navigation indicators
            // Positioned(
            //   top: MediaQuery.of(context).padding.top,
            //   left: 8,
            //   child: IconButton(
            //     icon: const Icon(Icons.arrow_back, color: Colors.white),
            //     onPressed: () => Get.back(),
            //     style: IconButton.styleFrom(
            //       backgroundColor: Colors.black.withOpacity(0.5),
            //       padding: const EdgeInsets.all(12),
            //     ),
            //   ),
            // ),

            // Product counter indicator
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Obx(() => Text(
                      '${currentIndex + 1} / ${controller.totalProducts.value > 0 ? controller.totalProducts.value : controller.filteredProducts.length.toString() + (controller.hasMoreProducts.value ? "+" : "")}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ),

            // Cart button
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Obx(() => Badge(
                      isLabelVisible: cartController.cartItems.isNotEmpty,
                      label: Text('${cartController.cartItems.length}'),
                      child: FloatingActionButton(
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          // Navigate to cart
                          Get.to(CartPage());
                        },
                        child: const Icon(Icons.shopping_cart,
                            color: Colors.white),
                      ),
                    )),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLoadingPage() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            const Text(
              'Loading more products...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetailsContent(Products product) {
    List<String> productImages = _getProductImages(product);
    bool hasImages = productImages.isNotEmpty;

    return CustomScrollView(
      slivers: [
        // Product image carousel as app bar
        SliverAppBar(
          expandedHeight: 350,
          pinned: true,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: _buildImageCarousel(product, productImages),
          ),
        ),

        // Product details content
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image indicator dots if multiple images
                  if (hasImages && productImages.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          productImages.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                    ),

                  Obx(() => _buildProductInfoCard(product)),
                  _buildDetailsSection(product),
                  _buildPricingSection(product),
                  _buildDescriptionSection(product),

                  // Add to cart button at bottom

                  const SizedBox(height: 80),
                  // Extra space for floating cart button
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel(Products product, List<String> mediaUrls) {
    if (mediaUrls.isEmpty) {
      // If no media, show placeholder
      return Container(
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No media available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Background gradient for better text visibility
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
                Colors.black.withOpacity(0.2),
              ],
            ),
          ),
        ),

        // Carousel slider for multiple media items
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: mediaUrls.length,
          options: CarouselOptions(
            height: double.infinity,
            viewportFraction: 1,
            enlargeCenterPage: false,
            enableInfiniteScroll: mediaUrls.length > 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final mediaUrl = mediaUrls[index];
            final mediaType = MediaItem.getTypeFromUrl(mediaUrl);

            return GestureDetector(
              onTap: () => _openMediaGallery(context, mediaUrls, index),
              child: Hero(
                tag: 'product-media-${product.itemCode}-$index',
                child: mediaType == MediaType.video
                    ? _buildVideoThumbnail(mediaUrl)
                    : _buildImageThumbnail(mediaUrl),
              ),
            );
          },
        ),

        // Left arrow for carousel
        if (mediaUrls.length > 1)
          Positioned(
            left: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => _carouselController.previousPage(),
                ),
              ),
            ),
          ),

        // Right arrow for carousel
        if (mediaUrls.length > 1)
          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () => _carouselController.nextPage(),
                ),
              ),
            ),
          ),
      ],
    );
  }

// New helper method to build video thumbnails
//   Widget _buildVideoThumbnail(String videoUrl) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Video thumbnail - you might need to generate/fetch this separately
//         // For now, we'll use a video thumbnail generator or a placeholder
//         FutureBuilder<String?>(
//           future: _getVideoThumbnail(videoUrl),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done &&
//                 snapshot.data != null) {
//               // If we have a thumbnail, show it
//               return CachedNetworkImage(
//                 imageUrl: snapshot.data!,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//                 placeholder: (context, url) => _buildLoadingPlaceholder(),
//                 errorWidget: (context, url, error) => _buildErrorWidget(),
//               );
//             } else {
//               // If no thumbnail yet, show a colored background
//               return Container(
//                 color: Colors.black,
//                 width: double.infinity,
//                 height: double.infinity,
//                 child: _buildLoadingPlaceholder(),
//               );
//             }
//           },
//         ),
//
//         // Play button overlay
//         Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.7),
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(
//             Icons.play_arrow,
//             color: Colors.white,
//             size: 40,
//           ),
//         ),
//       ],
//     );
//   }

// Helper method to fetch video thumbnail
  Future<String?> _getVideoThumbnail(String videoUrl) async {
    try {
      // Get temporary directory to store the thumbnail
      final directory = await getTemporaryDirectory();
      final thumbnailPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Generate the thumbnail using video_thumbnail package
      final thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: thumbnailPath,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 350, // Match your carousel height
        quality: 75,
      );

      if (thumbnailFile != null) {
        print("not getting thu,mbnail fiel");
        return 'file://$thumbnailFile';
      }

      // Fallback: check if we have a cached thumbnail on the server
      return '$videoUrl?thumbnail=true';
    } catch (e) {
      print('Error generating video thumbnail: $e');
      // Attempt to use a server-generated thumbnail as fallback
      return '$videoUrl?thumbnail=true';
    }
  }

// Improved _buildVideoThumbnail method with caching
  Widget _buildVideoThumbnail(String videoUrl) {
    // Cache key for storing generated thumbnails
    final thumbnailCacheKey = 'video_thumb_${videoUrl.hashCode}';

    return Stack(
      alignment: Alignment.center,
      children: [
        // Video thumbnail with local caching
        FutureBuilder<String?>(
          future: _getVideoThumbnail(videoUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              final thumbUrl = snapshot.data!;

              // If it's a local file
              if (thumbUrl.startsWith('file://')) {
                return Image.file(
                  File(thumbUrl.replaceFirst('file://', '')),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorWidget(),
                );
              }
              // If it's a network URL
              else {
                return CachedNetworkImage(
                  imageUrl: thumbUrl,
                  cacheKey: thumbnailCacheKey,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => _buildLoadingPlaceholder(),
                  errorWidget: (context, url, error) => _buildErrorWidget(),
                );
              }
            } else {
              // While generating thumbnail, show a loading indicator
              return Container(
                color: Colors.black,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Preparing video',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),

        // Play button overlay
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 40,
          ),
        ),
      ],
    );
  }

// Helper method for image thumbnails
  Widget _buildImageThumbnail(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => _buildLoadingPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
  }

// Loading placeholder with shimmer effect
  Widget _buildLoadingPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.white),
    );
  }

// Error widget when media fails to load
  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Media not available',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _openMediaGallery(
      BuildContext context, List<String> mediaUrls, int initialIndex) {
    // Convert string URLs to MediaItem objects
    final mediaItems = mediaUrls
        .map((url) => MediaItem(
              url: url,
              type: MediaItem.getTypeFromUrl(url),
            ))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullscreenMediaGallery(
          mediaItems: mediaItems,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Widget _buildProductInfoCard(Products product) {
    final cartItem = cartController.cartItems
        .firstWhereOrNull((item) => item.id == product.id);
    final bool isInCart = cartItem != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product title with animation
          Text(
            product.itemName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Category and GST row
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.category_outlined,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      product.category,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (int.tryParse(product.gst)! > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.receipt_outlined,
                          size: 18, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        'GST ${product.gst}%',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // Price and inventory quick info
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${product.saleRate}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  'In Stock: ${product.currentStock}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          (isInCart)
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _buildQuantityController(
                      cartItem), // Remove the 'as Rx<Products>' cast
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() => _buildAddToCartButton(product)),
                ),
          // Only show quantity controller if already in cart
          // Only show quantity controller if already in cart
          // if (isInCart)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 16),
          //     child: _buildQuantityController(
          //         cartItem), // Remove the 'as Rx<Products>' cast
          //   ),
        ],
      ),
    );
  }

  Widget _buildQuantityController(Products cartItem) {
    // Get current stock
    final int currentStock = int.tryParse(cartItem.currentStock) ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (cartItem.qty.value > 1) {
                cartController.addToCart(
                  cartItem,
                  cartItem.qty.value - 1,
                  cartItem.discount.value,
                );
              } else {
                // Show confirmation dialog before removing
                Get.dialog(
                  AlertDialog(
                    title: const Text('Remove Item'),
                    content: Text(
                      'Do you want to remove ${cartItem.itemName} from your cart?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('CANCEL'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          cartController.removeFromCart(cartItem.id);
                          Get.snackbar(
                            'Item Removed',
                            '${cartItem.itemName} has been removed from your cart',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.shade100,
                            colorText: Colors.red.shade900,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        child: const Text('REMOVE'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              }
            },
            color: AppColors.primary,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() => Text(
                  '${cartItem.qty.value}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: cartItem.qty.value >= currentStock
                ? () {
                    // Show stock limit message when trying to exceed stock
                    Get.snackbar(
                      'Stock Limit',
                      'Sorry, only $currentStock items available in stock',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange.shade100,
                      colorText: Colors.orange.shade900,
                      duration: const Duration(seconds: 2),
                    );
                  }
                : () {
                    cartController.addToCart(
                      cartItem,
                      cartItem.qty.value + 1,
                      cartItem.discount.value,
                    );
                  },
            color: cartItem.qty.value >= currentStock
                ? AppColors.primary.withOpacity(0.4) // Dimmed when at max stock
                : AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(Products product) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Product Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Product code
            _buildDetailRow(
              icon: Icons.qr_code,
              label: 'Product Code',
              value: product.itemCode ?? "0",
            ),

            const Divider(),

            // Pack specification
            _buildDetailRow(
              icon: Icons.inventory_2_outlined,
              label: 'Pack Specification',
              value: product.packing,
            ),

            const Divider(),

            // Unit
            _buildDetailRow(
              icon: Icons.straighten,
              label: 'Unit',
              value: product.unit,
            ),

            if (product.hsn.isNotEmpty) const Divider(),

            // HSN Code (if available)
            if (product.hsn.isNotEmpty)
              _buildDetailRow(
                icon: Icons.tag,
                label: 'HSN Code',
                value: product.hsn,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value.isEmpty ? 'Not specified' : value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: value.isEmpty ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(Products product) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_money, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Pricing & Stock Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pricing section with visual styling
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price details in a more visually appealing format
                  Row(
                    children: [
                      _buildPriceInfoItem(
                        icon: Icons.sell,
                        title: 'Sale rate',
                        value: '₹${product.saleRate}',
                      ),
                      if (product.saleRate.isNotEmpty)
                        _buildPriceInfoItem(
                          icon: Icons.business,
                          title: 'Wholesale',
                          value: '₹${product.saleRate}',
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (product.saleRate.isNotEmpty)
                        _buildPriceInfoItem(
                          icon: Icons.account_balance,
                          title: 'Distributor',
                          value: '₹${product.saleRate}',
                        ),
                      if (product.mrp!.isNotEmpty)
                        _buildPriceInfoItem(
                          icon: Icons.price_change,
                          title: 'Cost',
                          value: '₹${product.saleRate}',
                        ),
                    ],
                  ),
                  if (product.gst.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          _buildPriceInfoItem(
                            icon: Icons.receipt_long,
                            title: 'GST Rate',
                            value: '${product.gst}%',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stock information with visual styling
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stock Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Stock details in a more visually appealing format
                  Row(
                    children: [
                      _buildStockInfoItem(
                        icon: Icons.inventory,
                        title: 'Current Stock',
                        value: product.currentStock,
                      ),
                      _buildStockInfoItem(
                        icon: Icons.arrow_downward,
                        title: 'Min Order Quantity',
                        value: product.minOrderQty,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(Products product) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),

          // Price details section (keeping your existing code)

          // Description
          if (product.itemDescription != null &&
              product.itemDescription!.isNotEmpty)
            _buildDescriptionItem(
              icon: Icons.description,
              title: 'Description',
              content: product.itemDescription!,
            ),

          // Author
          if (product.remark4 != null && product.remark4!.isNotEmpty)
            _buildDescriptionItem(
              icon: Icons.person,
              title: 'Author',
              content: product.remark4!,
            ),

          // Precaution
          if (product.remark3 != null && product.remark3!.isNotEmpty)
            _buildDescriptionItem(
              icon: Icons.warning,
              title: 'Precaution',
              content: product.remark3!,
            ),

          // Directions of Use
          if (product.remark2 != null && product.remark2!.isNotEmpty)
            _buildDescriptionItem(
              icon: Icons.help_outline,
              title: 'Directions of Use',
              content: product.remark2,
            ),
        ],
      ),
    );
  }

// Helper widget to display description items with consistent formatting
  Widget _buildDescriptionItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.blue.shade800),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade800,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockInfoItem({
    required IconData icon,
    required String title,
    required String value,
    bool isFullWidth = false,
  }) {
    return isFullWidth
        ? Row(
            children: [
              Icon(icon, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade800,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Expanded(
            child: Row(
              children: [
                Icon(icon, color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade800,
                      ),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  void _showQuantityBottomSheet(Products product) {
    final quantityController = TextEditingController(text: '1');
    final discountController = TextEditingController(text: '0');

    // Get current stock
    final int currentStock = int.tryParse(product.currentStock) ?? 0;

    // Make sure we have stock available
    if (currentStock <= 0) {
      Get.snackbar(
        'Out of Stock',
        '${product.itemName} is currently out of stock',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add to Cart',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Available: $currentStock',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.shopping_bag_outlined),
                helperText: 'Maximum available: $currentStock',
              ),
              // Add a listener to ensure the value doesn't exceed stock
              onChanged: (value) {
                final enteredQty = int.tryParse(value) ?? 0;
                if (enteredQty > currentStock) {
                  quantityController.text = currentStock.toString();
                  quantityController.selection = TextSelection.fromPosition(
                    TextPosition(offset: currentStock.toString().length),
                  );
                }
              },
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final quantity = int.tryParse(quantityController.text) ?? 1;
                  final discount =
                      double.tryParse(discountController.text) ?? 0;

                  // Validate against current stock
                  if (quantity <= 0) {
                    Get.snackbar(
                      'Invalid Quantity',
                      'Please enter a valid quantity',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                      colorText: Colors.red.shade900,
                    );
                    return;
                  }

                  if (quantity > currentStock) {
                    Get.snackbar(
                      'Exceeds Stock',
                      'Only $currentStock items available',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange.shade100,
                      colorText: Colors.orange.shade900,
                    );
                    return;
                  }

                  cartController.addToCart(product, quantity, discount);
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Added ${product.itemName} to cart',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    backgroundColor: Colors.green.shade100,
                    colorText: Colors.green.shade900,
                  );
                },
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(Products product) {
    final cartItem = cartController.cartItems
        .firstWhereOrNull((item) => item.id == product.id);
    final bool isInCart = cartItem != null;

    // Get current stock
    final int currentStock = int.tryParse(product.currentStock) ?? 0;
    final bool isOutOfStock = currentStock <= 0;

    if (isInCart) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade700),
            const SizedBox(width: 8),
            Text(
              'Added to Cart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
      );
    }

    if (isOutOfStock) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.remove_shopping_cart, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              'Out of Stock',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: () => _showQuantityBottomSheetNew(product),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart),
          const SizedBox(width: 8),
          Text(
            'Add to Cart (${currentStock} available)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showQuantityBottomSheetNew(Products product) {
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
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_cart),
                      const SizedBox(width: 8),
                      Text(
                        availableStock > 0
                            ? 'Add to Cart (${selectedQuantity.value})'
                            : 'Out of Stock',
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

class _FullscreenMediaGallery extends StatefulWidget {
  final List<MediaItem> mediaItems;
  final int initialIndex;

  const _FullscreenMediaGallery({
    required this.mediaItems,
    required this.initialIndex,
  });

  @override
  _FullscreenMediaGalleryState createState() => _FullscreenMediaGalleryState();
}

class _FullscreenMediaGalleryState extends State<_FullscreenMediaGallery> {
  late int _currentIndex;
  late PageController _pageController;
  Map<int, VideoPlayerController?> _videoControllers = {};
  bool _showControls = false;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    // Initialize controllers for all video items
    for (int i = 0; i < widget.mediaItems.length; i++) {
      final item = widget.mediaItems[i];
      if (item.type == MediaType.video) {
        final controller = VideoPlayerController.network(item.url);
        _videoControllers[i] = controller;

        // Only initialize and play the initial video
        if (i == _currentIndex) {
          controller.initialize().then((_) {
            if (mounted) setState(() {});
            if (i == _currentIndex) controller.play();
          });
        }
      }
    }
  }

  void _onPageChanged(int index) {
    // Pause previous video if any
    final previousController = _videoControllers[_currentIndex];
    if (previousController != null) {
      previousController.pause();
    }

    // Update current index
    setState(() {
      _currentIndex = index;
    });

    // Initialize and play new video if needed
    final currentController = _videoControllers[index];
    if (currentController != null) {
      if (!currentController.value.isInitialized) {
        currentController.initialize().then((_) {
          if (mounted) setState(() {});
          currentController.play();
        });
      } else {
        currentController.play();
      }
    }
  }

  @override
  void dispose() {
    // Dispose all video controllers
    _videoControllers.values.forEach((controller) {
      if (controller != null) controller.dispose();
    });
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_currentIndex + 1}/${widget.mediaItems.length}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: widget.mediaItems.length,
        itemBuilder: (context, index) {
          final mediaItem = widget.mediaItems[index];

          if (mediaItem.type == MediaType.video) {
            final controller = _videoControllers[index];
            if (controller == null) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }

            // Check if controller is initialized
            final bool isInitialized = controller.value.isInitialized;
            final bool isPlaying =
                isInitialized ? controller.value.isPlaying : false;

            return Center(
              child: AspectRatio(
                aspectRatio:
                    isInitialized ? controller.value.aspectRatio : 16 / 9,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Video player
                    VideoPlayer(controller),

                    // Loading indicator
                    if (!isInitialized)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),

                    // Video controls overlay
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // Show/hide controls
                          _showControls = !_showControls;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                    // Full control bar
                    if (isInitialized)
                      AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          color: Colors.black54,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Progress bar
                              VideoProgressIndicator(
                                controller,
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                  playedColor: Colors.white,
                                  bufferedColor: Colors.white24,
                                  backgroundColor: Colors.grey,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),

                              // Control buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Rewind button
                                  IconButton(
                                    icon: const Icon(Icons.replay_10,
                                        color: Colors.white),
                                    onPressed: () {
                                      final newPosition =
                                          controller.value.position -
                                              const Duration(seconds: 10);
                                      controller.seekTo(newPosition);
                                    },
                                  ),

                                  // Fast backward
                                  IconButton(
                                    icon: const Icon(Icons.fast_rewind,
                                        color: Colors.white),
                                    onPressed: () {
                                      final newPosition =
                                          controller.value.position -
                                              const Duration(seconds: 30);
                                      controller.seekTo(newPosition);
                                    },
                                  ),

                                  // Play/pause
                                  IconButton(
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (isPlaying) {
                                          controller.pause();
                                        } else {
                                          controller.play();
                                        }
                                      });
                                    },
                                  ),

                                  // Fast forward
                                  IconButton(
                                    icon: const Icon(Icons.fast_forward,
                                        color: Colors.white),
                                    onPressed: () {
                                      final newPosition =
                                          controller.value.position +
                                              const Duration(seconds: 30);
                                      controller.seekTo(newPosition);
                                    },
                                  ),

                                  // Forward button
                                  IconButton(
                                    icon: const Icon(Icons.forward_10,
                                        color: Colors.white),
                                    onPressed: () {
                                      final newPosition =
                                          controller.value.position +
                                              const Duration(seconds: 10);
                                      controller.seekTo(newPosition);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),

                    // Play button in center (shows only initially or when paused)
                    if (isInitialized && !isPlaying && !_showControls)
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: IconButton(
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () {
                              controller.play();
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          } else {
            // Image display (your existing code)
            return Hero(
              tag: 'product-media-${index}',
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: CachedNetworkImage(
                  imageUrl: mediaItem.url,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[800],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.image_not_supported,
                            size: 64, color: Colors.white70),
                        SizedBox(height: 16),
                        Text(
                          'Image not available',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class MediaItem {
  final String url;
  final MediaType type;

  const MediaItem({required this.url, required this.type});

  // Helper to determine media type from URL or extension
  static MediaType getTypeFromUrl(String url) {
    final videoExtensions = [
      '.mp4',
      '.mov',
      '.avi',
      '.wmv',
      '.flv',
      '.webm',
      '.mkv'
    ];
    final lowercaseUrl = url.toLowerCase();

    for (final ext in videoExtensions) {
      if (lowercaseUrl.endsWith(ext)) {
        return MediaType.video;
      }
    }

    return MediaType.image;
  }
}

enum MediaType { image, video }

// Convert a list of URLs to a list of media items
List<MediaItem> convertUrlsToMediaItems(List<String> urls) {
  return urls
      .map((url) => MediaItem(
            url: url,
            type: MediaItem.getTypeFromUrl(url),
          ))
      .toList();
}
