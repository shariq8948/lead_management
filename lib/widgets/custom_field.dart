import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Widget? customIcon; // Optional custom icon

  final bool password;
  final bool? passwordField;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String?)? onChange;
  final Function? showPass;
  final bool? showLabel;
  final bool? showIcon;
  final bool enabled;
  final void Function()? forgotPassHandler;
  final bool shouldAutoFocus;
  final String? initVal;
  final void Function()? onFieldTap;
  final Function(PointerDownEvent pointerDownEvent)? onOutsideTap;
  final bool readOnly;
  final TextEditingController? editingController;
  final Color bgColor;
  final Color labelColor;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final int minLines;
  final bool withShadow;

  const CustomField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.inputAction,
    required this.inputType,
    this.passwordField = false,
    this.password = false,
    this.errorText,
    this.inputFormatters,
    this.validator,
    this.customIcon,
    this.onChange,
    this.showLabel = false,
    this.showIcon = false,
    this.showPass,
    this.enabled = true,
    this.forgotPassHandler,
    this.shouldAutoFocus = false,
    this.initVal,
    this.onFieldTap,
    this.onOutsideTap,
    this.readOnly = false,
    this.editingController,
    this.bgColor = Colors.white,
    this.labelColor = Colors.black,
    this.contentPadding,
    this.focusNode,
    this.minLines = 1,
    this.withShadow = true,
  });

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
        blurRadius: 10,
        offset: const Offset(0, 0),
      ),
    );
    var customErrorBorder = DecoratedInputBorder(
      child: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      shadow: BoxShadow(
        color: const Color(0xFFFF0000).withOpacity(0.25),
        spreadRadius: 0,
        blurRadius: 10,
        offset: const Offset(0, 0),
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showLabel == true
            ? Padding(
                padding: const EdgeInsets.only(
                  bottom: 5,
                  // left: 12,
                ),
                child: Text(
                  labelText,
                  style: TextStyle(
                    color: labelColor,
                    fontFamily: "JosefinSans",
                    fontSize: Get.size.width * 0.035,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        TextFormField(
          focusNode: focusNode,
          controller: editingController,
          textInputAction: inputAction,
          keyboardType: inputType,
          obscureText: password,
          inputFormatters: inputFormatters ?? [],
          validator: validator,
          onChanged: onChange,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: Get.size.width * 0.032,
          ),
          autofocus: shouldAutoFocus,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: enabled,
          initialValue: initVal,
          onTap: onFieldTap,
          onTapOutside: onOutsideTap,
          readOnly: readOnly,
          minLines: minLines,
          maxLines: minLines,
          cursorColor: Colors.teal,
          decoration: InputDecoration(
            filled: true,
            prefixIcon: showIcon! ? customIcon : null,
            fillColor: bgColor,
            isDense: true,
            border: withShadow
                ? customBorder
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
            focusedErrorBorder: withShadow
                ? customErrorBorder
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red.withOpacity(0.25),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
            disabledBorder: withShadow
                ? customBorder
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
            focusedBorder: withShadow
                ? customBorder
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
            enabledBorder: withShadow
                ? customBorder
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
            errorBorder: withShadow
                ? customErrorBorder
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red.withOpacity(0.25),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),

            hintStyle: TextStyle(
              fontFamily: "JosefinSans",
              color: Colors.grey.withOpacity(0.6),
              fontWeight: FontWeight.w400,
              fontSize: Get.size.width * 0.032,
            ),
            contentPadding: const EdgeInsets.all(
              13,
            ),
            hintText: hintText,
            suffixIconColor: Colors.grey,
            suffixIcon: passwordField == true
                ? password == true
                    ? GestureDetector(
                        onTap: () {
                          if (showPass != null) {
                            showPass!();
                          }
                        },
                        child: const Icon(
                          Icons.visibility_off,
                          size: 15,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (showPass != null) {
                            showPass!();
                          }
                        },
                        child: const Icon(
                          Icons.visibility,
                          size: 15,
                        ),
                      )
                : null,
            // suffixIconConstraints: const BoxConstraints(
            //   maxHeight: 14,
            //   minHeight: 14,
            //   maxWidth: 14,
            //   minWidth: 14,
            // ),
          ),
        ),
        passwordField == true
            ? Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  // right: 12,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      if (forgotPassHandler != null) {
                        forgotPassHandler!();
                      }
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
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
      {BorderSide? borderSide,
      InputBorder? child,
      BoxShadow? shadow,
      bool? isOutline}) {
    return DecoratedInputBorder(
      child: (child ?? this.child).copyWith(borderSide: borderSide),
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ShapeBorder scale(double t) {
    final scalledChild = child.scale(t);

    return DecoratedInputBorder(
      child: scalledChild is InputBorder ? scalledChild : child,
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
  // ignore: deprecated_member_use
  // int get hashCode => Object.hash(borderSide, child, shadow);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'DecoratedInputBorder')}($borderSide, $shadow, $child)';
  }
}
