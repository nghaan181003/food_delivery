import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/item/item_menu.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/discount_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/menu_list/menu_food_list_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_list/order_list_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/views/profile_restaurant_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/views/rating_list/rating_list_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/setting_schedule/views/schedule_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/views/statistic_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/view/voucher_overview_screen.dart';
import 'package:food_delivery_h2d/features/wallet/views/wallet_screen.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:get/get.dart';
import 'package:openai_api/openai_api.dart';

enum HomeRestaurant {
  order,
  menu,
  discount,
  vouncher,
  report,
  ratting,
  infor,
  wallet,
  setting,
  helper
}

extension HomeRestaunrantX on HomeRestaurant {
  Widget get toWidget => switch (this) {
        HomeRestaurant.infor => ItemMenu(
            onTap: () => Get.to(() => const ProfileRestaurantScreen()),
            title: "Thông tin cửa hàng",
            image: MyImagePaths.iconInfor),
        HomeRestaurant.menu => ItemMenu(
            onTap: () => Get.to(() => const MenuFoodListScreen()),
            title: "Thực đơn",
            image: MyImagePaths.iconMenu),
        HomeRestaurant.discount => ItemMenu(
            onTap: () => Get.to(() => const DiscountScreen()),
            title: "Khuyến mãi",
            image: MyImagePaths.iconAds),
        HomeRestaurant.vouncher => ItemMenu(
            onTap: () => Get.to(() => const VoucherOverviewScreen()),
            title: "Voucher",
            image: MyImagePaths.iconVoucher,
          ),
        HomeRestaurant.report => ItemMenu(
            onTap: () => Get.to(() => const StatisticScreen()),
            title: "Báo cáo",
            image: MyImagePaths.iconStatistic),
        HomeRestaurant.ratting => ItemMenu(
            onTap: () => Get.to(() => const RatingListScreen()),
            title: "Đánh giá",
            image: MyImagePaths.iconRating),
        HomeRestaurant.order => ItemMenu(
            onTap: () => Get.to(() => const OrderListScreen()),
            title: "Đơn hàng",
            image: MyImagePaths.iconOrder),
        HomeRestaurant.helper => ItemMenu(
            onTap: () => Get.to(() => MultiBlocProvider(
                  providers: [
                    BlocProvider<ChatBloc>(
                      create: (_) => injector.get<ChatBloc>(),
                    ),
                    BlocProvider<ConversationBloc>(
                      create: (_) => injector.get<ConversationBloc>(),
                    ),
                  ],
                  child: const ChatBotView(),
                )),
            title: "Trung tâm trợ giúp",
            image: MyImagePaths.iconService),
        HomeRestaurant.wallet => ItemMenu(
            onTap: () => Get.to(() => const WalletScreen()),
            title: "Ví của tôi",
            image: MyImagePaths.iconWallet1,
          ),
        HomeRestaurant.setting => ItemMenu(
            onTap: () => Get.to(() => const ScheduleScreen()),
            title: "Lịch đóng/mở quán",
            image: MyImagePaths.iconSwitch,
          ),
      };
}
