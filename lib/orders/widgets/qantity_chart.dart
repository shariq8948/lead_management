import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChartQuantitySelector extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final Function(int) onChanged;
  final Color primaryColor;
  final int? availableStock;

  const ChartQuantitySelector({
    Key? key,
    this.minValue = 1,
    this.maxValue = 20,
    this.initialValue = 1,
    required this.onChanged,
    this.primaryColor = Colors.blue,
    this.availableStock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      QuantitySelectorController(
        initialValue: initialValue,
        minValue: minValue,
        maxValue: availableStock != null && availableStock! < maxValue
            ? availableStock!
            : maxValue,
        onChanged: onChanged,
        chartMaxValue: maxValue,
        availableStock: availableStock,
      ),
      tag: UniqueKey().toString(),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Quantity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Selected: ${controller.selectedQuantity.value}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  )),
            ],
          ),
          if (availableStock != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Available Stock: $availableStock',
                style: TextStyle(
                  color:
                      availableStock! < 5 ? Colors.red : Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: (availableStock != null && availableStock! < maxValue
                    ? availableStock!
                    : maxValue) -
                controller.minValue +
                1,
            itemBuilder: (context, index) {
              final quantity = controller.minValue + index;

              return Obx(
                () => _buildQuantityButton(
                  quantity: quantity,
                  isSelected: quantity == controller.selectedQuantity.value,
                  isDisabled:
                      availableStock != null && quantity > availableStock!,
                  onTap: () => controller.updateValue(quantity),
                  primaryColor: primaryColor,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Obx(() => _buildActionButton(
                      icon: Icons.remove,
                      label: 'Decrease',
                      onPressed: controller.selectedQuantity.value >
                              controller.minValue
                          ? () => controller.updateValue(
                              controller.selectedQuantity.value - 1)
                          : null,
                      primaryColor: primaryColor,
                    )),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _buildQuantityInput(
                  controller: controller,
                  primaryColor: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Obx(() => _buildActionButton(
                      icon: Icons.add,
                      label: 'Increase',
                      onPressed: (availableStock == null ||
                              controller.selectedQuantity.value <
                                  availableStock!)
                          ? () => controller.updateValue(
                              controller.selectedQuantity.value + 1)
                          : null,
                      primaryColor: primaryColor,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityInput({
    required QuantitySelectorController controller,
    required Color primaryColor,
  }) {
    return _QuantityInputField(
      controller: controller,
      primaryColor: primaryColor,
    );
  }

  Widget _buildQuantityButton({
    required int quantity,
    required bool isSelected,
    bool isDisabled = false,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.shade200
              : isSelected
                  ? primaryColor
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDisabled
                ? Colors.grey.shade400
                : isSelected
                    ? primaryColor
                    : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: !isDisabled && isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            '$quantity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isDisabled
                  ? Colors.grey.shade500
                  : isSelected
                      ? Colors.white
                      : Colors.grey.shade800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color primaryColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            onPressed == null ? Colors.grey.shade300 : primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: onPressed == null ? 0 : 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: onPressed == null ? Colors.grey.shade500 : Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: onPressed == null ? Colors.grey.shade500 : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityInputField extends StatefulWidget {
  final QuantitySelectorController controller;
  final Color primaryColor;

  const _QuantityInputField({
    required this.controller,
    required this.primaryColor,
    Key? key,
  }) : super(key: key);

  @override
  State<_QuantityInputField> createState() => _QuantityInputFieldState();
}

class _QuantityInputFieldState extends State<_QuantityInputField> {
  late TextEditingController textController;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(
      text: widget.controller.selectedQuantity.value.toString(),
    );
    widget.controller.selectedQuantity.listen((value) {
      if (textController.text != value.toString()) {
        textController.text = value.toString();
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.primaryColor.withOpacity(0.5),
              width: 1.5,
            ),
            color: Colors.white,
          ),
          child: TextField(
            controller: textController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                final newValue = int.tryParse(value);
                if (newValue != null) {
                  if (widget.controller.availableStock != null &&
                      newValue > widget.controller.availableStock!) {
                    setState(() {
                      errorMessage =
                          'Cannot exceed available stock (${widget.controller.availableStock})';
                    });
                  } else {
                    setState(() {
                      errorMessage = null;
                    });
                    widget.controller.updateValue(newValue);
                  }
                }
              } else {
                setState(() {
                  errorMessage = null;
                });
              }
            },
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class QuantitySelectorController extends GetxController {
  final int minValue;
  final int maxValue;
  final int chartMaxValue;
  final Function(int) onChanged;
  final int? availableStock;

  RxInt selectedQuantity;

  QuantitySelectorController({
    required int initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.chartMaxValue,
    this.availableStock,
  }) : selectedQuantity = initialValue.clamp(minValue, maxValue).obs;

  void updateValue(int newValue) {
    int clampedValue = newValue.clamp(minValue, maxValue);

    // Corrected logic: Restrict to availableStock if available
    if (availableStock != null) {
      clampedValue = newValue.clamp(minValue, availableStock!);
    } else {
      clampedValue = newValue.clamp(minValue, maxValue);
    }

    if (clampedValue != selectedQuantity.value) {
      selectedQuantity.value = clampedValue;
      onChanged(clampedValue);
    }
  }
}
