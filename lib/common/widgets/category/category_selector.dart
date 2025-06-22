import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class CategorySelector<T> extends StatelessWidget {
  final List<T> categories;
  final T selectedItem;
  final String Function(T category) labelBuilder;
  final ValueChanged<T> onChanged;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedItem,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: MySizes.sm),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: MySizes.md),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedItem;
          final label = labelBuilder(category);

          return GestureDetector(
            onTap: () => onChanged(category),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: MySizes.md, vertical: MySizes.sm),
              decoration: BoxDecoration(
                color:
                    isSelected ? MyColors.darkPrimaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
