import 'package:flutter/material.dart';

class MobileTableView extends StatelessWidget {
  final List<Map<String, String>> data = [
    {
      "Date": "21/04/2024",
      "Customer": "Suyog ss",
      "Mobile": "N/A",
      "Amount": "430",
      "Mode of Payment": "Cash",
      "Cheque No./Ref.No": "yfrryr22466",
      "Bank": "00091325465554",
      "Remark": "This is for testing",
      "Collected By": "L4west L4west"
    },
    {
      "Date": "17/03/2024",
      "Customer": "Harshad",
      "Mobile": "9322652067",
      "Amount": "6630",
      "Mode of Payment": "Cash",
      "Cheque No./Ref.No": "",
      "Bank": "",
      "Remark": "",
      "Collected By": "mr4 mr4"
    },
    {
      "Date": "17/03/2024",
      "Customer": "Harshad",
      "Mobile": "9322652067",
      "Amount": "6630",
      "Mode of Payment": "Cash",
      "Cheque No./Ref.No": "",
      "Bank": "",
      "Remark": "",
      "Collected By": "mr4 mr4"
    },
    {
      "Date": "17/03/2024",
      "Customer": "Harshad",
      "Mobile": "9322652067",
      "Amount": "6630",
      "Mode of Payment": "Cash",
      "Cheque No./Ref.No": "",
      "Bank": "",
      "Remark": "",
      "Collected By": "mr4 mr4"
    },
    {
      "Date": "17/03/2024",
      "Customer": "Harshad",
      "Mobile": "9322652067",
      "Amount": "6630",
      "Mode of Payment": "Cash",
      "Cheque No./Ref.No": "",
      "Bank": "",
      "Remark": "",
      "Collected By": "mr4 mr4"
    },
    {
      "Date": "17/03/2024",
      "Customer": "Harshad",
      "Mobile": "9322652067",
      "Amount": "6630",
      "Mode of Payment": "Cash",
      "Cheque No./Ref.No": "",
      "Bank": "",
      "Remark": "",
      "Collected By": "mr4 mr4"
    },
    {
      "Date": "17/03/2024",
      "Customer": "Harshad",
      "Mobile": "9322652067",
      "Amount": "6630",
      "Mode of Payment": "Cash",
      "Cheque No./Ref.No": "",
      "Bank": "",
      "Remark": "",
      "Collected By": "mr4 mr4"
    },
    {
      "Date": "17/03/2024",
      "Customer": "Harshad",
      "Mobile": "9322652067",
      "Amount": "6630",
      "Mode of Payment": "Cash",
      "Cheque No./Ref.No": "",
      "Bank": "",
      "Remark": "",
      "Collected By": "mr4 mr4"
    },
    // Add more entries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final entry = data[index];
              return buildPayementsCard(entry, index); // Use the custom widget
            },
          ),
        ),
      ),
    );
  }

  Widget buildPayementsCard(final Map<String, String> entry, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(entry["Date"] ?? "N/A",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              Divider(),
              // Customer Name Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Name:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(entry["Customer"] ?? "N/A",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              Divider(),
              // Mobile Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mobile:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(entry["Mobile"] ?? "N/A",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              Divider(),
              // Cheque No. and Ref. No. Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cheque No.:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(entry["Cheque No."] ?? "N/A",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ref. No.:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(entry["Ref.No"] ?? "N/A",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              Divider(),
              // Bank Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bank:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(entry["Bank"] ?? "N/A",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              Divider(),
              // Remark Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Remark:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(entry["Remark"] ?? "N/A",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              Divider(),
              // Collected By Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Collected By:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(entry["Collected By"] ?? "N/A",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              Divider(),
              // Amount Row (Highlighted)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Amount:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.green[100], // Light green background
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "₹${entry["Amount"] ?? "0"}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800], // Dark green text color
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              // Action Buttons Row
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle Decline button action
                      print("Declined entry $index");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Vibrant red for Decline
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Decline"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Approve button action
                      print("Approved entry $index");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green, // Vibrant green for Approve
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Approve"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
