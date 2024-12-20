import 'package:flutter/material.dart';
class CustomCard extends StatelessWidget {
  final String name;
  final String date;
  final String status;
  final Color statusColor;
  final String phoneNumber;
  final String qualification;
  final IconData icon;

  const CustomCard({
    Key? key,
    required this.name,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.phoneNumber,
    required this.qualification,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with Icon, Name, and Arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24, color: Colors.blue),
                  SizedBox(width: 28),
                  Text(name, style: TextStyle(fontSize: 22, color: Colors.grey)),
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black.withOpacity(.7)),
            ],
          ),
          SizedBox(height: 16), // Space between rows

          // Row with Date, Status, Vertical Divider, Phone Number, and Qualification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 14),
                  Container(
                    width: 80,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        status,
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16), // Space before divider

              // Vertical Divider
              Container(
                width: 2,
                height: 60,
                color: Colors.grey[300],
              ),
              SizedBox(width: 16), // Space after divider

              // Phone Number and Qualification
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(phoneNumber, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  SizedBox(height: 4),
                  Text(qualification, style: TextStyle(fontSize: 14, color: Colors.grey[700],fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
