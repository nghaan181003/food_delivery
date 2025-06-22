import 'dart:convert';
import 'package:food_delivery_h2d/sockets/socket_service.dart';
import 'package:get/get.dart';

import '../../features/shippers/home/models/order_model.dart';

class OrderSocketHandler {
  final _socketService = SocketService.instance;

  void listenForOrderCreates(Function(Order order) onNewOrder) {
    _socketService.socket.on('order:new', (data) {
      final orderData = jsonDecode(jsonEncode(data));
      final order = Order.fromJson(orderData);
      onNewOrder(order);
    });
  }

  void listenNewOrderDriver(Function(Order order) onNewOrder) {
    _socketService.socket.on('order:created', (data) {
      final orderData = jsonDecode(jsonEncode(data));
      final order = Order.fromJson(orderData);
      onNewOrder(order);
    });
  }

  void listenNewOrderAssigned(Function(Order order) onNewOrder) {
    _socketService.socket.on('order:newOrderAssigned', (data) {
      final orderData = jsonDecode(jsonEncode(data));
      final order = Order.fromJson(orderData);
      onNewOrder(order);
    });
  }

  void listenForOrderUpdates(Function(Order order) onOrderUpdated) {
    _socketService.socket.on('order:updatedStatus', (data) {
      try {
        final orderData = jsonDecode(jsonEncode(data));
        final order = Order.fromJson(orderData);
        onOrderUpdated(order);
      } catch (e) {
        print('Error processing order update: $e');
      }
    });
  }

  void listenForOrderCancelled(Function(Order order) onOrderCancelled) {
    _socketService.socket.on('order:cancelled', (data) {
      try {
        final orderData = jsonDecode(jsonEncode(data));
        final order = Order.fromJson(orderData);
        onOrderCancelled(order);
      } catch (e) {
        print('Error processing order cancelled: $e');
      }
    });
  }

  void updateDriverLocation(String orderId, double latitude, double longitude) {
    if (_socketService.socket.connected) {
      _socketService.socket.emit('order:updateDriverLocation', {
        'orderId': orderId,
        'driverLat': latitude,
        'driverLng': longitude,
      });
    } else {
      print('Socket not connected, attempting to reconnect...');
      _socketService.socket.connect();
    }
  }

  void listenForDriverLocationUpdates(Function(Map<String, dynamic>) callback) {
    _socketService.socket
        .on('order:updateDriverLocation', (data) => callback(data));
  }

  void createOrder(Order order) {
    final orderData = order.toJson();
    _socketService.socket.emit('order:create', jsonEncode(orderData));
    print('Order created: $orderData');
  }

  void updateStatusOrder(String orderId, Map<String, dynamic> newStatus) {
    // Create payload
    print(
        'Updating order status for orderId: $orderId with newStatus: $newStatus');
    final orderData = {
      'orderId': orderId,
      'newStatus': newStatus,
    };

    // Emit the updateStatusOrder event
    _socketService.socket.emit('order:updateStatus', orderData);
  }

  void joinRoom(String room) async {
    _socketService.socket.emit('joinRoom', room);
    print('Requested to join room: $room');

    _socketService.socket.on('joinedRoom', (data) {
      print('Successfully joined room: ${data['roomId']}');
    });

    _socketService.socket.on('error', (data) {
      print('Failed to join room: ${data['message']}');
    });
  }

  void removeJoinRoom(String room) async {
    _socketService.socket.emit('leaveRoom', room);
    print('Requested to leave room: $room');

    _socketService.socket.on('leftRoom', (data) {
      print('Successfully left room: ${data['roomId']}');
    });

    _socketService.socket.on('error', (data) {
      print('Failed to leave room: ${data['message']}');
    });
  }

  void listenSuggestionOrder(Function(Order order) onSuggested) async {
    _socketService.socket.on('order:suggestion', (data) {
      try {
        final orderData = jsonDecode(jsonEncode(data['order']));
        final order = Order.fromJson(orderData);
        onSuggested(order);
      } catch (e) {
        print('Error processing suggested order: $e');
      }
    });
  }

  void listenRejectionOrder(Function(Order order) onRejected) async {
    _socketService.socket.on('order:rejection', (data) {
      try {
        final orderData = jsonDecode(jsonEncode(data['order']));
        final order = Order.fromJson(orderData);
        onRejected(order);
      } catch (e) {
        print('Error processing rejected order: $e');
      }
    });
  }

  // Clean up listeners
  void cleanUp() {
    _socketService.socket.off('order:new');
    _socketService.socket.off('order:created');
    _socketService.socket.off('order:updateStatus');
    _socketService.socket.off('order:updatedStatus');
    _socketService.socket.off('order:updateDriverLocation');
    _socketService.socket.off('order:cancelled');
  }
}
