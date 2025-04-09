import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class StateWiseVisitPage extends StatelessWidget {
  final StateWiseVisitController controller =
      Get.put(StateWiseVisitController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State-wise Visits'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'State-wise Summary:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Summary Section
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Visits: ${controller.totalVisits.value}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Unique States: ${controller.uniqueStates.value}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Divider(height: 20),
                ],
              ),
            ),
          ),

          // State-wise Visit List
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.stateWiseVisitData.length,
                itemBuilder: (context, index) {
                  final stateData = controller.stateWiseVisitData[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stateData.stateName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Total Visits: ${stateData.totalVisits}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Unique Visitors: ${stateData.uniqueVisitors}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Top Locations:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...stateData.topLocations.map(
                            (location) => Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                '- $location',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
