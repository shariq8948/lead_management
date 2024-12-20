import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer
import 'package:get/get.dart';

class CustomSearchField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool enabled;
  final Function(String)? onSearch;
  final VoidCallback? onClear;
  final Color bgColor;
  final Color labelColor;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  const CustomSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.enabled = true,
    this.onSearch,
    this.onClear,
    this.bgColor = Colors.white,
    this.labelColor = Colors.black,
    this.focusNode,
    this.contentPadding,
  });

  @override
  _CustomSearchFieldState createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  Timer? _debounce;
  bool _isLoading = false;  // To track if search is loading

  // Handle search input with debounce
  void _onSearchChanged(String query) {
    // Cancel the previous debounce timer
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    // Start a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        if (widget.onSearch != null) {
          setState(() {
            _isLoading = true;  // Set loading state to true
          });
          widget.onSearch!(query);  // Trigger the search callback
        }
      } else {
        // Optionally handle clearing search results when query is empty
        setState(() {
          _isLoading = false;  // Set loading state to false
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var customBorder = DecoratedInputBorder(
      child: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      shadow: BoxShadow(
        color: const Color(0xFF707070).withOpacity(0.25),
        spreadRadius: 0,
        blurRadius: 5,
        offset: const Offset(0, 0),
      ),
    );

    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: Get.size.width * 0.032,
      ),
      autocorrect: false,
      enabled: widget.enabled,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.bgColor,
        isDense: true,
        border: customBorder,
        focusedBorder: customBorder,
        enabledBorder: customBorder,
        hintStyle: TextStyle(
          color: Colors.grey.withOpacity(0.6),
          fontWeight: FontWeight.w400,
          fontSize: Get.size.width * 0.032,
        ),
        contentPadding: widget.contentPadding ?? const EdgeInsets.all(13),
        hintText: widget.hintText,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search button
            _isLoading
                ? const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            )
                : IconButton(
              icon: const Icon(Icons.search, size: 20, color: Colors.grey),
              onPressed: () {
                if (widget.onSearch != null && widget.controller != null) {
                  setState(() {
                    _isLoading = true; // Set loading state to true when search is triggered
                  });
                  widget.onSearch!(widget.controller!.text);
                }
              },
            ),
            // Clear button
            IconButton(
              icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
              onPressed: () {
                if (widget.onClear != null && widget.controller != null) {
                  widget.controller!.clear();
                  widget.onClear!();
                  setState(() {
                    _isLoading = false; // Reset loading state when cleared
                  });
                }
              },
            ),
          ],
        ),
      ),
      onChanged: _onSearchChanged, // Call debounced function when typing
      onFieldSubmitted: (query) {
        if (query.isNotEmpty && widget.onSearch != null) {
          setState(() {
            _isLoading = true;
          });
          widget.onSearch!(query); // Trigger search when user presses enter
        }
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

class DecoratedInputBorder extends InputBorder {
  DecoratedInputBorder({
    required this.child,
    required this.shadow,
  }) : super(borderSide: child.borderSide);

  final InputBorder child;
  final BoxShadow shadow;

  @override
  bool get isOutline => child.isOutline;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      child.getInnerPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      child.getOuterPath(rect, textDirection: textDirection);

  @override
  EdgeInsetsGeometry get dimensions => child.dimensions;

  @override
  InputBorder copyWith(
      {BorderSide? borderSide, InputBorder? child, BoxShadow? shadow}) {
    return DecoratedInputBorder(
      child: (child ?? this.child).copyWith(borderSide: borderSide),
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ShapeBorder scale(double t) {
    final scaledChild = child.scale(t);
    return DecoratedInputBorder(
      child: scaledChild is InputBorder ? scaledChild : child,
      shadow: BoxShadow.lerp(null, shadow, t)!,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {double? gapStart,
        double gapExtent = 0.0,
        double gapPercentage = 0.0,
        TextDirection? textDirection}) {
    final clipPath = Path()
      ..addRect(const Rect.fromLTWH(-5000, -5000, 10000, 10000))
      ..addPath(getInnerPath(rect), Offset.zero)
      ..fillType = PathFillType.evenOdd;
    canvas.clipPath(clipPath);

    final Paint paint = shadow.toPaint();
    final Rect bounds = rect.shift(shadow.offset).inflate(shadow.spreadRadius);

    canvas.drawPath(getOuterPath(bounds), paint);

    child.paint(canvas, rect,
        gapStart: gapStart,
        gapExtent: gapExtent,
        gapPercentage: gapPercentage,
        textDirection: textDirection);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is DecoratedInputBorder &&
        other.borderSide == borderSide &&
        other.child == child &&
        other.shadow == shadow;
  }

  @override
  int get hashCode => Object.hash(borderSide, child, shadow);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'DecoratedInputBorder')}($borderSide, $shadow, $child)';
  }
}
