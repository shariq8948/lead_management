import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../data/api/api_client.dart';
import '../../../../utils/api_endpoints.dart';
import '../../../widgets/page_wrapper.dart';

// Controller
class CategorySalesController extends GetxController {
  final dateRange = Rx<DateTimeRange?>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    ),
  );

  final isLoading = false.obs;
  final selectedViewType = 'chart'.obs; // 'chart' or 'table'
  final selectedTimeFrame = 'monthly'.obs; // 'daily', 'weekly', 'monthly'
  final selectedCategory = Rx<String?>(null);
  final topCategoriesCount = 10.obs;
  final searchQuery = ''.obs;
  final showOnlyTopCategories = true.obs;
  final sortBy = 'sales'.obs; // 'sales', 'growth', 'profit', 'units'
  final sortDirection = 'desc'.obs; // 'asc', 'desc'

  // Category data
  final categoryData = <CategorySalesData>[].obs;

  // Map to store assigned colors for categories
  final Map<String, Color> _categoryColorMap = {};

  // A list of predefined colors to use for categories
  final List<Color> categoryColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
    Colors.deepOrange,
    Colors.lime,
    Colors.lightBlue,
    Colors.deepPurple,
    Colors.brown,
  ];

  List<CategorySalesData> get processedCategories {
    // Start with all categories
    List<CategorySalesData> result = List.from(categoryData);

    // Apply search filter if there's a query
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where((category) => category.category
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Sort the categories
    result.sort((a, b) {
      var factor = sortDirection.value == 'asc' ? 1 : -1;
      switch (sortBy.value) {
        case 'sales':
          return (a.sales - b.sales).toInt() * factor;
        case 'growth':
          return (a.growth - b.growth).toInt() * factor;
        case 'profit':
          return (a.profit - b.profit).toInt() * factor;
        case 'units':
          return (a.units - b.units) * factor;
        default:
          return (a.sales - b.sales).toInt() * factor;
      }
    });

    // Take only top categories if required
    if (showOnlyTopCategories.value) {
      result = result.take(topCategoriesCount.value).toList();
    }

    return result;
  }

  // For pie chart
  final categoryPercentages = <CategoryPercentage>[].obs;

  void resetFilters() {
    searchQuery.value = '';
    showOnlyTopCategories.value = true;
    sortBy.value = 'sales';
    sortDirection.value = 'desc';
    topCategoriesCount.value = 10;
  }

  // Method to set search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Method to toggle top categories filter
  void toggleTopCategoriesFilter(bool value) {
    showOnlyTopCategories.value = value;
  }

  // Method to set number of top categories to show
  void setTopCategoriesCount(int count) {
    topCategoriesCount.value = count;
  }

  // Method to set sort field and direction
  void setSorting(String field, String direction) {
    sortBy.value = field;
    sortDirection.value = direction;
  }

  // Method to get grouped "Others" category for pie chart
  CategorySalesData getOthersCategory(List<CategorySalesData> topCategories) {
    // Find categories not in the top list
    List<CategorySalesData> otherCategories = categoryData
        .where(
            (cat) => !topCategories.any((top) => top.category == cat.category))
        .toList();

    if (otherCategories.isEmpty) {
      return CategorySalesData(
        category: 'Others',
        sales: 0,
        units: 0,
        profit: 0,
        growth: 0,
        products: [],
      );
    }

    // Sum up values for all other categories
    double totalSales = otherCategories.fold(0, (sum, cat) => sum + cat.sales);
    int totalUnits = otherCategories.fold(0, (sum, cat) => sum + cat.units);
    double totalProfit =
        otherCategories.fold(0, (sum, cat) => sum + cat.profit);
    double avgGrowth = otherCategories.isEmpty
        ? 0
        : otherCategories.fold(0.0, (sum, cat) => sum + cat.growth) /
            otherCategories.length;

    return CategorySalesData(
      category: 'Others',
      sales: totalSales,
      units: totalUnits,
      profit: totalProfit,
      growth: avgGrowth,
      products: [], // No individual products for the combined category
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void setDateRange(DateTimeRange? range) {
    dateRange.value = range;
    loadData();
  }

  void setViewType(String type) {
    selectedViewType.value = type;
  }

  void setTimeFrame(String timeFrame) {
    selectedTimeFrame.value = timeFrame;
    loadData();
  }

  void setSelectedCategory(String? category) {
    selectedCategory.value = category;
    // If category is selected, we might load more detailed data
    if (category != null) {
      loadProductData(category);
    }
  }

  // Helper method to convert hex color string to Color object
  Color hexToColor(String hexString) {
    try {
      hexString = hexString.replaceAll('#', '');

      // Ensure the hex string is 6 characters
      if (hexString.length == 3) {
        // Convert 3-digit hex to 6-digit (e.g. #F00 -> #FF0000)
        hexString = hexString.split('').map((e) => e + e).join();
      }

      // Add opacity if needed
      if (hexString.length == 6) {
        hexString = 'FF' + hexString;
      }

      // Parse the hex string to an integer
      return Color(int.parse('0x$hexString'));
    } catch (e) {
      print('Error parsing color: $hexString - $e');
      return Colors.grey; // Default fallback color
    }
  }

  // Get or generate a color for a category
  Color getColorForCategory(String category) {
    // If we've already assigned a color to this category, return it
    if (_categoryColorMap.containsKey(category)) {
      return _categoryColorMap[category]!;
    }

    // If it's "Others" category, always use grey
    if (category == 'Others') {
      _categoryColorMap[category] = Colors.grey;
      return Colors.grey;
    }

    // Generate a color based on the category name for consistency
    int index = _categoryColorMap.length % categoryColors.length;
    Color color = categoryColors[index];

    // Store the color in our map for future use
    _categoryColorMap[category] = color;

    return color;
  }

  void loadData() async {
    isLoading.value = true;

    try {
      // Make API call
      var res = await ApiClient().postg(ApiEndpoints.categorySales, data: {
        "Fromdate":
            dateRange.value?.start.toString().split(' ')[0] ?? "2022-01-01",
        "Uptodate":
            dateRange.value?.end.toString().split(' ')[0] ?? "2025-03-31",
        "UserId": 3,
        "Syscompanyid": 3,
        "Sysbranchid": 3,
        "filtertype": "S" // S, D, W, M
      });

      // Clear existing data
      categoryData.clear();

      // Parse the response and add to categoryData
      if (res != null && res['category'] != null && res['category'] is List) {
        Map<String, CategorySalesData> categoryMap = {};

        for (var categoryJson in res['category']) {
          String categoryName = categoryJson['categoryname'] ?? '';

          // Parse products
          List<ProductData> products = [];
          if (categoryJson['product'] != null &&
              categoryJson['product'] is List) {
            for (var productJson in categoryJson['product']) {
              products.add(ProductData(
                name: productJson['productname'] ?? '',
                sales:
                    double.tryParse(productJson['sales']?.toString() ?? '0') ??
                        0,
                units:
                    int.tryParse(productJson['unit']?.toString() ?? '0') ?? 0,
                profit: double.tryParse(
                        productJson['profiit']?.toString() ?? '0') ??
                    0,
              ));
            }
          }

          double sales =
              double.tryParse(categoryJson['sales']?.toString() ?? '0') ?? 0;
          int units =
              int.tryParse(categoryJson['unit']?.toString() ?? '0') ?? 0;
          double profit =
              double.tryParse(categoryJson['profiit']?.toString() ?? '0') ?? 0;
          double growth =
              double.tryParse(categoryJson['growth']?.toString() ?? '0') ?? 0;

          // If this category already exists, merge the data
          if (categoryMap.containsKey(categoryName)) {
            var existing = categoryMap[categoryName]!;

            categoryMap[categoryName] = CategorySalesData(
              category: categoryName,
              sales: existing.sales + sales,
              units: existing.units + units,
              profit: existing.profit + profit,
              growth: (existing.growth + growth) / 2, // Average the growth
              products: [
                ...existing.products,
                ...products
              ], // Combine product lists
            );
          } else {
            // Create new category entry
            categoryMap[categoryName] = CategorySalesData(
              category: categoryName,
              sales: sales,
              units: units,
              profit: profit,
              growth: growth,
              products: products,
            );
          }
        }

        // Convert map values to list
        categoryData.addAll(categoryMap.values);
      }

      // Handle category percentages from API if available
      if (res != null &&
          res['categoryPercentages'] != null &&
          res['categoryPercentages'] is List) {
        categoryPercentages.value = [];
        for (var percentageJson in res['categoryPercentages']) {
          String categoryName = percentageJson['categoryname'] ?? '';

          // Try to use the color from API first, or generate one if that fails
          Color color;
          try {
            color = hexToColor(percentageJson['colorHex'] ?? '');
            // Store this color in our map for consistency
            _categoryColorMap[categoryName] = color;
          } catch (e) {
            // Use our category color generator as fallback
            color = getColorForCategory(categoryName);
          }

          categoryPercentages.add(CategoryPercentage(
            category: categoryName,
            percentage: double.tryParse(
                    percentageJson['percentage']?.toString() ?? '0') ??
                0,
            color: color,
          ));
        }
      } else {
        // Calculate percentages if not provided by API
        calculateCategoryPercentages();
      }
    } catch (e) {
      // Handle error
      print('Error loading category sales data: $e');
      // You could show a snackbar/toast here
      Get.snackbar('Error', 'Failed to load category sales data');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to calculate category percentages if not provided by API
  void calculateCategoryPercentages() {
    double totalSales = categoryData.fold(0, (sum, item) => sum + item.sales);

    // Avoid division by zero
    if (totalSales <= 0) {
      categoryPercentages.value = categoryData.map((category) {
        return CategoryPercentage(
          category: category.category,
          percentage: 0,
          color: getColorForCategory(category.category),
        );
      }).toList();
      return;
    }

    categoryPercentages.value = categoryData.map((category) {
      return CategoryPercentage(
        category: category.category,
        percentage: (category.sales / totalSales * 100),
        color: getColorForCategory(category.category),
      );
    }).toList();
  }

  void loadProductData(String category) {
    // If we need to load specific product data for a category
    // This could be expanded in a real app to load detailed data
    // Currently not implemented as it would typically be an API call
  }

  // Helper method to format currency
  String formatCurrency(double amount) {
    return NumberFormat.currency(
            locale: 'en_US', symbol: '\₹', decimalDigits: 0)
        .format(amount);
  }
}

// Data models
class CategorySalesData {
  final String category;
  final double sales;
  final int units;
  final double profit;
  final double growth;
  final List<ProductData> products;

  CategorySalesData({
    required this.category,
    required this.sales,
    required this.units,
    required this.profit,
    required this.growth,
    required this.products,
  });
}

class ProductData {
  final String name;
  final double sales;
  final int units;
  final double profit;

  ProductData({
    required this.name,
    required this.sales,
    required this.units,
    required this.profit,
  });
}

class CategoryPercentage {
  final String category;
  final double percentage;
  final Color color;

  CategoryPercentage({
    required this.category,
    required this.percentage,
    required this.color,
  });
}
