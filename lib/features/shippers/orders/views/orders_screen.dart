import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/orders/views/widgets/filter_widget.dart';
import 'package:food_delivery_h2d/features/shippers/orders/views/widgets/order_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
        centerTitle: true,
        backgroundColor: MyColors.darkPrimaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: MyColors.primaryBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (_, innerBoxIsScrolled) {
          return [
            const SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              expandedHeight: 100,
              bottom: FilterWidget(),
            )
          ];
        },
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          itemCount: 10,
          itemBuilder: (context, index) {
            return const OrderTile();
          },
        ),
      ),
    );
  }
}
