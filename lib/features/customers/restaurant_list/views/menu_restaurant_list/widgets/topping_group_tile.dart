import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';

class ToppingGroupTile extends StatefulWidget {
  const ToppingGroupTile(
      {super.key,
      required this.toppingGroupModel,
      required this.onAdd,
      required this.onRemove});

  final ToppingGroupModel toppingGroupModel;
  final void Function(ToppingModel topping) onAdd;
  final void Function(ToppingModel topping) onRemove;

  @override
  State<ToppingGroupTile> createState() => _ToppingGroupTileState();
}

class _ToppingGroupTileState extends State<ToppingGroupTile> {
  final List<ToppingModel> selectedToppingIds = [];

  @override
  Widget build(BuildContext context) {
    final group = widget.toppingGroupModel;
    final toppings = group.toppings;
    final maxSelect = group.maxSelect;

    if (toppings.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.name,
          style: const TextStyle(
            color: MyColors.darkPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text("Chọn tối đa $maxSelect toppings",
            style: const TextStyle(fontSize: 14)),
        Column(
          children: toppings.map((topping) {
            final isSelected = selectedToppingIds.contains(topping);

            void toggleSelection() {
              setState(() {
                if (isSelected) {
                  selectedToppingIds.remove(topping);
                  widget.onRemove(topping);
                } else {
                  if (selectedToppingIds.length < maxSelect) {
                    selectedToppingIds.add(topping);
                    widget.onAdd(topping!);
                  }
                }
              });
            }

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Text(topping.name ?? ""),
              subtitle: Text(
                MyFormatter.formatCurrency((topping.price ?? 0).toInt()),
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: Checkbox(
                value: isSelected,
                onChanged: (_) => toggleSelection(),
              ),
              onTap: toggleSelection,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
