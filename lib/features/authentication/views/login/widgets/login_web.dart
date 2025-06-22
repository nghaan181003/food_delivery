import 'dart:ui'; // Import thư viện để dùng ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/login_form.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class LoginWeb extends StatelessWidget {
  const LoginWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Stack(
            children: [
              Image.asset(
                MyImagePaths.background,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),// chinh do mo cua anh
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height - 470) / 2,
          right: (MediaQuery.of(context).size.width - 650) / 3,
          child: SizedBox(
            width: 800,
            height: 450,
            child: Row(
              children: [
                Image.asset(
                  MyImagePaths.background,
                  fit: BoxFit.cover,
                  width: 400,
                  height: 470,
                ),
                Container(
                  color: MyColors.white,
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(MySizes.borderRadiusMd),
                          child: Image.asset(
                            MyImagePaths.appRed,
                            width: 120,
                            height: 120,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        const SizedBox(height: MySizes.spaceBtwItems),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: MySizes.xl * 2,
                              right: MySizes.xl * 2,
                              bottom: MySizes.xl),
                          child: LoginForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
