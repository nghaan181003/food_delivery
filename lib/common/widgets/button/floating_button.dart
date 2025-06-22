import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class FloatingButtons extends StatefulWidget {
  const FloatingButtons({super.key, required this.buttons});

  final List<FloatingActionButton> buttons;

  @override
  State<FloatingButtons> createState() => _FloatingButtonsState();
}

class _FloatingButtonsState extends State<FloatingButtons> {
  bool isExpanded = false;

  void toggle() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isExpanded)
          ...widget.buttons
              .map((btn) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: btn,
                  ))
              .toList(),
        FloatingActionButton(
            onPressed: toggle,
            backgroundColor: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              isExpanded ? Icons.close : Icons.menu,
              color: Colors.white,
            ))
      ],
    );
  }
}
