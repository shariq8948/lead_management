import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Model class for Employee Rating
class EmployeeRating {
  final String id;
  final String employeeName;
  final double overallRating;
  final List<RatingCategory> categories;
  final String feedback;
  final DateTime ratingDate;

  EmployeeRating({
    required this.id,
    required this.employeeName,
    required this.overallRating,
    required this.categories,
    required this.feedback,
    required this.ratingDate,
  });
}

class RatingCategory {
  final String name;
  final double score;
  final String description;

  RatingCategory({
    required this.name,
    required this.score,
    required this.description,
  });
}

// Controller
class EmployeeRatingsController extends GetxController {
  final rating = Rx<EmployeeRating?>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeRating();
  }

  void fetchEmployeeRating() async {
    isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      rating.value = EmployeeRating(
        id: '1',
        employeeName: 'John Doe',
        overallRating: 2.5,
        categories: [
          RatingCategory(
            name: 'Lead Conversion',
            score: 4.8,
            description: 'Exceptional work quality and delivery',
          ),
          RatingCategory(
            name: 'Task Conversion',
            score: 4.3,
            description: 'Good team communication and collaboration',
          ),
          RatingCategory(
            name: 'Calls',
            score: 4.5,
            description: 'Strong leadership skills and initiative',
          ),
          RatingCategory(
            name: 'Revenue',
            score: 1.2,
            description: 'Brings creative solutions to challenges',
          ),
        ],
        feedback:
            'John consistently delivers high-quality work and demonstrates strong leadership qualities. Shows great potential for growth.',
        ratingDate: DateTime.now(),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load employee rating',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
