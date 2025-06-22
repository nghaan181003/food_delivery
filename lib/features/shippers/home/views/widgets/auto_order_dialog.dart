import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class AutoOrderDialog extends StatefulWidget {
  final Order order;

  const AutoOrderDialog({super.key, required this.order});

  @override
  _AutoOrderDialogState createState() => _AutoOrderDialogState();
}

class _AutoOrderDialogState extends State<AutoOrderDialog> {
  OrderSocketHandler socketHandler = Get.find();
  late Timer _timer;
  int _secondsRemaining = 15;
  bool _isDragging = false;
  double _dragPosition = 0.0;
  bool _actionTaken = false;

  @override
  void initState() {
    super.initState();
    _dragPosition = 0.0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0 && !_actionTaken) {
        setState(() {
          _secondsRemaining--;
        });
      } else if (!_actionTaken) {
        _timer.cancel();
        Get.back();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details, double maxDrag) {
    if (_actionTaken) return;
    setState(() {
      _isDragging = true;
      _dragPosition += details.delta.dx;
      _dragPosition = _dragPosition.clamp(0.0, maxDrag);
    });
  }

  void _handleDragEnd(double maxDrag) {
    if (_actionTaken) return;
    setState(() {
      _isDragging = false;
    });
    if (_dragPosition >= maxDrag * 0.9) {
      _actionTaken = true;
      _timer.cancel();
      Get.back();
      socketHandler
          .removeJoinRoom(LoginController.instance.currentUser.driverId!);
      OrderController.instance.acceptOrder(widget.order);
    } else {
      setState(() {
        _dragPosition = 0.0;
      });
    }
  }

  void _rejectOrder() {
    if (_actionTaken) return;
    _actionTaken = true;
    _timer.cancel();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 60.0;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Đơn hàng mới',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(
            '$_secondsRemaining giây',
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
        ],
      ),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.store, "Nhà hàng", widget.order.restaurantName),
            _buildInfoRow(
                Icons.location_on, "Địa chỉ quán", widget.order.restAddress),
            _buildInfoRow(
                Icons.home, "Địa chỉ khách", widget.order.custAddress),
            _buildInfoRow(Icons.phone, "SĐT", widget.order.custPhone),
            _buildInfoRow(Icons.attach_money, "Tổng tiền",
                "${((widget.order.totalPrice ?? 0) + (widget.order.deliveryFee ?? 0))} VNĐ"),
            _buildInfoRow(Icons.delivery_dining, "Phí giao hàng",
                "${widget.order.deliveryFee} VNĐ"),
            const SizedBox(height: 20),
            SizedBox(
              height: buttonSize,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double maxWidth = constraints.maxWidth;
                  final double maxDrag =
                      (maxWidth - buttonSize).clamp(0, double.infinity);
                  return Container(
                    decoration: BoxDecoration(
                      color: MyColors.primaryBackgroundColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: maxWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Kéo để nhận đơn',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                        Positioned(
                          left: _dragPosition.clamp(0.0, maxDrag),
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) =>
                                _handleDragUpdate(details, maxDrag),
                            onHorizontalDragEnd: (_) => _handleDragEnd(maxDrag),
                            child: Container(
                              width: buttonSize,
                              height: buttonSize,
                              decoration: const BoxDecoration(
                                color: MyColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_forward,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _rejectOrder,
          child: const Text('Từ chối', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String? label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: MyColors.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
