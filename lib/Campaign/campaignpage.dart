import 'package:flutter/material.dart';

class Campaignpage extends StatelessWidget {
  const Campaignpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("Comming soon..."),
        ],
      ),
    );
  }
}
