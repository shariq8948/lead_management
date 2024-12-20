import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final iconSize = width * 0.1; // Adjust the icon size as a percentage of screen width

    return Container(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background Image for the custom shape (Rectangle 1)
          Positioned(
            bottom: 0,
            left: 5,
            right: width * 0.56, // Use relative positioning
            child: Image.asset(
              'assets/images/rectangle.png', // Replace with your background shape image path
              width: width,
              height: 80, // Match height with the Container in bottomNavigationBar
              fit: BoxFit.contain, // Ensures it covers the available width
            ),
          ),

          // Background Image for the second shape (Rectangle 2)
          Positioned(
            bottom: 0,
            left: width * 0.56, // Use relative positioning
            right: 5,
            child: Image.asset(
              'assets/images/rectangle2.png', // Replace with your background shape image path
              width: width,
              height: 80, // Match height with the Container in bottomNavigationBar
              fit: BoxFit.contain, // Ensures it covers the available width
            ),
          ),

          // Search Icon replaced with custom image
          Positioned(
            bottom: 20, // Adjust as needed to position the icon vertically
            left: width * 0.15, // Position it based on screen width
            child: IconButton(
              icon: Image.asset(
                'assets/icons/home.png', // Replace with your custom search icon path
                width: iconSize, // Set the width of the image to be responsive
                height: iconSize, // Set the height of the image to be responsive
              ),
              onPressed: () {},
            ),
          ),

          // Home Icon replaced with custom image
          Positioned(
            bottom: 20, // Adjust as needed to position the icon vertically
            right: width * 0.15, // Position it based on screen width
            child: IconButton(
              icon: Image.asset(
                'assets/icons/search.png', // Replace with your custom home icon path
                width: iconSize, // Set the width of the image to be responsive
                height: iconSize, // Set the height of the image to be responsive
              ),
              onPressed: () {},
            ),
          ),

          // Bottom app bar content with other icons
          BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Center space or additional content can be added here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
