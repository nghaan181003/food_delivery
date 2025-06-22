import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openai_api/src/core/components/extensions/context_extensions.dart';
import 'package:openai_api/src/core/components/extensions/string_extensions.dart';
import 'package:openai_api/src/domain/entity/chat/chat.dart';
import 'package:openai_api/src/domain/entity/chat/chat_status.dart';
import 'package:openai_api/src/domain/entity/chat/chat_type.dart';
import 'package:openai_api/src/domain/entity/conversation/conversation.dart';
import 'package:openai_api/src/presentation/chat_bot/bloc/chat_bloc.dart';
import 'package:openai_api/src/presentation/chat_bot/bloc/chat_modal_state.dart';
import 'package:openai_api/src/presentation/chat_bot/views/chat_bot_view.dart';
import 'package:openai_api/src/presentation/chat_bot/views/widgets/input_widget.dart';
import 'package:openai_api/src/presentation/chat_bot/views/widgets/message_item.dart';
import 'package:openai_api/src/presentation/conversation/bloc/conversation_bloc.dart';
import 'package:openai_api/src/presentation/conversation/views/conversation_view.dart';
// import 'package:dbiz_chat_bot_sdk/clean_architectures/data/data_source/remote/thread_api.dart';

class ChatBotMobile extends StatefulWidget {
  final TextEditingController textController;
  final Function(BuildContext, ChatState) listenChatState;
  final Function(BuildContext, ConversationState) listenConversationStateChange;
  final Function(Chat) handleSpeechText;
  const ChatBotMobile(
      {super.key,
      required this.textController,
      required this.listenConversationStateChange,
      required this.handleSpeechText,
      required this.listenChatState});

  @override
  State<ChatBotMobile> createState() => _ChatBotMobileState();
}

class _ChatBotMobileState extends State<ChatBotMobile> {
  ChatBloc get _bloc => context.read<ChatBloc>();
  ConversationBloc get _conversationBloc => context.read<ConversationBloc>();

  ChatState get _state => _bloc.state;

  ChatModalState get _data => _bloc.data;

  bool get _micAvailable => _data.micAvailable;

  List<Chat> get _chats => _data.chats;

  Conversation? get _conversation => _data.conversation;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
        listener: widget.listenChatState,
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              _body(context, state: state),
              if (state.loading)
                Container(
                  color: Colors.black45,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          );
        });
  }

  Widget _body(BuildContext context, {required ChatState state}) {
    return BlocListener<ConversationBloc, ConversationState>(
      bloc: _conversationBloc,
      listener: widget.listenConversationStateChange,
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: const SafeArea(
          child: Drawer(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ConversationView(isWebPlatform: false))),
        ),
        body: Container(
          margin: const EdgeInsets.all(12.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeaderBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 12.0),
                      IconButton(
                        onPressed: () async {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        icon: const Icon(Icons.menu),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          state.data.conversation?.header ?? "JoJo - Chatbot",
                          style: context.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                if (_conversation != null) ...[
                  Expanded(
                    child: ListView.builder(
                        reverse: true,
                        itemCount: _chats.length,
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          final chat = _chats[index];
                          return MessageItem(
                            content: chat.title,
                            loading: chat.chatStatus.isLoading,
                            time: chat.createdAt,
                            isBot: chat.chatType.isAssistant,
                            isErrorMessage: chat.chatStatus.isError,
                            speechOnPress: () => widget.handleSpeechText(chat),
                            longPressText: () {},
                            isAnimatedText: _data.textAnimation && index == 0,
                            textAnimationCompleted: () => _bloc.add(
                                const ChatEvent.changeTextAnimation(false)),
                          );
                        }),
                  ),
                  InputWidget(
                    textEditingController: widget.textController,
                    isListening: _state.listenSpeech,
                    borderRadius: 12,
                    onVoiceStart: () =>
                        _bloc.add(const ChatEvent.startListenSpeech()),
                    onVoiceStop: () =>
                        _bloc.add(const ChatEvent.stopListenSpeech()),
                    micAvailable: _micAvailable,
                    onSubmitted: () => _bloc
                        .add(ChatEvent.sendChat(widget.textController.text)),
                  )
                ] else ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(ImageConst.appIcon,
                            //     width: 32.0, height: 32.0, fit: BoxFit.cover),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          "Vui lòng tạo đoạn chat mới",
                          textAlign: TextAlign.center,
                          style: context.titleMedium
                              .copyWith(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
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
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child);
  }
}
