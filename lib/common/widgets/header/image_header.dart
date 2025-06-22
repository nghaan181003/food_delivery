import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class ImageHeader extends StatelessWidget {
  final double height;
  final String imageUrl;
  final bool isLocalImage;

  const ImageHeader({
    super.key,
    required this.height,
    required this.imageUrl,
    this.isLocalImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.secondaryTextColor,
      width: double.infinity,
      height: height,
      child: isLocalImage
          ? Image.file(
              File(imageUrl),
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
            )
          : Image.network(
              imageUrl,
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
    );
  }
}
