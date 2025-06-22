import 'package:flutter/material.dart';
import 'package:openai_api/src/app_coordinator.dart';
import 'package:openai_api/src/core/components/constant/handle_time.dart';
import 'package:openai_api/src/core/components/extensions/context_extensions.dart';
import 'package:openai_api/src/domain/entity/conversation/conversation.dart';

class ConversationItemWidget extends StatelessWidget {
  final Conversation conversation;
  final Function onDelete;
  final Function onSelectConversation;
  const ConversationItemWidget({
    super.key,
    required this.conversation,
    required this.onDelete,
    required this.onSelectConversation,
  });

  get titleMedium => null;

  get titleSmall => null;

  @override
  Widget build(BuildContext context) {
    final smallStyle = context.titleSmall
        .copyWith(fontSize: 11.0, color: Theme.of(context).hintColor);
    return GestureDetector(
      onLongPress: () async {
        final show = await context.showAlertDialog(
            header: "Xóa đoạn chat",
            content: "Bạn có chắc muốn xóa đoạn chat này");
        if (show) {
          onDelete.call();
        }
      },
      onTap: () => onSelectConversation.call(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).primaryColorLight,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset(ImageConst.appIcon, width: 30.0, height: 30.0),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(conversation.header, style: smallStyle)),
                      Text(
                        getjmFormat(
                            conversation.lastUpdate ?? conversation.createdAt),
                        style: smallStyle,
                      ),
                    ],
                  ),
                  Text(
                    conversation.title,
                    style: context.titleSmall
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    conversation.lastMessage ?? "Không có tin nhắn",
                    style: smallStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ].expand((e) => [e, const SizedBox(height: 2.0)]).toList()
                  ..removeLast(), // chen Sizebox vào giữa các item có heigt = 2, loại bỏ cái cuối
              ),
            )
          ],
        ),
      ),
    );
  }
}
