import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/header/wave_clipper.dart';

class WaveClipperWidget extends StatelessWidget {
  const WaveClipperWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: WaveClipper(), child: child);
  }
}
