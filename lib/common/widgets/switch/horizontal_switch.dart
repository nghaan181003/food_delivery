import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class MyHorizontalSwitch extends StatelessWidget {
  const MyHorizontalSwitch(
      {super.key,
      this.required = false,
      required this.lable,
      required this.value,
      this.onChanged});

  final String lable;
  final bool required;
  final bool value;
  final Function(bool)? onChanged;

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
        Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            value: value,
            activeColor: MyColors.darkPrimaryColor,
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}
