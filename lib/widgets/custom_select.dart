import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';
import 'custom_field.dart';
import 'custom_loader.dart';

class CustomSelectItem {
  String id;
  String value;

  CustomSelectItem({
    required this.id,
    required this.value,
  });
}

class CustomSelect extends StatelessWidget {
  // Existing parameters remain the same
  final List<CustomSelectItem> mainList;
  final Function(CustomSelectItem val) onSelect;
  final String placeholder;
  final String label;
  final TextEditingController textEditCtlr;
  final bool showLabel;
  final Function()? onTapField;
  final Function(PointerDownEvent pointerDownEvent)? onTapOutsideField;
  final FutureOr<List<CustomSelectItem>> Function(String)? suggestionFn;
  final Color filledColor;
  final Color labelColor;
  final String? Function(String?)? validator;
  final bool withShadow;
  final bool? withIcon;
  final Widget? customIcon;
  final bool showPlusIcon;
  final VoidCallback? onPlusPressed;

  const CustomSelect({
    super.key,
    required this.mainList,
    this.customIcon,
    required this.onSelect,
    required this.placeholder,
    required this.label,
    required this.textEditCtlr,
    this.showLabel = false,
    this.onTapField,
    this.withIcon = false,
    this.onTapOutsideField,
    this.suggestionFn,
    this.filledColor = Colors.white,
    this.labelColor = Colors.black,
    this.validator,
    this.withShadow = true,
    this.showPlusIcon = false,
    this.onPlusPressed,
  }) : assert(!showPlusIcon || onPlusPressed != null,
            'onPlusPressed is required when showPlusIcon is true');

  String normalize(String str) {
    return str.toLowerCase().trim().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        TypeAheadField<CustomSelectItem>(
          itemSeparatorBuilder: (ctx, idx) {
            return const Divider(
              height: 1,
              color: Colors.grey,
              indent: 12,
              endIndent: 12,
            );
          },
          suggestionsCallback: (search) {
            if (suggestionFn != null) {
              return suggestionFn!(search);
            }
            return mainList.where(
              (element) {
                return normalize(element.value).contains(
                  normalize(search),
                );
              },
            ).toList();
          },
          hideOnUnfocus: true,
          hideOnSelect: true,
          controller: textEditCtlr,
          loadingBuilder: (context) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: CustomLoader(),
              ),
            );
          },
          builder: (context, controller, focusNode) {
            return Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: CustomField(
                      editingController: controller,
                      focusNode: focusNode,
                      hintText: placeholder,
                      labelText: label,
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      onFieldTap: onTapField,
                      onOutsideTap: onTapOutsideField,
                      bgColor: filledColor,
                      validator: validator,
                      withShadow: withShadow,
                      showIcon: withIcon == true,
                      customIcon: withIcon == true
                          ? customIcon ??
                              Icon(
                                Icons.arrow_drop_down,
                                color: theme.primaryColor,
                              )
                          : null,
                    ),
                  ),
                ),
                if (showPlusIcon) ...[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        topRight: Radius.circular(12),
                        topLeft: Radius.circular(1),
                        bottomLeft: Radius.circular(1),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.add, size: 28),
                        onPressed: onPlusPressed,
                        color: Colors.white,
                        splashColor: Colors.white.withOpacity(0.3),
                        highlightColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  )
                ],
              ],
            );
          },
          decorationBuilder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: child,
            );
          },
          constraints: const BoxConstraints(
            maxHeight: 250,
          ),
          onSelected: onSelect,
          hideWithKeyboard: false,
          hideOnEmpty: true,
          itemBuilder: (context, item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                item.value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ),
      ],
    );
  }
}
