import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpeechIcon extends StatefulWidget {
  const SpeechIcon({super.key});

  @override
  State<SpeechIcon> createState() => _SpeechIconState();
}

class _SpeechIconState extends State<SpeechIcon> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    value: 1,
    duration: const Duration(seconds: 1),
    reverseDuration: const Duration(seconds: 1),
    lowerBound: 0.75,
    upperBound: 1.25,
    vsync: this,
  )
    ..forward()
    ..repeat(reverse: true);

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: Icon(
        CupertinoIcons.volume_up,
        color: Theme.of(context).primaryColor,
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: _animationController.value,
          child: child,
        );
      },
    );
  }
}
