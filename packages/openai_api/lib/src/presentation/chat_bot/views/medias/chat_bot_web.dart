import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openai_api/src/core/components/constant/constant.dart';
import 'package:openai_api/src/core/components/extensions/context_extensions.dart';
import 'package:openai_api/src/core/components/extensions/string_extensions.dart';
import 'package:openai_api/src/core/components/widgets/button_custom.dart';
import 'package:openai_api/src/domain/entity/chat/chat.dart';
import 'package:openai_api/src/domain/entity/chat/chat_status.dart';
import 'package:openai_api/src/domain/entity/chat/chat_type.dart';
import 'package:openai_api/src/presentation/chat_bot/bloc/chat_bloc.dart';
import 'package:openai_api/src/presentation/chat_bot/bloc/chat_modal_state.dart';
import 'package:openai_api/src/presentation/chat_bot/views/widgets/input_widget.dart';
import 'package:openai_api/src/presentation/chat_bot/views/widgets/message_item.dart';
import 'package:openai_api/src/presentation/conversation/bloc/conversation_bloc.dart';
import 'package:openai_api/src/presentation/conversation/views/conversation_view.dart';

class ChatBotWeb extends StatefulWidget {
  final Function(BuildContext, ChatState) listenChatState;
  final Function(BuildContext, ConversationState) listenConversationStateChange;
  final Function(Chat) handleSpeechText;
  final TextEditingController textController;
  const ChatBotWeb(
      {super.key,
      required this.textController,
      required this.listenChatState,
      required this.listenConversationStateChange,
      required this.handleSpeechText});

  @override
  State<ChatBotWeb> createState() => _ChatBotWebState();
}

class _ChatBotWebState extends State<ChatBotWeb> {
  ChatBloc get _bloc => context.read<ChatBloc>();
  ConversationBloc get _conversationBloc => context.read<ConversationBloc>();

  ChatState get _state => _bloc.state;

  ChatModalState get _data => _bloc.data;

  bool get _micAvailable => _data.micAvailable;

  List<Chat> get _chats => _data.chats;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: widget.listenChatState,
      child: Scaffold(
        backgroundColor: "#151718".toColor(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Expanded(flex: 2, child: _BuildTabBarView()),
              Expanded(
                flex: 8,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      BlocListener<ConversationBloc, ConversationState>(
                          bloc: _conversationBloc,
                          listener: widget.listenConversationStateChange,
                          child: Expanded(
                              flex: 5, child: _chatField(_bloc.state))),
                      Expanded(flex: 2, child: _conversationField())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _conversationField() => Container(
        decoration: BoxDecoration(
          color: "#fefefe".toColor(),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeaderBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonCustom(
                    color: Colors.black,
                    enableWidth: false,
                    child: Text(
                      "Feedback",
                      style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    onPress: () {},
                  ),
                  const SizedBox(width: 12.0),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            const Expanded(
                child: Padding(
              padding: EdgeInsets.all(12.0),
              child: ConversationView(isWebPlatform: true),
            )),
          ],
        ),
      );

  Widget _chatField(ChatState state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 12.0),
                Text(
                  state.data.conversation?.header ?? "Chat bot",
                  style: context.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              return Align(
                alignment: Alignment.center,
                child: SizedBox(
                    height: double.infinity,
                    width: (maxWidth > kTabletWidth)
                        ? kTabletWidth
                        : maxWidth - 24,
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        final conversation = state.data.conversation;
                        List<Chat> chats = state.data.chats;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (conversation != null) ...[
                              Expanded(
                                child: ListView.builder(
                                    reverse: true,
                                    itemCount: chats.length,
                                    itemBuilder: (_, index) {
                                      final chat = _chats[index];
                                      return MessageItem(
                                        content: chat.title,
                                        loading: chat.chatStatus.isLoading,
                                        time: chat.createdAt,
                                        isBot: chat.chatType.isAssistant,
                                        isErrorMessage: chat.chatStatus.isError,
                                        speechOnPress: () =>
                                            widget.handleSpeechText(chat),
                                        longPressText: () {},
                                        isWebPlatform: true,
                                        isSpeechText:
                                            _state.isSpeechText((chat.id)),
                                        isAnimatedText:
                                            _data.textAnimation && index == 0,
                                        textAnimationCompleted: () => _bloc.add(
                                            const ChatEvent.changeTextAnimation(
                                                false)),
                                      );
                                    }),
                              ),
                              InputWidget(
                                borderRadius: 12.0,
                                textEditingController: widget.textController,
                                isListening: _state.listenSpeech,
                                onVoiceStart: () => _bloc
                                    .add(const ChatEvent.startListenSpeech()),
                                onVoiceStop: () => _bloc
                                    .add(const ChatEvent.stopListenSpeech()),
                                micAvailable: _micAvailable,
                                onSubmitted: () => _bloc.add(ChatEvent.sendChat(
                                    widget.textController.text)),
                              )
                            ] else ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Image.asset(ImageConst.appIcon,
                                  //     width: 32.0,
                                  //     height: 32.0,
                                  //     fit: BoxFit.cover),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                "Please create and select thread",
                                textAlign: TextAlign.center,
                                style: context.titleMedium
                                    .copyWith(fontWeight: FontWeight.w600),
                              )
                            ]
                          ],
                        );
                      },
                    )),
              );
            }),
          ),
        ],
      ),
    );
  }

  Container _buildHeaderBar({
    required Widget child,
    required BorderRadiusGeometry borderRadius,
  }) {
    return Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child);
  }
}

class _BuildTabBarView extends StatelessWidget {
  const _BuildTabBarView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0).copyWith(left: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerTab(context),
          const SizedBox(height: 20.0),
          _BuildTabbarView(Colors.blue, Icons.chat, "Chat bot", true, () => {}),
          const SizedBox(height: 4.0),
          _BuildTabbarView(Colors.green, Icons.search, "Search", false, () {}),
          const SizedBox(height: 4.0),
          _BuildTabbarView(
              Colors.orange, Icons.person, "Characters", false, () {}),
          const SizedBox(height: 4.0),
          _BuildTabbarView(
              Colors.purple, Icons.settings, "Settings", false, () {}),
          const Spacer(),
          // const Divider(thickness: 0.1),
          // _buildProfileView(context),
        ],
      ),
    );
  }

  

  Row _headerTab(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(12.0),
        //   child: Image.asset(
        //     ImageConst.dbizLightIcon,
        //     width: 120.0,
        //     fit: BoxFit.contain,
        //   ),
        // ),
        // const SizedBox(width: 10.0),
        // Expanded(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         "Made with ♥️ by",
        //         style: context.titleSmall.copyWith(color: Colors.grey),
        //       ),
        //       Text(
        //         "DBiz",
        //         style: context.titleLarge.copyWith(
        //             color: Colors.white,
        //             fontSize: 24.0,
        //             fontWeight: FontWeight.bold),
        //       ),
        //     ],
        //   ),
        // )
      ],
    );
  }
}

class _BuildTabbarView extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String title;
  final bool isSelected;
  final Function() onTap;
  const _BuildTabbarView(
      this.color, this.icon, this.title, this.isSelected, this.onTap);

  @override
  State<_BuildTabbarView> createState() => __BuildTabbarViewState();
}

class __BuildTabbarViewState extends State<_BuildTabbarView> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (value) {
        setState(() {
          _isHover = value;
        });
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? widget.color.withOpacity(0.1)
              : _isHover
                  ? Colors.grey.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icon, color: widget.color, size: 18.0),
            const SizedBox(width: 10.0),
            Text(
              widget.title,
              style: context.titleMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
