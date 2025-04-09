import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leads/widgets/customActionbutton.dart';
import 'package:leads/widgets/custom_app_bar.dart';
import 'package:leads/widgets/custom_loader.dart';
import 'package:leads/widgets/custom_select.dart';
import 'package:leads/widgets/custom_text_field.dart';
import '../../data/models/categorymodel.dart';
import '../../data/models/category_details.dart';
import '../../utils/tags.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_snckbar.dart';
import 'category_controller.dart';

class AddCategoryPage extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());
  final String? catId;
  final CategoryDetailsModel? category;

  AddCategoryPage({super.key, this.catId, this.category}) {
    if (catId != null) {
      controller.fetchCategoryDetails(catId!).then((_) {
        if (controller.categoryDetails.isNotEmpty) {
          final details = controller.categoryDetails[0];
          print(details);
          controller.nameController.text = details.name;

          controller.descriptionController.text = details.description;
          controller.mainCategoryController.text = details.ucategoryId;
          controller.showMainCategoryController.text = details.ucategory;
          controller.subCatid.text = details.ucategoryId;
          if (details.iconimg.isNotEmpty) {
            controller.iconImageBase64.value = details.iconimg;
          }
          if (details.bannerimg.isNotEmpty) {
            controller.bannerImageBase64.value = details.bannerimg;
          }
        }
      });
    } else {
      controller.mainCategoryController.text = '0';
      controller.showMainCategoryController.text = 'Primary';
    }
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> pickImage(ImageSource source, RxString target) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1024,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64Image = "data:image/jpeg;base64,${base64Encode(bytes)}";
        if (target == controller.iconImageBase64) {
          controller.setIconImage(base64Image);
        } else {
          controller.setBannerImage(base64Image);
        }
      }
    } catch (e) {
      print("Error picking image: $e");
      CustomSnack.show(
        content: "Failed to pick image. Please try again.",
        snackType: SnackType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(
                controller.isEditing.value
                    ? "Edit Category"
                    : "Create Category",
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.resetForm();
              Get.back();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => _showHelpDialog(context),
            ),
          ],
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isLoading.value && catId != null) {
            return const Center(child: CustomLoader());
          }
          return _buildMainContent(context);
        }),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionWithHelp(
                'Category Details',
                'Basic information about your category',
                [
                  _buildAnimatedFormCard([
                    CustomTextField(
                      labelText: "Name",
                      hintText: "Enter category name",
                      textController: controller.nameController,
                      validator: (v) => v!.isEmpty ? "Required field" : null,
                      // prefixIcon: const Icon(Icons.category),
                      // helperText: "Choose a clear, descriptive name",
                    ),
                    const SizedBox(height: 16),
                    Obx(() => CustomSelect(
                          onTapField: () {
                            controller.showMainCategoryController.clear();
                            controller.mainCategoryController.clear();
                          },
                          label: "Parent Category",
                          placeholder: "Select parent category",
                          mainList: [
                            CustomSelectItem(id: '0', value: 'Primary'),
                            ...controller.mainCategories
                                .map((e) => CustomSelectItem(
                                      id: e.id,
                                      value: e.name,
                                    ))
                          ],
                          onSelect: (val) {
                            controller.mainCategoryController.text = val.id;
                            controller.showMainCategoryController.text =
                                val.value;
                          },
                          textEditCtlr: controller.showMainCategoryController,
                          // prefixIcon: const Icon(Icons.account_tree),
                        )),
                    const SizedBox(height: 16),
                    CustomTextField(
                      labelText: "Description",
                      hintText: "Enter category description...",
                      textController: controller.descriptionController,
                      maxLines: 3,
                      validator: (v) => v!.isEmpty ? "Required field" : null,
                      // prefixIcon: const Icon(Icons.description),
                      // helperText: "Provide a clear description of the category",
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionWithHelp(
                'Media Upload',
                'Add visual elements to your category',
                [
                  _buildAnimatedFormCard([
                    _buildEnhancedImageUploader(
                      context: context,
                      label: "Logo Image",
                      imageSource: controller.iconImageBase64.value,
                      color: Colors.orange,
                      onPressed: () => _showImageSourceDialog(
                          context,
                          controller.iconImageBase64,
                          "Select Logo Image Source"),
                      helperText:
                          "Upload a square logo image (recommended size: 200x200)",
                      icon: Icons.image,
                    ),
                    const SizedBox(height: 24),
                    _buildEnhancedImageUploader(
                      context: context,
                      label: "Banner Image",
                      imageSource: controller.bannerImageBase64.value,
                      color: Colors.blue,
                      onPressed: () => _showImageSourceDialog(
                          context,
                          controller.bannerImageBase64,
                          "Select Banner Image Source"),
                      helperText:
                          "Upload a banner image (recommended size: 1200x300)",
                      icon: Icons.panorama,
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 32),
              Obx(() => controller.isSaving.value
                  ? const Center(child: CustomLoader())
                  : _buildEnhancedActionButtons()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionWithHelp(
      String title, String subtitle, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildAnimatedFormCard(List<Widget> children) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildEnhancedImageUploader({
    required BuildContext context,
    required String label,
    required String imageSource,
    required Color color,
    required VoidCallback onPressed,
    required String helperText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          helperText,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3), width: 2),
            ),
            child: imageSource.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 48, color: color),
                      const SizedBox(height: 12),
                      Text(
                        "Tap to upload $label",
                        style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Click here to browse files",
                        style: TextStyle(
                          color: color.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildImageWidget(imageSource),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              if (label.contains("Logo")) {
                                controller.iconImageBase64.value = "";
                              } else {
                                controller.bannerImageBase64.value = "";
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomActionButton(
            type: CustomButtonType.cancel,
            onPressed: () {
              controller.resetForm();
              Get.back();
            },
            label: "Cancel",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomActionButton(
            type: controller.isEditing.value
                ? CustomButtonType.edit
                : CustomButtonType.save,
            onPressed: _handleFormSubmission,
            label:
                controller.isEditing.value ? "Save Changes" : "Create Category",
          ),
        ),
      ],
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.help_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text('Help Guide'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHelpSection(
                  'Category Name',
                  'Choose a clear, concise name that accurately describes your category. Avoid using special characters.',
                  Icons.category,
                ),
                const Divider(),
                _buildHelpSection(
                  'Parent Category',
                  'Select "Primary" if this is a main category, or choose an existing category as parent to create a subcategory.',
                  Icons.account_tree,
                ),
                const Divider(),
                _buildHelpSection(
                  'Description',
                  'Provide a detailed description of what this category represents. This helps users understand its purpose.',
                  Icons.description,
                ),
                const Divider(),
                _buildHelpSection(
                  'Images',
                  'Upload high-quality images for better visibility:\n• Logo: Square image (200x200px)\n• Banner: Rectangular image (1200x300px)',
                  Icons.image,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Got it!'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpSection(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog(
    BuildContext context,
    RxString target,
    String title,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery, target);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera, target);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageWidget(String imageSource) {
    if (imageSource.startsWith('http')) {
      return Container(
        width: double.infinity,
        // height: double.infinity,
        child: Image.network(
          imageSource,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorIcon(),
        ),
      );
    } else if (imageSource.startsWith('data:image')) {
      try {
        final bytes = base64Decode(imageSource.split(',').last);
        return Container(
          width: double.infinity,
          // height: double.infinity,
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildErrorIcon(),
          ),
        );
      } catch (e) {
        return _buildErrorIcon();
      }
    } else if (imageSource.isNotEmpty) {
      // Handle relative paths by combining with base URL
      final baseUrl = GetStorage().read(StorageTags.baseUrl) ?? '';
      return Container(
        width: double.infinity,
        // height: double.infinity,
        child: Image.network(
          "$baseUrl$imageSource",
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorIcon(),
        ),
      );
    }
    return _buildErrorIcon();
  }

  Widget _buildErrorIcon() {
    return Container(
      width: double.infinity,
      // height: double.infinity,
      child: const Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.red,
          size: 50,
        ),
      ),
    );
  }

  void _handleFormSubmission() {
    if (_formKey.currentState!.validate()) {
      if (catId != null) {
        controller.updateCategory(
            catId!,
            controller.categoryDetails.isNotEmpty
                ? controller.categoryDetails[0].code
                : '');
      } else {
        controller.saveCategory();
      }
    }
  }
}
