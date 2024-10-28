import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';
import 'custom_field.dart';


class CustomSelectItem {
  String id;
  String value;

  CustomSelectItem({
    required this.id,
    required this.value,
  });
}

class CustomSelect extends StatelessWidget {
  // Params
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

  const CustomSelect({
    super.key,
    required this.mainList,
    required this.onSelect,
    required this.placeholder,
    required this.label,
    required this.textEditCtlr,
    this.showLabel = false,
    this.onTapField,
    this.onTapOutsideField,
    this.suggestionFn,
    this.filledColor = bgColor,
    this.labelColor = Colors.black,
    this.validator,
    this.withShadow = true,
  });

  String normalize(String str) {
    return str.toLowerCase().trim().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showLabel == true
            ? Padding(
          padding: const EdgeInsets.only(
            bottom: 5,
            // left: 12,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontFamily: "JosefinSans",
              fontSize: Get.size.width * 0.035,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
            : const SizedBox.shrink(),
        TypeAheadField<CustomSelectItem>(
          itemSeparatorBuilder: (ctx, idx) {
            return const Divider();
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
          // autoFlipDirection: true,
          hideOnUnfocus: true,
          hideOnSelect: true,
          controller: textEditCtlr,
          loadingBuilder: (context) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: primary1Color,
                ),
              ),
            );
          },
          builder: (context, controller, focusNode) {
            return CustomField(
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
            );
            //   return TextFormField(
            //     controller: textEditCtlr,
            //     focusNode: focusNode,
            //     textInputAction: TextInputAction.done,
            //     keyboardType: TextInputType.text,
            //     textAlignVertical: TextAlignVertical.center,
            //     style: TextStyle(
            //       fontWeight: FontWeight.w500,
            //       fontSize: Get.size.width * 0.032,
            //     ),
            //     autofocus: false,
            //     autocorrect: false,
            //     autovalidateMode: AutovalidateMode.onUserInteraction,
            //     decoration: InputDecoration(
            //       isDense: true,
            //       hintText: placeholder,
            //       suffixIconColor: AppColors.darkGrey,
            //       hintStyle:
            //           Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
            //                 fontSize: Get.size.width * 0.032,
            //               ),
            //     ),
            //     onTap: onTapField,
            //     onTapOutside: onTapOutsideField,
            //   );
          },
          itemBuilder: (context, item) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.value,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
            );
          },
          decorationBuilder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: child,
            );
          },
          constraints: const BoxConstraints(
            maxHeight: 200,
          ),
          onSelected: onSelect,
          hideWithKeyboard: false,
          hideOnEmpty: true,
          // suggestionsController: suggestionsController,
        ),
      ],
    );
  }
}
