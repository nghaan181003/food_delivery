import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/customers/address_selection/controllers/address_selection_controller.dart';
import 'package:food_delivery_h2d/data/config/config_repository.dart';
import 'package:food_delivery_h2d/data/distance/distance_repository.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:get/get.dart';

class DeliveryFeeHelper {
  static Future<void> calculateDeliveryFee(
      {required Order order,
      required RxInt deliveryFee,
      required RxInt totalAmount,
      required RxDouble distance,
      required AddressSelectionController addressSelectionController,
      required ConfigRepository configRepository,
      required DistanceRepository distanceRepository}) async {
    final isCalculatingFee = true.obs;
    isCalculatingFee.value = true;
    try {
      final deliveryConfig = await configRepository.getDeliveryFeeConfig();

      if (deliveryConfig.status == Status.OK && deliveryConfig.data != null) {
        final config = deliveryConfig.data!;

        final baseFee = config.data['baseFee']?.toDouble() ?? 0.0;
        final additionalFeePerKm =
            config.data['additionalFeePerKm']?.toDouble() ?? 0.0;
        final surcharge = config.data['surcharge']?.toDouble() ?? 0.0;

        final fetchedDistance = await getDistanceFromBackend(
          addressSelectionController: addressSelectionController,
          distanceRepository: distanceRepository,
        );

        if (fetchedDistance == null) {
          deliveryFee.value = 0;
          order.deliveryFee = deliveryFee.value;
          return;
        }

        final extraDistance = (fetchedDistance - 1.0).clamp(0, double.infinity);
        deliveryFee.value =
            baseFee + (extraDistance * additionalFeePerKm) + surcharge;
        order.deliveryFee = deliveryFee.value;

        print("🚚 Khoảng cách: ${fetchedDistance.toStringAsFixed(2)} km");
        print("🚚 Phí vận chuyển: ${deliveryFee.value.toStringAsFixed(0)} VNĐ");
      } else {
        throw Exception('Lỗi API: ${deliveryConfig.message}');
      }
    } finally {
      isCalculatingFee.value = false;
    }
  }

  static Future<double?> getDistanceFromBackend(
      {required AddressSelectionController addressSelectionController,
      required DistanceRepository distanceRepository}) async {
    final point1 = {
      'lat': addressSelectionController.latitude.value,
      'lng': addressSelectionController.longitude.value
    };
    final point2 = {
      'lat': 10.762622, // Example restaurant lat
      'lng': 106.660172, // Example restaurant lng
    };

    try {
      final response = await distanceRepository.getDistance(point1, point2);
      if (response.status == Status.OK && response.data != null) {
        return response.data!.distance;
      } else {
        throw Exception('Lỗi API: ${response.message}');
      }
    } catch (e) {
      print("🔴 Lỗi getDistanceFromBackend: $e");
      return null;
    }
  }
}
