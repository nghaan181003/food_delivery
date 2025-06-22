import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/text_field/my_text_filed.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/controllers/menu_food_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/controllers/update_menu_food_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/category_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/select_topping_groups/select_topping_groups.dart';
import 'package:food_delivery_h2d/features/restaurants/setting_schedule/views/schedule_item_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/validations/validators.dart';
import 'package:get/get.dart';

class MenuFoodDetailScreen extends StatelessWidget {
  MenuFoodDetailScreen({super.key, required this.selectedItem});
  final Item selectedItem;
  final menuFoodController = Get.put(MenuFoodController());
  final updateMenuFoodController = Get.put(UpdateMenuFoodController());

  void fetchFoodDetail() {
    updateMenuFoodController.updatedItemId = selectedItem.itemId; // not good
    updateMenuFoodController.nameController.text = selectedItem.itemName;
    updateMenuFoodController.priceController.text =
        selectedItem.price.toString();
    updateMenuFoodController.quantityController.text =
        selectedItem.quantity.toString();
    updateMenuFoodController.descriptionController.text =
        selectedItem.description;

    updateMenuFoodController.keySearch.value = selectedItem.keySearch;

    String categoryId = selectedItem.categoryId.toString();
    if (menuFoodController.allCategories
        .any((category) => category.categoryId.toString() == categoryId)) {
      updateMenuFoodController.selectedCaterory.value = categoryId;
    } else {
      updateMenuFoodController.selectedCaterory.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchFoodDetail();
    return Scaffold(
      appBar: CustomAppBar(
        handleBack: () {
          updateMenuFoodController.foodImage.value = null;
          Get.back();
        },
        title: Text(updateMenuFoodController.isEditting.value
            ? "Chỉnh sửa món ăn"
            : "Thêm món ăn"),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.save,
                size: MySizes.iconMd,
              ),
              onPressed: () {
                updateMenuFoodController.save();
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: MySizes.md, right: MySizes.md, left: MySizes.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hình ảnh",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                      const SizedBox(
                        height: MySizes.sm,
                      ),
                      Text(
                        "Món có hình ảnh sẽ dễ\nthu hút khách hàng hơn",
                        style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: MyColors.secondaryTextColor,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: () => updateMenuFoodController
                              .pickImage(updateMenuFoodController.foodImage),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(MySizes.borderRadiusMd),
                              child: updateMenuFoodController.foodImage.value !=
                                      null
                                  ? Image.file(
                                      updateMenuFoodController.foodImage.value!,
                                      fit: BoxFit.cover,
                                      width: 70,
                                      height: 70,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: selectedItem.itemImage,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(
                                          child:
                                              CircularProgressIndicator()), // Show a loading indicator while the image loads
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons
                                              .error), // Show an error icon if the image fails to load
                                    )),
                        ),
                      ),
                      TextButton(
                          onPressed: () => updateMenuFoodController
                              .pickImage(updateMenuFoodController.foodImage),
                          child: Text(
                            "Sửa ảnh",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: MyColors.darkPrimaryTextColor,
                                    fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(MySizes.sm),
              child: Form(
                key: updateMenuFoodController.itemFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: MySizes.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tên",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          SizedBox(
                            width: 280,
                            child: MyTextFiled(
                                validator: (value) =>
                                    Validators.validateEmptyText("Tên", value),
                                textController:
                                    updateMenuFoodController.nameController,
                                hintText: "Nhập tên món ăn"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: MySizes.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Giá gốc",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          SizedBox(
                            width: 280,
                            child: MyTextFiled(
                                isNumberType: true,
                                validator: (value) =>
                                    Validators.validateEmptyText("Giá", value),
                                textController:
                                    updateMenuFoodController.priceController,
                                hintText: "Nhập giá món ăn (VNĐ)"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: MySizes.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Giá bán",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          SizedBox(
                            width: 280,
                            child: MyTextFiled(
                                isNumberType: true,
                                readOnly: true,
                                validator: (value) =>
                                    Validators.validateEmptyText("Giá", value),
                                textController: TextEditingController(
                                    text: MyFormatter.formatCurrency(
                                        selectedItem.salePrice ??
                                            selectedItem.price)),
                                hintText: "Nhập giá món ăn (VNĐ)"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: MySizes.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Danh mục",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          SizedBox(
                            width: 230,
                            height: 55,
                            child: Obx(
                              () => DropdownButtonHideUnderline(
                                child: DropdownButton<String?>(
                                  value: updateMenuFoodController
                                      .selectedCaterory.value,
                                  dropdownColor: MyColors.iconColor,
                                  onChanged: (String? newValue) {
                                    updateMenuFoodController
                                        .selectedCaterory.value = newValue;
                                  },
                                  isExpanded: true,
                                  hint: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(MySizes.sm + 2),
                                      child: Text(
                                        "Chọn danh mục",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color:
                                                  MyColors.secondaryTextColor,
                                            ),
                                      ),
                                    ),
                                  ),
                                  selectedItemBuilder: (BuildContext context) {
                                    return menuFoodController.allCategories
                                        .map((Category category) {
                                      return Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              MySizes.sm + 2),
                                          child: Text(
                                            category.categoryName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .apply(
                                                    color: MyColors
                                                        .primaryTextColor),
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  items: menuFoodController.allCategories
                                      .map((Category category) {
                                    return DropdownMenuItem<String?>(
                                      value: category.categoryId.toString(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            MySizes.sm + 2),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            category.categoryName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .apply(
                                                    color: MyColors
                                                        .primaryTextColor),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: MySizes.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Số lượng",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          SizedBox(
                            width: 260,
                            child: MyTextFiled(
                                isNumberType: true,
                                useThousandsFormatter: false,
                                validator: (value) =>
                                    Validators.validateEmptyText(
                                        "Số lượng", value),
                                textController:
                                    updateMenuFoodController.quantityController,
                                hintText: "Nhập số lượng món"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: MySizes.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Từ khóa",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                          Obx(
                            () => SizedBox(
                              width: 150,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    hint: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            MySizes.sm + 2),
                                        child: Text(
                                          "Chọn từ khóa",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color:
                                                    MyColors.secondaryTextColor,
                                              ),
                                        ),
                                      ),
                                    ),
                                    isExpanded: true,
                                    value: updateMenuFoodController
                                            .keySearch.value!.isNotEmpty
                                        ? updateMenuFoodController
                                            .keySearch.value
                                        : null,
                                    items: [
                                      "Cơm",
                                      "Bún",
                                      "Phở",
                                      "Mì",
                                      "Ăn vặt",
                                      "Bánh ngọt",
                                      "Trà sữa",
                                      "Nước ép"
                                    ].map((category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              MySizes.sm + 2),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              category,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .apply(
                                                      color: MyColors
                                                          .primaryTextColor),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      updateMenuFoodController
                                          .keySearch(value.toString());
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedItem.itemId.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(
                            height: MySizes.spaceBtwItems,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: MySizes.sm, bottom: MySizes.md),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Nhóm topping",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .apply(
                                          color: MyColors.darkPrimaryTextColor),
                                ),
                                InkWell(
                                  onTap: () => Get.to(() => SelectToppingGroups(
                                        itemId: selectedItem.itemId,
                                      )),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Chọn nhóm Topping",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .apply(
                                                color:
                                                    MyColors.primaryTextColor),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: MyColors.secondaryTextColor,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (selectedItem.itemId.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(
                            height: MySizes.spaceBtwItems,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => ScheduleItemScreen(id: selectedItem.itemId,));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: MySizes.sm),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Lịch bán món",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .apply(
                                            color: MyColors.darkPrimaryTextColor),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: MyColors.secondaryTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: MySizes.md,
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: MySizes.sm),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Mô tả",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: MySizes.spaceBtwItems,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: MyTextFiled(
                        textAlign: TextAlign.left,
                        textController:
                            updateMenuFoodController.descriptionController,
                        hintText: "Nhập mô tả món ăn",
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
