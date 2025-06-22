import 'package:food_delivery_h2d/features/chat/models/chat_message.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var messages = <ChatMessage>[].obs;

  late String chatId;

  void setChatId(String orderId) {
    chatId = orderId;
  }
  

  Stream<List<ChatMessage>> getMessagesStream() {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }

  Future<void> sendMessage(String senderId, String text) async {
    final newMessage = ChatMessage(
      senderId: senderId,
      text: text,
      createdAt: DateTime.now(),
    );

    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(newMessage.toMap());
  }
}
