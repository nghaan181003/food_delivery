import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class MenuSearchBar extends StatelessWidget {
  const MenuSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(top: MySizes.md, left: MySizes.md, right: MySizes.md),
      child: TextField(
        controller: controller, 
        // onChanged: (value) {
        //   controller.searchEmployee(query: value);
        // },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear_rounded),
            onPressed: () {
              controller.clear(); 
            },
          ),
          hintText: "Nhập tên món ăn",
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: MyColors.secondaryTextColor,
                            fontStyle: FontStyle.italic, fontWeight: FontWeight.w500,),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
            borderSide: const BorderSide(
                color: MyColors.darkPrimaryColor), 
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
            borderSide: const BorderSide(
                color: MyColors.lightPrimaryColor), 
          ),
        ),
      ),
    );
  }
}
