import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openai_api/src/presentation/conversation/bloc/conversation_bloc.dart';
import 'package:openai_api/src/presentation/conversation/views/medias/conversation_mobile.dart';

class ConversationView extends StatefulWidget {
  final bool isWebPlatform;
  const ConversationView({super.key, this.isWebPlatform = false});

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
      // if (widget.isWebPlatform) {
      //   return ConverationWeb(state: state);
      // }
      return ConversationMobile(state: state);
    });
  }
}
