import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:openai_api/src/core/components/extensions/context_extensions.dart';
import 'package:openai_api/src/core/components/extensions/string_extensions.dart';
import 'package:openai_api/src/presentation/chat_bot/views/widgets/dot_waiting.dart';
import 'package:openai_api/src/presentation/chat_bot/views/widgets/speech_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageItem extends StatefulWidget {
  final bool isBot;
  final String content;
  final DateTime time;
  final bool loading;
  final bool isErrorMessage;
  final bool isSpeechText;
  final Function() longPressText;
  final Function() speechOnPress;
  final Function() textAnimationCompleted;
  final bool isAnimatedText;
  final bool isWebPlatform;
  const MessageItem({
    super.key,
    this.isWebPlatform = false,
    this.isErrorMessage = false,
    this.isSpeechText = false,
    this.isAnimatedText = false,
    required this.isBot,
    required this.content,
    required this.time,
    required this.loading,
    required this.speechOnPress,
    required this.longPressText,
    required this.textAnimationCompleted,
  });

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    final style = context.titleSmall.copyWith(
      fontSize: 13.0,
      color: widget.isBot ? context.titleLarge.color : Colors.white,
    );
    if (widget.isWebPlatform && widget.isBot) {
      return _BuildMessageWebWidget(
          content: widget.content,
          voicCall: widget.speechOnPress,
          isLoading: widget.loading);
    }
    var content = [
      Flexible(
        flex: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment:
              widget.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            if (widget.isBot) ...[
              _chatBotInformation(context),
              const SizedBox(height: 5.0),
            ],
            InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onLongPress: () {
                if (!widget.isErrorMessage) {
                  widget.longPressText();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: widget.isErrorMessage
                      ? Colors.red
                      : widget.isBot
                          ? "#f3f5f7".toColor()
                          : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: widget.loading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SizedBox(
                          width: 80,
                          child: DotWaiting(
                            radius: 6,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            innerPadding: 2,
                            color: context.titleLarge.color!,
                          ),
                        ),
                      )
                    : widget.isBot
                        ? Column(
                            children: [
                              Markdown(
                                selectable: true,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                data: widget.content,
                                onTapLink: (text, href, title) {
                                  //Open link
                                  // ignore: deprecated_member_use
                                  href != null ? launch(href) : null;
                                },
                                styleSheet: MarkdownStyleSheet.fromTheme(
                                        Theme.of(context))
                                    .copyWith(p: style),
                              ),
                              // if (youtubeLink?.isNotEmpty ?? false) ...[
                              //   const SizedBox(height: 12.0),
                              //   YoutubeDisplay(url: youtubeLink!),
                              // ]
                            ],
                          )
                        : Text(widget.content, style: style),
              ),
            )
          ],
        ),
      ),
      if (widget.isBot) ...[
        const SizedBox(width: 10.0),
        InkWell(
          onTap: widget.speechOnPress,
          child: widget.isSpeechText
              ? const SpeechIcon()
              : Icon(
                  Icons.volume_down,
                  size: 18,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
        ),
      ],
      if (!widget.isBot) SizedBox(width: context.widthDevice * 0.1),
      SizedBox(width: context.widthDevice * 0.05)
    ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            widget.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: widget.isBot ? content : content.reversed.toList(),
      ),
    );
  }

  Row _chatBotInformation(BuildContext context) {
    return Row(
      children: [
        // Container(
        //   width: 20.0,
        //   height: 20.0,
        //   decoration: BoxDecoration(
        //     border: Border.all(width: 1, color: Colors.white),
        //     image: const DecorationImage(
        //       image: AssetImage(ImageConst.msSunnyIcon),
        //       fit: BoxFit.cover,
        //     ),
        //     shape: BoxShape.circle,
        //   ),
        // ),
        const SizedBox(width: 5.0),
        Text(
          "JoJo",
          style: context.titleSmall.copyWith(fontSize: 12.0),
        ),
      ],
    );
  }
}

class _BuildMessageWebWidget extends StatelessWidget {
  final String content;
  final bool isLoading;

  final Function() voicCall;
  const _BuildMessageWebWidget(
      {required this.content, required this.voicCall, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          width: isLoading ? 108 : constraints.maxWidth * 0.6,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 34.0),
                padding: const EdgeInsets.all(16.0).copyWith(bottom: 42.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: "#f3f5f7".toColor(),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 80,
                        child: DotWaiting(
                          radius: 6,
                          animationDuration: const Duration(milliseconds: 300),
                          innerPadding: 2,
                          verticalOffset: -10,
                          color: context.titleLarge.color!,
                        ),
                      )
                    : Markdown(
                        selectable: true,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        data: content,
                        onTapLink: (text, href, title) {
                          //Open link
                          // ignore: deprecated_member_use
                          href != null ? launch(href) : null;
                        },
                        styleSheet:
                            MarkdownStyleSheet.fromTheme(Theme.of(context))
                                .copyWith(p: context.titleSmall.copyWith()),
                      ),
              ),
              _buildActionField(context),
            ],
          ),
        );
      }),
    );
  }

  Positioned _buildActionField(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 24.0,
      child: SizedBox(
        height: 60.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Container(
            //   width: 60,
            //   height: 60,
            //   padding: const EdgeInsets.all(3.0),
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).cardColor,
            //     borderRadius: BorderRadius.circular(12.0),
            //   ),
            //   child: _sunnyIcon(),
            // ),
            if (!isLoading) ...[
              const SizedBox(width: 6.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Text(
                      "JoJo",
                      style: context.titleSmall
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5.0),
                    _buildActionButton(
                        onTap: () {},
                        child:
                            Text("Copy", style: context.titleSmall.copyWith())),
                    const SizedBox(width: 5.0),
                    _buildActionButton(
                        onTap: voicCall,
                        child: Text("Voice",
                            style: context.titleSmall.copyWith())),
                    const SizedBox(width: 5.0),
                    _buildActionButton(
                        onTap: () {},
                        child: Text("Reply",
                            style: context.titleSmall.copyWith())),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ClipRRect _sunnyIcon() {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(12.0),
  //     child: Image.asset(
  //       ImageConst.msSunnyIcon,
  //       fit: BoxFit.cover,
  //       width: double.infinity,
  //       height: double.infinity,
  //     ),
  //   );
  // }

  Widget _buildActionButton(
      {required Function() onTap, required Widget child}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 28,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(width: 1, color: "#e8ecef".toColor()),
          ),
          child: child),
    );
  }
}
