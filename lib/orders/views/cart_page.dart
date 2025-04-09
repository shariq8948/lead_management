import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../controllers/cart_controller.dart';
import '../invoice/invoice_generator.dart';
import '../model/product.dart';

class CartPage extends StatelessWidget {
  final CartController _cartController = Get.find();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Obx(() {
                  if (_cartController.cartItems.isEmpty) {
                    return _buildEmptyCart(context);
                  }
                  return Column(
                    children: [
                      _buildCartSummary(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _cartController.cartItems.length,
                        itemBuilder: (context, index) {
                          final product = _cartController.cartItems[index];
                          return _buildCartItem(product, context);
                        },
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Obx(() => _cartController.cartItems.isNotEmpty
            ? _buildTotalSection(context)
            : const SizedBox.shrink()),
      );

  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Orders Cart',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      actions: [
        Obx(() => _cartController.cartItems.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.delete_sweep_outlined,
                    color: Colors.redAccent),
                onPressed: _showClearCartDialog,
                tooltip: 'Clear Cart',
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildCartSummary() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        color: Colors.blue.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                icon: Icons.shopping_bag_outlined,
                title: 'Items',
                value: '${_cartController.cartItems.length}',
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey.withOpacity(0.3),
              ),
              _buildSummaryItem(
                icon: Icons.local_offer_outlined,
                title: 'Total Discount',
                value: '₹${_calculateTotalSavings().toStringAsFixed(2)}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.blue.shade700),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_cart.png',
            height: 200,
            width: 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Your Cart is Empty',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Looks like you haven\'t added anything to your cart yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Create your order',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Products product, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _showDeleteItemDialog(product),
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Remove',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductImage(product),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.itemName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '₹${product.saleRate}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              _buildDiscountTag(product),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildGstRow(product),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuantityControls(product, context),
                    _buildDiscountField(product),
                  ],
                ),
                const SizedBox(height: 12),
                _buildItemTotals(product),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(Products product) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: (product.imageUrl.isNotEmpty)
            ? Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.broken_image_outlined,
                    size: 40,
                    color: Colors.grey[400],
                  );
                },
              )
            : Icon(
                Icons.image_outlined,
                size: 40,
                color: Colors.grey[400],
              ),
      ),
    );
  }

  Widget _buildDiscountTag(Products product) {
    if (product.discount.value <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${product.discount.value}% OFF',
          style: TextStyle(
            fontSize: 12,
            color: Colors.green.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildGstRow(Products product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'GST (${product.gst}%)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          '₹${_calculateItemGST(product).toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildItemTotals(Products product) {
    final double subtotal = _calculateItemTotal(product);
    final double gst = _calculateItemGST(product);
    final double total = subtotal + gst;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Subtotal: ₹${subtotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'GST: ₹${gst.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Total (incl. GST): ₹${total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (product.discount.value > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Saved: ₹${_calculateSavings(product).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
              ),
            ),
          ),
      ],
    );
  }

  double _calculateItemGST(Products product) {
    final price = double.tryParse(product.saleRate) ?? 0;
    final subtotal = price * product.qty.value;
    final discount = subtotal * (product.discount.value / 100);
    final afterDiscount = subtotal - discount;
    final gstRate = double.tryParse(product.gst) ?? 0;
    return (afterDiscount * gstRate) / 100;
  }

  Widget _buildQuantityControls(Products product, BuildContext context) {
    final int currentStock = int.tryParse(product.currentStock) ?? 0;
    final bool canDecrement = product.qty.value > 1;
    final bool canIncrement = product.qty.value < currentStock;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: canDecrement
                ? () => _updateQuantity(product, product.qty.value - 1)
                : () => _showRemoveConfirmation(product, context),
            context: context,
          ),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              '${product.qty.value}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: canIncrement
                ? () => _updateQuantity(product, product.qty.value + 1)
                : () => _showStockLimitMessage(currentStock, context),
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required BuildContext context,
  }) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: onPressed != null
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: onPressed != null
                  ? Theme.of(context).primaryColor
                  : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  void _showRemoveConfirmation(Products product, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text(
          'Do you want to remove ${product.itemName} from your cart?',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cartController.removeFromCart(product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.itemName} removed from cart'),
                  backgroundColor: Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            child: const Text('REMOVE'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _showStockLimitMessage(int currentStock, BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sorry, only $currentStock items available in stock'),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _updateQuantity(Products product, int newQty) {
    final int currentStock = int.tryParse(product.currentStock) ?? 0;

    if (newQty <= 0) {
      _showRemoveConfirmation(product, Get.context!);
      return;
    }

    if (newQty > currentStock) {
      HapticFeedback.mediumImpact();
      _showStockLimitMessage(currentStock, Get.context!);
      return;
    }

    if (newQty > 0) {
      HapticFeedback.lightImpact();
      _cartController.updateQuantity(product.id, newQty);
      product.qty.value = newQty;
    }
  }

  Widget _buildDiscountField(Products product) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: product.discount.value == 0
                  ? ''
                  : product.discount.value.toString(),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '0', // Shows 0 as hint
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              ),
              style: const TextStyle(fontSize: 14),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.isEmpty) {
                    return newValue;
                  }
                  double? value = double.tryParse(newValue.text);
                  if (value != null && value > 100) {
                    // Reject the input if it exceeds 100
                    Get.snackbar(
                      'Invalid Input',
                      'Discount cannot exceed 100%',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                    return oldValue;
                  }
                  return newValue;
                }),
              ],
              onChanged: (value) {
                // Your existing update discount method already has the validation
                _updateDiscount(product, value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              '%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTotalSectionRow(
              title: 'Total Items',
              value: '${_cartController.cartItems.length}',
            ),
            const SizedBox(height: 8),
            _buildTotalSectionRow(
              title: 'Total Savings',
              value: '₹${_calculateTotalSavings().toStringAsFixed(2)}',
              valueColor: Colors.green.shade700,
            ),
            const SizedBox(height: 8),
            _buildTotalSectionRow(
              title: 'Subtotal',
              value: '₹${_cartController.totalAmount.value.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            _buildTotalSectionRow(
              title: 'Total GST',
              value: '₹${_cartController.totalGST.value.toStringAsFixed(2)}',
            ),
            const Divider(height: 24),
            _buildGrandTotalRow(context),
            const SizedBox(height: 16),
            _buildCheckoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSectionRow({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGrandTotalRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Grand Total',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(() => Text(
              '₹${_cartController.grandTotal.value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            )),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showCheckoutDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        minimumSize: const Size(double.infinity, 56),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Proceed to Checkout',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded),
        ],
      ),
    );
  }

  void _showClearCartDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red[400]),
            const SizedBox(width: 8),
            const Text('Clear Cart'),
          ],
        ),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _cartController.clearCart();
              Get.back();
              Get.snackbar(
                'Cart Cleared',
                'All items have been removed from your cart',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red[400],
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 2),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showDeleteItemDialog(Products product) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.remove_shopping_cart_outlined, color: Colors.red[400]),
            const SizedBox(width: 8),
            const Text('Remove Item'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove "${product.itemName}" from your cart?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _cartController.removeFromCart(product.id);
              Get.back();
              Get.snackbar(
                'Item Removed',
                '${product.itemName} has been removed from your cart',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red[400],
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                duration: const Duration(milliseconds: 900),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _updateDiscount(Products product, String value) {
    double? newDiscount = double.tryParse(value);
    if (newDiscount != null && newDiscount >= 0 && newDiscount <= 100) {
      product.discount.value = newDiscount;
      _cartController.updateDiscount(product.id, newDiscount);
    }
  }

  double _calculateItemTotal(Products product) {
    final price = double.tryParse(product.saleRate) ?? 0;
    final subtotal = price * product.qty.value;
    final discount = subtotal * (product.discount.value / 100);
    return subtotal - discount;
  }

  double _calculateSavings(Products product) {
    final price = double.tryParse(product.saleRate) ?? 0;
    final subtotal = price * product.qty.value;
    return subtotal * (product.discount.value / 100);
  }

  double _calculateTotalSavings() {
    return _cartController.cartItems.fold(0.0, (total, product) {
      return total + _calculateSavings(product);
    });
  }

  // This method is just a placeholder to prevent errors. You mentioned you already have it implemented.
  void _showCheckoutDialog(BuildContext context) {
    final TextEditingController advanceController = TextEditingController();
    final TextEditingController utrController = TextEditingController();
    final TextEditingController searchController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: Get.width * 0.9,
                constraints: BoxConstraints(maxHeight: Get.height * 0.85),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section with Gradient
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColor.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Checkout Details',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white),
                                onPressed: () => Get.back(),
                              ),
                            ],
                          ),
                        ),

                        // Main Content with Padding
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Customer Section
                              _buildSectionHeader(
                                'Select Customer',
                                Icons.person_outline,
                                context,
                              ),
                              const SizedBox(height: 16),

                              // Search Field with Animation
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search customer...',
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    _cartController.searchCustomers(value);
                                  },
                                ),
                              ),

                              // Search Results with Animated Loading
                              Obx(() {
                                if (_cartController.isSearching.value) {
                                  return const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                if (_cartController.searchResults.isNotEmpty) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.only(top: 16),
                                    constraints: BoxConstraints(
                                      maxHeight: Get.height * 0.2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: Colors.grey[200]!),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 10,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount:
                                          _cartController.searchResults.length,
                                      itemBuilder: (context, index) {
                                        final customer = _cartController
                                            .searchResults[index];
                                        return Material(
                                          color: Colors.transparent,
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 8,
                                            ),
                                            leading: CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.1),
                                              child: Text(
                                                customer.name?[0] ?? "",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              customer.name ?? "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            subtitle: Text(
                                              customer.mobile,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            onTap: () => _cartController
                                                .selectCustomer(customer),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return const SizedBox();
                              }),

                              // Selected Customer Card with Animation
                              Obx(() {
                                if (_cartController.selectedCustomer.value !=
                                    null) {
                                  return TweenAnimationBuilder(
                                    duration: const Duration(milliseconds: 300),
                                    tween: Tween<double>(begin: 0, end: 1),
                                    builder: (context, double value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blue[50]!,
                                                Colors.blue[100]!
                                                    .withOpacity(0.5),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Colors.blue[200]!,
                                            ),
                                          ),
                                          child: _buildSelectedCustomerInfo(),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const SizedBox();
                              }),

                              const SizedBox(height: 24),
                              const Divider(),
                              const SizedBox(height: 24),

                              // Payment Section
                              _buildSectionHeader(
                                'Payment Details',
                                Icons.payment_outlined,
                                context,
                              ),
                              const SizedBox(height: 16),

                              // Advance Amount Field
                              _buildAnimatedTextField(
                                controller: advanceController,
                                label: 'Advance Amount',
                                prefix: '₹',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  _cartController.advanceAmount.value =
                                      double.tryParse(value) ?? 0;
                                },
                              ),

                              // Payment Mode Selection
                              Obx(() {
                                if (_cartController.advanceAmount.value > 0) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      _buildPaymentModeSelector(context),
                                      if (_cartController.paymentMode.value !=
                                          'Cash') ...[
                                        const SizedBox(height: 16),
                                        _buildAnimatedTextField(
                                          controller: utrController,
                                          label: 'UTR/Reference Number',
                                          onChanged: (value) {
                                            _cartController.utrNumber.value =
                                                value;
                                          },
                                        ),
                                      ],
                                    ],
                                  );
                                }
                                return const SizedBox();
                              }),

                              const SizedBox(height: 32),

                              // Proceed Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _validateAndProceed(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Proceed to Invoice',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildPaymentModeSelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Payment Mode',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        value: _cartController.paymentMode.value,
        items: _cartController.paymentModes.map((mode) {
          return DropdownMenuItem(
            value: mode,
            child: Text(mode),
          );
        }).toList(),
        onChanged: (value) {
          _cartController.paymentMode.value = value!;
        },
      ),
    );
  }

  void _validateAndProceed(BuildContext context) {
    // Validate customer selection
    if (_cartController.selectedCustomer.value == null) {
      _showErrorNotification(
        'Customer Required',
        'Please select a customer to proceed with checkout.',
      );
      return;
    }

    // Validate UTR for non-cash payments
    if (_cartController.advanceAmount.value > 0 &&
        _cartController.paymentMode.value != 'Cash' &&
        _cartController.utrNumber.value.isEmpty) {
      _showErrorNotification(
        'UTR Required',
        'Please enter UTR/Reference number for non-cash payments.',
      );
      return;
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth > 600
                    ? constraints.maxWidth * 0.2
                    : 20,
                vertical: 20,
              ),
              child: Material(
                borderRadius: BorderRadius.circular(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Order Summary Icon
                      Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.receipt_long_outlined,
                            size: 32,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ),

                      // Title
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Text(
                          'Confirm Order Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Order Summary Rows
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            _buildSummaryRow(
                                'Customer',
                                _cartController.selectedCustomer.value!.name ??
                                    ""),
                            _buildSummaryRow('Total Items',
                                '${_cartController.cartItems.length}'),
                            _buildSummaryRow('Subtotal',
                                '₹${_cartController.totalAmount.value.toStringAsFixed(2)}'),
                            _buildSummaryRow('GST',
                                '₹${_cartController.totalGST.value.toStringAsFixed(2)}'),
                            _buildSummaryRow('Grand Total',
                                '₹${_cartController.grandTotal.value.toStringAsFixed(2)}',
                                isHighlighted: true),

                            // Advance Payment Details (if applicable)
                            if (_cartController.advanceAmount.value > 0) ...[
                              _buildSummaryRow('Advance',
                                  '₹${_cartController.advanceAmount.value}'),
                              _buildSummaryRow('Payment Mode',
                                  _cartController.paymentMode.value),
                              if (_cartController.utrNumber.value.isNotEmpty)
                                _buildSummaryRow('UTR Number',
                                    _cartController.utrNumber.value),
                            ],
                          ],
                        ),
                      ),

                      // Divider
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),

                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Get.back(),
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Review',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.back(); // Close confirmation dialog
                                  _cartController.submitOrder(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Get.theme.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with fixed width
          SizedBox(
            width: 100, // Adjust this width based on your longest label
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 8), // Spacing between label and value
          // Value with flexible width and text wrapping
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isHighlighted ? 16 : 14,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                color: isHighlighted ? Colors.green[700] : Colors.grey[800],
              ),
              textAlign: TextAlign.right,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorNotification(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[400],
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderRadius: 12,
      duration: Duration(seconds: 1),
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, IconData icon, BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCustomerInfo() {
    final customer = _cartController.selectedCustomer.value!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.blue[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Selected Customer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.blue[700],
                size: 20,
              ),
              onPressed: _cartController.clearSelectedCustomer,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCustomerInfoRow(
            Icons.person_outline, 'Name', customer.name ?? ""),
        if (customer.mobile.isNotEmpty)
          _buildCustomerInfoRow(
              Icons.phone_outlined, 'Mobile', customer.mobile),
        if (customer.email?.isNotEmpty ?? false)
          _buildCustomerInfoRow(Icons.email_outlined, 'Email', customer.email!),
        if (customer.address1?.isNotEmpty ?? false)
          _buildCustomerInfoRow(
              Icons.location_on_outlined, 'Address', customer.address1!),
      ],
    );
  }

  Widget _buildCustomerInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.blue[400],
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    TextInputType? keyboardType,
    required Function(String) onChanged,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: label,
                prefixText: prefix,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
  }
}
