import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/appbar.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/customers/address_selection/controllers/address_selection_controller.dart';
import 'package:food_delivery_h2d/features/customers/home/controllers/home_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/nearby_restaurant_controller.dart';
import 'package:food_delivery_h2d/features/notification/controllers/notification_controller.dart';
import 'package:food_delivery_h2d/features/notification/views/notification_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/notification_restaurant/views/notification_restaurant_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class CustomerAppbar extends StatelessWidget {
  CustomerAppbar({
    super.key,
  });
  final AddressSelectionController _addressController =
      Get.put(AddressSelectionController());
  final addressKey = RxInt(0);

  void _showFullScreenMap(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Map",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // --- Header ---
              Container(
                color: MyColors.darkPrimaryColor, // Màu nền bạn muốn
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: MySizes.xl,
                    bottom: MySizes.sm,
                    left: MySizes.xl,
                    right: MySizes.xs,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Chọn vị trí trên bản đồ",
                          style: TextStyle(
                            color: MyColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: MyColors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: FutureBuilder<LatLng>(
                  future: _addressController.getInitialPositionForMap(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final initialCenter = snapshot.data ??
                        LatLng(
                          _addressController.latitude.value != 0
                              ? _addressController.latitude.value
                              : 10.7769,
                          _addressController.longitude.value != 0
                              ? _addressController.longitude.value
                              : 106.7009,
                        );

                    return Obx(() => FlutterMap(
                          options: MapOptions(
                            initialCenter: initialCenter,
                            initialZoom: 15.0,
                            onTap: (tapPosition, point) {
                              LoginController.instance
                                  .currentLocation["latitude"] = point.latitude;
                              LoginController
                                      .instance.currentLocation["longitude"] =
                                  point.longitude;
                              addressKey.value++;
                              NearbyRestaurantController.instance
                                  .fetchNearbyRestaurant(
                                point.latitude,
                                point.longitude,
                                20,
                                20,
                              );
                              Navigator.pop(context);
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.example.food_delivery_h2d',
                            ),
                            MarkerLayer(
                              markers: [
                                if (_addressController.latitude.value != 0.0 &&
                                    _addressController.longitude.value != 0.0)
                                  Marker(
                                    point: LatLng(
                                      _addressController.latitude.value,
                                      _addressController.longitude.value,
                                    ),
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(LoginController());
    final homeController = Get.put(HomeController());
    final controller = Get.put(NotificationController());
    return MyAppBar(
      padding: const EdgeInsets.only(left: MySizes.xs,),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: MySizes.lg - 2),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    "Giao đến:",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: Colors.white),
                  ),
                ),
                const Spacer(),
                InkWell(
                    onTap: () {
                      Get.to(
                        const NotificationScreen(),
                      );
                    },
                    child: Stack(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: MySizes.xs, top: MySizes.sm),
                          child: Icon(
                            Icons.notifications_on_outlined,
                            color: MyColors.white,
                            size: 22,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 3,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                                color: MyColors.darkPrimaryColor,
                                borderRadius: BorderRadius.circular(100)),
                            child: Center(
                                child: Obx(
                              () => Text(
                                controller.countNotificationNotRead.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .apply(color: Colors.white),
                              ),
                            )),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          const SizedBox(height: MySizes.xs),
          InkWell(
            onTap: () async {
              _showFullScreenMap(context);
            },
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: MySizes.iconMs,
                ),
                const SizedBox(width: MySizes.xs),
                Obx(() => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: 260,
                        child: FutureBuilder<String?>(
                          key: ValueKey(addressKey.value),
                          future: authController.currentLocation != null
                              ? homeController.getAddressFromCoordinates(
                                  authController.currentLocation!['latitude'],
                                  authController.currentLocation!['longitude'],
                                )
                              : Future.value(null),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? "Đang lấy địa chỉ hiện tại..."
                                  : snapshot.hasData && snapshot.data != null
                                      ? snapshot.data!
                                      : "Chọn địa chỉ",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .apply(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    )),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: MySizes.iconSm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
