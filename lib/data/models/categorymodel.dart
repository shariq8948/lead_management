class CategoryList {
  final String id;
  final String name;
  final String code;
  final String? ucategory;
  final String? ucategoryId;
  final String? description;
  final String? iconimg;
  final String? iconimgname;
  final String? bannerimg;
  final String? bannerimgname;
  final String? categoryforapp;
  final String? createdby;
  final String? modifiedby;
  final String? createdon;
  final String? isduplicateupdated;

  CategoryList({
    required this.id,
    required this.name,
    required this.code,
    this.ucategory,
    this.ucategoryId,
    this.description,
    this.iconimg,
    this.iconimgname,
    this.bannerimg,
    this.bannerimgname,
    this.categoryforapp,
    this.createdby,
    this.modifiedby,
    this.createdon,
    this.isduplicateupdated,
  });

  // Factory method to create a Category from JSON
  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      ucategory: json['ucategory'],
      ucategoryId: json['ucategoryId'],
      description: json['description'],
      iconimg: json['iconimg'],
      iconimgname: json['iconimgname'],
      bannerimg: json['bannerimg'],
      bannerimgname: json['bannerimgname'],
      categoryforapp: json['categoryforapp'],
      createdby: json['createdby'],
      modifiedby: json['modifiedby'],
      createdon: json['createdon'],
      isduplicateupdated: json['isduplicateupdated'],
    );
  }

  // Method to convert a Category to JSON
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
