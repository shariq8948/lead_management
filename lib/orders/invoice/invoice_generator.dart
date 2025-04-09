import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../data/models/dropdown_list.model.dart';
import '../model/product.dart';

class InvoiceGenerator {
  // Company constants
  static const String COMPANY_NAME = 'PSM Soft-tech pvt ltd';
  static const String COMPANY_ADDRESS = '226/230,royal palms,aarey';
  static const String COMPANY_CITY = 'Mumbai, Maharashtra, 222255';
  static const String COMPANY_PHONE = '+91988765432';
  static const String COMPANY_GST = 'GSTIN0000111110N';
  static const String COMPANY_EMAIL = 'support@psmsoftech.com';
  static const String COMPANY_LOGO_PATH = 'assets/images/logo.png';

  // Currency formatter
  static final currencyFormat = NumberFormat.currency(
    symbol: '₹',
    locale: 'hi_IN',
    decimalDigits: 2,
  );

  /// Generates a PDF invoice and returns the file path
  static Future<String> generateInvoice({
    required List<Products> items,
    required double totalAmount,
    required double totalSavings,
    required CustomerResponseModel customer,
    required double? advanceAmount,
    required String? paymentMode,
    required String? utrNumber,
    required double totalGST,
    String? orderNumber,
  }) async {
    final pdf = pw.Document();

    // Load fonts
    final font = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();
    final italicFont = await PdfGoogleFonts.notoSansItalic();

    // Try to load the logo
    pw.MemoryImage? logoImage;
    try {
      final logoBytes = await rootBundle.load(COMPANY_LOGO_PATH);
      logoImage = pw.MemoryImage(logoBytes.buffer
          .asUint8List(logoBytes.offsetInBytes, logoBytes.lengthInBytes));
    } catch (e) {
      print('Logo not found: $e');
      // Continue without logo
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildWatermark(context, boldFont),
        footer: (context) => _buildPageFooter(context, font, italicFont),
        build: (pw.Context context) => [
          _buildHeader(boldFont, logoImage, orderNumber),
          pw.SizedBox(height: 20),
          _buildInvoiceInfo(boldFont, font, customer, orderNumber),
          pw.SizedBox(height: 20),
          _buildItemsTable(items, font, boldFont),
          pw.SizedBox(height: 20),
          _buildPaymentSection(
            totalAmount,
            totalSavings,
            totalGST,
            advanceAmount,
            paymentMode,
            utrNumber,
            boldFont,
            font,
          ),
          pw.SizedBox(height: 30),
          _buildTermsAndConditions(boldFont, font),
        ],
      ),
    );

    return await _saveDocument(pdf);
  }

  /// Builds the "Original Bill" watermark in the header
  static pw.Widget _buildWatermark(pw.Context context, pw.Font boldFont) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        'Original Bill',
        style: pw.TextStyle(
          font: boldFont,
          color: PdfColors.grey300,
          fontSize: 24,
        ),
      ),
    );
  }

  /// Builds the invoice header with logo and title
  static pw.Widget _buildHeader(
      pw.Font boldFont, pw.MemoryImage? logoImage, String? orderNumber) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  if (logoImage != null)
                    pw.Container(
                      height: 50,
                      width: 50,
                      margin: const pw.EdgeInsets.only(right: 10),
                      child: pw.Image(logoImage),
                    ),
                  pw.Text(
                    'Billing details',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 40,
                      color: PdfColors.blue900,
                    ),
                  ),
                ],
              ),
              if (orderNumber != null && orderNumber.isNotEmpty)
                pw.Text(
                  'Order #: $orderNumber',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 16,
                  ),
                ),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: 'Order #: $orderNumber',
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the invoice information section with company and customer details
  static pw.Widget _buildInvoiceInfo(
    pw.Font boldFont,
    pw.Font font,
    CustomerResponseModel customer,
    String? orderNumber,
  ) {
    final boxDecoration = pw.BoxDecoration(
      color: PdfColors.grey100,
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      border: pw.Border.all(color: PdfColors.grey300),
    );

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Company information (From)
        pw.Expanded(
          flex: 2,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: boxDecoration,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('From:', style: pw.TextStyle(font: boldFont)),
                pw.SizedBox(height: 5),
                pw.Text(COMPANY_NAME, style: pw.TextStyle(font: font)),
                pw.Text(COMPANY_ADDRESS, style: pw.TextStyle(font: font)),
                pw.Text(COMPANY_CITY, style: pw.TextStyle(font: font)),
                pw.Text('Phone: $COMPANY_PHONE',
                    style: pw.TextStyle(font: font)),
                pw.Text('GSTIN: $COMPANY_GST', style: pw.TextStyle(font: font)),
                pw.Text('Email: $COMPANY_EMAIL',
                    style: pw.TextStyle(font: font)),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 20),

        // Customer information (Bill To)
        pw.Expanded(
          flex: 2,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: boxDecoration,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Bill To:', style: pw.TextStyle(font: boldFont)),
                pw.SizedBox(height: 5),
                pw.Text(customer.name ?? "", style: pw.TextStyle(font: font)),
                if (customer.address1?.isNotEmpty ?? false)
                  pw.Text(customer.address1!, style: pw.TextStyle(font: font)),
                if (customer.mobile.isNotEmpty)
                  pw.Text('Phone: ${customer.mobile}',
                      style: pw.TextStyle(font: font)),
                if (customer.email?.isNotEmpty ?? false)
                  pw.Text('Email: ${customer.email}',
                      style: pw.TextStyle(font: font)),
                if (customer.gstNo.isNotEmpty)
                  pw.Text('GSTIN: ${customer.gstNo}',
                      style: pw.TextStyle(font: font)),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 20),

        // Invoice details
        pw.Expanded(
          flex: 1,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: boxDecoration,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Invoice Details:',
                    style: pw.TextStyle(font: boldFont)),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Date:', style: pw.TextStyle(font: font)),
                    pw.Text(DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        style: pw.TextStyle(font: font)),
                  ],
                ),
                if (orderNumber != null && orderNumber.isNotEmpty)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Order #:', style: pw.TextStyle(font: font)),
                      pw.Text(orderNumber, style: pw.TextStyle(font: font)),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the items table with product details
  static pw.Widget _buildItemsTable(
    List<Products> items,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(3), // Item name
        1: const pw.FlexColumnWidth(1), // Item Code
        2: const pw.FlexColumnWidth(2), // HSN/SAC
        3: const pw.FlexColumnWidth(1), // Qty
        4: const pw.FlexColumnWidth(2), // Rate
        5: const pw.FlexColumnWidth(1), // Discount
        6: const pw.FlexColumnWidth(1), // GST %
        7: const pw.FlexColumnWidth(2), // GST Amt
        8: const pw.FlexColumnWidth(2), // Total
      },
      children: [
        // Table header
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _tableHeader('Item Description', boldFont),
            _tableHeader('Code', boldFont),
            _tableHeader('HSN/SAC', boldFont),
            _tableHeader('Qty', boldFont),
            _tableHeader('Rate', boldFont),
            _tableHeader('Disc.%', boldFont),
            _tableHeader('GST%', boldFont),
            _tableHeader('GST Amt', boldFont),
            _tableHeader('Total', boldFont),
          ],
        ),
        // Table rows for each item
        ...items.map((item) {
          // Calculate values for each row
          final price = double.tryParse(item.saleRate) ??
              (double.tryParse(item.mrp) ?? 0);
          final subtotal = price * item.qty.value;
          final discount = subtotal * (item.discount.value / 100);
          final afterDiscount = subtotal - discount;
          final gstRate = double.tryParse(item.gst) ?? 0;
          final gstAmount = (afterDiscount * gstRate) / 100;
          final total = afterDiscount + gstAmount;

          return pw.TableRow(
            children: [
              _tableCell(item.itemName, font,
                  alignment: pw.Alignment.centerLeft),
              _tableCell(item.itemCode ?? '-', font),
              _tableCell(item.hsn ?? '-', font),
              _tableCell('${item.qty.value}', font),
              _tableCell(currencyFormat.format(price), font),
              _tableCell('${item.discount.value}%', font),
              _tableCell('${item.gst}%', font),
              _tableCell(currencyFormat.format(gstAmount), font),
              _tableCell(currencyFormat.format(total), font),
            ],
          );
        }).toList(),
      ],
    );
  }

  /// Builds the payment section with totals and payment details
  static pw.Widget _buildPaymentSection(
    double totalAmount,
    double totalSavings,
    double totalGST,
    double? advanceAmount,
    String? paymentMode,
    String? utrNumber,
    pw.Font boldFont,
    pw.Font font,
  ) {
    final hasAdvancePayment = advanceAmount != null && advanceAmount > 0;
    final remainingAmount = hasAdvancePayment
        ? totalAmount + totalGST - advanceAmount
        : totalAmount + totalGST;

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Payment details section (left side)
        pw.Expanded(
          flex: 3,
          child: hasAdvancePayment
              ? pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(8)),
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Payment Details:',
                          style: pw.TextStyle(font: boldFont, fontSize: 14)),
                      pw.SizedBox(height: 8),
                      _paymentDetailRow('Advance Amount:',
                          currencyFormat.format(advanceAmount), font),
                      _paymentDetailRow(
                          'Payment Mode:', paymentMode ?? 'N/A', font),
                      if (paymentMode?.toLowerCase() != 'cash' &&
                          utrNumber?.isNotEmpty == true)
                        _paymentDetailRow(
                            'UTR/Reference:', utrNumber ?? 'N/A', font),
                      _paymentDetailRow('Remaining Amount:',
                          currencyFormat.format(remainingAmount), font),
                    ],
                  ),
                )
              : pw.Container(),
        ),

        // Totals section (right side)
        pw.Expanded(
          flex: 2,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              border: pw.Border.all(color: PdfColors.grey300),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _totalRow('Subtotal:', totalAmount + totalSavings, boldFont),
                _totalRow('Total Savings:', -totalSavings, boldFont),
                _totalRow('Total GST:', totalGST, boldFont),
                pw.Divider(thickness: 2),
                _totalRow('Grand Total:', totalAmount + totalGST, boldFont,
                    isTotal: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the terms and conditions section
  static pw.Widget _buildTermsAndConditions(pw.Font boldFont, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Terms & Conditions',
            style: pw.TextStyle(font: boldFont, fontSize: 14),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            '1. Payment is due within 30 days from the date of invoice\n'
            '2. Please include invoice number in all payment communications\n'
            '3. Make all checks payable to $COMPANY_NAME\n'
            '4. Late payments are subject to a 2% monthly interest charge\n'
            '5. This is a computer-generated invoice, no signature required',
            style: pw.TextStyle(font: font, fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// Builds the page footer with generation date and page numbers
  static pw.Widget _buildPageFooter(
      pw.Context context, pw.Font font, pw.Font italicFont) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      padding: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: pw.TextStyle(font: italicFont, fontSize: 8),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(font: font, fontSize: 8),
          ),
        ],
      ),
    );
  }

  /// Helper method to create table header cells
  static pw.Widget _tableHeader(String text, pw.Font boldFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: boldFont,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Helper method to create table data cells
  static pw.Widget _tableCell(
    String text,
    pw.Font font, {
    pw.Alignment alignment = pw.Alignment.center,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      alignment: alignment,
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 10),
      ),
    );
  }

  /// Helper method to create total rows in the summary section
  static pw.Widget _totalRow(
    String title,
    double amount,
    pw.Font boldFont, {
    bool isTotal = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: isTotal ? 14 : 12,
            ),
          ),
          pw.Text(
            currencyFormat.format(amount.abs()),
            style: pw.TextStyle(
              font: boldFont,
              fontSize: isTotal ? 14 : 12,
              color: amount < 0 ? PdfColors.green : PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to create payment detail rows
  static pw.Widget _paymentDetailRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(font: font)),
          pw.Text(value, style: pw.TextStyle(font: font)),
        ],
      ),
    );
  }

  /// Saves the PDF document to the file system and returns the path
  static Future<String> _saveDocument(pw.Document pdf) async {
    final dir = await getApplicationDocumentsDirectory();
    final String fileName =
        'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  /// Shares the invoice using the device's share functionality
  static Future<ShareResult> shareInvoice(String filePath) async {
    final result = await Share.shareXFiles(
      [XFile(filePath)],
      subject: 'Invoice ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
      text: 'Please find attached your invoice.',
    );
    return result;
  }
}
