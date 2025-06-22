import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/mobile_wrapper.dart';
import 'package:food_delivery_h2d/common/widgets/switch/horizontal_switch.dart';
import 'package:food_delivery_h2d/common/widgets/text_field/horizontal_form_field.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/controller/topping_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/validations/validators.dart';
import 'package:get/get.dart';

class EditToppingView extends StatefulWidget {
  const EditToppingView({super.key, required this.topping});

  final ToppingModel topping;

  @override
  State<EditToppingView> createState() => _EditToppingViewState();
}

class _EditToppingViewState extends State<EditToppingView> {
  late TextEditingController nameTopping;
  late TextEditingController priceTopping;
  late bool isActive;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameTopping = TextEditingController(text: widget.topping.name);
    priceTopping = TextEditingController(
      text: widget.topping.price?.toString() ?? "",
    );
    isActive = widget.topping.isActive ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.topping.isNew ? "Thêm Topping" : "Sửa Topping";
    return MobileWrapper(
      appBar: CustomAppBar(
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.save,
                  size: MySizes.iconMd,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newTopping = widget.topping.copyWith(
                        isActive: isActive,
                        name: nameTopping.text,
                        price: MyFormatter.parseFormattedStringToInt(
                            priceTopping.text));
                    if (widget.topping.toppingGroupId == null) {
                      Get.back<ToppingModel>(result: newTopping);
                      return;
                    }
                    ToppingController.instance.saveTopping(newTopping);
                  }
                }),
          ],
          handleBack: () {
            Get.back();
          },
          title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(MySizes.sm),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyHorizontalFormField(
                  onValidate: (value) =>
                      Validators.validateEmptyText("Tên Topping", value),
                  controller: nameTopping,
                  required: true,
                  hintText: "VD: Tên Topping",
                  lable: "Tên"),
              MyHorizontalFormField(
                  onValidate: (value) =>
                      Validators.validateEmptyText("Giá", value),
                  isNumber: true,
                  required: true,
                  controller: priceTopping,
                  hintText: "VD: 25,000",
                  lable: "Giá"),
              MyHorizontalSwitch(
                lable: "Còn bán",
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
              )
            ]
                .expand((e) => [
                      e,
                      const Divider(
                          color: MyColors.dividerColor, thickness: 0.1)
                    ])
                .toList(),
          ),
        ),
      ),
      bottom: widget.topping.isNew
          ? null
          : Padding(
              padding: const EdgeInsets.all(MySizes.sm),
              child: OutlinedButton(
                onPressed: () {
                  if (widget.topping.id == null) {
                    Get.back<ToppingModel>(
                        result: widget.topping.copyWith(isDelete: true));
                    return;
                  }
                  ToppingController.instance.deleteTopping(widget.topping);
                },
                child: const Text("Xóa"),
              ),
            ),
    );
  }
}
