import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leads/Masters/productEntry/productListController.dart';
import 'package:leads/widgets/custom_button.dart';
import 'package:leads/widgets/custom_field.dart';
import 'package:leads/widgets/custom_select.dart';

class ProductEntryPage extends StatelessWidget {
  ProductEntryPage({super.key});
  final controller = Get.find<Productlistcontroller>();

  Future<void> pickImage(ImageSource source, RxString target) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      target.value = "data:image/jpeg;base64,${base64Encode(bytes)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.isEdit.value ? "Edit Product" : "Add New Product",
          style: const TextStyle(fontSize: 18),
        ),
        elevation: 0,
        actions: [
          // Add help button to app bar
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help Guide',
            onPressed: () => _showHelp(context),
          ),
          // Optional: Add a quick tips button
          // PopupMenuButton<String>(
          //   icon: const Icon(Icons.tips_and_updates_outlined),
          //   tooltip: 'Quick Tips',
          //   onSelected: (String value) {
          //     // Show a quick tip based on the selection
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(
          //         content: Text(_getQuickTip(value)),
          //         behavior: SnackBarBehavior.floating,
          //         duration: const Duration(seconds: 4),
          //         action: SnackBarAction(
          //           label: 'Dismiss',
          //           onPressed: () {},
          //         ),
          //       ),
          //     );
          //   },
          //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          //     const PopupMenuItem<String>(
          //       value: 'images',
          //       child: Text('Image Tips'),
          //     ),
          //     const PopupMenuItem<String>(
          //       value: 'pricing',
          //       child: Text('Pricing Tips'),
          //     ),
          //     const PopupMenuItem<String>(
          //       value: 'inventory',
          //       child: Text('Inventory Tips'),
          //     ),
          //   ],
          // ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _buildProductEntryForm(),
        ),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const ProductHelpDialog(),
    );
  }

  String _getQuickTip(String category) {
    switch (category) {
      case 'images':
        return 'Tip: Use square images (800x800px) for best results. Ensure good lighting and a clean background.';
      case 'pricing':
        return 'Tip: Remember to check competitor prices and maintain healthy margins. Consider seasonal pricing strategies.';
      case 'inventory':
        return 'Tip: Set min/max levels based on sales velocity and lead times. Consider seasonal demand variations.';
      default:
        return 'Tip: Fill all required fields marked with * for successful product creation.';
    }
  }

  Widget _buildProductEntryForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInformation(),
            const SizedBox(height: 20),
            _buildPricingSection(),
            const SizedBox(height: 20),
            _buildCategorySection(),
            const SizedBox(height: 20),
            _buildAdditionalInformation(),
            const SizedBox(height: 20),
            _buildImageSection(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInformation() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Basic Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CustomField(
              hintText: "Enter Product Name",
              labelText: "Product Name*",
              inputAction: TextInputAction.next,
              inputType: TextInputType.text,
              editingController: controller.nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a product name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomSelect(
                label: "Select Unit*",
                placeholder: "Please select a Unit",
                mainList: controller.units
                    .map((element) => CustomSelectItem(
                          id: element.id,
                          value: element.uName,
                        ))
                    .toList(),
                onSelect: (val) {
                  controller.unitController.text = val.id;
                  controller.showUnitController.text = val.value;
                },
                textEditCtlr: controller.showUnitController,
                showLabel: true,
                onTapField: () {
                  controller.unitController.clear();
                  controller.showUnitController.clear();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a unit';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pricing Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomField(
                    showLabel: true,
                    hintText: "Sale Rate",
                    labelText: "Sale Rate*",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.number,
                    editingController: controller.saleRateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (!value.isNum) {
                        return "Numbers Only";
                      }
                      // Check if sale rate exceeds MRP
                      final saleRate = double.tryParse(value) ?? 0;
                      final mrp =
                          double.tryParse(controller.mrpController.text) ?? 0;
                      if (mrp > 0 && saleRate > mrp) {
                        return 'cannot exceed MRP';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomField(
                    showLabel: true,
                    hintText: "MRP",
                    labelText: "MRP*",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.number,
                    editingController: controller.mrpController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (!value.isNum) {
                        return "Numbers Only";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => CustomSelect(
                      label: "Sale GST*",
                      placeholder: "Select Sale GST",
                      mainList: controller.sgst
                          .map((element) => CustomSelectItem(
                                id: element.id,
                                value: element.stax,
                              ))
                          .toList(),
                      onSelect: (val) {
                        controller.sgstController.text = val.id;
                        controller.showsgstController.text = val.value;
                      },
                      textEditCtlr: controller.showsgstController,
                      showLabel: true,
                      onTapField: () {
                        controller.sgstController.clear();
                        controller.showsgstController.clear();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }

                        if (!value.isNum) {
                          return "Numbers Only";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => CustomSelect(
                      label: "Purchase GST*",
                      placeholder: "Select Purchase GST",
                      mainList: controller.pgst
                          .map((element) => CustomSelectItem(
                                id: element.id,
                                value: element.ptax,
                              ))
                          .toList(),
                      onSelect: (val) {
                        controller.pgstController.text = val.id;
                        controller.showpgstController.text = val.value;
                      },
                      textEditCtlr: controller.showpgstController,
                      showLabel: true,
                      onTapField: () {
                        controller.pgstController.clear();
                        controller.showpgstController.clear();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomField(
                    showLabel: true,
                    hintText: "Discount %",
                    labelText: "Discount %*",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.number,
                    editingController: controller.discountController,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only digits
                      LengthLimitingTextInputFormatter(
                          3), // Limit input length to 3 characters
                      _DiscountInputFormatter(), // Custom formatter to restrict values above 100
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      int? discount = int.tryParse(value);
                      if (discount == null || discount > 100) {
                        return "Cannot exceed 100%";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => CustomSelect(
                      label: "HSN Code*",
                      placeholder: "Select HSN",
                      mainList: controller.hsn
                          .map((element) => CustomSelectItem(
                                id: element.id,
                                value: element.shortName,
                              ))
                          .toList(),
                      onSelect: (val) {
                        controller.hsnController.text = val.id;
                        controller.showhsnController.text = val.value;
                      },
                      textEditCtlr: controller.showhsnController,
                      showLabel: true,
                      onTapField: () {
                        controller.hsnController.clear();
                        controller.showhsnController.clear();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Classification",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomSelect(
                label: "Company*",
                placeholder: "Select Company",
                mainList: controller.company
                    .map((element) => CustomSelectItem(
                          id: element.id,
                          value: element.name,
                        ))
                    .toList(),
                onSelect: (val) {
                  controller.comapnyController.text = val.id;
                  controller.showCompanyController.text = val.value;
                },
                textEditCtlr: controller.showCompanyController,
                showLabel: true,
                onTapField: () {
                  controller.comapnyController.clear();
                  controller.showCompanyController.clear();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a company';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomSelect(
                label: "Category*",
                placeholder: "Select Category",
                mainList: controller.category
                    .map((element) => CustomSelectItem(
                          id: element.id,
                          value: element.name,
                        ))
                    .toList(),
                onSelect: (val) {
                  controller.categoryController.text = val.id;
                  controller.showCategoryController.text = val.value;
                },
                textEditCtlr: controller.showCategoryController,
                showLabel: true,
                onTapField: () {
                  controller.categoryController.clear();
                  controller.showCategoryController.clear();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInformation() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: ExpansionTile(
        title: const Text(
          "Additional Information",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomField(
                  hintText: "Enter barcode",
                  labelText: "Barcode",
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  editingController: controller.barcodeController,
                  showLabel: true,
                ),
                const SizedBox(height: 16),
                CustomSelect(
                  mainList: controller.sizecategoryItems,
                  onSelect: (selectedItem) {
                    controller.sizeController.text = selectedItem.value;
                  },
                  placeholder: 'Select Size Category',
                  label: 'Size Category',
                  textEditCtlr: controller.sizeController,
                  showLabel: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomField(
                        showLabel: true,
                        hintText: "Min. Order Qty",
                        labelText: "Minimum Order Quantity",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        editingController: controller.minQtyController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // Optional field
                          }
                          if (!value.isNum) {
                            return "Numbers Only";
                          }
                          final minQty = double.tryParse(value) ?? 0;
                          final maxQty = double.tryParse(
                                  controller.maxQtyController.text) ??
                              0;
                          if (maxQty > 0 && minQty > maxQty) {
                            return 'Min order cannot exceed max';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomField(
                        showLabel: true,
                        hintText: "Max. Order Qty",
                        labelText: "Maximum Order Quantity",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        editingController: controller.maxQtyController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // Optional field
                          }
                          if (!value.isNum) {
                            return "Numbers Only";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomField(
                        showLabel: true,
                        hintText: "Min Level",
                        labelText: "Minimum Stock Level",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        editingController: controller.minLevelController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // Optional field
                          }
                          if (!value.isNum) {
                            return "Numbers Only";
                          }
                          final minLevel = double.tryParse(value) ?? 0;
                          final maxLevel = double.tryParse(
                                  controller.maxLevelController.text) ??
                              0;
                          if (maxLevel > 0 && minLevel > maxLevel) {
                            return 'Min level cannot exceed max';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomField(
                        showLabel: true,
                        hintText: "Max Level",
                        labelText: "Maximum Stock Level",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        editingController: controller.maxLevelController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // Optional field
                          }
                          if (!value.isNum) {
                            return "Numbers Only";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                // Rest of the fields remain unchanged
                const SizedBox(height: 16),
                CustomField(
                  showLabel: true,
                  hintText: "Enter product description or remarks",
                  labelText: "Description",
                  inputAction: TextInputAction.newline,
                  inputType: TextInputType.multiline,
                  minLines: 3,
                  editingController: controller.descriptionController,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomField(
                        showLabel: true,
                        hintText: "Additional Note 1",
                        labelText: "Note 1",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        editingController: controller.remark1Controller,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomField(
                        showLabel: true,
                        hintText: "Additional Note 2",
                        labelText: "Note 2",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        editingController: controller.remark2Controller,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomField(
                        showLabel: true,
                        hintText: "Additional Note 3",
                        labelText: "Note 3",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        editingController: controller.remark3Controller,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomField(
                        showLabel: true,
                        hintText: "Additional Note 4",
                        labelText: "Note 4",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        editingController: controller.remark4Controller,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product Images",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _buildImagePickerButton(
                      label: "Product Logo",
                      imageBase64: controller.iconImageBase64,
                      color: Colors.blue,
                      onPressed: () => pickImage(
                        ImageSource.gallery,
                        controller.iconImageBase64,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => _buildImagePickerButton(
                      label: "Banner Image",
                      imageBase64: controller.bannerImageBase64,
                      color: Colors.orange,
                      onPressed: () => pickImage(
                        ImageSource.gallery,
                        controller.bannerImageBase64,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerButton({
    required String label,
    required RxString imageBase64,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: imageBase64.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, color: color, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImageWidget(imageBase64.value),
              ),
      ),
    );
  }

  Widget _buildImageWidget(String imageSource) {
    if (imageSource.startsWith('http')) {
      return Image.network(
        imageSource,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.red,
              size: 32,
            ),
          );
        },
      );
    } else {
      try {
        final bytes = base64Decode(imageSource.split(',').last);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.broken_image,
                color: Colors.red,
                size: 32,
              ),
            );
          },
        );
      } catch (e) {
        return const Center(
          child: Icon(
            Icons.broken_image,
            color: Colors.red,
            size: 32,
          ),
        );
      }
    }
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      onPressed: () {
        if (controller.formKey.currentState!.validate()) {
          if (controller.isEdit.value) {
            controller.updateProduct();
          } else {
            controller.addProduct();
          }
        }
      },
      buttonType: ButtonTypes.primary,
      width: Get.size.width,
      text: controller.isEdit.value ? "Update Product" : "Save Product",
      bgColor: Colors.blue,
    );
  }
}

class _DiscountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    int? value = int.tryParse(newValue.text);
    if (value == null || value > 100) {
      return oldValue; // Prevent input if greater than 100
    }
    return newValue;
  }
}

class ProductHelpDialog extends StatelessWidget {
  const ProductHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Product Entry Help Guide',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildHelpSection(
              'Basic Information',
              'Enter the fundamental details of your product:',
              [
                'Product Name: Enter a unique, descriptive name',
                'Unit: Select the measurement unit (e.g., pieces, kg, liters)',
              ],
            ),
            _buildHelpSection(
              'Pricing Details',
              'Configure the pricing structure:',
              [
                'Sale Rate: The selling price to customers',
                'MRP: Maximum Retail Price',
                'GST: Select applicable tax rates for sales and purchases',
                'Discount: Enter the standard discount percentage',
                'HSN Code: Harmonized System Nomenclature for tax classification',
              ],
            ),
            _buildHelpSection(
              'Classification',
              'Categorize your product:',
              [
                'Company: Select the manufacturing company',
                'Category: Choose the product category for organization',
              ],
            ),
            _buildHelpSection(
              'Additional Information',
              'Optional but useful details:',
              [
                'Barcode: Enter product barcode if available',
                'Size Category: Select the applicable size category',
                'Order Quantities: Set minimum and maximum order limits',
                'Stock Levels: Define minimum and maximum stock levels',
                'Notes: Add any additional remarks or product details',
              ],
            ),
            _buildHelpSection(
              'Images',
              'Add product visuals:',
              [
                'Product Logo: Upload a clear product image or logo',
                'Banner Image: Add a promotional banner image',
                'Supported formats: JPG, PNG',
                'Recommended size: 800x800 pixels',
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(
      String title, String description, List<String> points) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ...points.map((point) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 14)),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
          const Divider(),
        ],
      ),
    );
  }
}
