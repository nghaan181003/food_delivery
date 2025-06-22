import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class MyVerticalImageText extends StatelessWidget {
  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final double? widthImage;
  final double? heightImage;
  final TextStyle? textStyle;
  final void Function()? onTap;
  final EdgeInsets? padding;

  const MyVerticalImageText(
      {super.key,
      required this.image,
      required this.title,
      this.textColor = MyColors.primaryTextColor,
      this.backgroundColor = Colors.white,
      this.width,
      this.height,
      this.widthImage,
      this.heightImage,
      this.textStyle,
      required this.onTap,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(MySizes.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // circular icon
            Container(
              width: width ?? 50,
              height: height ?? 55,
              // padding: padding ?? const EdgeInsets.all(MySizes.sm),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Image(
                  width: width ?? 50,
                  height: height ?? 55,
                  image: AssetImage(image),
                  fit: BoxFit.contain,
                  // color: Colors.white,
                ),
              ),
            ),

            // Text
            const SizedBox(
              height: MySizes.spaceBtwItems / 4,
            ),
            Text(
              textAlign: TextAlign.center,
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textStyle ??
                  Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: textColor,
                      ),
            )
          ],
        ),
      ),
    );
  }
}
