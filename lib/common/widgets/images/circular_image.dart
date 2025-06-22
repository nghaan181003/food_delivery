

import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class MyCircularImage extends StatelessWidget {
  const MyCircularImage(
      {super.key,
      this.fit,
      required this.image,
      this.isNetworkImage = false,
      this.overlayColor,
      this.backgroundColor,
      this.width = 56,
      this.height = 56,
      this.padding = MySizes.sm});

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Image(
            fit: fit,
            color: overlayColor,
            image: isNetworkImage
                ? NetworkImage(image)
                : AssetImage(image) as ImageProvider),
      ),
    );
  }
}
