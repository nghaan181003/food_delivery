import 'package:flutter/material.dart';

class ExpandContainer extends StatefulWidget {
  const ExpandContainer(
      {super.key, required this.child, required this.expandedContent});

  final Widget child;
  final Widget expandedContent;

  @override
  State<ExpandContainer> createState() => _ExpandContainerState();
}

class _ExpandContainerState extends State<ExpandContainer>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  void dispose() {
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleExpand,
          child: widget.child,
        ),
        _isExpanded ? widget.expandedContent : const SizedBox(),
      ],
    );
    ;
  }
}
