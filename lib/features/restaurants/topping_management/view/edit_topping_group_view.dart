import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/expand/expand_container.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/mobile_wrapper.dart';
import 'package:food_delivery_h2d/common/widgets/text_field/horizontal_form_field.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/controller/topping_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/enum/options.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/view/edit_topping_view.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/view/widgets/topping_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/validations/validators.dart';
import 'package:get/get.dart';

class EditToppingGroupView extends StatefulWidget {
  const EditToppingGroupView({super.key, required this.toppingGroup});

  final Rx<ToppingGroupModel> toppingGroup;

  @override
  State<EditToppingGroupView> createState() => _EditToppingGroupViewState();
}

class _EditToppingGroupViewState extends State<EditToppingGroupView> {
  late final TextEditingController nameToppingGroup;
  final _formKey = GlobalKey<FormState>();
  late ToppingGroupOptions _selectedOption;
  late int _maxSelect;

  @override
  void initState() {
    nameToppingGroup =
        TextEditingController(text: widget.toppingGroup.value.name);
    _selectedOption = widget.toppingGroup.value.isRequired
        ? ToppingGroupOptions.yes
        : ToppingGroupOptions.no;
    _maxSelect = widget.toppingGroup.value.maxSelect;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ToppingController.instance.isLoading.value;

    return MobileWrapper(
      appBar: CustomAppBar(
        handleBack: () {
          Get.back();
        },
        title: Text(widget.toppingGroup.value.isNew
            ? "Thêm nhóm Topping"
            : "Chỉnh sửa nhóm Topping"),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(MySizes.sm),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.toppingGroup.value.isNew
                            ? const SizedBox()
                            : MyHorizontalFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: widget.toppingGroup.value.id),
                                hintText: "",
                                lable: "Mã"),
                        MyHorizontalFormField(
                            onValidate: (value) => Validators.validateEmptyText(
                                "Tên nhóm Topping", value),
                            required: true,
                            controller: nameToppingGroup,
                            hintText: "VD: Nhóm Topping",
                            lable: "Tên"),
                        //TODO: quyen tuy chon

                        _buildOptional(),
                        //TODO: mon them
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                          child: Text(
                            "Món thêm",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MyColors.darkPrimaryTextColor),
                          ),
                        ),
                        //TODO: hien thi danh cac topping
                        _buildToppingList(context),

                        //TODO: Mon da lien ket
                      ]
                          .expand((e) => [
                                e,
                                const Divider(
                                    color: MyColors.dividerColor,
                                    thickness: 0.1)
                              ])
                          .toList(),
                    ),
                  ),
                ),
        ),
      ),
      bottom: _BottomNavigationBar(
          onDelete: widget.toppingGroup.value.isNew
              ? null
              : () {
                  ToppingController.instance
                      .deleteToppingGroup(widget.toppingGroup.value);
                },
          onSave: () {
            if (_formKey.currentState!.validate()) {
              ToppingController.instance.saveToppingGroup(
                  widget.toppingGroup.value.copyWith(
                      name: nameToppingGroup.text,
                      isRequired: _selectedOption.toValue,
                      maxSelect: _maxSelect));
            }
          }),
    );
  }

  Widget _buildAddTopping(BuildContext context) {
    return TextButton(
        onPressed: () async {
          final result = await Get.to(() => EditToppingView(
                topping: ToppingModel()
                    .copyWith(toppingGroupId: widget.toppingGroup.value.id),
              ));

          if (result is ToppingModel) {
            final newToppings =
                List<ToppingModel>.from(widget.toppingGroup.value.toppings)
                  ..add(result);

            widget.toppingGroup.value =
                widget.toppingGroup.value.copyWith(toppings: newToppings);
          }
        },
        child: Column(
          children: [
            const Icon(
              Icons.add,
              color: MyColors.secondaryTextColor,
            ),
            Text(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(color: MyColors.secondaryTextColor),
                "Thêm topping"),
          ],
        ));
  }

  Widget _buildContentInOption() {
    return Container(
      padding: const EdgeInsets.all(MySizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Khách hàng có bắt buộc phải chọn tùy chọn không",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          ...ToppingGroupOptions.values.map((e) => e.toWidget(
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    _selectedOption = value;
                  }
                });
              })),
          _selectedOption.isYes ? _buildMaxSelectWidget() : const SizedBox()
        ],
      ),
    );
  }

  Widget _buildMaxSelectWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Số lượng tùy chọn"),
        DropdownButton(
            value: _maxSelect,
            items: List.generate(
              widget.toppingGroup.value.quantity,
              (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('${index + 1}'),
              ),
            ),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  _maxSelect = value;
                }
              });
            })
      ],
    );
  }

  Widget _buildOptional() {
    return ExpandContainer(
      expandedContent: _buildContentInOption(),
      child: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: "Quyền tùy chọn",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: MyColors.darkPrimaryTextColor),
                  children: const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 24,
              color: MyColors.secondaryTextColor,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToppingList(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Sử dụng Obx để tự động theo dõi sự thay đổi của toppingGroup
      Obx(() {
        return Column(
          children: [
            ...widget.toppingGroup.value.toppings.asMap().entries.map((entry) {
              final index = entry.key;
              final topping = entry.value;
              return Padding(
                padding: const EdgeInsets.only(top: MySizes.sm),
                child: ToppingTile(
                    onTap: () async {
                      final result =
                          await Get.to(() => EditToppingView(topping: topping));
                      if (result is ToppingModel) {
                        final updatedToppings = [
                          ...widget.toppingGroup.value.toppings
                        ];
                        if (result.isDelete) {
                          updatedToppings.removeAt(index);
                        } else {
                          updatedToppings[index] = result;
                        }

                        widget.toppingGroup.value = widget.toppingGroup.value
                            .copyWith(toppings: updatedToppings);
                      }
                    },
                    onChanged: (value) {
                      if (topping.isNew) {
                        final updatedToppings = [
                          ...widget.toppingGroup.value.toppings
                        ];
                        updatedToppings[index] =
                            updatedToppings[index].copyWith(isActive: value);

                        widget.toppingGroup.value = widget.toppingGroup.value
                            .copyWith(toppings: updatedToppings);
                      } else {
                        ToppingController.instance.onChangeIsActive(topping);
                      }
                    },
                    topping: topping.obs),
              );
            }),
            Center(child: _buildAddTopping(context)),
          ],
        );
      }),
    ]);
  }
}

class _BottomNavigationBar extends StatelessWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onSave;

  const _BottomNavigationBar({required this.onDelete, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, -5),
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              onDelete != null
                  ? Expanded(
                      child: OutlinedButton(
                        onPressed: onDelete,
                        child: const Text("Xóa"),
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSave,
                  child: const Text("Lưu"),
                ),
              ),
            ]
                .expand((element) => [element, const SizedBox(width: 8.0)])
                .toList()
              ..removeLast(),
          ),
        ],
      ),
    );
  }
}
