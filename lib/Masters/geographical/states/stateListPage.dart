import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/Masters/geographical/states/stateController.dart';

import 'package:leads/utils/constants.dart';

import '../city/cityList.dart';
import 'addStatePage.dart';

class StateListPage extends StatelessWidget {
  StateListPage({super.key});
  final stateController controller = Get.put(stateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("State List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Obx(
                () => Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Column(
                      children: [
                        Text(
                          "State Information",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 10),
                        DataTable(
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
                                'State Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'State Id',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ),
                            ),
                            DataColumn(label: SizedBox.shrink()),
                          ],
                          rows:
                              List.generate(controller.states.length, (index) {
                            final state = controller.states[index];
                            return DataRow(
                              cells: [
                                DataCell(Center(
                                    child:
                                        Text('${index + 1}'))), // Serial Number
                                DataCell(
                                  Text(
                                    state.state!,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataCell(Center(child: Text(state.statecode!))),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => CityListPage(),
                                          arguments: state.id.toString());
                                      // Add your navigation or actions here.
                                    },
                                    child: Icon(Icons.arrow_forward,
                                        color: Colors.blueAccent),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(Addstatepage());
          print("Add new state");
        },
        backgroundColor: screenbgColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
