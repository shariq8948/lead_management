import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/widgets/custom_button.dart';
import 'package:leads/widgets/custom_field.dart';
import '../widgets/custom_search_field.dart';
import 'item_controller.dart';

class ItemListPage extends StatelessWidget {
  final ItemController controller = Get.put(ItemController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      // Load more items when scrolled to the bottom
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (controller.hasMoreLeads.value && !controller.isFetchingMore.value) {
          controller.fetchProducts(isInitialFetch: false); // Fetch more items
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Item List"),
        actions: [
          Stack(
            clipBehavior: Clip.none, // Ensures the text doesn't get clipped
            children: [
              IconButton(
                onPressed: () {
                  _showCheckoutBottomSheet(context);
                },
                icon: Icon(Icons.shopping_cart, size: 35),
              ),
              Positioned(
                top: 4, // Adjust the vertical position of the text
                left: 1, // Adjust the horizontal position of the text
                child: Container(
                  height: 20,
                  width: 15,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(
                    () => Center(
                      child: Text(
                        controller.selectedItems.length.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard
        },
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
              ),
            ),
            child: Obx(() {
              return Column(
                // spacing: 100,
                children: [
                  CustomSearchField(
                    hintText: "hintText",
                    controller: controller.seacrchController,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller:
                          _scrollController, // Set scroll controller for pagination
                      itemCount: controller.productList.length +
                          1, // Add 1 for the loading indicator
                      itemBuilder: (context, index) {
                        if (index == controller.productList.length) {
                          // Show a loading indicator at the bottom if more items are loading
                          return controller.isFetchingMore.value
                              ? Center(child: CircularProgressIndicator())
                              : SizedBox
                                  .shrink(); // Return an empty space if no more data to load
                        }

                        final item = controller.productList[index];

                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10.0,
                              ),
                            ],
                            border: Border(
                              bottom: BorderSide(
                                  width: 2,
                                  color: Colors.blue.withOpacity(0.4)),
                              top: BorderSide(
                                  width: 1,
                                  color: Colors.blue.withOpacity(0.4)),
                              right: BorderSide(
                                  width: .5,
                                  color: Colors.blue.withOpacity(0.4)),
                              left: BorderSide(
                                  width: 1.5,
                                  color: Colors.blue.withOpacity(0.4)),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Item Name
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Out of Stock", // Modify based on your actual data
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Obx(
                                      () => IconButton(
                                        icon: item.isSelected.value
                                            ? Icon(Icons.delete,
                                                color: Colors.red)
                                            : Icon(Icons.add,
                                                color: Colors.green),
                                        onPressed: () {
                                          if (!item.isSelected.value) {
                                            item.isSelected.value = true;
                                            controller.addItem(item);
                                          } else {
                                            controller.removeItem(item);
                                            item.isSelected.value = false;
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                // Item details like iname, group, etc.
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.iname,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${item.igroup}(GST ${item.stax} %)",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                // Quantity and Discount Fields
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomField(
                                        hintText: "Enter Quantity",
                                        labelText: "Quantity",
                                        inputAction: TextInputAction.next,
                                        inputType: TextInputType.number,
                                        editingController: item.qtyController,
                                        showLabel: true,
                                        onChange: (value) {
                                          // Update the observable value
                                          item.qty.value =
                                              int.tryParse(value!) ?? 0;
                                        },
                                      ),
                                    ),
                                    // IconButton(
                                    //   onPressed: () {
                                    //     // Increment the qty
                                    //     controller.increment(item);
                                    //   },
                                    //   icon: Icon(Icons.add),
                                    // ),
                                    SizedBox(width: Get.size.width * .4),
                                    Expanded(
                                      child: CustomField(
                                        hintText: "Enter Discount",
                                        labelText: "Discount %",
                                        inputAction: TextInputAction.none,
                                        inputType: TextInputType.number,
                                        editingController:
                                            item.discountController,
                                        showLabel: true,
                                        onChange: (value) {
                                          // Update the observable discount
                                          item.discount.value =
                                              double.tryParse(value!) ?? 0.0;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                // Rate and GST
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "Rate: ₹${item.rate1}",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "MRP: ${item.netrate}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      double discountedPrice =
                                          int.tryParse(item.rate1)! -
                                              (int.tryParse(item.rate1)! *
                                                  item.discount.value /
                                                  100);
                                      double finalPrice = discountedPrice +
                                          (discountedPrice *
                                              int.tryParse(item.stax)! /
                                              100);
                                      return Text(
                                        "₹${(item.qty * finalPrice).toStringAsFixed(2)}", // Total price after discount and GST
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  void _showCheckoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CheckoutBottomSheet();
      },
    );
  }
}

class CheckoutBottomSheet extends StatelessWidget {
  final ItemController controller = Get.find<ItemController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  // Make the entire content scrollable
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Checkout",
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width > 600 ? 20 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(() {
                        return Column(
                          children: List.generate(
                              controller.selectedItems.length, (index) {
                            final item = controller.selectedItems[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.iname,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text("Code: ${item.company}"),
                                              Spacer(),
                                              Text("Rate: ₹${item.rate1}"),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              // Editable Quantity Field
                                              Expanded(
                                                flex: 2,
                                                child: TextField(
                                                  controller:
                                                      item.qtyController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    labelText: "Qty",
                                                    border:
                                                        OutlineInputBorder(),
                                                    isDense: true,
                                                  ),
                                                  onChanged: (value) {
                                                    item.qty.value =
                                                        int.tryParse(value) ??
                                                            0;
                                                  },
                                                ),
                                              ),

                                              SizedBox(width: 10),
                                              // Editable Discount Field
                                              Expanded(
                                                flex: 2,
                                                child: TextField(
                                                  controller:
                                                      item.discountController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    labelText: "Discount %",
                                                    border:
                                                        OutlineInputBorder(),
                                                    isDense: true,
                                                  ),
                                                  onChanged: (value) {
                                                    item.discount.value =
                                                        double.tryParse(
                                                                value) ??
                                                            0.0;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Obx(() {
                                          // Calculate discounted price
                                          double discountedPrice =
                                              int.tryParse(item.rate1)! -
                                                  (int.tryParse(item.rate1)! *
                                                      item.discount.value /
                                                      100);

                                          // Add GST to the discounted price
                                          double finalPrice = discountedPrice +
                                              (discountedPrice *
                                                  int.tryParse(item.stax)! /
                                                  100);

                                          return Text(
                                            "₹${(item.qty.value * finalPrice).toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Displaying Total Price
              Obx(() {
                double totalPrice =
                    controller.selectedItems.fold(0.0, (total, item) {
                  // Calculate discounted price per item
                  double discountedPrice = int.tryParse(item.rate1)! -
                      (int.tryParse(item.rate1)! * item.discount.value / 100);

                  // Add GST
                  double finalPrice = discountedPrice +
                      (discountedPrice * int.tryParse(item.stax)! / 100);

                  // Add the item price based on quantity
                  return total + (item.qty.value * finalPrice);
                });

                return Text(
                  "Total: ₹${totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 18,
                  ),
                );
              }),
              SizedBox(height: 10),
              // Fixed button section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Close"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          // Implement saving and printing logic here
                        },
                        buttonType: ButtonTypes.primary,
                        width: Get.size.width * 0.5,
                        text: "Save And Print",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
