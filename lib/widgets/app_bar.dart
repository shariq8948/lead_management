import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/widgets/custom_field.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final List<Widget>? actions;
  final bool isBack;
  final double elevation;
  final RxBool? showSearch; // Optional search state
  final TextEditingController _searchController = TextEditingController();

  // Flag to control whether to show the search field or not
  final bool shouldShowSearch;

  // API function to call on search
  final Future<void> Function(String query)? onSearch;

  CustomAppBar({
    Key? key,
    required this.titleText,
    this.actions,
    this.isBack = false,
    this.elevation = 4.0,
    this.showSearch, // Optional, can be null
    this.shouldShowSearch =
        true, // Set to true if you want the search functionality on this screen
    this.onSearch, // Function to call when search text changes
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      leading: isBack
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      backgroundColor: Colors.teal,
      title: Obx(
        () {
          return shouldShowSearch && showSearch != null && showSearch!.value
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomField(
                      hintText: "Search",
                      labelText: "Search",
                      inputAction: TextInputAction.search,
                      inputType: TextInputType.text,
                      editingController: _searchController,
                      onChange: (value) {
                        if (onSearch != null) {
                          // Call the API function when text changes
                          onSearch!(value!);
                        }
                      },
                    ),
                  ),
                )
              : Text(
                  titleText,
                  style: TextStyle(color: Colors.black),
                );
        },
      ),
      actions: [
        if (shouldShowSearch)
          Obx(
            () {
              return IconButton(
                icon: Icon(
                  showSearch != null && showSearch!.value
                      ? Icons.close
                      : Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (showSearch != null) {
                    showSearch!.value =
                        !showSearch!.value; // Toggle search visibility
                  }
                },
              );
            },
          ),
        if (actions != null) ...actions!,
      ],
    );
  }
}
