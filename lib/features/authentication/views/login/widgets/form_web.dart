import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/background_login.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/login_form.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/login_web.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/tab_item.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class LoginFormWeb extends StatelessWidget {
  const LoginFormWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height, 
      width: MediaQuery.of(context).size.width, 
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 300,
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicatorPadding:
                      EdgeInsets.only(left: MySizes.sm, right: MySizes.sm),
                  tabs: [
                    TabItem(title: "Trang chủ"),
                    TabItem(title: "Đăng nhập"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  BackGroundLogin(),
                  LoginWeb(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


        
        // Stack(
        //   children: [
        //     BackGroundLogin(),
        //     // Positioned(
        //     //   top: (MediaQuery.of(context).size.height - 470) / 2,
        //     //   right: (MediaQuery.of(context).size.width - 650) / 3,
        //     //   child: SizedBox(
        //     //     width: 400,
        //     //     height: 470,
        //     //     child: Card(
        //     //       elevation: 4,
        //     //       shadowColor: MyColors.darkPrimaryColor,
        //     //       child: Column(
        //     //         mainAxisAlignment: MainAxisAlignment.center,
        //     //         children: [
        //     //           ClipRRect(
        //     //             borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
        //     //             child: Image.asset(
        //     //               MyImagePaths.appRed,
        //     //               width: 120,
        //     //               height: 120,
        //     //               fit: BoxFit.cover,
        //     //             ),
        //     //           ),
        //     //           const SizedBox(height: MySizes.spaceBtwItems,),
        //     //           const Padding(
        //     //             padding: EdgeInsets.only(
        //     //                 left: MySizes.xl * 2,
        //     //                 right: MySizes.xl * 2,
        //     //                 bottom: MySizes.xl),
        //     //             child: LoginForm(),
        //     //           ),
        //     //         ],
        //     //       ),
        //     //     ),
        //     //   ),
        //     // ),
        //     // Positioned(
        //     //   top: (MediaQuery.of(context).size.height - 250) / 2,
        //     //   left: (MediaQuery.of(context).size.width - 750) / 3,
        //     //   child: ClipRRect(
        //     //     borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
        //     //     child: Image.asset(
        //     //       MyImagePaths.background,
        //     //       width: 400,
        //     //       height: 250,
        //     //       fit: BoxFit.fill,
        //     //     ),
        //     //   ),
        //     // ),
        //   ],
        // ),
