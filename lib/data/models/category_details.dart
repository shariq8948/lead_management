class CategoryDetailsModel {
  final String id;
  final String name;
  final String code;
  final String ucategory;
  final String ucategoryId;
  final String description;
  final String iconimg;
  final String iconimgname;
  final String bannerimg;
  final String bannerimgname;
  final String categoryforapp;
  final String? createdby;
  final String? modifiedby;
  final String createdon;
  final String? isduplicateupdated;

  CategoryDetailsModel({
    required this.id,
    required this.name,
    required this.code,
    required this.ucategory,
    required this.ucategoryId,
    required this.description,
    required this.iconimg,
    required this.iconimgname,
    required this.bannerimg,
    required this.bannerimgname,
    required this.categoryforapp,
    this.createdby,
    this.modifiedby,
    required this.createdon,
    this.isduplicateupdated,
  });

  // Factory method to create a CategoryDetailsModel from JSON
  factory CategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    return CategoryDetailsModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      ucategory: json['ucategory'],
      ucategoryId: json['ucategoryId'],
      description: json['description'],
      iconimg: json['iconimg'] ?? '',
      iconimgname: json['iconimgname'],
      bannerimg: json['bannerimg'] ?? '',
      bannerimgname: json['bannerimgname'],
      categoryforapp: json['categoryforapp'],
      createdby: json['createdby'],
      modifiedby: json['modifiedby'],
      createdon: json['createdon'],
      isduplicateupdated: json['isduplicateupdated'],
    );
  }

  // Method to convert the CategoryDetailsModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'ucategory': ucategory,
      'ucategoryId': ucategoryId,
      'description': description,
      'iconimg': iconimg,
      'iconimgname': iconimgname,
      'bannerimg': bannerimg,
      'bannerimgname': bannerimgname,
      'categoryforapp': categoryforapp,
      'createdby': createdby,
      'modifiedby': modifiedby,
      'createdon': createdon,
      'isduplicateupdated': isduplicateupdated,
    };
  }
}
