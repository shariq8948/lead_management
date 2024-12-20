import 'package:flutter/material.dart';

class Expensedetails extends StatelessWidget {
  const Expensedetails({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController hotelController = TextEditingController();
    final TextEditingController foodController = TextEditingController();
    final TextEditingController travelingController = TextEditingController();
    final TextEditingController localTravelingController =
        TextEditingController();
    final TextEditingController localTravelingKMController =
        TextEditingController();
    final TextEditingController otherExpensesController =
        TextEditingController();
    final TextEditingController remarkController = TextEditingController();
    final TextEditingController finalExpenseController =
        TextEditingController();

    hotelController.text = "100"; // Default value
    foodController.text = "200"; // Default value
    travelingController.text = "300"; // Default value
    localTravelingController.text = "150"; // Default value
    localTravelingKMController.text = "50"; // Default value
    otherExpensesController.text = "100"; // Default value
    remarkController.text = "No comments"; // Default value
    finalExpenseController.text = "1000"; // Default value

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Details"),
        // backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerCard(),
              const SizedBox(height: 16),
              expenseDetailsSection(
                hotelController,
                foodController,
                travelingController,
                localTravelingController,
                localTravelingKMController,
                otherExpensesController,
                remarkController,
                finalExpenseController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.deepPurple, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
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
              const Text(
                "General Details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              detailRow("Date", "2024-02-07"),
              detailRow("City", "Mumbai"),
              detailRow("State", "27-Maharashtra"),
              detailRow("Area", "Andheri"),
              detailRow("From", "2024-02-01"),
              detailRow("To", "2024-02-07"),
              detailRow("No. of Activity", "0"),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    print("View Attachment clicked");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    backgroundColor: Colors.teal, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12), // Larger border radius for a rounded look
                    ),
                    elevation: 5, // Added shadow for depth
                    shadowColor:
                        Colors.teal.withOpacity(0.4), // Subtle shadow color
                    side: BorderSide(
                        color: Colors.tealAccent,
                        width: 1.5), // Border with accent color
                  ),
                  child: Text(
                    "View Attachment",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget expenseDetailsSection(
    TextEditingController hotelController,
    TextEditingController foodController,
    TextEditingController travelingController,
    TextEditingController localTravelingController,
    TextEditingController localTravelingKMController,
    TextEditingController otherExpensesController,
    TextEditingController remarkController,
    TextEditingController finalExpenseController,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expense Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            buildExpenseForm(
              hotelController,
              foodController,
              travelingController,
              localTravelingController,
              localTravelingKMController,
              otherExpensesController,
              remarkController,
              finalExpenseController,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("Approve clicked");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Approve"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpenseForm(
    TextEditingController hotelController,
    TextEditingController foodController,
    TextEditingController travelingController,
    TextEditingController localTravelingController,
    TextEditingController localTravelingKMController,
    TextEditingController otherExpensesController,
    TextEditingController remarkController,
    TextEditingController finalExpenseController,
  ) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1.5),
      },
      children: [
        buildExpenseHeaderRow(),
        buildExpenseRow(
            "Hotel", hotelController, "150", "100"), // Proposed, Checker values
        buildExpenseRow("Food Expense", foodController, "200", "150"),
        buildExpenseRow("Traveling", travelingController, "300", "250"),
        buildExpenseRow(
            "Local Traveling", localTravelingController, "150", "130"),
        buildExpenseRow(
            "Local Traveling KM", localTravelingKMController, "50", "45"),
        buildExpenseRow("Other Expenses", otherExpensesController, "100", "90"),
        buildExpenseRow(
            "Remark", remarkController, "No comments", "Updated remarks",
            isTextArea: true),
        buildTotalRow("Total Expenses", "1000"), // Example value
      ],
    );
  }

  TableRow buildExpenseHeaderRow() {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.grey),
      children: [
        headerCell(""),
        headerCell("Proposed Expense"),
        headerCell("Checker Expense"),
        headerCell("Final Expense"),
      ],
    );
  }

  TableRow buildExpenseRow(String label, TextEditingController controller,
      String proposedValue, String checkerValue,
      {bool isTextArea = false}) {
    return TableRow(
      children: [
        tableCell(label),
        tableCell(proposedValue), // Proposed Expense (static value)
        tableCell(checkerValue), // Checker Expense (static value)
        editableField(controller, isTextArea), // Final Expense (editable)
      ],
    );
  }

  TableRow buildTotalRow(String label, String total) {
    return TableRow(
      children: [
        tableCell(label),
        tableCell(total), // Display total value in a read-only cell
        tableCell(""), // Empty for Checker Expense
        tableCell(""), // Empty for Final Expense
      ],
    );
  }

  Widget headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget editableField(TextEditingController controller, bool isTextArea) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isTextArea
          ? TextField(
              controller: controller,
              maxLines: 2,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            )
          : TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
    );
  }
}
