import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Masters/productEntry/product_detail_controller.dart';
import 'package:leads/widgets/custom_loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductDetailController controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    final productId = Get.arguments?['productId'];

    if (productId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchProductDetails("userId", productId);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          Obx(() {
            if (controller.productDetails.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                onPressed: () => _generatePdf(context),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomLoader());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.productDetails.isEmpty) {
          return const Center(child: Text("No product details available."));
        }

        return SingleChildScrollView(
          child: mainDetailsCard(),
        );
      }),
    );
  }

  Widget mainDetailsCard() {
    List<String> imageList = [
      if (controller.productDetails[0].imagepath?.isNotEmpty ?? false)
        controller.productDetails[0].imagepath!,
      if (controller.productDetails[0].appimagepath?.isNotEmpty ?? false)
        controller.productDetails[0].appimagepath!,
      if (controller.productDetails[0].image3?.isNotEmpty ?? false)
        controller.productDetails[0].image3!,
    ];

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Product Details",
                style: Theme.of(Get.context!).textTheme.titleLarge,
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Edit') {
                    print('Edit selected');
                  } else if (value == 'Delete') {
                    print('Delete selected');
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                                  "http://lead.mumbaicrm.com/${imageList[index]}",
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
                          "http://lead.mumbaicrm.com/${imageList[index]}",
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
                      onPageChanged: (index, reason) {},
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
          const SizedBox(height: 16),
          Center(
            child: Text(
              controller.productDetails[0].iname!,
              style: Theme.of(Get.context!).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 16),
          buildAlignedInfoRow("MRP:", controller.productDetails[0].mrp!),
          buildAlignedInfoRow(
              "Description:", controller.productDetails[0].itemdisc!),
          buildAlignedInfoRow(
              "Company:", controller.productDetails[0].company!),
          buildAlignedInfoRow(
              "Category:", controller.productDetails[0].igroup!),
          buildAlignedInfoRow(
              "Sub-Category:", controller.productDetails[0].undergroup!),
          buildAlignedInfoRow(
              "Status:", controller.productDetails[0].approvalstatus!),
          buildAlignedInfoRow(
              "Bar Code:", controller.productDetails[0].barcode!),
          buildAlignedInfoRow(
              "HSN:", controller.productDetails[0].sname ?? "No code"),
          buildAlignedInfoRow(
              "Sale Rate:", controller.productDetails[0].rate1 ?? "N/A"),
          buildAlignedInfoRow(
              "Size:", controller.productDetails[0].ssize ?? "N/A"),
          buildOptionalRemark("Remark 1", controller.productDetails[0].remark1),
          buildOptionalRemark("Remark 2", controller.productDetails[0].remark2),
          buildOptionalRemark("Remark 3", controller.productDetails[0].remark3),
          buildOptionalRemark("Remark 4", controller.productDetails[0].remark4),
          buildOptionalRemark("Remark 5", controller.productDetails[0].remark5),
          buildAlignedInfoRow(
              "Created By:", controller.productDetails[0].createdby ?? "N/A"),
          buildAlignedInfoRow(
              "Created On:", controller.productDetails[0].createdon ?? "N/A"),
          buildAlignedInfoRow(
              "Net Rate", controller.productDetails[0].netrate ?? "N/A"),
          buildAlignedInfoRow(
              "Purchase Rate", controller.productDetails[0].prate ?? "N/A"),
          buildAlignedInfoRow(
              "CP Rate", controller.productDetails[0].cprate ?? "N/A"),
        ],
      ),
    );
  }

  Widget buildAlignedInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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

  Future<void> _generatePdf(BuildContext context) async {
    final product = controller.productDetails[0];
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Product Details',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Text(
                    product.iname!,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                _buildPdfInfoRow('MRP:', product.mrp!),
                _buildPdfInfoRow('Description:', product.itemdisc!),
                _buildPdfInfoRow('Company:', product.company!),
                _buildPdfInfoRow('Category:', product.igroup!),
                _buildPdfInfoRow('Sub-Category:', product.undergroup!),
                _buildPdfInfoRow('Status:', product.approvalstatus!),
                _buildPdfInfoRow('Bar Code:', product.barcode!),
                _buildPdfInfoRow('HSN:', product.sname ?? 'No code'),
                _buildPdfInfoRow('Sale Rate:', product.rate1 ?? 'N/A'),
                _buildPdfInfoRow('Size:', product.ssize ?? 'N/A'),
                _buildPdfOptionalRemark('Remark 1', product.remark1),
                _buildPdfOptionalRemark('Remark 2', product.remark2),
                _buildPdfOptionalRemark('Remark 3', product.remark3),
                _buildPdfOptionalRemark('Remark 4', product.remark4),
                _buildPdfOptionalRemark('Remark 5', product.remark5),
                _buildPdfInfoRow('Created By:', product.createdby ?? 'N/A'),
                _buildPdfInfoRow('Created On:', product.createdon ?? 'N/A'),
                _buildPdfInfoRow('Net Rate', product.netrate ?? 'N/A'),
                _buildPdfInfoRow('Purchase Rate', product.prate ?? 'N/A'),
                _buildPdfInfoRow('CP Rate', product.cprate ?? 'N/A'),
              ],
            ),
          );
        },
      ),
    );

    try {
      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/product_details.pdf');
      await file.writeAsBytes(bytes);

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }

  pw.Widget _buildPdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfOptionalRemark(String label, String? remark) {
    if (remark == null || remark.isEmpty) return pw.SizedBox.shrink();
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
      child: _buildPdfInfoRow(label, remark),
    );
  }
}
