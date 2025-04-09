import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateSalesQuotationPdf({
  required String fromCompany,
  required String fromCall,
  required String fromEmail,
  required String fromContactPerson,
  required String toPhone,
  required String toEmail,
  required String quotationNo,
  required String dateTime,
  required String clientType,
  required List<Map<String, dynamic>> products,
  required String status,
  required String approvedBy,
  required String approvalDateTime,
  required String remarks,
  required double grandTotal,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header with Color
            pw.Text(
              'Sales Quotation',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green, // Set the color here
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                // From Section
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('From:',
                        style: pw.TextStyle(color: PdfColors.grey)),
                    pw.Text(fromCompany,
                        style: pw.TextStyle(color: PdfColors.black)),
                    pw.Text('Call: $fromCall',
                        style: pw.TextStyle(color: PdfColors.black)),
                    pw.Text('Email: $fromEmail',
                        style: pw.TextStyle(color: PdfColors.black)),
                    pw.Text('Contact Person: $fromContactPerson',
                        style: pw.TextStyle(color: PdfColors.black)),
                  ],
                ),
                // To Section
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('To:', style: pw.TextStyle(color: PdfColors.grey)),
                    pw.Text(toPhone,
                        style: pw.TextStyle(color: PdfColors.black)),
                    pw.Text(toEmail,
                        style: pw.TextStyle(color: PdfColors.black)),
                  ],
                ),
              ],
            ),
            pw.Divider(color: PdfColors.grey), // Divider color
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Quotation No: $quotationNo',
                  style: pw.TextStyle(color: PdfColors.black),
                ),
                pw.Text(
                  'Date & Time: $dateTime',
                  style: pw.TextStyle(color: PdfColors.black),
                ),
              ],
            ),
            pw.Text('Client Type: $clientType',
                style: pw.TextStyle(color: PdfColors.black)),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                  color: PdfColors.grey), // Table border color
              children: [
                // Header Row
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                      color: PdfColors.green), // Header background color
                  children: [
                    pw.Text('Sr',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.Text('Code',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.Text('Product Name',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.Text('Qty',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.Text('Exported Qty',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.Text('Pending Qty',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.Text('Rate',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.Text('Disc(%)',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.Text('Gst(%)',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.Text('Total',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                  ],
                ),
                // Product Rows
                ...products.map(
                  (product) => pw.TableRow(
                    children: [
                      pw.Text(product['sr'].toString(),
                          style: pw.TextStyle(color: PdfColors.black)),
                      pw.Text(product['code'].toString(),
                          style: pw.TextStyle(color: PdfColors.black)),
                      pw.Text(product['name'].toString(),
                          style: pw.TextStyle(color: PdfColors.black)),
                      pw.Text(product['qty'].toString(),
                          style: pw.TextStyle(color: PdfColors.black)),
                      pw.Text(product['exportedQty'].toString(),
                          style: pw.TextStyle(color: PdfColors.black)),
                      pw.Text(product['pendingQty'].toString(),
                          style: pw.TextStyle(color: PdfColors.black)),
                      pw.Text(product['rate'].toString(),
                          style: pw.TextStyle(color: PdfColors.black)),
                      pw.Text(product['discount'].toString(),
                          style: pw.TextStyle(color: PdfColors.black)),
                      pw.Text(product['gst'].toString(),
                          style: pw.TextStyle(color: PdfColors.black)),
                      pw.Text(product['total'].toString(),
                          style: pw.TextStyle(color: PdfColors.black)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Status: $status',
              style: pw.TextStyle(color: PdfColors.black),
            ),
            pw.Text(
              'By: $approvedBy',
              style: pw.TextStyle(color: PdfColors.black),
            ),
            pw.Text(
              'On: $approvalDateTime',
              style: pw.TextStyle(color: PdfColors.black),
            ),
            pw.Text(
              'Remarks: $remarks',
              style: pw.TextStyle(color: PdfColors.black),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Grand Total: $grandTotal',
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: PdfColors.green),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save());
}
