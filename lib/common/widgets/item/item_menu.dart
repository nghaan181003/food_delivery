import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/images/image_text_image.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class ItemMenu extends StatelessWidget {
  final String title;
  final String image;
  final Color textColor;
  final VoidCallback? onTap;

  const ItemMenu({
    super.key,
    required this.title,
    required this.image,
    this.textColor = MyColors.darkPrimaryTextColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: MyVerticalImageText(
            image: image,
            title: title,
            width: 24, height: 24,

            // widthImage: 20,
            // heightImage: 22,
            // textStyle: Theme.of(context)
            //     .textTheme
            //     .bodySmall!
            //     .apply(color: MyColors.darkPrimaryTextColor),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
