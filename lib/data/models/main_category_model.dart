class MainCategoryModel {
  final String id;
  final String name;
  final String? issubcategory; // nullable since it can be null

  MainCategoryModel({
    required this.id,
    required this.name,
    this.issubcategory,
  });

  // Factory constructor to create Category instance from JSON
  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      issubcategory: json['issubcategory'] as String?,
    );
  }

  // Method to convert Category instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'issubcategory': issubcategory,
    };
  }
}
