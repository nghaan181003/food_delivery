import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/scroll_controller.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class BackGroundLogin extends StatelessWidget {
  BackGroundLogin({super.key});

  final ScrollControllerX scrollControllerX = Get.put(ScrollControllerX());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollControllerX.controller,
      child: Container(
        color: MyColors.greyWhite,
        child: Column(children: [
          SizedBox(height: 10,),
          Obx(() {
            bool isVisible = scrollControllerX.isVisibleImg.value;
            return AnimatedOpacity(
              opacity: isVisible ? 1 : 0,
              duration: const Duration(milliseconds: 700),
              child: Transform.translate(
                offset: Offset(isVisible ? 0 : -100, 0),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(MySizes.borderRadiusMd),
                  child: Image.asset(
                    MyImagePaths.background,
                    width: 1200,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(MySizes.xl),
            child: Card(
              elevation: 8,
              color: MyColors.greyWhite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    bool isVisible = scrollControllerX.isVisible(100);
                    return AnimatedOpacity(
                      opacity: isVisible ? 1 : 0,
                      duration: const Duration(milliseconds: 700),
                      child: Transform.translate(
                        offset: Offset(isVisible ? 0 : -100, 0),
                        child: const Padding(
                          padding: EdgeInsets.only(left: MySizes.xl),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Khám Phá Dịch Vụ Đặt Đồ Ăn Thượng Hạng",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: MyColors.primaryTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MySizes.xs,
                                  ),
                                  Image(
                                    width: 24,
                                    height: 24,
                                    image: AssetImage(MyImagePaths.iconSearch),
                                    fit: BoxFit.cover,
                                    // color: Colors.white,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Chúng tôi mang đến trải nghiệm đặt món ăn, thức uống tuyệt vời từ ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: MyColors.primaryTextColor),
                              ),
                              Text(
                                "những nhà hàng hàng đầu, giao tận nơi ngay khi bạn cần.",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: MyColors.primaryTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  Obx(() {
                    bool isVisible = scrollControllerX.isVisible(100);
                    return AnimatedOpacity(
                      opacity: isVisible ? 1 : 0,
                      duration: const Duration(milliseconds: 700),
                      child: Transform.translate(
                        offset: Offset(isVisible ? 0 : 100, 0),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(MySizes.borderRadiusMd),
                          child: Image.asset(
                            MyImagePaths.imgWeb3,
                            width: 280,
                            height: 300,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: MySizes.xl, right: MySizes.xl, bottom: MySizes.xl),
            child: Card(
              elevation: 8,
              color: MyColors.greyWhite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    bool isVisible = scrollControllerX.isVisible(450);
                    return AnimatedOpacity(
                      opacity: isVisible ? 1 : 0,
                      duration: const Duration(milliseconds: 700),
                      child: Transform.translate(
                        offset: Offset(isVisible ? 0 : -100, 0),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(MySizes.borderRadiusMd),
                          child: Image.asset(
                            MyImagePaths.imgWeb2,
                            width: 330,
                            height: 300,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  }),
                  Obx(() {
                    bool isVisible = scrollControllerX.isVisible(450);
                    return AnimatedOpacity(
                      opacity: isVisible ? 1 : 0,
                      duration: const Duration(milliseconds: 700),
                      child: Transform.translate(
                        offset: Offset(isVisible ? 0 : 100, 0),
                        child: const Padding(
                          padding: EdgeInsets.only(right: MySizes.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image(
                                    width: 24,
                                    height: 24,
                                    image: AssetImage(MyImagePaths.iconRocket),
                                    fit: BoxFit.cover,
                                    // color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: MySizes.xs,
                                  ),
                                  Text(
                                    "Chỉ với vài cú click",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: MyColors.primaryTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Bạn có thể thưởng thức bữa ăn ngon miệng ngay tại nhà hoặc văn phòng",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: MyColors.primaryTextColor),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Tiện lợi, nhanh chóng, đảm bảo chất lượng – hãy để chúng tôi phục vụ bạn!",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: MyColors.primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
