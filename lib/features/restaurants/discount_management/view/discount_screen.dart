import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/tab_item.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/widgets/discount_management_tab.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/widgets/explore_tab.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: Text('Khuyến mãi'),
        ),
        body: Column(
          children: [
            TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicatorPadding:
                    const EdgeInsets.only(left: MySizes.sm, right: MySizes.sm),
                tabs: const [
                  TabItem(title: "Khám phá"),
                  TabItem(title: "Quản lý"),
                ]),
            Expanded(
                child: TabBarView(controller: _tabController, children: [
              const ExploreTab(),
              const DiscountManagementTab(),
            ]))
          ],
        ),
      ),
    );
  }
}
