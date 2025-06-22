import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPTextField extends StatelessWidget {
  const OTPTextField({
    super.key, this.controller,
  });

  final controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 64,
        height: 64,
        child: TextFormField(
          controller: controller,
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).previousFocus();
            }
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly
          ],
        ));
  }
}
