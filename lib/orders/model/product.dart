import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Products {
  final String id;
  final String itemName;
  final String itemCode;
  final String category;
  final String brand;
  final String categoryId;
  final String brandId;
  final String gst;
  final String packing;
  final String boxSize;
  final String unit;
  final String unitId;
  final String hsn;
  final String mrp;
  final String saleRate;
  // final String discount;
  final List<ProductSize> sizes;
  final List<ProductColor> colors;
  final String itemDescription;
  final String remark1;
  final String remark2;
  final String remark3;
  final String remark4;
  final String remark5;
  final String barcode;
  final String imageUrl;
  final String smallImageUrl;
  final String currentStock;
  final String minOrderQty;
  final String negativeStockAllow;
  final String avgRating;
  final String isMyWish;
  final String pageNumber;
  final List<ProductImage> images;
  final List<ProductRating> ratings;

  // Reactive values for cart functionality
  RxBool isSelected;
  RxInt qty;
  RxDouble discount;

  // Controllers for UI
  TextEditingController qtyController;
  TextEditingController discountController;

  Products({
    required this.id,
    required this.itemName,
    required this.itemCode,
    required this.category,
    required this.brand,
    required this.categoryId,
    required this.brandId,
    required this.gst,
    required this.packing,
    required this.boxSize,
    required this.unit,
    required this.unitId,
    required this.hsn,
    required this.mrp,
    required this.saleRate,
    required this.sizes,
    required this.colors,
    required this.itemDescription,
    required this.remark1,
    required this.remark2,
    required this.remark3,
    required this.remark4,
    required this.remark5,
    required this.barcode,
    required this.imageUrl,
    required this.smallImageUrl,
    required this.currentStock,
    required this.minOrderQty,
    required this.negativeStockAllow,
    required this.avgRating,
    required this.isMyWish,
    required this.pageNumber,
    required this.images,
    required this.ratings,
    bool isSelected = false,
    int qty = 1,
    double discount = 0,
  })  : isSelected = RxBool(isSelected),
        qty = RxInt(qty),
        discount = RxDouble(discount),
        qtyController = TextEditingController(text: qty.toString()),
        discountController = TextEditingController(text: discount.toString());

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'] ?? '',
      itemName: json['itemName'] ?? '',
      itemCode: json['itemCode'] ?? '',
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      categoryId: json['categoryid'] ?? '',
      brandId: json['brandid'] ?? '',
      gst: json['gst'] ?? '',
      packing: json['packing'] ?? '',
      boxSize: json['boxsize'] ?? '',
      unit: json['unit'] ?? '',
      unitId: json['unitid'] ?? '',
      hsn: json['hsn'] ?? '',
      mrp: json['mrp'] ?? '',
      saleRate: json['saleRate'] ?? '',
      sizes: (json['size'] as List<dynamic>?)
              ?.map((size) => ProductSize.fromJson(size))
              .toList() ??
          [],
      colors: (json['colour'] as List<dynamic>?)
              ?.map((color) => ProductColor.fromJson(color))
              .toList() ??
          [],
      itemDescription: json['itemdescription'] ?? '',
      remark1: json['remark1'] ?? '',
      remark2: json['remark2'] ?? '',
      remark3: json['remark3'] ?? '',
      remark4: json['remark4'] ?? '',
      remark5: json['remark5'] ?? '',
      barcode: json['barcode'] ?? '',
      imageUrl: json['imageurl'] ?? '',
      smallImageUrl: json['smallimageurl'] ?? '',
      currentStock: json['currentstock'] ?? '0',
      minOrderQty: json['minorderqty'] ?? '0',
      negativeStockAllow: json['negetivestockallow'] ?? 'False',
      avgRating: json['avgrating'] ?? '0',
      isMyWish: json['ismywish'] ?? '0',
      pageNumber: json['pageNumber'] ?? '1',
      images: (json['images'] as List<dynamic>?)
              ?.map((image) => ProductImage.fromJson(image))
              .toList() ??
          [],
      ratings: (json['rating'] as List<dynamic>?)
              ?.map((rating) => ProductRating.fromJson(rating))
              .toList() ??
          [],
      qty: int.tryParse(json['qty']?.toString() ?? '1') ?? 1,
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'itemCode': itemCode,
      'category': category,
      'brand': brand,
      'categoryid': categoryId,
      'brandid': brandId,
      'gst': gst,
      'packing': packing,
      'boxsize': boxSize,
      'unit': unit,
      'unitid': unitId,
      'hsn': hsn,
      'mrp': mrp,
      'saleRate': saleRate,
      'discount': discount,
      'size': sizes.map((size) => size.toJson()).toList(),
      'colour': colors.map((color) => color.toJson()).toList(),
      'itemdescription': itemDescription,
      'remark1': remark1,
      'remark2': remark2,
      'remark3': remark3,
      'remark4': remark4,
      'remark5': remark5,
      'barcode': barcode,
      'imageurl': imageUrl,
      'smallimageurl': smallImageUrl,
      'currentstock': currentStock,
      'minorderqty': minOrderQty,
      'negetivestockallow': negativeStockAllow,
      'avgrating': avgRating,
      'ismywish': isMyWish,
      'pageNumber': pageNumber,
      'images': images.map((image) => image.toJson()).toList(),
      'rating': ratings.map((rating) => rating.toJson()).toList(),
      'qty': qty.value,
      'discount': discount.value,
    };
  }
}

class ProductSize {
  final String id;
  final String itemId;
  final String sizeId;
  final String sizeName;
  final String mrp;
  final String rate;
  final String rate1;
  final String pRate;
  final String? disc;
  final String? createdBy;
  final String? modifiedBy;
  final String? createdOn;
  final String? negativeStockAllow;
  final String currentStock;

  ProductSize({
    required this.id,
    required this.itemId,
    required this.sizeId,
    required this.sizeName,
    required this.mrp,
    required this.rate,
    required this.rate1,
    required this.pRate,
    this.disc,
    this.createdBy,
    this.modifiedBy,
    this.createdOn,
    this.negativeStockAllow,
    required this.currentStock,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      id: json['id'] ?? '',
      itemId: json['itemid'] ?? '',
      sizeId: json['sizeid'] ?? '',
      sizeName: json['sizename'] ?? '',
      mrp: json['mrp'] ?? '',
      rate: json['rate'] ?? '',
      rate1: json['rate1'] ?? '',
      pRate: json['prate'] ?? '',
      disc: json['disc'],
      createdBy: json['createdby'],
      modifiedBy: json['modifiedby'],
      createdOn: json['createdon'],
      negativeStockAllow: json['negetivestockallow'],
      currentStock: json['currentStock'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemid': itemId,
      'sizeid': sizeId,
      'sizename': sizeName,
      'mrp': mrp,
      'rate': rate,
      'rate1': rate1,
      'prate': pRate,
      'disc': disc,
      'createdby': createdBy,
      'modifiedby': modifiedBy,
      'createdon': createdOn,
      'negetivestockallow': negativeStockAllow,
      'currentStock': currentStock,
    };
  }
}

class ProductColor {
  final String id;
  final String itemId;
  final String colorId;
  final String colorName;
  final String colorCode;
  final String? createdBy;
  final String? modifiedBy;
  final String? createdOn;

  ProductColor({
    required this.id,
    required this.itemId,
    required this.colorId,
    required this.colorName,
    required this.colorCode,
    this.createdBy,
    this.modifiedBy,
    this.createdOn,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      id: json['id'] ?? '',
      itemId: json['itemid'] ?? '',
      colorId: json['colourid'] ?? '',
      colorName: json['colourname'] ?? '',
      colorCode: json['colourcode'] ?? '',
      createdBy: json['createdby'],
      modifiedBy: json['modifiedby'],
      createdOn: json['createdon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemid': itemId,
      'colourid': colorId,
      'colourname': colorName,
      'colourcode': colorCode,
      'createdby': createdBy,
      'modifiedby': modifiedBy,
      'createdon': createdOn,
    };
  }
}

class ProductImage {
  final String itemId;
  final String imageName;
  final String imageUrl;

  ProductImage({
    required this.itemId,
    required this.imageName,
    required this.imageUrl,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      itemId: json['itemid'] ?? '',
      imageName: json['imageName'] ?? '',
      imageUrl: json['imageurl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemid': itemId,
      'imageName': imageName,
      'imageurl': imageUrl,
    };
  }
}

class ProductRating {
  final String itemId;
  final String rating;
  final String feedback;
  final String date;
  final String username;
  final String imageUrl;

  ProductRating({
    required this.itemId,
    required this.rating,
    required this.feedback,
    required this.date,
    required this.username,
    required this.imageUrl,
  });

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      itemId: json['itemid'] ?? '',
      rating: json['rating'] ?? '',
      feedback: json['feedback'] ?? '',
      date: json['date'] ?? '',
      username: json['username'] ?? '',
      imageUrl: json['imageurl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemid': itemId,
      'rating': rating,
      'feedback': feedback,
      'date': date,
      'username': username,
      'imageurl': imageUrl,
    };
  }
}
