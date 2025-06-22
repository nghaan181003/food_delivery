import 'package:flutter/material.dart';

class OptionsWidget<T> extends StatelessWidget {
  const OptionsWidget(
      {super.key,
      required this.label,
      required this.value,
      required this.groupValue,
      this.isReverse = false,
      this.onChanged});

  final String label;
  final T value;
  final T groupValue;
  final Function(T?)? onChanged;
  final bool isReverse;

  @override
  Widget build(BuildContext context) {
    final children = [
      Text(label),
      Radio(value: value, groupValue: groupValue, onChanged: onChanged)
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: isReverse ? children.reversed.toList() : children,
    );
  }
}
