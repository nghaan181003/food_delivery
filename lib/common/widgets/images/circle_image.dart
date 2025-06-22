import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';

class CircleImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool isLocalImage;
  final double? width;
  final double? height;

  const CircleImage(
      {super.key,
      required this.imageUrl,
      this.radius = 40.0,
      this.isLocalImage = false,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: isLocalImage
          ? Image.file(
              File(imageUrl),
              width: width ?? radius * 2,
              height: height ?? radius * 2,
              fit: BoxFit.cover,
            )
          : FadeInImage.assetNetwork(
              placeholder: MyImagePaths.iconImage,
              image: imageUrl,
              width: width ?? radius * 2,
              height: height ?? radius * 2,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) =>
                  _errorPlaceholder(),
            ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 40.0,
      ),
    );
  }
}
