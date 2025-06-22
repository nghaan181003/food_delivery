import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/keyboard_hider.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/login_form.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/form_web.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: KeyboardHider(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kIsWeb)
                const LoginFormWeb()
              else ...[
                PrimaryHeader(
                  child: Text(
                    "Đăng nhập",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.apply(color: MyColors.white),
                  ),
                ),
                Center(
                  child: Image.asset(
                    MyImagePaths.appRed,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                //Image.asset(MyImagePaths.appRed),
                const Padding(
                  padding: EdgeInsets.all(MySizes.spaceBtwItems),
                  child: Column(
                    children: [LoginForm()],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
