import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/header/circular_container.dart';
import 'package:food_delivery_h2d/common/widgets/header/curved_edges_widget.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class MyPrimaryHeaderContainer extends StatelessWidget {
  final Widget child;
  const MyPrimaryHeaderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CurvedEdgesWidget(
      child: Container(
        color: MyColors.primaryColor,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: CicularContainer(
                backgroudColor: MyColors.lightPrimaryColor.withOpacity(0.2),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: CicularContainer(
                backgroudColor: MyColors.lightPrimaryColor.withOpacity(0.2),
              ),
            ),
            child
          ],
        ),
      ),
    );
  }
}
