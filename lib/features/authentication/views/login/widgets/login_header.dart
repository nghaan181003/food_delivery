import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/header/wave_header.dart';
import 'package:food_delivery_h2d/utils/devices/devices_utils.dart';
import '../../../../../utils/constants/sizes.dart';

class PrimaryHeader extends StatelessWidget {
  final Widget child;
  const PrimaryHeader({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return WaveHeader(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.only(
                left: MySizes.defaultSpace,
                right: MySizes.defaultSpace,
                top: MyDeviceUtils.getAppBarHeight(),
                bottom: 130),
            child: child),
      ),
    );
  }
}
