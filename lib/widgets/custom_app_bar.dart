import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBarActionItem {
  IconData asset;
  Function onTap;
  bool isBadge;

  CustomAppBarActionItem({
    required this.asset,
    required this.onTap,
    this.isBadge = false,
  });
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData? leadingIcon;
  final Widget? leading;
  final List<CustomAppBarActionItem>? actions;
  final bool? isBack;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color textColor;
  final String? titleText;
  final Widget? title;
  final double? elevation;
  final Function? leadingTap;
  final double titleSpace;

  const CustomAppBar({
    super.key,
    this.leading,
    this.leadingIcon,
    this.actions,
    this.isBack,
    this.backgroundColor = Colors.transparent,
    this.foregroundColor = Colors.black,
    this.textColor = Colors.black,
    this.title,
    this.titleText,
    this.elevation = 0.2,
    this.leadingTap,
    this.titleSpace = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (leading != null || isBack == true || leadingIcon != null) {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        centerTitle: false,
        title: getTitle(),
        titleSpacing: titleSpace,
        elevation: elevation,
        scrolledUnderElevation: 0.2,
        leading: leading == null
            ? IconButton(
          icon: leadingIcon != null
              ? Icon(
            leadingIcon,
            size: 26,
            color: foregroundColor,
          )
              : const Icon(
            Icons.chevron_left,
            size: 26,
            color: Colors.black,
          ),
          onPressed: () {
            if (leading != null && leadingTap != null) {
              leadingTap!();
            } else {
              Get.back();
            }
          },
        )
            : leading!,
        actions: getActions(),
      );
    } else {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        centerTitle: false,
        titleSpacing: titleSpace,
        title: getTitle(),
        elevation: elevation,
        scrolledUnderElevation: 0.2,
        actions: getActions(),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);

  List<Widget> getActions() {
    return [
      ...(actions ?? []).map(
            (e) {
          return IconButton(
            icon: Icon(
              e.asset,
              size: Get.size.width * 0.055,
              color: foregroundColor,
            ),
            onPressed: () {
              e.onTap();
            },
          );
        },
      ),
    ];
  }

  Widget? getTitle() {
    if (titleText == null && title != null) {
      return title!;
    } else if (title == null && titleText != null) {
      Widget textW = Text(
        titleText ?? "",
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: "JosefinSans",
        ),
      );

      return textW;
    } else {
      return null;
    }
  }
}