import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import '../models/delivery_step.dart';

List<DeliveryStep> convertOrdersToDeliverySteps(List<Order> orders) {
  final pickupSteps = <DeliveryStep>[];
  final deliverySteps = <DeliveryStep>[];

  for (final order in orders) {
    final createdAt = order.createdAt ?? order.orderDatetime;

    pickupSteps.add(DeliveryStep(
      index: 0,
      orderId: order.id,
      type: DeliveryStepType.pickup,
      createdAt: createdAt,
      order: order,
      address: order.restAddress ?? '',
      name: order.restaurantName,
    ));

    deliverySteps.add(DeliveryStep(
      index: 0,
      orderId: order.id,
      type: DeliveryStepType.delivery,
      createdAt: createdAt,
      order: order,
      address: order.custAddress ?? '',
      name: "Khách hàng",
    ));
  }

  pickupSteps.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  deliverySteps.sort((a, b) => a.createdAt.compareTo(b.createdAt));

  final allSteps = [...pickupSteps, ...deliverySteps];

  for (int i = 0; i < allSteps.length; i++) {
    allSteps[i] = allSteps[i].copyWith(index: i + 1);
  }

  return allSteps;
}
