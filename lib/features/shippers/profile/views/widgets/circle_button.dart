import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class CircleButton extends StatelessWidget {
  final double size;
  final Color color;
  final Widget child;
  final double radius;
  final Color? borderColor;
  final double borderWidth;
  final void Function()? onTap;

  const CircleButton({
    super.key,
    required this.size,
    required this.color,
    required this.child,
    required this.onTap,
    this.radius = 20,
    this.borderColor,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Material(
        color: color,
        child: InkWell(
          onHover: (value) {},
          onTap: onTap,
          child: Container(
            decoration: (borderColor != null)
                ? BoxDecoration(
                    border: Border.all(
                        color: MyColors.darkPrimaryColor, width: borderWidth),
                    borderRadius: BorderRadius.circular(radius),
                  )
                : null,
            width: size,
            height: size,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
