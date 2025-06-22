import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class AnimatedDigitCounter extends StatefulWidget {
  final double value;
  final Duration duration;

  final bool isFormatedCurrency;
  const AnimatedDigitCounter({
    super.key,
    required this.value,
    this.isFormatedCurrency = true,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedDigitCounter> createState() => _AnimatedDigitCounterState();
}

class _AnimatedDigitCounterState extends State<AnimatedDigitCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldValue = 0.0;

  @override
  void initState() {
    super.initState();
    _oldValue = 0.0;

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<double>(begin: _oldValue, end: widget.value)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedDigitCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _oldValue = _animation.value;

      _controller.reset();
      _animation = Tween<double>(begin: _oldValue, end: widget.value)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedValue;
    if (widget.isFormatedCurrency) {
      formattedValue = '${_animation.value.toStringAsFixed(0).replaceAllMapped(
                RegExp(r'\B(?=(\d{3})+(?!\d))'),
                (match) => ',',
              )}đ';
    } else {
      formattedValue = _animation.value.toStringAsFixed(0);
    }

    return Text(
      formattedValue,
      style: Theme.of(context)
          .textTheme
          .displaySmall!
          .copyWith(color: MyColors.white),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
