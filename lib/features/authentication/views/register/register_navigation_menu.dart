import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/appbar.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/enums.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/devices/devices_utils.dart';
import 'package:food_delivery_h2d/utils/helpers/convert_role.dart';

class RegisterNavigationMenu extends StatelessWidget {
  const RegisterNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MyDeviceUtils.getScreenWidth(context);
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: const MyAppBar(
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          child: Center(
              child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: MySizes.gridViewSpacing,
                crossAxisSpacing: MySizes.gridViewSpacing,
                mainAxisExtent: width * 0.6),
            children: UserRole.values.map((role) {
              return GestureDetector(
                onTap: () {
                  ConvertEnumRole.toPage(role);
                },
                child: Card(
                  child: SizedBox(
                    width: width * 0.6,
                    height: width * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image
                        Image(
                          image: AssetImage(ConvertEnumRole.toImagePath(role)),
                          width: 64,
                          height: 64,
                        ),
                        const SizedBox(
                          height: MySizes.spaceBtwItems,
                        ),
                        // Text
                        Text(
                          ConvertEnumRole.toDisplayName(role),
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
        ),
      ),
    );
  }
}
