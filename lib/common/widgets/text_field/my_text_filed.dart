import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';

class MyTextFiled extends StatefulWidget {
  final bool useThousandsFormatter;

  const MyTextFiled({
    super.key,
    required this.textController,
    required this.hintText,
    this.maxLines = 1,
    this.textAlign,
    this.readOnly = false,
    this.validator,
    this.isNumberType = false,
    this.symbol = 'VND',
    this.useThousandsFormatter = true,
  });

  final String hintText;
  final TextEditingController textController;
  final int maxLines;
  final TextAlign? textAlign;
  final bool readOnly;
  final bool isNumberType;
  final FormFieldValidator<String>? validator;
  final String symbol;

  @override
  State<MyTextFiled> createState() => _MyTextFiledState();
}

class _MyTextFiledState extends State<MyTextFiled> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.textController;
    _formatInitialValueIfNeeded();
  }

  @override
  void didUpdateWidget(covariant MyTextFiled oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textController != widget.textController) {
      _controller = widget.textController;
      _formatInitialValueIfNeeded();
    }
  }

  void _formatInitialValueIfNeeded() {
    if (widget.isNumberType &&
        widget.useThousandsFormatter &&
        _controller.text.isNotEmpty) {
      final rawNumber = _controller.text.replaceAll(RegExp(r'[^\d]'), '');
      final number = int.tryParse(rawNumber);
      if (number != null) {
        final formatted = MyFormatter.formatThousands(number.toString(),
            symbol: widget.symbol);
        _controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType:
                widget.isNumberType ? TextInputType.number : TextInputType.text,
            validator: widget.validator,
            inputFormatters: widget.isNumberType
                ? widget.useThousandsFormatter
                    ? [
                        MyFormatter.thousandsSeparatorFormatter(
                            symbol: widget.symbol)
                      ]
                    : [FilteringTextInputFormatter.digitsOnly]
                : [],
            textAlign: widget.textAlign ?? TextAlign.right,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: MyColors.primaryTextColor,
                  height: 2,
                ),
            controller: _controller,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: MyColors.secondaryTextColor,
                  ),
              // contentPadding:
              //     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              contentPadding: const EdgeInsets.only(right: 4.0),
            ),
          ),
        ),
      ],
    );
  }
}
