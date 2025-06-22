import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openai_api/src/core/components/extensions/context_extensions.dart';
import 'package:openai_api/src/presentation/chat_bot/views/widgets/listening_icon.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function onSubmitted;
  final bool isListening;
  final Function() onVoiceStart;
  final Function() onVoiceStop;
  final bool micAvailable;
  final Color? borderColor;
  final double? borderRadius;
  const InputWidget({
    this.borderColor,
    this.borderRadius,
    required this.textEditingController,
    required this.onSubmitted,
    required this.isListening,
    required this.onVoiceStart,
    required this.onVoiceStop,
    required this.micAvailable,
    super.key,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    final micIcon =
        !widget.micAvailable ? CupertinoIcons.mic_off : CupertinoIcons.mic_fill;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius ?? 28),
            ),
            border: Border.all(
              color: widget.borderColor ?? Theme.of(context).hintColor,
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: !widget.isListening
                    ? widget.onVoiceStart
                    : widget.onVoiceStop,
                icon: widget.isListening
                    ? const ListeningIcon()
                    : Icon(micIcon, color: Theme.of(context).hintColor),
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: context.titleMedium,
                  decoration: InputDecoration(
                    hintText:
                        widget.isListening ? 'Đang nghe' : 'Nhập tin nhắn',
                    hintStyle: context.titleMedium.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                  ),
                  controller: widget.textEditingController,
                  onSubmitted: (value) {
                    widget.onSubmitted.call();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    icon: const Icon(Icons.send_rounded),
                    color: Colors.white,
                    onPressed: () {
                      if (!widget.isListening) {
                        widget.onSubmitted.call();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
