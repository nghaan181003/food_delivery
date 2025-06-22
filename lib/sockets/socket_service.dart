import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  static SocketService get instance => Get.find<SocketService>();
  late IO.Socket _socket;

  Future init(String baseUrl) async {
    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket.onConnect((_) {
      print('Connected to the socket server');
    });

    _socket.onDisconnect((_) {
      print('Disconnected from the socket server');
    });

    _socket.onError((data) {
      print('Socket error: $data');
    });

    return this;
  }

  IO.Socket get socket => _socket;

  void disconnect() {
    _socket.disconnect();
  }
}
