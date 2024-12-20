import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

enum ButtonTypes {
  outline,
  primary,
}

enum ButtonSize {
  small,
  regular,
  large,
}

class CustomButton extends StatelessWidget {
  final Widget? icon;
  final String? text;
  final bool? withIcon;
  final Color? foregroundColor;
  final Color? borderColor;
  final Color bgColor;
  final bool enabled;
  final bool loading;
  final Function onPressed;
  final ButtonTypes buttonType;
  final double width;
  final ButtonSize buttonSize;

  const CustomButton({
    super.key,
    this.icon,
    this.text,
    this.withIcon,
    this.foregroundColor,
    this.borderColor,
    this.bgColor = Colors.transparent,
    this.enabled = true,
    this.loading = false,
    this.buttonSize = ButtonSize.regular,
    required this.onPressed,
    required this.buttonType,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColorFromType() {
      switch (buttonType) {
        case ButtonTypes.primary:
          return buttonBgColor;
        case ButtonTypes.outline:
          return Colors.transparent;
        default:
          return buttonBgColor;
      }
    }

    Color getForegroundColorFromType() {
      if (foregroundColor != null) {
        if (enabled && !loading) {
          return foregroundColor!;
        }
        return foregroundColor!.withOpacity(0.7);
      } else {
        if (buttonType == ButtonTypes.outline) {
          if (borderColor != null) {
            if (enabled && !loading) {
              return borderColor!;
            }
            return borderColor!.withOpacity(0.7);
          }

          if (enabled && !loading) {
            return buttonBgColor;
          }
          return buttonBgColor.withOpacity(0.7);
        } else {
          if (enabled && !loading) {
            return Colors.white;
          }
          return Colors.white.withOpacity(0.7);
        }
      }
    }

    double getFontSize() {
      switch (buttonSize) {
        case ButtonSize.small:
          return 13;
        case ButtonSize.regular:
          return 15;
        case ButtonSize.large:
          return 17;
        default:
          return 15;
      }
    }

    double getButtonHeight() {
      switch (buttonSize) {
        case ButtonSize.small:
          return Get.size.height * 0.05;
        case ButtonSize.regular:
          return Get.size.height * 0.058 > 50 ? 50 : Get.size.height * 0.058;
        case ButtonSize.large:
          return Get.size.height * 0.072 > 60 ? 60 : Get.size.height * 0.072;
        default:
          return 15;
      }
    }

    Widget getChildFromType() {
      if (!loading) {
        if (withIcon != null && withIcon == true && icon != null) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              icon!,
              text != null
                  ? Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  text!,
                  style: TextStyle(
                    color: getForegroundColorFromType(),
                    fontSize: getFontSize(),
                    fontFamily: "JosefinSans",
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ],
          );
        } else {
          return text != null
              ? Text(
            text!,
            style: TextStyle(
              color: getForegroundColorFromType(),
              fontSize: getFontSize(),
              fontFamily: "JosefinSans",
            ),
          )
              : const SizedBox.shrink();
        }
      } else {
        return SizedBox(
          width: getFontSize() + 3,
          height: getFontSize() + 3,
          child: CircularProgressIndicator(color: getForegroundColorFromType()),
        );
      }
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width / 2),
        boxShadow: buttonType == ButtonTypes.primary
            ? [
          BoxShadow(
            color: buttonBgColor.withOpacity(0.6),
            spreadRadius: 4,
            blurRadius: 8,
            offset: const Offset(0, 0),
          )
        ]
            : [],
      ),
      child: MaterialButton(
        minWidth: width,
        onPressed: enabled && !loading ? () => onPressed() : null,
        splashColor: Colors.black.withOpacity(0.2),
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width / 2),
        ),
        child: Ink(
          width: width,
          decoration: BoxDecoration(
            color: enabled && !loading
                ? getBackgroundColorFromType()
                : (buttonType == ButtonTypes.outline)
                ? Colors.transparent
                : getBackgroundColorFromType().withOpacity(0.6),
            borderRadius: BorderRadius.circular(width / 2),
            border: borderColor != null
                ? Border.all(
              width: 1,
              color: enabled && !loading
                  ? borderColor!
                  : borderColor!.withOpacity(0.7),
            )
                : Border.all(
              width: 1,
              color: Colors.transparent,
            ),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 300.0,
              minHeight: getButtonHeight(),
            ),
            alignment: Alignment.center,
            child: getChildFromType(),
          ),
        ),
      ),
    );
  }
}
