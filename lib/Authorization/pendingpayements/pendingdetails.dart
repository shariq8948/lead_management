import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      "id": "EMP234A",
      "name": "Samsung Galaxy S25 Flip, Slim Fit",
      "price": 270,
      "discount": "2% (GST 5%)",
      "qty": 27,
      "exportQty": 20,
      "pendingQty": 20,
      "totalAmount": 2056,
    },
    {
      "id": "EMP567B",
      "name": "Apple iPhone 14 Pro",
      "price": 1200,
      "discount": "5% (GST 12%)",
      "qty": 15,
      "exportQty": 10,
      "pendingQty": 5,
      "totalAmount": 18000,
    },
    {
      "id": "EMP890C",
      "name": "Google Pixel 8",
      "price": 899,
      "discount": "3% (GST 8%)",
      "qty": 10,
      "exportQty": 8,
      "pendingQty": 2,
      "totalAmount": 8990,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('#3qhejhe23'),
        backgroundColor: Colors.teal,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '27-Feb-2023, 20:34PM',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),

            const SizedBox(height: 16.0),

            // Dynamically generate order cards
            ...products.map((product) => _buildOrderCard(product)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'From,',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'PSM SoftTech PVT LTD\nMobile: +91 98989898\nEmail: akanksha021995@gmail.com',
            style: TextStyle(color: Colors.white),
          ),
          const Divider(color: Colors.white, height: 20.0),
          const Text(
            'To,',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'PSM SoftTech PVT LTD\nAddress: Lorem ipsum dolor sit amet consectetuer.\nScelerisque facilisi pulvinar nibh proin egestas pharetra.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Title
          Text(
            product['id'],
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          // Product Details
          Text(
            '${product['name']}\n₹ ${product['price']}     Dis: ${product['discount']}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailColumn('Qty', product['qty'].toString()),
              _buildDetailColumn('Export Qty', product['exportQty'].toString()),
              _buildDetailColumn(
                  'Pending Qty', product['pendingQty'].toString()),
              _buildDetailColumn('Total Amount', '₹ ${product['totalAmount']}'),
            ],
          ),
          const SizedBox(height: 16.0),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton('Approved', Colors.blue, Icons.check_circle),
              _buildActionButton('Hold', Colors.orange, Icons.pause_circle),
              _buildActionButton('Cancel', Colors.green, Icons.cancel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, Color color, IconData icon) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Add functionality for button taps
            print('$label pressed for product');
          },
          borderRadius: BorderRadius.circular(25.0),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2.0),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24.0,
            ),
          ),
        ),
        const SizedBox(height: 8.0), // Spacing between icon and label
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
