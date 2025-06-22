import 'package:flutter/material.dart';

class KeyboardHider extends StatelessWidget {
  final Widget child;
  const KeyboardHider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
