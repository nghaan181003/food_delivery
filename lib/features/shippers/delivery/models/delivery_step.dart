import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';

enum DeliveryStepType {
  pickup,
  delivery;

  IconData get toIconData => switch (this) {
        DeliveryStepType.delivery => Icons.person,
        DeliveryStepType.pickup => Icons.store,
      };

  String get toPrefixLabel => switch (this) {
        DeliveryStepType.delivery => "Giao",
        DeliveryStepType.pickup => "Lấy",
      };

  Color get toColor => switch (this) {
        DeliveryStepType.delivery => Colors.green,
        DeliveryStepType.pickup => Colors.red,
      };
}

class DeliveryStep {
  final String orderId;
  final DeliveryStepType type;
  final DateTime createdAt;
  final Order order;
  final String address;
  final String name;
  final int index;

  DeliveryStep({
    required this.orderId,
    required this.type,
    required this.createdAt,
    required this.order,
    required this.address,
    required this.name,
    required this.index,
  });

  DeliveryStep copyWith({
    String? orderId,
    DeliveryStepType? type,
    DateTime? createdAt,
    Order? order,
    String? address,
    String? name,
    int? index,
  }) {
    return DeliveryStep(
        orderId: orderId ?? this.orderId,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        order: order ?? this.order,
        address: address ?? this.address,
        name: name ?? this.name,
        index: index ?? this.index);
  }
}
