import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/map_tracking_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class MapTracking extends StatelessWidget {
  final Order order;
  MapTracking({super.key, required this.order});

  final MapTrackingController mapController = Get.find();
  final flutterMapController = MapController();

  @override
  Widget build(BuildContext context) {
    mapController.initializeWithOrder(order);

    return Scaffold(
      appBar: const CustomAppBar(title: Text("Theo dõi đơn hàng")),
      body: Obx(() {
        final shipperLoc = mapController.shipperLocation.value;
        return FlutterMap(
          mapController: flutterMapController,
          options: MapOptions(
            initialCenter: shipperLoc,
            initialZoom: 15.0,
            minZoom: 5.0,
            maxZoom: 20.0,
            onMapReady: () {
              debugPrint('MapWidget: Map is ready');
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.food_delivery_h2d',
              errorTileCallback: (tile, error, stackTrace) {
                debugPrint('Tile error: $error');
              },
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: mapController.routePoints.toList(),
                  strokeWidth: 5.0,
                  color: MyColors.primaryColor,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: shipperLoc,
                  width: 80.0,
                  height: 80.0,
                  child: Image.asset(
                    'assets/icons/ic_shipper_marker.png',
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person_pin_circle,
                          color: MyColors.primaryColor);
                    },
                  ),
                ),
                Marker(
                  point: mapController.restaurantLocation.value,
                  width: 40.0,
                  height: 40.0,
                  child: Image.asset(
                    'assets/icons/ic_restaurant_marker.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.restaurant,
                          color: MyColors.primaryColor);
                    },
                  ),
                ),
                Marker(
                  point: mapController.customerLocation.value,
                  width: 40.0,
                  height: 40.0,
                  child: Image.asset(
                    'assets/icons/ic_home_marker.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.home,
                          color: MyColors.primaryColor);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
