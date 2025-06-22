import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/text_field/my_text_filed.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class MyHorizontalFormField extends StatelessWidget {
  const MyHorizontalFormField(
      {super.key,
      this.onValidate,
      required this.controller,
      required this.hintText,
      required this.lable,
      this.width,
      this.isNumber = false,
      this.readOnly = false,
      this.required = false});

  final String? Function(String?)? onValidate;
  final TextEditingController controller;
  final String hintText;
  final String lable;
  final bool required;
  final bool readOnly;
  final bool isNumber;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: lable,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: MyColors.darkPrimaryTextColor),
            children: required
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        SizedBox(
          width: width ?? 280,
          child: MyTextFiled(
              isNumberType: isNumber,
              readOnly: readOnly,
              validator: onValidate,
              textController: controller,
              hintText: hintText),
        ),
      ],
    );
  }
}
