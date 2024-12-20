import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/QuotationEntry/quotation_entry_controller.dart';
import '../widgets/custom_search_field.dart';
import 'item_listPage.dart';

class QuotationEntryPage extends StatelessWidget {
  QuotationEntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuotationEntryController controller =
        Get.put(QuotationEntryController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Quotation Entry"),
          bottom: const TabBar(
            indicatorColor: Colors.teal,
            tabs: [
              Tab(text: "Customer"),
              Tab(text: "Prospect"),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFE1FFED), Color(0xFFE6E6E6)],
            ),
          ),
          child: TabBarView(
            children: [
              _buildCustomerTab(controller),
              // _buildProspectTab(controller),
              Container(
                child: Text("Prospect data"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerTab(QuotationEntryController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Search:"),
              const SizedBox(width: 8),
              Expanded(
                child: CustomSearchField(
                  hintText: "Search customer...",
                  controller: controller.customerSearchController,
                  onSearch: (query) => controller.filterCustomerData(query),
                  onClear: controller.clearCustomerSearch,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.customerData.isEmpty) {
                return const Center(child: Text("No customers found"));
              }

              // Correcting itemCount to reflect the actual number of items
              return ListView.builder(
                itemCount: controller.customerData.length +
                    (controller.hasMoreCustomers.value
                        ? 1
                        : 0), // Add extra item for the loading indicator
                itemBuilder: (context, index) {
                  // If the index is the last item and more data is available, load more data
                  if (index == controller.customerData.length &&
                      controller.hasMoreCustomers.value) {
                    controller.fetchCustomers(
                        isInitialFetch: false); // Fetch more data
                    return const Center(child: CircularProgressIndicator());
                  }

                  final customer = controller.customerData[index];
                  return CustomerCard(
                    onUpdate: () {
                      Get.to(
                        () => ItemListPage(),
                      );
                    },
                    id: customer.id,
                    name: customer.name ?? "No Name",
                    mobile: "customer.mobile",
                    email:
                        (customer.email == "") ? "No email" : customer.email!,
                    state: customer.state,
                    city: customer.city,
                  );

                  //   Card(
                  //   elevation: 1,
                  //   child: ListTile(
                  //     title: Text(customer.name ?? "No Name"),
                  //     subtitle: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text("Mobile: ${customer.mobile ?? 'N/A'}"),
                  //         Text("Email: ${customer.email ?? 'N/A'}"),
                  //       ],
                  //     ),
                  //     trailing: IconButton(
                  //       icon: const Icon(Icons.arrow_forward_ios),
                  //       onPressed: () {
                  //         Get.to(() => ItemListPage(),
                  //           transition: Transition.rightToLeftWithFade,
                  //           curve: Curves.easeInOutExpo,
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // );
                },
              );
            }),
          )
        ],
      ),
    );
  }

  Widget CustomerCard({
    required String name,
    required String id,
    required String mobile,
    required String email,
    required String state,
    required String city,
    VoidCallback? onUpdate,
    VoidCallback? onDelete,
  }) {
    return GestureDetector(
      onTap: onUpdate,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            bottom: BorderSide(color: Colors.blue.withOpacity(.5), width: 2),
            left: BorderSide(color: Colors.blue.withOpacity(.5), width: 1),
            right: BorderSide(color: Colors.blue.withOpacity(.5), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                    // PopupMenuButton<int>(
                    //   itemBuilder: (context) => [
                    //     PopupMenuItem(
                    //       value: 1,
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment
                    //             .start, // Align items horizontally
                    //         children: [
                    //           const Icon(
                    //             Icons.delete,
                    //             size: 20,
                    //           ),
                    //           const SizedBox(
                    //               width: 18), // Space between icon and text
                    //           const Text("Delete"),
                    //         ],
                    //       ),
                    //     ),
                    //     PopupMenuItem(
                    //       value: 2,
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment
                    //             .start, // Align items horizontally
                    //         children: [
                    //           const Icon(
                    //             Icons.update,
                    //             size: 20,
                    //           ),
                    //           const SizedBox(
                    //               width: 18), // Space between icon and text
                    //           const Text("Edit"),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    //   icon: const Icon(Icons.more_horiz), // Icon for the button
                    //   offset: const Offset(0, 50), // Adjusts the popup position
                    //   color: Colors.white, // Background color of the popup menu
                    //   elevation: 4, // Elevation for shadow effect
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   onSelected: (value) {
                    //     if (value == 1) {
                    //       print("Get The App clicked");
                    //     } else if (value == 2) {
                    //       onUpdate!();
                    //       print("About clicked");
                    //     }
                    //   },
                    // ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      city,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      state,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      mobile,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      email,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [],
                )

                // const SizedBox(height: 8),
                // Row(
                //   children: [
                //     Expanded(
                //       child: buildInputFieldWithIcon(
                //         iconPath: 'assets/icons/call.svg',
                //         value: mobile,
                //       ),
                //     ),
                //     const SizedBox(width: 16),
                //     Expanded(
                //       child: buildInputFieldWithIcon(
                //         iconPath: 'assets/icons/mail.svg',
                //         value: email,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 16),
                // Row(
                //   children: [
                //     Expanded(
                //       child: buildInputFieldWithIcon(
                //         iconPath: 'assets/icons/location.svg', // Use an appropriate icon for address
                //         value: address,
                //       ),
                //     ),
                //     const SizedBox(width: 16),
                //     Expanded(
                //       child: buildInputFieldWithIcon(
                //         iconPath: 'assets/icons/city.svg', // Use an appropriate icon for city
                //         value: city,
                //       ),
                //     ),
                //   ],
                // ),

                // const SizedBox(height: 20),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     ElevatedButton(
                //       onPressed: onUpdate,
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.green,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //       ),
                //       child: Row(
                //         children: [
                //           SvgPicture.asset(
                //             'assets/icons/edit.svg',
                //             width: 20,
                //             height: 20,
                //           ),
                //           const SizedBox(width: 8),
                //           const Text('Update'),
                //         ],
                //       ),
                //     ),
                //     const SizedBox(width: 16),
                //     ElevatedButton(
                //       onPressed: () {
                //         showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return AlertDialog(
                //               title: const Text('Confirm Delete'),
                //               content: const Text('Are you sure you want to delete this customer?'),
                //               actions: [
                //                 TextButton(
                //                   onPressed: () {
                //                     Navigator.of(context).pop();
                //                   },
                //                   child: const Text('Cancel'),
                //                 ),
                //                 TextButton(
                //                   onPressed: () {
                //                     onDelete(); // Call the delete callback function
                //                     Navigator.of(context).pop();
                //                     Get.to(() => CustomerListPage()); // Replace with your page
                //                   },
                //                   child: const Text('Delete'),
                //                 ),
                //               ],
                //             );
                //           },
                //         );
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.red,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //       ),
                //       child: Row(
                //         children: [
                //           SvgPicture.asset(
                //             'assets/icons/delete-svgrepo-com.svg',
                //             width: 20,
                //             height: 20,
                //           ),
                //           const SizedBox(width: 8),
                //           const Text('Delete'),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Widget _buildProspectTab(QuotationEntryController controller) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             const Text("Search:"),
  //             const SizedBox(width: 8),
  //             Expanded(
  //               child: CustomSearchField(
  //                 hintText: "Search prospect...",
  //                 controller: controller.prospectSearchController,
  //                 onSearch: (query) => controller.filterProspectData(query),
  //                 onClear: controller.clearProspectSearch,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         Expanded(
  //           child: Obx(() {
  //             if (controller.isLoading.value) {
  //               return const Center(child: CircularProgressIndicator());
  //             }
  //             if (controller.prospectData.isEmpty) {
  //               return const Center(child: Text("No prospects found"));
  //             }
  //             return ListView.builder(
  //               itemCount: controller.prospectData.length + 1,
  //               itemBuilder: (context, index) {
  //                 if (index == controller.prospectData.length && controller.hasMoreProspects.value) {
  //                   controller.fetchProspects(isInitialFetch: false);  // Fetch more data on scroll
  //                   return const Center(child: CircularProgressIndicator());
  //                 }
  //                 final prospect = controller.prospectData[index];
  //                 return Card(
  //                   elevation: 1,
  //                   child: ListTile(
  //                     title: Text(prospect['name'] ?? "No Name"),
  //                     subtitle: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text("Mobile: ${prospect['mobile'] ?? 'N/A'}"),
  //                         Text("Email: ${prospect['email'] ?? 'N/A'}"),
  //                       ],
  //                     ),
  //                     trailing: IconButton(
  //                       icon: const Icon(Icons.arrow_forward_ios),
  //                       onPressed: () {
  //                         Get.to(() => ItemListPage(),
  //                           transition: Transition.rightToLeftWithFade,
  //                           curve: Curves.easeInOutExpo,
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 );
  //               },
  //             );
  //           }),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
