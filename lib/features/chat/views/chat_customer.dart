import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatCustomer extends StatelessWidget {
  final String customerId;
  final String driverId;
  final String currentUserId;
  final String driverName;
  final String driverImage;
  final String orderId;
  final String? orderStatus;
  ChatCustomer(
      {super.key,
      required this.customerId,
      required this.driverId,
      required this.currentUserId,
      required this.driverName,
      required this.driverImage,
      required this.orderId,
      this.orderStatus}) {
    controller.setChatId(orderId);
  }
  final ChatController controller = Get.put(ChatController());

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Row(
          children: [
            ClipOval(
              child: Image.network(
                driverImage,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 28, color: Colors.white);
                },
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            driverName == "Unknown" ? const Text("Chưa có tài xế nhận đơn") : Text(driverName)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: MySizes.sm, left: MySizes.sm, bottom: MySizes.md),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: controller.getMessagesStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());

                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId == currentUserId;
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe
                                ? MyColors.darkPrimaryTextColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                                color: isMe ? MyColors.white : Colors.black),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: MySizes.sm,
            ),
            if (orderStatus == 'delivered' || orderStatus == 'cancelled')
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Phiên chat với tài xế đã kết thúc"),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration:
                          const InputDecoration(hintText: "Nhập tin nhắn..."),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (messageController.text.trim().isNotEmpty) {
                        controller.sendMessage(
                            currentUserId, messageController.text.trim());
                        messageController.clear();
                      }
                    },
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
