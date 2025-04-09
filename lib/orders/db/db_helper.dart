import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

import '../model/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._private();
  static Database? _database;

  // New database name for the other app
  static const String _databaseName = 'new_cart_database.db';
  static const int _databaseVersion = 1;

  DatabaseHelper._private();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE new_cart(
            id TEXT PRIMARY KEY,
            data TEXT,
            gst_rate REAL,
            gst_amount REAL,
            timestamp INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<void> insertOrUpdateCartItem(Products product) async {
    final db = await database;
    try {
      double price = double.tryParse(product.saleRate) ?? 0;
      double itemTotal = price * product.qty.value;
      double discountAmount = (itemTotal * product.discount.value) / 100;
      double itemSubtotal = itemTotal - discountAmount;
      double gstRate = double.tryParse(product.gst) ?? 0;
      double gstAmount = (itemSubtotal * gstRate) / 100;

      await db.insert(
        'new_cart',
        {
          'id': product.id,
          'data': jsonEncode(product.toJson()),
          'gst_rate': gstRate,
          'gst_amount': gstAmount,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateQuantity(String productId, int newQty) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.query(
        'new_cart',
        where: 'id = ?',
        whereArgs: [productId],
      );

      if (result.isNotEmpty) {
        Map<String, dynamic> productData = jsonDecode(result.first['data']);

        productData['qty'] = newQty;

        double price = double.tryParse(productData['Rate1'] ?? '0') ?? 0;
        double discount =
            double.tryParse(productData['Discount']?.toString() ?? '0') ?? 0;
        double itemTotal = price * newQty;
        double discountAmount = (itemTotal * discount) / 100;
        double itemSubtotal = itemTotal - discountAmount;
        double gstRate = double.tryParse(productData['Stax'] ?? '0') ?? 0;
        double gstAmount = (itemSubtotal * gstRate) / 100;

        await db.update(
          'new_cart',
          {
            'data': jsonEncode(productData),
            'gst_rate': gstRate,
            'gst_amount': gstAmount,
          },
          where: 'id = ?',
          whereArgs: [productId],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDiscount(String productId, double newDiscount) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.query(
        'new_cart',
        where: 'id = ?',
        whereArgs: [productId],
      );

      if (result.isNotEmpty) {
        Map<String, dynamic> productData = jsonDecode(result.first['data']);

        productData['discount'] = newDiscount;
        print("new discount ${newDiscount}");
        double price = double.tryParse(productData['Rate1'] ?? '0') ?? 0;
        double quantity =
            double.tryParse(productData['Qty']?.toString() ?? '1') ?? 1;
        double itemTotal = price * quantity;
        double discountAmount = (itemTotal * newDiscount) / 100;
        double itemSubtotal = itemTotal - discountAmount;
        double gstRate = double.tryParse(productData['Stax'] ?? '0') ?? 0;
        double gstAmount = (itemSubtotal * gstRate) / 100;

        await db.update(
          'new_cart',
          {
            'data': jsonEncode(productData),
            'gst_rate': gstRate,
            'gst_amount': gstAmount,
          },
          where: 'id = ?',
          whereArgs: [productId],
        );
      }
    } catch (e) {
      print('Error updating discount: $e');
      rethrow;
    }
  }

  Future<void> printTableData(String tableName) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> results = await db.query(tableName);

    print('Table: $tableName');
    for (var row in results) {
      print(row);
    }
  }

  Future<void> printColumnNames() async {
    final db = await database;
    final result = await db.rawQuery("PRAGMA table_info(new_cart)");

    print("Column names in 'new_cart' table:");
    for (var row in result) {
      print(row['name']);
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;

    try {
      printColumnNames();

      final results = await db.query('new_cart');
      print(results);

      return results.map((e) {
        final data = jsonDecode(e['data'] as String);
        data['gst_rate'] = e['gst_rate'];
        data['gst_amount'] = e['gst_amount'];
        return Map<String, dynamic>.from(data);
      }).toList();
    } catch (e) {
      print('Error retrieving cart items: $e');
      return [];
    }
  }

  Future<void> deleteCartItem(String productId) async {
    final db = await database;
    try {
      await db.delete(
        'new_cart',
        where: 'id = ?',
        whereArgs: [productId],
      );
      print('Cart item deleted: $productId');
    } catch (e) {
      print('Error deleting cart item: $e');
    }
  }

  Future<void> clearCart() async {
    final db = await database;
    try {
      await db.delete('new_cart');
      print('Cart cleared successfully');
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  Future<void> debugPrintCartContents() async {
    final db = await database;
    final results = await db.query('new_cart');
    print('Current new_cart contents:');
    for (var item in results) {
      print(item);
    }
  }
}
