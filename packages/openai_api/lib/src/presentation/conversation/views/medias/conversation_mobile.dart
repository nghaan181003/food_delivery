import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openai_api/src/core/components/extensions/context_extensions.dart';
import 'package:openai_api/src/domain/entity/conversation/conversation.dart';
import 'package:openai_api/src/presentation/conversation/bloc/conversation_bloc.dart';
import 'package:openai_api/src/presentation/conversation/views/widgets/conversation_item_widget.dart';

class ConversationMobile extends StatefulWidget {
  final ConversationState state;
  const ConversationMobile({super.key, required this.state});

  @override
  State<ConversationMobile> createState() => _ConversationMobileState();
}

class _ConversationMobileState extends State<ConversationMobile> {
  ConversationBloc get _bloc => context.read<ConversationBloc>();

  Color get _backgroundColor => Theme.of(context).scaffoldBackgroundColor;

  Color get _primaryColor => Theme.of(context).primaryColor;

  List<Conversation> get _conversations => widget.state.data.conversations;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _body(context: context, state: widget.state),
        if (widget.state.loading)
          Container(
            color: Colors.black45,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(child: CircularProgressIndicator()),
          )
      ],
    );
  }

  Widget _body(
      {required BuildContext context, required ConversationState state}) {
    return Scaffold(
      extendBody: true,
      backgroundColor: _backgroundColor,
      bottomNavigationBar: _bottomNavigationField(context),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AppBar(
            backgroundColor: _primaryColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              "Lịch sử chat",
              style: context.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.history, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 15.0, bottom: 80.0),
          itemCount: _conversations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10.0),
          itemBuilder: (_, index) {
            final conversation = _conversations[index];
            return ConversationItemWidget(
              conversation: conversation,
              onDelete: () => _bloc.add(
                ConversationEvent.deleteConversation(
                    conversationId: conversation.id),
              ),
              onSelectConversation: () => _bloc.add(
                ConversationEvent.selectConversation(
                    conversationId: conversation.id),
              ),
            );
          }),
    );
  }

  Widget _bottomNavigationField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        onPressed: () =>
            _bloc.add(const ConversationEvent.createConversation()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 18.0),
            const SizedBox(
              width: 8,
            ),
            Text(
              "Đoạn chat mới",
              style: context.titleSmall
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
