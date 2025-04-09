import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/Masters/category/categoryDetailController.dart';
import 'package:leads/Masters/productEntry/product_detail_controller.dart';
import 'package:leads/utils/tags.dart';
import 'package:leads/widgets/custom_loader.dart';

class CategoryDetailPage extends StatelessWidget {
  final CategoryDetailController controller =
      Get.put(CategoryDetailController());

  @override
  Widget build(BuildContext context) {
    // Extract the productId from arguments
    final categoryId = Get.arguments?['categoryId'];

    // Fetch product details on page load
    if (categoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchCategoryDetails("userId", categoryId);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomLoader());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.categoryDetails.isEmpty) {
          return const Center(child: Text("No product details available."));
        }

        // Since only one product detail is expected, directly access the first item

        return SingleChildScrollView(
          child: mainDetailsCard(),
        );
      }),
    );
  }

  Widget mainDetailsCard() {
    // Consolidate valid image paths into a single list
    List<String> imageList = [
      if (controller.categoryDetails[0].iconimg?.isNotEmpty ?? false)
        controller.categoryDetails[0].iconimg!,
      if (controller.categoryDetails[0].bannerimg?.isNotEmpty ?? false)
        controller.categoryDetails[0].bannerimg!,
    ];

    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Product Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (imageList.isNotEmpty)
            Center(
              child: Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: imageList.length,
                    itemBuilder: (context, index, realIndex) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: Get.context!,
                            builder: (context) => Dialog(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Image.network(
                                  "${GetStorage().read(StorageTags.baseUrl)}${imageList[index]}",
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                          child: Icon(Icons.error, size: 80)),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          "${GetStorage().read(StorageTags.baseUrl)}${imageList[index]}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 100),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 200.0,
                      aspectRatio: 16 / 9,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        // Handle page change if needed
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageList.map((imagePath) {
                      int index = imageList.indexOf(imagePath);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          else
            const Center(
              child: Icon(Icons.image_not_supported, size: 100),
            ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              controller.categoryDetails[0].name!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // buildAlignedInfoRow("MRP:", controller.categoryDetails[0].mrp!),
          buildAlignedInfoRow(
              "Description:", controller.categoryDetails[0].description!),
          // buildAlignedInfoRow(
          //     "Company:", controller.categoryDetails[0].c!),
          buildAlignedInfoRow("Category:", controller.categoryDetails[0].name!),
          buildAlignedInfoRow(
              "Sub-Category:", controller.categoryDetails[0].ucategory!),
          buildAlignedInfoRow("Code:", controller.categoryDetails[0].code!),
          buildAlignedInfoRow("Created By",
              controller.categoryDetails[0].createdby ?? "No Name"),
          buildAlignedInfoRow("Created On:",
              controller.categoryDetails[0].createdon ?? "No code"),
        ],
      ),
    );
  }

  Widget buildAlignedInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Adjust the label width as needed
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionalRemark(String label, String? remark) {
    if (remark == null || remark.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: buildAlignedInfoRow(label, remark),
    );
  }
}
