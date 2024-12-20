import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Masters/area/areaList.dart';
import 'package:leads/Masters/city/addCity.dart';
import 'package:leads/Masters/city/cityListController.dart';
import 'package:leads/utils/constants.dart';

class CityListPage extends StatelessWidget {
  CityListPage({super.key});
  final cityListController controller = Get.put(cityListController());

  @override
  Widget build(BuildContext context) {
    final String stateId = Get.arguments; // Get the stateId directly

    // Ensure the controller fetches the city list data for the given stateId
    controller.fetchCity(stateId);

    return Scaffold(
      appBar: AppBar(
        title: Text("City List for State ID: $stateId"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      Text(
                        "City Information",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(() {
                        // Use Obx to reactively build the DataTable
                        return DataTable(
                          columnSpacing: 40,
                          columns: [
                            DataColumn(
                              label: Text(
                                'Sr. No.',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'City Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'City Id',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ),
                            ),
                            DataColumn(label: SizedBox.shrink()),
                          ],
                          rows:
                              List.generate(controller.states.length, (index) {
                            final city = controller.states[index];
                            return DataRow(
                              cells: [
                                DataCell(Center(child: Text('${index + 1}'))),
                                DataCell(
                                  Text(
                                    city.city!,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataCell(Center(child: Text(city.cityID!))),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => areaListpage(),
                                          arguments: city.cityID.toString());
                                      // Implement your navigation or actions here.
                                    },
                                    child: Icon(Icons.arrow_forward,
                                        color: Colors.blueAccent),
                                  ),
                                ),
                              ],
                            );
                          }),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddCityPage());
          print("Add new state");
        },
        backgroundColor: screenbgColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
