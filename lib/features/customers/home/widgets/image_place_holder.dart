import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/features/customers/home/controllers/image_page_controller.dart';

class ImagePlaceHolder extends StatelessWidget {
  const ImagePlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      MyImagePaths.img1,
      MyImagePaths.img2,
      MyImagePaths.img3,
    ];

    final ImagePageController controller = Get.put(ImagePageController());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          items: imagePaths.map((path) {
            return Center(
              child: SizedBox(
                height: kIsWeb ? 350 : 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                    width: kIsWeb ? 900 : double.infinity,
                  ),
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            initialPage: 0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            onPageChanged: (index, reason) {
              controller.updateIndex(index);
            },
          ),
        ),
        const SizedBox(height: kIsWeb ? 0 : 20),
        if (!kIsWeb)
          Obx(
            () => AnimatedSmoothIndicator(
              activeIndex: controller.currentIndex.value,
              count: imagePaths.length,
              effect: const ScrollingDotsEffect(
                dotHeight: 6,
                dotWidth: 6,
                activeDotColor: Colors.yellow,
                dotColor: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }
}
