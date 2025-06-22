import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/side_bar/widgets/side_bar_item.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class ExpandableSidebarItem extends StatefulWidget {
  final IconData icon;
  final String itemName;
  final List<SideBarItem> children;

  const ExpandableSidebarItem({
    super.key,
    required this.icon,
    required this.itemName,
    required this.children,
  });

  @override
  State<ExpandableSidebarItem> createState() => _ExpandableSidebarItemState();
}

class _ExpandableSidebarItemState extends State<ExpandableSidebarItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Padding(
            padding: const EdgeInsets.only(
              top: MySizes.sm, left: MySizes.sm, right: MySizes.sm),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: MySizes.md, horizontal: MySizes.lg),
              decoration: BoxDecoration(
                color: isExpanded ? MyColors.darkPrimaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: isExpanded ? Colors.white : MyColors.darkPrimaryColor),
                  const SizedBox(width: MySizes.md),
                  Expanded(
                    child: Text(
                      widget.itemName,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: isExpanded ? Colors.white : MyColors.darkPrimaryColor,
                          ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: isExpanded ? Colors.white : MyColors.darkPrimaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),

        if (isExpanded)
          Column(
            children: widget.children
                .map(
                  (child) => Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: child,
                  ),
                )
                .toList(),
          )
      ],
    );
  }
}
