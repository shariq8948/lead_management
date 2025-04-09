import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class TransactionFiltersSheet extends StatelessWidget {
  final TransactionsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Advanced Filters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Reset all filters
                  controller.selectedStatus.value = null;
                  controller.startDate.value = null;
                  controller.endDate.value = null;
                  controller.searchController.clear();
                  controller.minAmount.value = null;
                  controller.maxAmount.value = null;
                  controller.applyFilters();
                  Get.back();
                },
                child: const Text('Reset All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Amount Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Min Amount',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    controller.minAmount.value =
                        value.isNotEmpty ? double.tryParse(value) : null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Max Amount',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    controller.maxAmount.value =
                        value.isNotEmpty ? double.tryParse(value) : null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  controller.applyFilters();
                  Get.back();
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
