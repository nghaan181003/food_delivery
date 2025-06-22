import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'topping_group_tile.dart';

class ToppingSheet extends StatefulWidget {
  const ToppingSheet({super.key, required this.toppings});

  final List<ToppingGroupModel> toppings;

  @override
  State<ToppingSheet> createState() => _ToppingSheetState();
}

class _ToppingSheetState extends State<ToppingSheet> {
  final List<ToppingModel> selectedToppings = [];

  void _handleAdd(ToppingModel topping) {
    setState(() {
      selectedToppings.add(topping);
    });
  }

  void _handleRemove(ToppingModel topping) {
    setState(() {
      selectedToppings.removeWhere((t) => t.id == topping.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: MySizes.md,),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.toppings.length,
              itemBuilder: (context, index) {
                return ToppingGroupTile(
                  toppingGroupModel: widget.toppings[index],
                  onAdd: _handleAdd,
                  onRemove: _handleRemove,
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selectedToppings);
                  },
                  child: const Text("Thêm vào giỏ hàng"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
