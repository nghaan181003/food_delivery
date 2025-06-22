import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/sockets/socket_service.dart';
import 'package:food_delivery_h2d/utils/constants/socket.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(SocketService());
    Get.find<SocketService>().init(BaseUrlSocket.baseUrl);
  }
}
